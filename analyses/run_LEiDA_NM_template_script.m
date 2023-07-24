
%% BOOLEAN PARAMETERS TO DECIDE WHICH LEiDA PART TO RUN
% TO BE CHANGED BY USER ACCORDING TO NEEDS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% boolean (0=no; 1=yes) indicating which part of the scripts you want to
% run
bool.start = 0; 
bool.clusterP = 0;
bool.clusterS = 0;
bool.analysisK = 1;
bool.analysisCentroid = 1;
bool.transitionK = 0;
bool.StateTime = 0;


%% GENERAL INPUTS
% TO BE CHANGED BY USER ACCORDING TO NEEDS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
denoisingOptions = {'ICA', 'ACompCor'};
denoisingChoice = 0;
smoothing = 0;

%mainFolder = 'H:\MINT\MRI\Analyses\LEiDA'; % FOR LAURA
%mainFolder = 'Z:\MRI\Analyses\LEiDA'; % FOR JOANA
mainFolder = '/Volumes/hwhalley-adol-imaging/irritability_project/LEiDA_updated_scripts_2023' ; %FOR NIAMH


% Directory of the LEiDA toolbox folder:
param.LEiDA_directory = fullfile(mainFolder, 'LEiDA_updated_scripts_2023');

% Directory of the folder with the parcellated neuroimaging data:
param.Data_directory = fullfile(mainFolder, '/data/LEiDA_timeseries_both_conditions/');
    %, ...
    %['cortical_atlas_' num2str(smoothing) 'mm' denoisingOptions{denoisingChoice} '_double_scans_excl_rem']);


% Name of the run to be used to create the folder to save the data:
% data will be saved in the mainFolder under the folder path 
% fullfile(results,param.res.atlas,param.res.preproc,param.res.run_name)
% if you don't want to have a certain subfolder (e.g. you use always the same 
% preprocessing and don't need to have that folder explicitly defined) just
% put it to empty -> e.g. param.res.preproc = [];
param.res.atlas = 'cortical_atlas_NaN_rem';
param.res.preproc = []; 
%'denoise-' denoisingOptions{denoisingChoice} '_smooth-' num2str(smoothing) 'mm'];%'denoise-ICA_smooth-0mm';
param.res.run_name = '20230221_new_script_trial';

% Tag of conditions given in the parcellated image files:
param.Conditions_tag = {'_irrit_','_rest_'};
                                                % choose 2 of the 4, select paired or unpaired accordingly
                                                
%% PARCELLATION PARAMETERS    
% TO BE CHANGED BY USER ACCORDING TO NEEDS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parcellation applied to the imaging data (see tutorial):

% if you are using a different atlas, save it in the
% ParcelsMNI2mm.mat (make sure matrix dimensions and voxels sizes are compatible)
% and add the name of the atlas and the labels in the lists below
atlas.possibleOptions = {'AAL116','AAL120','brainnetome_cortical_yeo_dimensions'};

% choose the atlas you want to use based on its position in the lists above
parcellationID = 2;
param.parcellation.name = atlas.possibleOptions{parcellationID};

% Number of brain areas included in your atlas:
total_nAreas_inParcellation = 120;
param.parcellation.areas = 1:total_nAreas_inParcellation;

% you might want to exclude certain areas from your parcellation (e.g. only
% consider the X first, or remove some randomly distributed in terms of
% label number like removing the areas labelled 40 130 and 155).
% Alternatively, your parcellation might not have consecutive labels.
% If so, set restrictParcellation to 1 (instead of 0) and list the labels 
% of the areas you want to remove in areas2remove
% e.g. remove first 3:  areas2remove = 1:3;
%      remove last 3:   areas2remove = 208:210; (assuming your parcellation has 210)
%      remove random 3: areas2remove = [40 130 155];
restrictParcellation = 1;
if restrictParcellation
    param.parcellation.areas2remove = [17, 18, 23:26, 29, 43, 91, 92, 94:98, 105, 106, 108, 111, 112]; %20 NaN regions
    param.parcellation.areas = setxor(param.parcellation.areas, param.parcellation.areas2remove);
else
    param.parcellation.areas2remove = []; %#ok<*UNRCH>
end

param.parcellation.n_areas = length(param.parcellation.areas);

 % Yeo9 is not possible at the moment because all plotting is prepared for
 % 7 (7colours, etc)
possibleYeoAtlas = {'Yeo7'};%, 'Yeo9'}; 
yeoID = 1;
param.parcellation.YeoAtlas = possibleYeoAtlas{yeoID};


%% fMRI PARAMETERS
% TO BE CHANGED BY USER ACCORDING TO NEEDS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS FOR LEiDA_Start_JL

% Repetition time (TR) of the fMRI data (if unknown set to 1):
param.fMRI.TR = 1.4;
% Maximum number of TRs for all fMRI sessions:
param.fMRI.Tmax = 257;
% Apply temporal filtering to data (0: no; 1: yes)
param.fMRI.apply_filter = 1;
% Lowpass frequency of filter (default 0.1):
param.fMRI.flp = 0.1;
% Highpass frequency of filter (default 0.01):
param.fMRI.fhi = 0.01;


%% STATS PARAMETERS
% TO BE CHANGED BY USER ACCORDING TO NEEDS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% For the statistics:
% Choose 0 (unpaired) if subjects in different conditions are not the
% same; or 1 (paired) if subjects are the same across conditions.
param.stats.Paired_tests = 1;

% Number of permutations. For the first analysis to be relatively quick,
% run around 500 permutations, but then increase to 10000 to increase the
% reliability of the final statistical results (p-values) for publication.
param.stats.n_permutations = 500;
% Number of bootstrap samples within each permutation. For the first
% analysis to be relatively quick, choose around 10, but then increase to
% 500 for more reliable final results.
param.stats.n_bootstraps = 10;

% For the figure of the pyramid of PL states:
% Direction to plot the FC states/brain ('SideView' or 'TopView'):
param.plot.CortexDirection = 'SideView'; 


%% RUN LEIDA START
if bool.start
    LEiDA_Start_JL(param);
end


%% RUN CLUSTER PERFORMANCE TO SELECT K
if bool.clusterP
    %res_dir = fullfile(param.LEiDA_directory, ['res_' param.run_name]); %17/02/2023 LK changed to match results folder location detailed below
    % Directory with the results from LEiDA 
    [pathstr,~,~] = fileparts(param.LEiDA_directory);  
    mainPath = pathstr(1:find(pathstr == filesep, 1, 'last'));  
    res = fullfile(param.res.atlas, param.res.preproc, param.res.run_name);  
    res_dir = fullfile(mainPath, 'results', res); 

    cluster_performance(res_dir);
end

if bool.clusterS
    % Define K value, (e.g., K returning the most significant differences between
    % conditions or based on dunn/randindex):
    param.cluster.SelectK = input('Select the K you want to use for further analyses ');
    
    % Directory with the results from LEiDA - 17/02/2023 added by LK, required if running clusterS but not clusterP
    [pathstr,~,~] = fileparts(param.LEiDA_directory); 
    mainPath = pathstr(1:find(pathstr == filesep, 1, 'last'));  
    res = fullfile(param.res.atlas, param.res.preproc, param.res.run_name);  
    res_dir = fullfile(mainPath, 'results', res);

    K_dir = fullfile(res_dir, ['K' num2str(param.cluster.SelectK)]); % LK 16/02/2023 changed param.SelectK to param.cluster.SelectK
    if ~exist(K_dir, 'dir')
        mkdir(K_dir);
    end
    
    cluster_stability(res_dir, K_dir, param.cluster.SelectK); % LK 16/02/2023 changed param.SelectK to param.cluster.SelectK
else
    param.cluster.SelectK = 19 ; % TO BE CHANGED BY USER ACCORDING TO NEEDS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                               % Selecting K = 8 
                               

end



%% INPUTS FOR LEiDA_AnalysisK_JL
if bool.analysisK
    LEiDA_AnalysisK_JL(param);
end


%% INPUTS FOR LEiDA_AnalysisCentroid_JL
if bool.analysisCentroid
    % Define the PL state to be studied (1 <= PL state <= SelectK):
    for centroid = 2:param.cluster.SelectK
        param.cluster.Centroid = centroid;
        LEiDA_AnalysisCentroid_JL(param);
    end
end


%% INPUTS LEiDA_TransitionsK_JL
if bool.transitionK
    LEiDA_TransitionsK_JL(param);
end


%% INPUTS LEiDA_StateTime_JL
% Define the subject to analyse into more detail (file name of subject or unique ID/number):
if bool.StateTime
    % remember that the subject number that will be used will be in
    % relation to the place it occupies in the list of data and not the
    % actual subject ID
    param.Subject = 2; % TO BE CHANGED BY USER ACCORDING TO NEEDS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    LEiDA_StateTime_JL(param);
end


%% Saving parameter file 
% Directory with the results from LEiDA
[pathstr,~,~] = fileparts(param.LEiDA_directory); 
mainPath = pathstr(1:find(pathstr == filesep, 1, 'last')); 
res = fullfile(param.res.atlas, param.res.preproc, param.res.run_name);
saveFolder = fullfile(mainPath, 'results', res); 

if bool.start
    start_tag = 'LEiDAStart-On';
else
    start_tag = 'LEiDAStart-Off';
end

if bool.clusterP
    clustP_tag = 'clusterP-On';
else
    clustP_tag = 'clusterP-Off';
end

if bool.clusterS
    clustS_tag = 'clusterS-On'; %#ok<*NASGU>
else
    clustS_tag = 'clusterS-Off';
end

if bool.analysisK
    anaK_tag = 'anaK-On';
else
    anaK_tag = 'anaK-Off';
end

if bool.analysisCentroid
    anaC_tag = 'anaC-On';
else
    anaC_tag = 'anaC-Off';
end

if bool.transitionK
    transK_tag = 'transK-On';
else
    transK_tag = 'transK-Off';
end

if bool.StateTime
    stateTime_tag = 'stateTime-On';
else
    stateTime_tag = 'stateTime-Off';
end


saveFile = ['param_' start_tag '_' clustP_tag '_' clustS_tag '_' anaK_tag '_' anaC_tag '_' transK_tag '_' clustS_tag '.mat'];
save(fullfile(saveFolder, saveFile), 'param')

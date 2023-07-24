
%The purpose of this script is to extract the outputs from the LEiDA
%Toolbox to compare with behavioural measures. 


%First, load in output from LEiDA start script 

%Extract Fractional Occupancy and Dwell Time values for each condition
%We will use these as inputs for our LEiDA compare scirpt. 

%FRACTIONAL OCCUPANCY 
load('/Volumes/hwhalley-adol-imaging/irritability_project/results/cortical_atlas_NaN_rem/20230221_new_script_trial/LEiDA_Stats_FracOccup.mat');


% return a subjects x states x models 3d matrix for each condition
 FO_irrit = squeeze(P(Index_Conditions==1, :, :)) ; %1= irrit

 FO_rest = squeeze(P(Index_Conditions==2, :, :)) ;%2= rest

 FO_diff = FO_irrit - FO_rest ; %get difference between conditions
 
 save('/Volumes/hwhalley-adol-imaging/irritability_project/results/cortical_atlas_NaN_rem/20230221_new_script_trial/FO_irrit.mat', 'FO_irrit');
 save('/Volumes/hwhalley-adol-imaging/irritability_project/results/cortical_atlas_NaN_rem/20230221_new_script_trial/FO_rest.mat', 'FO_rest') ;
 save('/Volumes/hwhalley-adol-imaging/irritability_project/results/cortical_atlas_NaN_rem/20230221_new_script_trial/FO_diff.mat', 'FO_diff') ;
clear
 
%DWELL TIME
load('/Volumes/hwhalley-adol-imaging/irritability_project/results/cortical_atlas_NaN_rem/20230221_new_script_trial/LEiDA_Stats_DwellTime.mat');


% return a subjects x states x models 3d matrix for each condition
 DT_irrit = squeeze(LT(Index_Conditions==1, :, :)) ; %1= irrit

 DT_rest = squeeze(LT(Index_Conditions==2, :, :)) ;%2= rest

 DT_diff = DT_irrit - DT_rest ; %get difference between conditions
 
 save('/Volumes/hwhalley-adol-imaging/irritability_project/results/cortical_atlas_NaN_rem/20230221_new_script_trial/DT_irrit.mat', 'DT_irrit');
 save('/Volumes/hwhalley-adol-imaging/irritability_project/results/cortical_atlas_NaN_rem/20230221_new_script_trial/DT_rest.mat', 'DT_rest');
 save('/Volumes/hwhalley-adol-imaging/irritability_project/results/cortical_atlas_NaN_rem/20230221_new_script_trial/DT_diff.mat', 'DT_diff') ;
clear


%Convert LEiDA behavioural data from .csv to .mat for use in LEiDA_compare
%scores script. 

%read in .csv file

M=readtable('/Volumes/hwhalley-adol-imaging/irritability_project/LEiDA_updated_scripts_2023/data/LEiDA_behavioural_data.csv');
save('/Volumes/hwhalley-adol-imaging/irritability_project/LEiDA_updated_scripts_2023/data/LEiDA_behavioural_data.mat','M');

load('/Volumes/hwhalley-adol-imaging/irritability_project/LEiDA_updated_scripts_2023/data/LEiDA_behavioural_data.mat'); 


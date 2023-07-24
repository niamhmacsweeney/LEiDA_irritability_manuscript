function LEiDA_compare_scores
%
% Function to compare behavioural data with
% properties of LEiDA networks (DT and FO) 
%
%
% Fran Hancock
% May 2021 fran.hancock@kcl.ac.uk
% Modified by Joana Cabral and Vania Miguel
% May 2021

%Modified by Niamh MacSweeney 
%March 2023
%%%%%%%


% Load in Fractional Occupancy (FO) and Dwell Time (DT) difference scores
%These scores have been generated in prep_LEiDA_behav_data.m

%%%%%%%%% Fractional occupancy %%%%%%%%%%

% Load FO_diff
Kmeans_file='/Volumes/hwhalley-adol-imaging/irritability_project/results/cortical_atlas_NaN_rem/20230221_new_script_trial/FO_diff.mat';
load(Kmeans_file)
D_FO=FO_diff

%Load DT_diff
Kmeans_file='/Volumes/hwhalley-adol-imaging/irritability_project/results/cortical_atlas_NaN_rem/20230221_new_script_trial/DT_diff.mat';
load(Kmeans_file)
D_DT=DT_diff


% File with Time_sessions
load('/Volumes/hwhalley-adol-imaging/irritability_project/results/cortical_atlas_NaN_rem/20230221_new_script_trial/LEiDA_EigenVectors.mat','V1_all')
Time_sessions=V1_all;

%Load in range of K file 

load('/Volumes/hwhalley-adol-imaging/irritability_project/results/cortical_atlas_NaN_rem/20230221_new_script_trial/LEiDA_Clusters.mat','rangeK')
rangeK=rangeK;

%clear V1_all

signif_threshold=0.01;


N_Subjects=max(Time_sessions);




% Indicate the collumns in the table of scores that will be compared
%  4=age; 6=ari_total; 7=PHQ_9 total; 10 = irrit mean FD; 12=FD_motion (avg. across
% conditions). 

ind_scores= [6 7];   %use average motion  

load('/Volumes/hwhalley-adol-imaging/irritability_project/LEiDA_updated_scripts_2023/data/LEiDA_behavioural_data.mat', 'M');
table_scores=M;

for score=1:length(ind_scores)
    
    disp(' ')
    disp([table_scores.Properties.VariableNames{ind_scores(score)}  ' - Column ' num2str(ind_scores(score))])
    
    Scores=table2array(table_scores(:,ind_scores(score)));
    
    for K=1:length(rangeK)
        
        for c=1:rangeK(K)
            
            Pkc=squeeze(D_FO(:,K,c));
            % Calculate correlation between Scores and Probability of
            % Network
            [cc, p]=corr(Pkc,Scores,'Type','Spearman');
            D_FO_pval(score,K,c)=p;
            D_FO_corr(score,K,c)=cc;
            
            if D_FO_pval(score,K,c)<(signif_threshold)
                disp(['signif correlation with prob Network =' num2str(c) ' for K=' num2str(rangeK(K))])
                disp(['cc=' num2str(cc) ' p=' num2str(p)])
                %myfit = polyfit(Pkc,Scores,1)
                %figure
                %scatter(Pkc,Scores)
                %savefig(sprintf('/Volumes/hwhalley-adol-imaging/irritability_project/LEiDA_updated_scripts_2023/figs/Irrit_prob_net_%d_K_%d_col_%s.fig', c, rangeK(K), table_scores.Properties.VariableNames{ind_scores(score)}))
                % Alternatively save as a png
                %saveas(gcf, sprintf('Prob_net_%d_K_%d_col_%s.png', c, rangeK(K), table_scores.Properties.VariableNames{ind_scores(score)})) 
                close(gcf)   
            end
            
            %check if variables are normally distributed
            %normplot(Pkc) - probability scores look normally distributed


            Lkc=squeeze(D_DT(:,K,c));
            [cc, p]=corr(Lkc,Scores,'Type','Spearman');
            D_DT_pval(score,K,c)=p;
            D_DT_corr(score,K,c)=cc;
            
            if D_DT_pval(score,K,c)<(signif_threshold)
                disp(['signif correlation with duration of Network =' num2str(c) ' for K=' num2str(rangeK(K))])
                disp(['cc=' num2str(cc) ' p=' num2str(p)])
                %figure
                %plot(Lkc, Scores)
                %savefig(sprintf('/Volumes/hwhalley-adol-imaging/irritability_project/LEiDA_updated_scripts_2023/figs/Irrit_dur_net_%d_K_%d_col_%s.fig', c, rangeK(K), table_scores.Properties.VariableNames{ind_scores(score)}))
                % Alternatively save as a png
                %saveas(gcf, sprintf('Dur_net_%d_K_%d_col_%s.png', c, rangeK(K), table_scores.Properties.VariableNames{ind_scores(score)})) 
                close(gcf)   
                
                % Alternative with linear model and a fit line
                % temp_model = fitlm(Lkc, Scores)
                % plot(temp_model)
                % savefig(sprintf('Dur_net_%d_K_%d_col_%s.fig', c, rangeK(K), table_scores.Properties.VariableNames{ind_scores(score)}))
                % close(gcf)
                
                
                
                
            end
        end
    end
    
end

clear

%save('correlation_output.mat', 'D_FO_pval', 'D_FO_corr', 'D_DT_pval', 'D_DT_corr')

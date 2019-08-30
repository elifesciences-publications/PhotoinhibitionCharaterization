clear all
close all


load ./data/Fig11_data_photoinhibition_timecourse.mat


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Key variable
% 
% experiment_ID:
% % % 1  -- VGAT-ChR2, S1 spatial mapping, protocol comparison
% % % 2  -- SOM x Ai32, S1 spatial mapping
% % % 3  -- PV x Ai32, S1 spatial mapping
% % % 4  -- VGAT-ChR2, striatum spatial mapping
% % % 5  -- Arch, S1 spatial mapping
% % % 7  -- PV-cre inj, S1 spatial mapping
% % % 8  -- PVxReaChR, S1 spatial mapping
% % % 10 -- PVxReaChR, ALM spatial mapping
% % % 11 -- VGAT-ChR2, ALM spatial mapping
% % % 12 -- VGAT-ChR2, M1 rebound mapping
% 
% 
% unit_info_all:
% % % colume 1:   cell_type_tmp (1-putative pyramidal neurons; 2-putative FS neurons; 0-unclassified)
% % % colume 2&3: probe_type
% % % colume 4:   recording_depth (in um)  
% % % colume 5:   channel the unit was recorded on 
% % % colume 6&7: galvo_zero_offset_iSession (in mm, ML and AP)
% % % colume 8:   experiment_ID (see above)
% 
% 
% % response_data_all:
% % % each cell is one unit; each cell is a Nx6 matrix, where N is the number of trials
% % % colume 1:   spike rate baseline
% % % colume 2:   spike rate dring photostimulation
% % % colume 3:   photostimulation power (in mW)
% % % colume 4&5: laser position relative to electrode (in mm, ML and AP)
% % % colume 6:   photostimulation type
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%% time course of inactivation

% ################# transgenic data #####################
laser_dist = [-.1:.5:3.5];
mytitle = {
    '1 VGAT S1'
    '3 PV ChR2 S1';...
    '8 PV ReaChR S1';...
    '10 PV ReaChR ALM';...
    '11 VGAT ALM';...
    };

summarycolor = {
    {[0 0  1],['o']};...  % 1 VGAT S1
    {[1 0  0],['o']};...  % 3 PV S1
    {[.4 0 0],['o']};...  % 8 PV ReaChR S1
    {[.4 0 0],['s']};...  % 10 PV ReaChR ALM
    {[0 0 1],['s']};...  % 11 VGAT ALM
    };


effect_allExp_dist1 = [];
cellType_allExp_dist1 = [];
PSTH_allExp_dist1 = [];
ExpID_allExp_dist1 = [];
sig_allExp_dist1 = [];      % p value, baseline vs. stim

effect_allExp_dist2 = [];
cellType_allExp_dist2 = [];
PSTH_allExp_dist2 = [];
ExpID_allExp_dist2 = [];
sig_allExp_dist2 = [];

effect_allExp_dist3 = [];
cellType_allExp_dist3 = [];
PSTH_allExp_dist3 = [];
ExpID_allExp_dist3 = [];
sig_allExp_dist3 = [];

effect_allExp_dist4 = [];
cellType_allExp_dist4 = [];
PSTH_allExp_dist4 = [];
ExpID_allExp_dist4 = [];
sig_allExp_dist4 = [];

n_experiment = 0;
for experiment_ID = [1 2 3 7 8 11];
    n_experiment = n_experiment+1;
    
    
    response_data_tmp = cell2mat(response_data_all(unit_info_all(:,8)==experiment_ID,:));
    aom_power_all = unique(response_data_tmp(:,3));
    aom_power_all = aom_power_all(aom_power_all>0);
    
    
    
    for i_dist = 1:4
        
        
        effect_allCells = [];
        cellType_allCells = [];
        PSTH_allCells = [];
        sig_allCells = [];
        
        n_cell = 0;
        for i_unit = find(unit_info_all(:,8)==experiment_ID)'
            
            if (unit_info_all(i_unit,3)==5)
                electrode_offset = -(floor(unit_info_all(i_unit,5)/8.1))*.4;
            elseif (unit_info_all(i_unit,3)==1) || (unit_info_all(i_unit,3)==2) || (unit_info_all(i_unit,3)==3)
                electrode_offset = -(floor(unit_info_all(i_unit,5)/8.1))*.2;
            end
            unit_dist_offset = [electrode_offset-unit_info_all(i_unit,6) unit_info_all(i_unit,7)];
            
            
            response_data_tmp = response_data_all{i_unit};
            spk_times_tmp = spk_times_all{i_unit};
            
            unit_dist_tmp = response_data_tmp(:,4)-unit_dist_offset(1);
            
            if i_dist == 1
                i_sel_trial = find(abs(unit_dist_tmp)<=.25 &  (response_data_tmp(:,3)>1 & response_data_tmp(:,3)<2)); 
            elseif i_dist == 2
                i_sel_trial = find(abs(unit_dist_tmp)>.25 & abs(unit_dist_tmp)<=1 & (response_data_tmp(:,3)>1 & response_data_tmp(:,3)<2)); 
            elseif i_dist == 3
                i_sel_trial = find(abs(unit_dist_tmp)>1 & abs(unit_dist_tmp)<=2 & (response_data_tmp(:,3)>1 & response_data_tmp(:,3)<2)); 
            elseif i_dist == 4
                i_sel_trial = find(abs(unit_dist_tmp)>2 & (response_data_tmp(:,3)>1 & response_data_tmp(:,3)<2)); 
            end
            
            
            if length(i_sel_trial)>=2
                
                n_cell = n_cell+1;
                
                
                FR_background_tmp = response_data_tmp(i_sel_trial,1);
                
                FR_stim_tmp = [];
                for i_trial_tmp = i_sel_trial'
                    FR_stim_tmp(end+1,1) = sum(spk_times_tmp{i_trial_tmp}>0 & spk_times_tmp{i_trial_tmp}<0.01)/.01;
                    FR_stim_tmp(end,2) = sum(spk_times_tmp{i_trial_tmp}>0.01 & spk_times_tmp{i_trial_tmp}<.1)/.09;
                    FR_stim_tmp(end,3) = sum(spk_times_tmp{i_trial_tmp}>0.1 & spk_times_tmp{i_trial_tmp}<.2)/.1;
                    FR_stim_tmp(end,4) = sum(spk_times_tmp{i_trial_tmp}>0.2 & spk_times_tmp{i_trial_tmp}<.4)/.2;
                    FR_stim_tmp(end,5) = sum(spk_times_tmp{i_trial_tmp}>0.4 & spk_times_tmp{i_trial_tmp}<.6)/.2;
                    FR_stim_tmp(end,6) = sum(spk_times_tmp{i_trial_tmp}>0.6 & spk_times_tmp{i_trial_tmp}<.8)/.2;
                    FR_stim_tmp(end,7) = sum(spk_times_tmp{i_trial_tmp}>0.8 & spk_times_tmp{i_trial_tmp}<1)/.2;
                    FR_stim_tmp(end,8) = sum(spk_times_tmp{i_trial_tmp}>1 & spk_times_tmp{i_trial_tmp}<1.2)/.2;
                    FR_stim_tmp(end,9) = sum(spk_times_tmp{i_trial_tmp}>0 & spk_times_tmp{i_trial_tmp}<1.2)/1.2;
                end
                
                [psth_tmp t] = func_getPSTHmidBin(spk_times_tmp(i_sel_trial), -.5,4);
                
                effect_allCells(n_cell,:) = [mean(FR_background_tmp) mean(FR_stim_tmp)];
                cellType_allCells(n_cell,:) = unit_info_all(i_unit,1);
                PSTH_allCells(n_cell,:) = psth_tmp;
                
                [h p]=ttest2(FR_background_tmp, FR_stim_tmp(:,9));
                sig_allCells(n_cell,1) = p;

            end
            
        
        end
    
        
        % save data
        eval(['effect_allExp_dist',num2str(i_dist),' = [effect_allExp_dist',num2str(i_dist),'; effect_allCells];']);
        eval(['cellType_allExp_dist',num2str(i_dist),' = [cellType_allExp_dist',num2str(i_dist),'; cellType_allCells];']);
        eval(['PSTH_allExp_dist',num2str(i_dist),' = [PSTH_allExp_dist',num2str(i_dist),'; PSTH_allCells];']);
        eval(['ExpID_allExp_dist',num2str(i_dist),' = [ExpID_allExp_dist',num2str(i_dist),'; zeros(size(cellType_allCells,1),1)+experiment_ID];']);
        eval(['sig_allExp_dist',num2str(i_dist),' = [sig_allExp_dist',num2str(i_dist),'; sig_allCells];']);

    end
        
end



figure;
subplot(4,2,1); hold on
plot(t,mean(PSTH_allExp_dist1(cellType_allExp_dist1==1,:)), 'color',[0 0 0])
xlim([-.5 2])

subplot(4,2,3); hold on
plot(t,mean(PSTH_allExp_dist2(cellType_allExp_dist2==1,:)), 'color',[0 0 .6])
xlim([-.5 2])

subplot(4,2,5); hold on
plot(t,mean(PSTH_allExp_dist3(cellType_allExp_dist3==1,:)), 'color',[0 0 1])
xlim([-.5 2])

subplot(4,2,7); hold on
plot(t,mean(PSTH_allExp_dist4(cellType_allExp_dist4==1,:)), 'color',[.7 .7 1])
xlim([-.5 2])
xlabel('Time (sec)')
ylabel('Spike rate (spk/s)')

subplot(1,2,2); hold on
plot(t,mean(PSTH_allExp_dist1(cellType_allExp_dist1==1,:)), 'color',[0 0 0],'linewidth',2)
plot(t,mean(PSTH_allExp_dist2(cellType_allExp_dist2==1,:)), 'color',[0 0 .6],'linewidth',2)
plot(t,mean(PSTH_allExp_dist3(cellType_allExp_dist3==1,:)), 'color',[0 0 1],'linewidth',2)
plot(t,mean(PSTH_allExp_dist4(cellType_allExp_dist4==1,:)), 'color',[.7 .7 1],'linewidth',2)
xlim([-.02 .08])
xlabel('Time (sec)')
ylabel('Spike rate (spk/s)')







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


effect_allExp = [];
cellType_allExp = [];
PSTH_allExp = [];
ExpID_allExp = [];
sig_allExp = [];


n_experiment = 0;
for experiment_ID = [1 3 8 10 11];
    n_experiment = n_experiment+1;
    
    
    response_data_tmp = cell2mat(response_data_all(unit_info_all(:,8)==experiment_ID,:));
    aom_power_all = unique(response_data_tmp(:,3));
    aom_power_all = aom_power_all(aom_power_all>0);
    
    
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

        i_sel_trial = find(abs(unit_dist_tmp)<=.4 &  (response_data_tmp(:,3)>5 & response_data_tmp(:,3)<20)); 
        
        
        if length(i_sel_trial)>=10
            
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
            end
            
            [psth_tmp t] = func_getPSTHsmallBin(spk_times_tmp(i_sel_trial), -.5,4);
            
            effect_allCells(n_cell,:) = [mean(FR_background_tmp) mean(FR_stim_tmp)];
            cellType_allCells(n_cell,:) = unit_info_all(i_unit,1);
            PSTH_allCells(n_cell,:) = psth_tmp;
           
            
            for i_cond = 1:8
                [h p]=ttest2(FR_background_tmp, FR_stim_tmp(:,i_cond));
                sig_allCells(n_cell,i_cond+1) = p;
            end
            sig_allCells(:,1) = nan;
            
            
        end
        
        
    end
    
    % save data
    effect_allExp = [effect_allExp; effect_allCells];
    cellType_allExp = [cellType_allExp; cellType_allCells];
    PSTH_allExp = [PSTH_allExp; PSTH_allCells];
    ExpID_allExp = [ExpID_allExp; zeros(size(cellType_allCells,1),1)+experiment_ID];
    sig_allExp = [sig_allExp; sig_allCells];
    
    
end
    
figure;
subplot(3,1,1); hold on
plot(t,mean(PSTH_allExp(cellType_allExp==1 & (ExpID_allExp==1 | ExpID_allExp==11),:)), 'b')
plot(t,mean(PSTH_allExp(cellType_allExp==2 & (ExpID_allExp==1 | ExpID_allExp==11),:)), 'r')
xlim([-.5 2])
ylim([0 max(mean(PSTH_allExp(cellType_allExp==2 & (ExpID_allExp==1 | ExpID_allExp==11),:)))*1.2]);
title('VGAT-ChR2');
xlabel('Time (sec)')
ylabel('Spike rate (spk/s)')


subplot(3,1,2); hold on
plot(t,mean(PSTH_allExp(cellType_allExp==1 & (ExpID_allExp==3),:)), 'b')
plot(t,mean(PSTH_allExp(cellType_allExp==2 & (ExpID_allExp==3),:)), 'r')
xlim([-.5 2])
ylim([0 max(mean(PSTH_allExp(cellType_allExp==2 & (ExpID_allExp==3),:)))*1.2]);
title('PV x ChR2');


subplot(3,1,3); hold on
plot(t,mean(PSTH_allExp(cellType_allExp==1 & (ExpID_allExp==8 | ExpID_allExp==10),:)), 'b')
plot(t,mean(PSTH_allExp(cellType_allExp==2 & (ExpID_allExp==8 | ExpID_allExp==10),:)), 'r')
xlim([-.5 2])
ylim([0 max(mean(PSTH_allExp(cellType_allExp==2 & (ExpID_allExp==8 | ExpID_allExp==10),:)))*1.2]);
title('PV x ReaChR');



effect_allExp(effect_allExp<.1)=.1;
effect_allExp(effect_allExp>80)=80;


figure;
n_plot = 0;
for i_tmp=[2:3 8]
    n_plot = n_plot+1;
    
    subplot(3,3,n_plot); hold on
    plot(effect_allExp(cellType_allExp==1 & (ExpID_allExp==1 | ExpID_allExp==11),1),effect_allExp(cellType_allExp==1 & (ExpID_allExp==1 | ExpID_allExp==11),i_tmp),'.');
    plot(effect_allExp(cellType_allExp==2 & (ExpID_allExp==1 | ExpID_allExp==11),1),effect_allExp(cellType_allExp==2 & (ExpID_allExp==1 | ExpID_allExp==11),i_tmp),'.r');

    plot(effect_allExp(cellType_allExp==1 & (ExpID_allExp==1 | ExpID_allExp==11) & sig_allExp(:,i_tmp)<0.05,1),effect_allExp(cellType_allExp==1 & (ExpID_allExp==1 | ExpID_allExp==11) & sig_allExp(:,i_tmp)<0.05,i_tmp),'o');
    plot(effect_allExp(cellType_allExp==2 & (ExpID_allExp==1 | ExpID_allExp==11) & sig_allExp(:,i_tmp)<0.05,1),effect_allExp(cellType_allExp==2 & (ExpID_allExp==1 | ExpID_allExp==11) & sig_allExp(:,i_tmp)<0.05,i_tmp),'or');
    line([0.1 80],[0.1 80]);
    ylim([0.1 80]);
    xlim([0.1 80]);
    set(gca,'xscale','log','yscale','log')
end


for i_tmp=[2:3 8]
    n_plot = n_plot+1;
    
    subplot(3,3,n_plot); hold on
    plot(effect_allExp(cellType_allExp==1 & (ExpID_allExp==3),1),effect_allExp(cellType_allExp==1 & (ExpID_allExp==3),i_tmp),'.');
    plot(effect_allExp(cellType_allExp==2 & (ExpID_allExp==3),1),effect_allExp(cellType_allExp==2 & (ExpID_allExp==3),i_tmp),'.r');

    plot(effect_allExp(cellType_allExp==1 & (ExpID_allExp==3) & sig_allExp(:,i_tmp)<0.05,1),effect_allExp(cellType_allExp==1 & (ExpID_allExp==3) & sig_allExp(:,i_tmp)<0.05,i_tmp),'o');
    plot(effect_allExp(cellType_allExp==2 & (ExpID_allExp==3) & sig_allExp(:,i_tmp)<0.05,1),effect_allExp(cellType_allExp==2 & (ExpID_allExp==3) & sig_allExp(:,i_tmp)<0.05,i_tmp),'or');
    line([0.1 80],[0.1 80]);
    ylim([0.1 80]);
    xlim([0.1 80]);
    set(gca,'xscale','log','yscale','log')
end


for i_tmp=[2:3 8]
    n_plot = n_plot+1;
    
    subplot(3,3,n_plot); hold on
    plot(effect_allExp(cellType_allExp==1 & (ExpID_allExp==8 | ExpID_allExp==10),1),effect_allExp(cellType_allExp==1 & (ExpID_allExp==8 | ExpID_allExp==10),i_tmp),'.');
    plot(effect_allExp(cellType_allExp==2 & (ExpID_allExp==8 | ExpID_allExp==10),1),effect_allExp(cellType_allExp==2 & (ExpID_allExp==8 | ExpID_allExp==10),i_tmp),'.r');

    plot(effect_allExp(cellType_allExp==1 & (ExpID_allExp==8 | ExpID_allExp==10) & sig_allExp(:,i_tmp)<0.05,1),effect_allExp(cellType_allExp==1 & (ExpID_allExp==8 | ExpID_allExp==10) & sig_allExp(:,i_tmp)<0.05,i_tmp),'o');
    plot(effect_allExp(cellType_allExp==2 & (ExpID_allExp==8 | ExpID_allExp==10) & sig_allExp(:,i_tmp)<0.05,1),effect_allExp(cellType_allExp==2 & (ExpID_allExp==8 | ExpID_allExp==10) & sig_allExp(:,i_tmp)<0.05,i_tmp),'or');
    line([0.1 80],[0.1 80]);
    ylim([0.1 80]);
    xlim([0.1 80]);
    set(gca,'xscale','log','yscale','log')
end

subplot(3,3,1);
xlabel('Spike rate, baseline (spk/s)')
ylabel('Spike rate, photostim (spk/s)')





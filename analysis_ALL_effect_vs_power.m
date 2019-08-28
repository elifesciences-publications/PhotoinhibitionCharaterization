clear all
close all

% 
% meta_passive_neuronal_depth_data
% 
% waveform_all = [];
% unit_info_all = [];
% exp_ind_all = [];
% response_data_all = [];     % [FR_baseline FR_stim  AOM(V)  galvoX(mm)  galvoY(mm)]
% 
% % experiment index
% % 1  -- VGAT-ChR2, S1 spatial mapping, protocol comparison
% % 2  -- SOM x Ai32, S1 spatial mapping
% % 3  -- PV x Ai32, S1 spatial mapping
% 
% % 4  -- VGAT-ChR2, striatum spatial mapping
% % 5  -- Arch, S1 spatial mapping
% % 6  -- ArchT, S1 spatial mapping
% % 7  -- PV-cre inj, S1 spatial mapping
% % 8  -- PVxReaChR, S1 spatial mapping
% % 9  -- PVxReaChR, subcortical spatial mapping
% % 10 -- PVxReaChR, ALM spatial mapping
% % 11 -- VGAT-ChR2, ALM spatial mapping
% % 12 -- VGAT-ChR2, M1 rebound mapping
% 
% 
% 
% for i_session = 1:size(Sessions_Name,1)
% 
%     istr = findstr(Sessions_Name{i_session},'\');
%     animal_ID = Sessions_Name{i_session}(istr(1)+1:istr(2)-1);
%     session_ID = Sessions_Name{i_session}(istr(2)+1:istr(3)-1);
% 
%     filename_tmp = ['.\data\',animal_ID,'_',session_ID,'.mat'];
% 
%     % load experiment meta data
%     session_type_iSession = session_type(i_session,:);
%     probe_type_iSession = probe_type(i_session,:);
%     recording_depth_iSession = recording_depth(i_session,:);
%     galvo_zero_offset_iSession = galvo_zero_offset(i_session,:);
% 
% 
%     % experimenta ID
%     clear experiment_index_tmp
%     if (session_type_iSession{1}(1)==1) & (session_type_iSession{3}==1) & (session_type_iSession{4}==1)
% 
%         disp('1  -- VGAT-ChR2, S1 protocol comparison');
%         experiment_index_tmp = 1;
% 
% 
%     elseif (session_type_iSession{1}(1)==2) & (session_type_iSession{3}==1) & (session_type_iSession{4}==2)
% 
%         disp('2  -- SOM x Ai32, S1 spatial mapping');
%         experiment_index_tmp = 2;
% 
%     elseif (session_type_iSession{1}(1)==2) & (session_type_iSession{3}==1) & (session_type_iSession{4}==3)
% 
%         disp('3  -- PV x Ai32, S1 spatial mapping');
%         experiment_index_tmp = 3;
% 
% 
%     elseif (session_type_iSession{1}(1)==2) & (session_type_iSession{3}==1) & (session_type_iSession{4}==6)
% 
%         disp('5  -- Arch, S1 spatial mapping');
%         experiment_index_tmp = 5;
% 
%     elseif (session_type_iSession{1}(1)==2) & (session_type_iSession{3}==1) & (session_type_iSession{4}==7)
% 
%         disp('6  -- ArchT, S1 spatial mapping');
%         experiment_index_tmp = 6;
% 
%     elseif (session_type_iSession{1}(1)==4) & (session_type_iSession{3}==1) & (session_type_iSession{4}==4) & ~strcmp(animal_ID,'ANM189681')
% 
%         disp('7  -- PV-cre inj, S1 spatial mapping');
%         experiment_index_tmp = 7;
% 
%     elseif (session_type_iSession{1}(1)==2) & (session_type_iSession{3}==1) & (session_type_iSession{4}==5)
% 
%         disp('8  -- PVxReaChR, S1 spatial mapping');
%         experiment_index_tmp = 8;
% 
%     elseif (session_type_iSession{1}(1)==2) & (session_type_iSession{3}==2) & (session_type_iSession{4}==5)
% 
%         disp('10 -- PVxReaChR, ALM spatial mapping');
%         experiment_index_tmp = 10;
% 
%     elseif (session_type_iSession{1}(1)==2) & (session_type_iSession{3}==2) & (session_type_iSession{4}==1)
% 
%         disp('11 -- VGAT-ChR2, ALM spatial mapping');
%         experiment_index_tmp = 11;
% 
%     else
%         experiment_index_tmp = 0;
%     end
% 
% 
% 
%     if experiment_index_tmp>0
% 
% 
%         disp(filename_tmp);
%         load(filename_tmp);
% 
% 
%         % convert AOM_input into power
%         aom_input_tmp = unique([solo_photostim_type solo_aom],'rows');
%         power_all = [];
%         for i_stim = 1:size(aom_input_tmp,1)
%             if aom_input_tmp(i_stim,1)==1 & aom_input_tmp(i_stim,2)>0
%                 [dummy power_tmp] = stimulation_power_analysis_new(aom_input_tmp(i_stim,2), 'cosine', session_type_iSession{5}(1), session_type_iSession{5}(2));
%                 power_all(i_stim,1) = power_tmp/1400/6;
%             elseif aom_input_tmp(i_stim,1)==2 & aom_input_tmp(i_stim,2)>0
%                 [dummy power_tmp] = stimulation_power_analysis_new(aom_input_tmp(i_stim,2), 'continuous', session_type_iSession{5}(1), session_type_iSession{5}(2));
%                 power_all(i_stim,1) = power_tmp/1400/6;
%             else
%                 power_all(i_stim,1) = nan;
%             end
%         end
% 
%         solo_aom_power = solo_aom;
%         for i_stim = 1:size(aom_input_tmp,1)
%             solo_aom_power(solo_photostim_type==aom_input_tmp(i_stim,1) & solo_aom==aom_input_tmp(i_stim,2),:) = power_all(i_stim,1);
%         end
%         
%         % go through single untis
%         for i_unit = 1:size(single_units,1)
% 
%             unit_tmp = single_units{i_unit};
%             unit_tmp.stable_trials(unit_tmp.stable_trials>size(solo_aom,1))=[];
%             unit_stable_trials_tmp = zeros(size(solo_aom,1),1);
%             unit_stable_trials_tmp(unit_tmp.stable_trials) = 1;
% 
%             % average waveform
%             waveform_tmp = mean(unit_tmp.waveforms);
%             waveform_amp_tmp = range(waveform_tmp);
% 
% 
%             % cell type
%             if probe_type_iSession(1) == 1
%                 whisper_flag_tmp = 0;
%             elseif probe_type_iSession(1) == 2
%                 whisper_flag_tmp = 1;
%             end
%             [cell_type_tmp spk_width_tmp] = func_get_cell_type_WhisperSwitch(unit_tmp.waveforms, whisper_flag_tmp);
% 
% 
%             % response data
%             clear FR_baseline_tmp  FR_stim_tmp;
%             %exception: VGAT protocol comparison, only keep cosine data
%             if experiment_index_tmp==1 & session_type_iSession{1}(1)==1
%                 solo_laser_time(solo_photostim_type~=1,:)=nan;
%             end
%             i_sel_trials = find(~isnan(solo_laser_time(:,1)) & solo_laser_time(:,1)>.5 & unit_stable_trials_tmp);
%             FR_baseline_tmp = [];
%             FR_stim_tmp = [];
%             photostim_info_tmp = [];
%             for i_trial = i_sel_trials'
%                 t_laserON_tmp = solo_laser_time(i_trial,1);
%                 t_laserOFF_tmp = solo_laser_time(i_trial,2);
%                 FR_baseline_tmp(end+1,1) = sum(unit_tmp.spike_times>(t_laserON_tmp-.5) & unit_tmp.spike_times<t_laserON_tmp & unit_tmp.trials==i_trial)/.5;
%                 FR_stim_tmp(end+1,1) = sum(unit_tmp.spike_times>t_laserON_tmp & unit_tmp.spike_times<(t_laserOFF_tmp-.2) & unit_tmp.trials==i_trial)/(t_laserOFF_tmp-.2-t_laserON_tmp);
% 
%                 photostim_info_tmp(end+1,:) = [solo_aom_power(i_trial,1) solo_dist(i_trial,:) solo_photostim_type(i_trial,:)];
%             end
% 
% 
%             %save data
%             waveform_all{end+1,1} = waveform_tmp/norm(waveform_tmp);
%             unit_info_all(end+1,:) = [cell_type_tmp   probe_type_iSession   recording_depth_iSession   median(unit_tmp.channel)  galvo_zero_offset_iSession   experiment_index_tmp];
%             exp_ind_all(end+1,:) = experiment_index_tmp;   % experiment index
%             response_data_all{end+1,1} = [FR_baseline_tmp FR_stim_tmp photostim_info_tmp];
% 
% 
%         end
% 
%     end
% 
% end
% 
% save analysis_ALL_effect_vs_power
load analysis_ALL_effect_vs_power





% ################# transgenic data #####################
laser_dist = [-.1:.5:3.5];
mytitle = {
    '1 VGAT S1'
    '2 SOM S1';...
    '3 PV S1';...
    '5 Arch S1';...
    %'6 ArchT Rbp4 S1';...
    '7 PV-cre inj S1';...
    '8 PV ReaChR S1';...
    '10 PV ReaChR ALM';...
    '11 VGAT ALM';...
    };

summarycolor = {
    {[0 0  1],['o']};...  % 1 VGAT S1
    {[0 1  0],['o']};...  % 2 SOM S1
    {[1 0  0],['o']};...  % 3 PV S1
    {[.7 .7 0],['o']};...  % 5 Arch S1
    %{[0 0 0],['o']};...  % 6 ArchT Rbp4 S1
    {[0 .6 0],['o']};...  % 7 PV-cre inj S1
    {[.4 0 0],['o']};...  % 8 PV ReaChR S1
    {[.4 0 0],['s']};...  % 10 PV ReaChR ALM
    {[0 0 1],['s']};...  % 11 VGAT ALM
    };



figure; hold on

n_experiment = 0;
for experiment_ID = [1 2 3 5 7 8 10 11];
    n_experiment = n_experiment+1;
    
    
    response_data_tmp = cell2mat(response_data_all(unit_info_all(:,8)==experiment_ID,:));
    aom_power_all = unique(response_data_tmp(:,3));
    aom_power_all = aom_power_all(aom_power_all>0);
    
    % exception: SOM, combine power
    if experiment_ID==2
        som_pow_fix1 = [aom_power_all(2) aom_power_all(3)];
        som_pow_fix2 = [aom_power_all(5) aom_power_all(6)];
        som_pow_fix3 = [aom_power_all(8) aom_power_all(9)];        
        response_data_tmp(response_data_tmp(:,3)==som_pow_fix1(1),3)=som_pow_fix1(2);
        response_data_tmp(response_data_tmp(:,3)==som_pow_fix2(1),3)=som_pow_fix2(2);
        response_data_tmp(response_data_tmp(:,3)==som_pow_fix3(1),3)=som_pow_fix3(2);
        aom_power_all = unique(response_data_tmp(:,3));
        aom_power_all = aom_power_all(aom_power_all>0);
    end

    
    %     % exception: Arch/ArchT, label affected neurons
    %     affected_cell_tmp = [];
    %     for i_unit = 1:numel(response_data_all)
    %         i_sel_trial = find(response_data_all{i_unit}(:,3)==max(response_data_all{i_unit}(:,3)) & response_data_all{i_unit}(:,4)<.5);
    %         affected_cell_tmp(i_unit,1) = (mean(response_data_all{i_unit}(i_sel_trial,2))/mean(response_data_all{i_unit}(i_sel_trial,1)))<.3;
    %     end
    
    % exception: Arch/ArchT, only use continuous
    if experiment_ID==5 | experiment_ID==6
        aom_power_all = unique(response_data_tmp(response_data_tmp(:,6)==2,3));
        aom_power_all = aom_power_all(aom_power_all>0);
    end
    
    
    n_units_all = [];
    effect_all = [];
    for i_power = 1:numel(aom_power_all)
        
        FR_allCells = [];
        for i_unit = find(unit_info_all(:,8)==experiment_ID)'
            
            % cell selection
            clear flg_cell_sel
            flg_cell_sel = (unit_info_all(i_unit,1)==1);
            %             if (experiment_ID ~= 5) & (experiment_ID ~= 6)
            %                 flg_cell_sel = (unit_info_all(i_unit,1)==1);
            %             else
            %                 % exception: Arch/ArchT, label affected neurons
            %                 flg_cell_sel = (affected_cell_tmp(i_unit)==1);
            %             end
            
            if flg_cell_sel
                
                if (unit_info_all(i_unit,3)==5)
                    electrode_offset = -(floor(unit_info_all(i_unit,5)/8.1))*.4;
                elseif (unit_info_all(i_unit,3)==1) || (unit_info_all(i_unit,3)==2) || (unit_info_all(i_unit,3)==3)
                    electrode_offset = -(floor(unit_info_all(i_unit,5)/8.1))*.2;
                end
                unit_dist_offset = [electrode_offset-unit_info_all(i_unit,6) unit_info_all(i_unit,7)];
                
                
                response_data_tmp = response_data_all{i_unit};
                % exception: SOM, combine power
                if experiment_ID==2
                    response_data_tmp(response_data_tmp(:,3)==som_pow_fix1(1),3)=som_pow_fix1(2);
                    response_data_tmp(response_data_tmp(:,3)==som_pow_fix2(1),3)=som_pow_fix2(2);
                    response_data_tmp(response_data_tmp(:,3)==som_pow_fix3(1),3)=som_pow_fix3(2);
                end
                unit_dist_tmp = response_data_tmp(:,4)-unit_dist_offset(1);
                
                
                i_sel_trial = find(abs(unit_dist_tmp)<=0.4 &  response_data_tmp(:,3)==aom_power_all(i_power));
                
                
                FR_allCells(end+1,:) =  mean(response_data_tmp(i_sel_trial,1:2),1);
                
            end
        end
        
        FR_tmp = FR_allCells(:,2)./FR_allCells(:,1);
        FR_tmp(FR_allCells(:,1)<=.5,:)=nan;
        
        effect_all(i_power,1) = nanmean(FR_tmp);
        effect_all(i_power,2) = nanstd(FR_tmp)/sqrt(sum(~isnan(FR_tmp)));
        
        n_units_all(i_power,1) = size(FR_allCells,1);
        
    end
    
    disp(['experiment_ID ',num2str(experiment_ID),' -- n = ',num2str(max(n_units_all)),'    min ',num2str(min(n_units_all)), 'max power: ',num2str(max(aom_power_all))]);
        
    
    plot(aom_power_all,effect_all(:,1),'linewidth',2,'color',summarycolor{n_experiment}{1});
    errorbar(aom_power_all,effect_all(:,1),effect_all(:,2),'color',summarycolor{n_experiment}{1});
    
    
end

set(gca,'xscale','log')
xlim([0.2 40]);
ylim([0 1.4])
line([.2 40],[1 1],'linewidth',2,'linestyle',':','color','k')



%% Guang's ALM PV-cre x ReaChR data
load .\GuangALMPVReaChRData\Allsession_PV_PC_center2shank.mat

aom_power_all = PCmat(1,1:6);
PCmat(11,:) = [];

effect_all = [];
for i_power = 1:6
    FR_tmp = PCmat(:,i_power);
    effect_all(i_power,1) = nanmean(FR_tmp);
    effect_all(i_power,2) = nanstd(FR_tmp)/sqrt(sum(~isnan(FR_tmp)));
end

plot(aom_power_all,effect_all(:,1),'linewidth',2,'color',[.4 0 0]);
errorbar(aom_power_all,effect_all(:,1),effect_all(:,2),'color',[.4 0 0]);







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
%     if (session_type_iSession{1}(1)==1 | session_type_iSession{1}(1)==2) & (session_type_iSession{3}==1) & (session_type_iSession{4}==1)
%         
%         disp('1  -- VGAT-ChR2, S1 spatial mapping');
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
%                 photostim_info_tmp(end+1,:) = [solo_aom(i_trial,1) solo_dist(i_trial,:) solo_photostim_type(i_trial,:)];
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
% save analysis_ALL_effect_vs_dist
load analysis_ALL_effect_vs_dist




% 
% % ################# transgenic data #####################
% laser_dist = [-.1:.2:1.2 1.5 2 2.5 3.5];
% mycolor = {
%     {[0 0 .6],[0 0 1],[.6 .6  1]};...  % 1 VGAT S1
%     {[0 .6 0],[0 1 0],[.6  1 .6],[.6  1 .6]};...  % 2 SOM S1
%     {[ .6 0 0],[1 0 0],[1 .6 .6]};...  % 3 PV S1
%     {[0 0 0],[.2 .2 0],[.4 .4 0],[.55 .55  0], [.7 .7 0], [.8 .8 0], [.9 .9 0]};...  % 5 Arch S1
%     {[0 0 0],[.2 .2 .2],[.4 .4 .4],[.55 .55  .55], [.7 .7 .7], [.8 .8 .8], [.9 .9 .9]};...  % 6 ArchT Rbp4 S1
%     {[0 0 0],[.4 0 0],[.75 0 0],[1 0 0],[1 .4 .4]};...  % 8 PV ReaChR S1
%     {[0 0 0],[.4 0 0],[.75 0 0],[1 0 0],[1 .4 .4]};...  % 10 PV ReaChR ALM
%     {[0 0 .6],[0 0 1],[.3 .3  1],[.6 .6  1]};...  % 11 VGAT ALM
%     };
% mytitle = {
%     '1 VGAT S1'
%     '2 SOM S1';...
%     '3 PV S1';...
%     '5 Arch S1';...
%     '6 ArchT Rbp4 S1';...
%     '8 PV ReaChR S1';...
%     '10 PV ReaChR ALM';...
%     '11 VGAT ALM';...
%     };
% 
% summarycolor = {
%     {[0 0  1],['o']};...  % 1 VGAT S1
%     {[0 1  0],['o']};...  % 2 SOM S1
%     {[1 0  0],['o']};...  % 3 PV S1
%     {[.7 .7 0],['o']};...  % 5 Arch S1
%     {[0 0 0],['o']};...  % 6 ArchT Rbp4 S1
%     {[.4 0 0],['o']};...  % 8 PV ReaChR S1
%     {[.4 0 0],['s']};...  % 10 PV ReaChR ALM
%     {[0 0 1],['s']};...  % 11 VGAT ALM
%     };
% 
% n_experiment = 0;
% for experiment_ID = [1 2 3 5 8 10 11];
%     n_experiment = n_experiment+1;
%     
%     
%     response_data_tmp = cell2mat(response_data_all(unit_info_all(:,8)==experiment_ID,:));
%     aom_power_all = unique(response_data_tmp(:,3));
%     % exception: VGAT
%     if experiment_ID==1
%         aom_power_all = [.42 .75 2.5];
%         
%     % exception: SOM
%     elseif experiment_ID==2
%         aom_power_all = [.48 .83 3.4];
%     end
%     
%     % exception: Arch/ArchT, label affected neurons
%     affected_cell_tmp = [];
%     for i_unit = 1:numel(response_data_all)
%         i_sel_trial = find(response_data_all{i_unit}(:,3)==max(response_data_all{i_unit}(:,3)) & response_data_all{i_unit}(:,4)<.5);        
%         affected_cell_tmp(i_unit,1) = (mean(response_data_all{i_unit}(i_sel_trial,2))/mean(response_data_all{i_unit}(i_sel_trial,1)))<.3;
%     end
%     
%     
%     
%     effect_all = [];
%     for i_power = 1:numel(aom_power_all)
%         n_dist = 0;
%         for i_stim_dist = laser_dist
%             n_dist = n_dist+1;
%             
%             
%             FR_allCells = [];
%             for i_unit = find(unit_info_all(:,8)==experiment_ID)'
%                 
%                 if unit_info_all(i_unit,1)==1
%                     
%                     if (unit_info_all(i_unit,3)==5)
%                         electrode_offset = -(floor(unit_info_all(i_unit,5)/8.1))*.4;
%                     elseif (unit_info_all(i_unit,3)==1) || (unit_info_all(i_unit,3)==2) || (unit_info_all(i_unit,3)==3)
%                         electrode_offset = -(floor(unit_info_all(i_unit,5)/8.1))*.2;
%                     end
%                     unit_dist_offset = [electrode_offset-unit_info_all(i_unit,6) unit_info_all(i_unit,7)];
%                     
%                     
%                     response_data_tmp = response_data_all{i_unit};
%                     unit_dist_tmp = response_data_tmp(:,4)-unit_dist_offset(1);
%                     
%                     % exception: SOM
%                     if experiment_ID==2
%                         response_data_tmp(response_data_tmp(:,3)==.52,3) = .48;
%                         response_data_tmp(response_data_tmp(:,3)==.5,3) = .48;
%                         response_data_tmp(response_data_tmp(:,3)==.87,3) = .83;
%                         response_data_tmp(response_data_tmp(:,3)==2.72,3) = 3.4;
%                         response_data_tmp(response_data_tmp(:,3)==2.9,3) = 3.4;
%                     end
%                     
%                     
%                     if i_stim_dist == -.1
%                         i_sel_trial = find(unit_dist_tmp <= i_stim_dist+.1 & unit_dist_tmp> -inf  &  response_data_tmp(:,3)==aom_power_all(i_power));
%                     elseif i_stim_dist == 1.5
%                         i_sel_trial = find(unit_dist_tmp <= i_stim_dist+.25 & unit_dist_tmp> i_stim_dist-.1  &  response_data_tmp(:,3)==aom_power_all(i_power));
%                     elseif i_stim_dist == 2
%                         i_sel_trial = find(unit_dist_tmp <= i_stim_dist+.25 & unit_dist_tmp> i_stim_dist-.25  &  response_data_tmp(:,3)==aom_power_all(i_power));
%                     elseif i_stim_dist == 2.5
%                         i_sel_trial = find(unit_dist_tmp <= i_stim_dist+.5 & unit_dist_tmp> i_stim_dist-.25  &  response_data_tmp(:,3)==aom_power_all(i_power));
%                     elseif i_stim_dist == 3.5                        
%                         i_sel_trial = find(unit_dist_tmp> i_stim_dist-.5  &  response_data_tmp(:,3)==aom_power_all(i_power));
%                     else
%                         i_sel_trial = find(unit_dist_tmp <= i_stim_dist+.1 & unit_dist_tmp> i_stim_dist-.1  &  response_data_tmp(:,3)==aom_power_all(i_power));
%                     end
%                     
%                     % label affected neurons
%                     if  affected_cell_tmp(i_unit)==0
%                         i_sel_trial=[];
%                     end
%                     
%                     FR_allCells(end+1,:) =  mean(response_data_tmp(i_sel_trial,1:2),1);
%                     
%                 end
%             end
%             
%             FR_tmp = FR_allCells(:,2)./FR_allCells(:,1);
%             FR_tmp(FR_allCells(:,1)<.5,:)=nan;
%             
%             effect_all(n_dist,i_power,1) = nanmean(FR_tmp);
%             effect_all(n_dist,i_power,2) = nanstd(FR_tmp)/sqrt(sum(~isnan(FR_tmp)));
%             
%             
%         end
%         
%     end
%     
% 
%     figure(1); 
%     subplot(4,2,n_experiment); hold on
%     for i_power=1:numel(aom_power_all)
%         plot(laser_dist,effect_all(:,i_power,1),'color',mycolor{n_experiment}{i_power},'linewidth',2);
%         errorbar(laser_dist,effect_all(:,i_power,1),effect_all(:,i_power,2),'color',mycolor{n_experiment}{i_power});
%         xlim([-.2 3.5]);
%         ylim([0 2]);
%         line([-.2 3.5],[1 1],'color','k','linestyle',':','linewidth',2)
%     end
%     title(mytitle{n_experiment})
%     
%     
%     
%     effect_size_allCondition = [];
%     effect_spread_allCondition = [];
%     for i_tmp=1:numel(aom_power_all)
%         x = laser_dist;
%         y = effect_all(1:length(x),i_tmp,1);
%         if  y(1)<.8
%             y_half_max = 1-(1-min(y))/2;
%             x(isnan(y))=[];
%             y(isnan(y))=[];
%             
%             fit_func = fit(x',y,'linearinterp');
%             x_fit = 0:.01:4;
%             y_fit = fit_func(x_fit);
%             dist_fit = x_fit(y_fit>=y_half_max);
%             if ~isempty(dist_fit)
%                 dist_fit = dist_fit(1);
%                 effect_size_allCondition(end+1,1) = min(y);
%                 effect_spread_allCondition(end+1,1) = dist_fit;
%             end
%         end
%     end
%     figure(3); hold on
%     plot(effect_size_allCondition, effect_spread_allCondition, summarycolor{n_experiment}{2},'linestyle', '-','color',summarycolor{n_experiment}{1})
%     xlabel('fraction of spikes at center')
%     ylabel('radius half max')
% 
%     
% end
% 
% 
% 
% 
% 
% 
% 
% % ################# PV viral injection data #####################
% laser_dist = [-.1:.2:1.5];
% 
% response_data_tmp = cell2mat(response_data_all(unit_info_all(:,8)==7,:));
% aom_power_all = unique(response_data_tmp(:,3));
% 
% 
% unit_dist_all = [];
% unit_response_all = [];
% for i_unit = 1:size(unit_info_all,1)
%     
%     if unit_info_all(i_unit,8)==7 & (unit_info_all(i_unit,3)==5) & unit_info_all(i_unit,1)==1
%        
%         electrode_offset = -(floor(unit_info_all(i_unit,5)/8.1))*.4;
%         unit_dist_all(end+1,1) = electrode_offset-unit_info_all(i_unit,6);    %<<<<<<<<<<<<< only horizontally displaced currently
%     
%         response_data_tmp = response_data_all{i_unit};
%         FR_tmp = [];
%         for i_aom = aom_power_all'
%             i_sel_trial = (response_data_tmp(:,3)==i_aom);
%             FR_tmp = [FR_tmp mean(response_data_tmp(i_sel_trial,1:2),1)];
%         end
%         unit_response_all(end+1,:) = FR_tmp;
%     end
% end
% 
% 
% FR_tmp = [];
% for i = 1:6    
%     FR_tmp(:,i) = unit_response_all(:,(i-1)*2+2)./unit_response_all(:,(i-1)*2+1);
%     FR_tmp(unit_response_all(:,(i-1)*2+1)<.5,i)=nan;
% end
% FR_tmp(FR_tmp>2)=2;
% 
% figure
% for i=1:numel(aom_power_all)
%     subplot(1,6,i); hold on
%     plot(unit_dist_all,FR_tmp(:,i),'o')
%     xlim([-.2 2]);
%     ylim([0 2]); 
%     line([-.2 2],[1 1],'color','k','linestyle',':','linewidth',2)
% end
% 
% 
% 
% mycolor = {[0 0 0],[0 .2 0],[0 .4 0],[0 .55  0], [0 .7 0], [0 .8 0]}
% 
% figure(1);
% subplot(4,2,8); hold on
% effect_all = [];
% for i_power = 1:numel(aom_power_all)
%     n_dist = 0;
%     for i_stim_dist = laser_dist
%         n_dist = n_dist+1;
%         
%         if i_stim_dist == -.1
%             i_dist_select = (unit_dist_all <= i_stim_dist+.1 & unit_dist_all> -inf);
%         else
%             i_dist_select = (unit_dist_all <= i_stim_dist+.1 & unit_dist_all> i_stim_dist-.1);
%         end
%         
%         effect_all(n_dist,i_power,1) = nanmean(FR_tmp(i_dist_select,i_power));
%         effect_all(n_dist,i_power,2) = nanstd(FR_tmp(i_dist_select,i_power))/sqrt(sum(~isnan(FR_tmp(i_dist_select,i_power))));
%     end
%     
%     plot(laser_dist,effect_all(:,i_power,1),'color',mycolor{i_power},'linewidth',2);
%     errorbar(laser_dist,effect_all(:,i_power,1),effect_all(:,i_power,2),'color',mycolor{i_power});
%     
% end
% xlim([-.5 3.5]);
% ylim([0 2]);
% line([-.5 3.5],[1 1],'color','k','linestyle',':','linewidth',2)
% title('7 PV-cre S1 inj')
% 
% 
% effect_size_allCondition = [];
% effect_spread_allCondition = [];
% for i_tmp=1:6
%     x = laser_dist;
%     y = effect_all(1:length(x),i_tmp,1);
%     if  y(1)<.8
%         y_half_max = 1-(1-min(y))/2;
%         x(isnan(y))=[];
%         y(isnan(y))=[];
%         
%         fit_func = fit(x',y,'linearinterp');
%         x_fit = 0:.01:4;
%         y_fit = fit_func(x_fit);
%         dist_fit = x_fit(y_fit>=y_half_max);
%         dist_fit = dist_fit(1);
%         
%         effect_size_allCondition(end+1,1) = min(y);
%         effect_spread_allCondition(end+1,1) = dist_fit;
%     end
% end
% figure(3); hold on
% plot(effect_size_allCondition, effect_spread_allCondition, 'o-','color',[0 .8 0])
% xlabel('fraction of spikes at center')
% ylabel('radius half max')










% ################# transgenic data #####################
% laser_dist = [-.1:.1:3.5];
laser_dist = [-.1:.25:3.5];



mycolor = {
    {[0 0 .6],[0 0 1],[.6 .6  1]};...  % 1 VGAT S1
    {[0 .6 0],[0 1 0],[.6  1 .6],[.6  1 .6]};...  % 2 SOM S1
    {[ .6 0 0],[1 0 0],[1 .6 .6]};...  % 3 PV S1
    {[0 0 0],[.2 .2 0],[.4 .4 0],[.55 .55  0], [.7 .7 0], [.8 .8 0], [.9 .9 0]};...  % 5 Arch S1
    %{[0 0 0],[.2 .2 .2],[.4 .4 .4],[.55 .55  .55], [.7 .7 .7], [.8 .8 .8], [.9 .9 .9]};...  % 6 ArchT Rbp4 S1
    {[0 0 0],[.4 0 0],[.75 0 0],[1 0 0],[1 .4 .4]};...  % 8 PV ReaChR S1
    {[0 0 0],[.4 0 0],[.75 0 0],[1 0 0],[1 .4 .4]};...  % 10 PV ReaChR ALM
    {[0 0 .6],[0 0 1],[.3 .3  1],[.6 .6  1]};...  % 11 VGAT ALM
    };
mytitle = {
    '1 VGAT S1'
    '2 SOM S1';...
    '3 PV S1';...
    '5 Arch S1';...
    %'6 ArchT Rbp4 S1';...
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
    {[.4 0 0],['o']};...  % 8 PV ReaChR S1
    {[.4 0 0],['s']};...  % 10 PV ReaChR ALM
    {[0 0 1],['s']};...  % 11 VGAT ALM
    };

n_experiment = 0;
for experiment_ID = [1 2 3 5 8 10 11];
    n_experiment = n_experiment+1;
    
    
    response_data_tmp = cell2mat(response_data_all(unit_info_all(:,8)==experiment_ID,:));
    aom_power_all = unique(response_data_tmp(:,3));
    aom_power_all = aom_power_all(aom_power_all>0);
    % exception: VGAT
    if experiment_ID==1
        aom_power_all = [.42 .75 2.5];
        
    % exception: SOM
    elseif experiment_ID==2
        aom_power_all = [.48 .83 3.4];
    end
    
    % exception: Arch or ArchT
    if experiment_ID==5 | experiment_ID==6
        response_data_tmp = cell2mat(response_data_all(unit_info_all(:,8)==experiment_ID,:));
        response_data_tmp(response_data_tmp(:,3)==.48 & response_data_tmp(:,6)==2,3) = 5.48;
        response_data_tmp(response_data_tmp(:,3)==.82 & response_data_tmp(:,6)==2,3) = 5.82;
        response_data_tmp(response_data_tmp(:,3)==2.4 & response_data_tmp(:,6)==2,3) = 7.4;
        response_data_tmp(response_data_tmp(:,3)==5 & response_data_tmp(:,6)==2,3) = 10;
        aom_power_all = unique(response_data_tmp(:,3));
        aom_power_all = aom_power_all(aom_power_all>0);
    end
    
    
    %     % exception: Arch/ArchT, label affected neurons
    %     affected_cell_tmp = [];
    %     for i_unit = 1:numel(response_data_all)
    %         i_sel_trial = find(response_data_all{i_unit}(:,3)==max(response_data_all{i_unit}(:,3)) & response_data_all{i_unit}(:,4)<.5);
    %         affected_cell_tmp(i_unit,1) = (mean(response_data_all{i_unit}(i_sel_trial,2))/mean(response_data_all{i_unit}(i_sel_trial,1)))<.3;
    %     end
    
    
    effect_all = [];
    for i_power = 1:numel(aom_power_all)
        n_dist = 0;
        for i_stim_dist = laser_dist
            n_dist = n_dist+1;
            
            
            FR_allCells = [];
            for i_unit = find(unit_info_all(:,8)==experiment_ID)'
                
                % cell selection
                clear flg_cell_sel
                flg_cell_sel = (unit_info_all(i_unit,1)==1);
                %                 if (experiment_ID ~= 5) & (experiment_ID ~= 6)
                %                     flg_cell_sel = (unit_info_all(i_unit,1)==1);
                %                 else
                %                     % exception: Arch/ArchT, label affected neurons
                %                     flg_cell_sel = (affected_cell_tmp(i_unit)==1);
                %                 end
                
                if flg_cell_sel
                    
                    if (unit_info_all(i_unit,3)==5)
                        electrode_offset = -(floor(unit_info_all(i_unit,5)/8.1))*.4;
                    elseif (unit_info_all(i_unit,3)==1) || (unit_info_all(i_unit,3)==2) || (unit_info_all(i_unit,3)==3)
                        electrode_offset = -(floor(unit_info_all(i_unit,5)/8.1))*.2;
                    end
                    unit_dist_offset = [electrode_offset-unit_info_all(i_unit,6) unit_info_all(i_unit,7)];
                    
                    
                    response_data_tmp = response_data_all{i_unit};
                    unit_dist_tmp = response_data_tmp(:,4)-unit_dist_offset(1);
                    
                    % exception: SOM
                    if experiment_ID==2
                        response_data_tmp(response_data_tmp(:,3)==.52,3) = .48;
                        response_data_tmp(response_data_tmp(:,3)==.5,3) = .48;
                        response_data_tmp(response_data_tmp(:,3)==.87,3) = .83;
                        response_data_tmp(response_data_tmp(:,3)==2.72,3) = 3.4;
                        response_data_tmp(response_data_tmp(:,3)==2.9,3) = 3.4;
                    end
                    % exception: Arch or ArchT
                    if experiment_ID==5 | experiment_ID==6
                        response_data_tmp(response_data_tmp(:,3)==.48 & response_data_tmp(:,6)==2,3) = 5.48;
                        response_data_tmp(response_data_tmp(:,3)==.82 & response_data_tmp(:,6)==2,3) = 5.82;
                        response_data_tmp(response_data_tmp(:,3)==2.4 & response_data_tmp(:,6)==2,3) = 7.4;
                        response_data_tmp(response_data_tmp(:,3)==5 & response_data_tmp(:,6)==2,3) = 10;
                    end
                    
                    
                    if i_stim_dist == -.1
                        i_sel_trial = find(unit_dist_tmp <= i_stim_dist+.25 & unit_dist_tmp> -inf  &  response_data_tmp(:,3)==aom_power_all(i_power));
                    else
                        i_sel_trial = find(unit_dist_tmp <= i_stim_dist+.25 & unit_dist_tmp> i_stim_dist-.25  &  response_data_tmp(:,3)==aom_power_all(i_power));
                    end
                    
                    
                    FR_allCells(end+1,:) =  mean(response_data_tmp(i_sel_trial,1:2),1);
                    
                end
            end
            
            FR_tmp = FR_allCells(:,2)./FR_allCells(:,1);
            FR_tmp(FR_allCells(:,1)<.4,:)=nan;
            
            effect_all(n_dist,i_power,1) = nanmean(FR_tmp);
            effect_all(n_dist,i_power,2) = nanstd(FR_tmp)/sqrt(sum(~isnan(FR_tmp)));
            
        end
        
    end
    
    disp(['experiment_ID ',num2str(experiment_ID),' -- n = ',num2str(sum(unit_info_all(:,8)==experiment_ID & unit_info_all(:,1)==1))]);
    
    
    figure(1); 
    subplot(4,2,n_experiment); hold on
    for i_power=1:numel(aom_power_all)
        if effect_all(1,i_power,1)<.9
            x = laser_dist;
            y = effect_all(:,i_power,1);
            se = effect_all(:,i_power,2);
            se(isnan(y))=[];
            x(isnan(y))=[];
            y(isnan(y))=[];
            plot(x,y,'color',mycolor{n_experiment}{i_power},'linewidth',2);
            errorbar(x,y,se,'color',mycolor{n_experiment}{i_power});
            xlim([-.2 3.5]);
            ylim([0 2]);
            line([-.2 3.5],[1 1],'color','k','linestyle',':','linewidth',2)
        end
    end
    title(mytitle{n_experiment})
    
    
    
    effect_size_allCondition = [];
    effect_spread_allCondition = [];
    for i_tmp=1:numel(aom_power_all)
        x = laser_dist;
        y = effect_all(1:length(x),i_tmp,1);
        if  y(1)<.8
            y_half_max = 1-(1-min(y))/2;
            x(isnan(y))=[];
            y(isnan(y))=[];
            
            if length(x)>2
                fit_func = fit(x',y,'linearinterp');
                x_fit = 0:.01:4;
                y_fit = fit_func(x_fit);
                dist_fit = x_fit(y_fit>=y_half_max);
                if ~isempty(dist_fit)
                    dist_fit = dist_fit(1);
                    effect_size_allCondition(end+1,1) = min(y);
                    effect_spread_allCondition(end+1,1) = dist_fit;
                end
            end
        end
    end
    figure(3); hold on
    plot(effect_size_allCondition, effect_spread_allCondition, summarycolor{n_experiment}{2},'linestyle', '-','color',summarycolor{n_experiment}{1})
    xlabel('fraction of spikes at center')
    ylabel('radius half max')

    
end




% ################# PV viral injection data #####################
% laser_dist = [-.1:.5:1.5];
laser_dist = [-.1:.1:1.5];

response_data_tmp = cell2mat(response_data_all(unit_info_all(:,8)==7,:));
aom_power_all = unique(response_data_tmp(:,3));


unit_dist_all = [];
unit_response_all = [];
for i_unit = 1:size(unit_info_all,1)
    
    if unit_info_all(i_unit,8)==7 & (unit_info_all(i_unit,3)==5) & unit_info_all(i_unit,1)==1
       
        electrode_offset = -(floor(unit_info_all(i_unit,5)/8.1))*.4;
        unit_dist_all(end+1,1) = electrode_offset-unit_info_all(i_unit,6);    %<<<<<<<<<<<<< only horizontally displaced currently
    
        response_data_tmp = response_data_all{i_unit};
        FR_tmp = [];
        for i_aom = aom_power_all'
            i_sel_trial = (response_data_tmp(:,3)==i_aom);
            FR_tmp = [FR_tmp mean(response_data_tmp(i_sel_trial,1:2),1)];
        end
        unit_response_all(end+1,:) = FR_tmp;
    end
end


FR_tmp = [];
for i = 1:6    
    FR_tmp(:,i) = unit_response_all(:,(i-1)*2+2)./unit_response_all(:,(i-1)*2+1);
    FR_tmp(unit_response_all(:,(i-1)*2+1)<.5,i)=nan;
end
FR_tmp(FR_tmp>2)=2;

figure
for i=1:numel(aom_power_all)
    subplot(1,6,i); hold on
    plot(unit_dist_all,FR_tmp(:,i),'o')
    xlim([-.2 2]);
    ylim([0 2]); 
    line([-.2 2],[1 1],'color','k','linestyle',':','linewidth',2)
end



mycolor = {[0 0 0],[0 .2 0],[0 .4 0],[0 .55  0], [0 .7 0], [0 .8 0]}

figure(1);
subplot(4,2,8); hold on
effect_all = [];
for i_power = 1:numel(aom_power_all)
    n_dist = 0;
    for i_stim_dist = laser_dist
        n_dist = n_dist+1;
        
        if i_stim_dist == -.1
            i_dist_select = (unit_dist_all <= i_stim_dist+.25 & unit_dist_all> -inf);
        else
            i_dist_select = (unit_dist_all <= i_stim_dist+.25 & unit_dist_all> i_stim_dist-.25);
        end
        
        effect_all(n_dist,i_power,1) = nanmean(FR_tmp(i_dist_select,i_power));
        effect_all(n_dist,i_power,2) = nanstd(FR_tmp(i_dist_select,i_power))/sqrt(sum(~isnan(FR_tmp(i_dist_select,i_power))));
    end
    
    plot(laser_dist,effect_all(:,i_power,1),'color',mycolor{i_power},'linewidth',2);
    errorbar(laser_dist,effect_all(:,i_power,1),effect_all(:,i_power,2),'color',mycolor{i_power});
    
end
xlim([-.2 3.5]);
ylim([0 2]);
line([-.2 3.5],[1 1],'color','k','linestyle',':','linewidth',2)
title('7 PV-cre S1 inj')


effect_size_allCondition = [];
effect_spread_allCondition = [];
for i_tmp=1:6
    x = laser_dist;
    y = effect_all(1:length(x),i_tmp,1);
    if  y(1)<.8
        y_half_max = 1-(1-min(y))/2;
        x(isnan(y))=[];
        y(isnan(y))=[];
        
        fit_func = fit(x',y,'linearinterp');
        x_fit = 0:.01:4;
        y_fit = fit_func(x_fit);
        dist_fit = x_fit(y_fit>=y_half_max);
        dist_fit = dist_fit(1);
        
        effect_size_allCondition(end+1,1) = min(y);
        effect_spread_allCondition(end+1,1) = dist_fit;
    end
end
figure(3); hold on
plot(effect_size_allCondition, effect_spread_allCondition, 'o-','color',[0 .8 0])
xlabel('fraction of spikes at center')
ylabel('radius half max')























%% bootstrap
unit_info_all_bakup = unit_info_all;
response_data_all_bakup = response_data_all;
n_unit = size(response_data_all_bakup,1)



for i_btstrp = 1:200
    
    i_sample = randsample(n_unit,n_unit,'true');
    
    response_data_all = response_data_all_bakup(i_sample,1);
    unit_info_all = unit_info_all_bakup(i_sample,:);
    
    
    
    

    % ################# transgenic data #####################
    %laser_dist = [-.1:.5:3.5];
    laser_dist = [-.1:.1:3.5];
    mycolor = {
        {[0 0 .6],[0 0 1],[.6 .6  1]};...  % 1 VGAT S1
        {[0 .6 0],[0 1 0],[.6  1 .6],[.6  1 .6]};...  % 2 SOM S1
        {[ .6 0 0],[1 0 0],[1 .6 .6]};...  % 3 PV S1
        {[0 0 0],[.2 .2 0],[.4 .4 0],[.55 .55  0], [.7 .7 0], [.8 .8 0], [.9 .9 0]};...  % 5 Arch S1
        %{[0 0 0],[.2 .2 .2],[.4 .4 .4],[.55 .55  .55], [.7 .7 .7], [.8 .8 .8], [.9 .9 .9]};...  % 6 ArchT Rbp4 S1
        {[0 0 0],[.4 0 0],[.75 0 0],[1 0 0],[1 .4 .4]};...  % 8 PV ReaChR S1
        {[0 0 0],[.4 0 0],[.75 0 0],[1 0 0],[1 .4 .4]};...  % 10 PV ReaChR ALM
        {[0 0 .6],[0 0 1],[.3 .3  1],[.6 .6  1]};...  % 11 VGAT ALM
        };
    mytitle = {
        '1 VGAT S1'
        '2 SOM S1';...
        '3 PV S1';...
        '5 Arch S1';...
        %'6 ArchT Rbp4 S1';...
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
        {[.4 0 0],['o']};...  % 8 PV ReaChR S1
        {[.4 0 0],['s']};...  % 10 PV ReaChR ALM
        {[0 0 1],['s']};...  % 11 VGAT ALM
        };
    
    n_experiment = 0;
    for experiment_ID = [1 2 3 5 8 10 11];
        n_experiment = n_experiment+1;
        
        
        response_data_tmp = cell2mat(response_data_all(unit_info_all(:,8)==experiment_ID,:));
        aom_power_all = unique(response_data_tmp(:,3));
        aom_power_all = aom_power_all(aom_power_all>0);
        % exception: VGAT
        if experiment_ID==1
            aom_power_all = [.42 .75 2.5];
            
            % exception: SOM
        elseif experiment_ID==2
            aom_power_all = [.48 .83 3.4];
        end
        
        % exception: Arch or ArchT
        if experiment_ID==5 | experiment_ID==6
            response_data_tmp = cell2mat(response_data_all(unit_info_all(:,8)==experiment_ID,:));
            response_data_tmp(response_data_tmp(:,3)==.48 & response_data_tmp(:,6)==2,3) = 5.48;
            response_data_tmp(response_data_tmp(:,3)==.82 & response_data_tmp(:,6)==2,3) = 5.82;
            response_data_tmp(response_data_tmp(:,3)==2.4 & response_data_tmp(:,6)==2,3) = 7.4;
            response_data_tmp(response_data_tmp(:,3)==5 & response_data_tmp(:,6)==2,3) = 10;
            aom_power_all = unique(response_data_tmp(:,3));
            aom_power_all = aom_power_all(aom_power_all>0);
        end
        
        %
        %         % exception: Arch/ArchT, label affected neurons
        %         affected_cell_tmp = [];
        %         for i_unit = 1:numel(response_data_all)
        %             i_sel_trial = find(response_data_all{i_unit}(:,3)==max(response_data_all{i_unit}(:,3)) & response_data_all{i_unit}(:,4)<.5);
        %             affected_cell_tmp(i_unit,1) = (mean(response_data_all{i_unit}(i_sel_trial,2))/mean(response_data_all{i_unit}(i_sel_trial,1)))<.3;
        %         end
        %
        
        effect_all = [];
        for i_power = 1:numel(aom_power_all)
            n_dist = 0;
            for i_stim_dist = laser_dist
                n_dist = n_dist+1;
                
                
                FR_allCells = [];
                for i_unit = find(unit_info_all(:,8)==experiment_ID)'
                    
                    % cell selection
                    clear flg_cell_sel
                    flg_cell_sel = (unit_info_all(i_unit,1)==1);
                    %                     if (experiment_ID ~= 5) & (experiment_ID ~= 6)
                    %                         flg_cell_sel = (unit_info_all(i_unit,1)==1);
                    %                     else
                    %                         % exception: Arch/ArchT, label affected neurons
                    %                         flg_cell_sel = (affected_cell_tmp(i_unit)==1);
                    %                     end
                    
                    if flg_cell_sel
                        
                        if (unit_info_all(i_unit,3)==5)
                            electrode_offset = -(floor(unit_info_all(i_unit,5)/8.1))*.4;
                        elseif (unit_info_all(i_unit,3)==1) || (unit_info_all(i_unit,3)==2) || (unit_info_all(i_unit,3)==3)
                            electrode_offset = -(floor(unit_info_all(i_unit,5)/8.1))*.2;
                        end
                        unit_dist_offset = [electrode_offset-unit_info_all(i_unit,6) unit_info_all(i_unit,7)];
                        
                        
                        response_data_tmp = response_data_all{i_unit};
                        unit_dist_tmp = response_data_tmp(:,4)-unit_dist_offset(1);
                        
                        % exception: SOM
                        if experiment_ID==2
                            response_data_tmp(response_data_tmp(:,3)==.52,3) = .48;
                            response_data_tmp(response_data_tmp(:,3)==.5,3) = .48;
                            response_data_tmp(response_data_tmp(:,3)==.87,3) = .83;
                            response_data_tmp(response_data_tmp(:,3)==2.72,3) = 3.4;
                            response_data_tmp(response_data_tmp(:,3)==2.9,3) = 3.4;
                        end
                        % exception: Arch or ArchT
                        if experiment_ID==5 | experiment_ID==6
                            response_data_tmp(response_data_tmp(:,3)==.48 & response_data_tmp(:,6)==2,3) = 5.48;
                            response_data_tmp(response_data_tmp(:,3)==.82 & response_data_tmp(:,6)==2,3) = 5.82;
                            response_data_tmp(response_data_tmp(:,3)==2.4 & response_data_tmp(:,6)==2,3) = 7.4;
                            response_data_tmp(response_data_tmp(:,3)==5 & response_data_tmp(:,6)==2,3) = 10;
                        end
                        
                        
                        if i_stim_dist == -.1
                            i_sel_trial = find(unit_dist_tmp <= i_stim_dist+.25 & unit_dist_tmp> -inf  &  response_data_tmp(:,3)==aom_power_all(i_power));
                        else
                            i_sel_trial = find(unit_dist_tmp <= i_stim_dist+.25 & unit_dist_tmp> i_stim_dist-.25  &  response_data_tmp(:,3)==aom_power_all(i_power));
                        end
                        
                        
                        FR_allCells(end+1,:) =  mean(response_data_tmp(i_sel_trial,1:2),1);
                        
                    end
                end
                
                FR_tmp = FR_allCells(:,2)./FR_allCells(:,1);
                FR_tmp(FR_allCells(:,1)<.4,:)=nan;
                
                effect_all(n_dist,i_power,1) = nanmean(FR_tmp);
                effect_all(n_dist,i_power,2) = nanstd(FR_tmp)/sqrt(sum(~isnan(FR_tmp)));
                
            end
            
        end
        
        
        effect_size_allCondition = [];
        effect_spread_allCondition = [];
        for i_tmp=1:numel(aom_power_all)
            x = laser_dist;
            y = effect_all(1:length(x),i_tmp,1);
            if  y(1)<.8
                y_half_max = 1-(1-min(y))/2;
                x(isnan(y))=[];
                y(isnan(y))=[];
                
                if length(x)>2
                    fit_func = fit(x',y,'linearinterp');
                    x_fit = 0:.01:4;
                    y_fit = fit_func(x_fit);
                    dist_fit = x_fit(y_fit>=y_half_max);
                    if ~isempty(dist_fit)
                        dist_fit = dist_fit(1);
                        effect_size_allCondition(end+1,1) = min(y);
                        effect_spread_allCondition(end+1,1) = dist_fit;
                    end
                end
            end
        end
        figure(12); hold on
        plot(effect_size_allCondition, effect_spread_allCondition, '.','color',summarycolor{n_experiment}{1})
        
        
    end
    

    
    
    


    
    % ################# PV viral injection data #####################
    laser_dist = [-.1:.5:1.5];
    
    response_data_tmp = cell2mat(response_data_all(unit_info_all(:,8)==7,:));
    aom_power_all = unique(response_data_tmp(:,3));
    
    
    unit_dist_all = [];
    unit_response_all = [];
    for i_unit = 1:size(unit_info_all,1)
        
        if unit_info_all(i_unit,8)==7 & (unit_info_all(i_unit,3)==5) & unit_info_all(i_unit,1)==1
            
            electrode_offset = -(floor(unit_info_all(i_unit,5)/8.1))*.4;
            unit_dist_all(end+1,1) = electrode_offset-unit_info_all(i_unit,6);    %<<<<<<<<<<<<< only horizontally displaced currently
            
            response_data_tmp = response_data_all{i_unit};
            FR_tmp = [];
            for i_aom = aom_power_all'
                i_sel_trial = (response_data_tmp(:,3)==i_aom);
                FR_tmp = [FR_tmp mean(response_data_tmp(i_sel_trial,1:2),1)];
            end
            unit_response_all(end+1,:) = FR_tmp;
        end
    end
    
    
    FR_tmp = [];
    for i = 1:6
        FR_tmp(:,i) = unit_response_all(:,(i-1)*2+2)./unit_response_all(:,(i-1)*2+1);
        FR_tmp(unit_response_all(:,(i-1)*2+1)<.5,i)=nan;
    end
    FR_tmp(FR_tmp>2)=2;
    
    
    effect_all = [];
    for i_power = 1:numel(aom_power_all)
        n_dist = 0;
        for i_stim_dist = laser_dist
            n_dist = n_dist+1;
            
            if i_stim_dist == -.1
                i_dist_select = (unit_dist_all <= i_stim_dist+.25 & unit_dist_all> -inf);
            else
                i_dist_select = (unit_dist_all <= i_stim_dist+.25 & unit_dist_all> i_stim_dist-.25);
            end
            
            effect_all(n_dist,i_power,1) = nanmean(FR_tmp(i_dist_select,i_power));
            effect_all(n_dist,i_power,2) = nanstd(FR_tmp(i_dist_select,i_power))/sqrt(sum(~isnan(FR_tmp(i_dist_select,i_power))));
        end
        
    end
    
    
    effect_size_allCondition = [];
    effect_spread_allCondition = [];
    for i_tmp=1:6
        x = laser_dist;
        y = effect_all(1:length(x),i_tmp,1);
        if  y(1)<.8
            y_half_max = 1-(1-min(y))/2;
            x(isnan(y))=[];
            y(isnan(y))=[];
            
            fit_func = fit(x',y,'linearinterp');
            x_fit = 0:.01:4;
            y_fit = fit_func(x_fit);
            dist_fit = x_fit(y_fit>=y_half_max);
            dist_fit = dist_fit(1);
            
            effect_size_allCondition(end+1,1) = min(y);
            effect_spread_allCondition(end+1,1) = dist_fit;
        end
    end
    figure(12); hold on
    plot(effect_size_allCondition, effect_spread_allCondition, 'o','color',[0 .8 0])
    

    pause(.1)
end    
    
    
    
    
    
    
    
    














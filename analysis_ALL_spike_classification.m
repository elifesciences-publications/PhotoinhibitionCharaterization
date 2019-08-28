clear all
close all
% 
% meta_passive_neuronal_depth_data
% 
% waveform_all = [];
% unit_info_all = []; % [cell_type    spike_width     peak_amp    baseline_FR     photostim_FR(highest power)  probe_type_iSession   sig_FR_change] 
% exp_ind_all = [];   % experiment index
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
%     disp(filename_tmp);
%     load(filename_tmp);
%     
%     % load experiment meta data
%     session_type_iSession = session_type(i_session,:);
%     probe_type_iSession = probe_type(i_session,:);
%     recording_depth_iSession = recording_depth(i_session,:);
%     
%     
%     % experimenta ID
%     clear experiment_index_tmp;
%     if ((session_type_iSession{1}(1)==1) | (session_type_iSession{1}(1)==2)) & (session_type_iSession{3}==1) & (session_type_iSession{4}==1)
%         
%         disp('1  -- VGAT-ChR2, S1 spatial mapping, protocol comparison');
%         experiment_index_tmp = 1;
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
%     elseif (session_type_iSession{1}(1)==2) & (session_type_iSession{3}==4) & (session_type_iSession{4}==1)
%         
%         disp('4  -- VGAT-ChR2, striatum spatial mapping');
%         experiment_index_tmp = 4;
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
%     elseif (session_type_iSession{1}(1)==4) & (session_type_iSession{3}==1 | session_type_iSession{3}==2) & (session_type_iSession{4}==4)
%         
%         disp('7  -- PV-cre inj, S1 spatial mapping');
%         experiment_index_tmp = 7;
%         
%     elseif (session_type_iSession{1}(1)==2) & (session_type_iSession{3}==1) & (session_type_iSession{4}==5)
%         
%         disp('8  -- PVxReaChR, S1 spatial mapping');
%         experiment_index_tmp = 8;
%         
%     elseif (session_type_iSession{1}(1)==2) & (session_type_iSession{3}==4) & (session_type_iSession{4}==5)
%         
%         disp('9  -- PVxReaChR, striatum spatial mapping');
%         experiment_index_tmp = 9;
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
%     elseif (session_type_iSession{1}(1)==5) & (session_type_iSession{3}==3) & (session_type_iSession{4}==1)
%         
%         disp('12 -- VGAT-ChR2, M1 rebound mapping');
%         experiment_index_tmp = 12;
%         
%     else
%         warning('no matching experimental condition found')
%     end
%         
%         
%         
%     % go through single untis
%     for i_unit = 1:size(single_units,1)
%        
%         unit_tmp = single_units{i_unit};
%         unit_tmp.stable_trials(unit_tmp.stable_trials>size(solo_aom,1))=[];
%         unit_stable_trials_tmp = zeros(size(solo_aom,1),1);
%         unit_stable_trials_tmp(unit_tmp.stable_trials) = 1;
%         
%         
%         
%         % average waveform
%         waveform_tmp = mean(unit_tmp.waveforms);
%         waveform_amp_tmp = range(waveform_tmp);
%         
%         
%         % cell type
%         if probe_type_iSession(1) == 1
%             whisper_flag_tmp = 0;
%         elseif probe_type_iSession(1) == 2
%             whisper_flag_tmp = 1;
%         end
%         [cell_type_tmp spk_width_tmp] = func_get_cell_type_WhisperSwitch(unit_tmp.waveforms, whisper_flag_tmp);
%         
%         
%         % response data
%         clear FR_baseline_tmp  FR_stim_tmp;
%         if experiment_index_tmp == 5 | experiment_index_tmp == 6
%             
%             i_sel_trials = find(solo_aom==max(solo_aom(solo_photostim_type==1|solo_photostim_type==2)) & sum(solo_dist,2)==0 & ~isnan(solo_laser_time(:,1)) & solo_laser_time(:,1)>.5 & unit_stable_trials_tmp);
%             FR_baseline_tmp = [];
%             FR_stim_tmp = [];
%             for i_trial = i_sel_trials'
%                 t_laserON_tmp = solo_laser_time(i_trial,1);
%                 t_laserOFF_tmp = solo_laser_time(i_trial,2);
%                 FR_baseline_tmp(end+1,1) = sum(unit_tmp.spike_times>(t_laserON_tmp-.5) & unit_tmp.spike_times<t_laserON_tmp & unit_tmp.trials==i_trial)/.5;
%                 FR_stim_tmp(end+1,1) = sum(unit_tmp.spike_times>t_laserON_tmp & unit_tmp.spike_times<(t_laserOFF_tmp-.2) & unit_tmp.trials==i_trial)/(t_laserOFF_tmp-.2-t_laserON_tmp);
%             end
%             
%         else
%             
%             i_sel_trials = find(solo_aom==max(solo_aom(solo_photostim_type==1)) & sum(solo_dist,2)==0 & ~isnan(solo_laser_time(:,1)) & solo_laser_time(:,1)>.5 & unit_stable_trials_tmp);
%             FR_baseline_tmp = [];
%             FR_stim_tmp = [];
%             for i_trial = i_sel_trials'
%                 t_laserON_tmp = solo_laser_time(i_trial,1);
%                 t_laserOFF_tmp = solo_laser_time(i_trial,2);
%                 FR_baseline_tmp(end+1,1) = sum(unit_tmp.spike_times>(t_laserON_tmp-.5) & unit_tmp.spike_times<t_laserON_tmp & unit_tmp.trials==i_trial)/.5;
%                 FR_stim_tmp(end+1,1) = sum(unit_tmp.spike_times>t_laserON_tmp & unit_tmp.spike_times<(t_laserOFF_tmp-.2) & unit_tmp.trials==i_trial)/(t_laserOFF_tmp-.2-t_laserON_tmp);
%             end
%             
%         end
%         if ~isnan(FR_baseline_tmp) & ~isnan(FR_stim_tmp)
%             [h p_tmp] = ttest2(FR_baseline_tmp, FR_stim_tmp);
%         else
%             p_tmp = nan;
%         end
% 
%         
%         %save data
%         waveform_all{end+1,1} = waveform_tmp/norm(waveform_tmp);
%         unit_info_all(end+1,:) = [cell_type_tmp   spk_width_tmp   waveform_amp_tmp  mean(FR_baseline_tmp)  mean(FR_stim_tmp)   probe_type_iSession   recording_depth_iSession   p_tmp   median(unit_tmp.channel)]; 
%         exp_ind_all(end+1,:) = experiment_index_tmp;   % experiment index
%         
%         
%     end
%     
% end
% 
% save analysis_ALL_spike_classification
load analysis_ALL_spike_classification



%% yeild broken down by experiment
figure;
subplot(1,9,1); hold on
bar(1,sum(unit_info_all(:,1)==1),'b');
bar(2,sum(unit_info_all(:,1)==2),'r');
bar(3,sum(unit_info_all(:,1)==0),'k');

subplot(1,9,2:5); hold on
for i_experiment = 1:12
    bar(i_experiment, sum(unit_info_all(:,1)==1 & exp_ind_all==i_experiment),'b');
end

subplot(1,9,6:9); hold on
for i_experiment = 1:12
    bar(i_experiment, sum(unit_info_all(:,1)==2 & exp_ind_all==i_experiment),'r');
end



%% spike waveshape quantification
figure;
subplot(2,2,1); hold on
for i = 1:numel(waveform_all)
    if unit_info_all(i,1)==0
        color_tmp = 'k';
    elseif unit_info_all(i,1)==1
        color_tmp = 'b';
    elseif unit_info_all(i,1)==2
        color_tmp = 'r';
    end
    
    [dummy i_peak] = min(waveform_all{i});
    if unit_info_all(i,6)==1
        t_tmp = ((1:size(waveform_all{i},2))-i_peak)/19531;
    elseif unit_info_all(i,6)==2
        t_tmp = ((1:size(waveform_all{i},2))-i_peak)/25000;
    end        
    
    plot(t_tmp, waveform_all{i},color_tmp);
end

subplot(2,2,2); hold on
hist(unit_info_all(:,2)*1000,0:.03:1);
xlim([0.1 .8])
line([0 0]+9/19531*1000,[0 500],'color','k');
line([0 0]+7/19531*1000,[0 500],'color','k');
xlabel('spike width (ms)')

subplot(2,2,3); hold on
plot(unit_info_all(unit_info_all(:,1)==0,2)*1000,unit_info_all(unit_info_all(:,1)==0,3),'.k');
plot(unit_info_all(unit_info_all(:,1)==1,2)*1000,unit_info_all(unit_info_all(:,1)==1,3),'.b');
plot(unit_info_all(unit_info_all(:,1)==2,2)*1000,unit_info_all(unit_info_all(:,1)==2,3),'.r');
xlabel('spike width (ms)')
ylabel('spike amplitude')

subplot(2,2,4); hold on
plot(unit_info_all(unit_info_all(:,1)==0,2)*1000,unit_info_all(unit_info_all(:,1)==0,4),'.k');
plot(unit_info_all(unit_info_all(:,1)==1,2)*1000,unit_info_all(unit_info_all(:,1)==1,4),'.b');
plot(unit_info_all(unit_info_all(:,1)==2,2)*1000,unit_info_all(unit_info_all(:,1)==2,4),'.r');
xlabel('spike width (ms)')
ylabel('FR baseline')




figure; hold on
for i_exp = 1:12
    bar(i_exp,sum(exp_ind_all==i_exp));
end




% spike shape across brain areas

% S1
i_sel_cell = find(exp_ind_all==1 | exp_ind_all==2 | exp_ind_all==3 | exp_ind_all==5 | exp_ind_all==6 | exp_ind_all==7 | exp_ind_all==8);
subplot(2,3,1); hold on
for i = i_sel_cell'
    if unit_info_all(i,1)==0
        color_tmp = 'k';
    elseif unit_info_all(i,1)==1
        color_tmp = 'b';
    elseif unit_info_all(i,1)==2
        color_tmp = 'r';
    end
    
    [dummy i_peak] = min(waveform_all{i});
    if unit_info_all(i,6)==1
        t_tmp = ((1:size(waveform_all{i},2))-i_peak)/19531*1000;
    elseif unit_info_all(i,6)==2
        t_tmp = ((1:size(waveform_all{i},2))-i_peak)/25000*1000;
    end        
    
    plot(t_tmp, waveform_all{i},color_tmp);
end
xlim([-.5 .6]);
title('Somatosensory cortex')

subplot(2,3,4); hold on
hist(unit_info_all(i_sel_cell,2)*1000,0:.025:1);
xlim([0.1 .8])
line([0 0]+9/19531*1000,[0 300],'color','k');
line([0 0]+7/19531*1000,[0 300],'color','k');
xlabel('spike width (ms)')



% motor cortex (ALM and M1)
i_sel_cell = find(exp_ind_all==10 | exp_ind_all==11 | exp_ind_all==12);
subplot(2,3,2); hold on
for i = i_sel_cell'
    if unit_info_all(i,1)==0
        color_tmp = 'k';
    elseif unit_info_all(i,1)==1
        color_tmp = 'b';
    elseif unit_info_all(i,1)==2
        color_tmp = 'r';
    end
    
    [dummy i_peak] = min(waveform_all{i});
    if unit_info_all(i,6)==1
        t_tmp = ((1:size(waveform_all{i},2))-i_peak)/19531*1000;
    elseif unit_info_all(i,6)==2
        t_tmp = ((1:size(waveform_all{i},2))-i_peak)/25000*1000;
    end        
    
    plot(t_tmp, waveform_all{i},color_tmp);
end
xlim([-.5 .6]);
title('Motor cortex')

subplot(2,3,5); hold on
hist(unit_info_all(i_sel_cell,2)*1000,0:.025:1);
xlim([0.1 .8])
line([0 0]+9/19531*1000,[0 300],'color','k');
line([0 0]+7/19531*1000,[0 300],'color','k');
xlabel('spike width (ms)')


% striatum cortex 
unit_depth_all = [];
for i_unit = 1:size(unit_info_all,1)
    unit_depth_all(i_unit,1) = func_get_electrode_depth(unit_info_all(i_unit,10), unit_info_all(i_unit,7), unit_info_all(i_unit,8));
end
i_sel_cell = find(exp_ind_all==4 & unit_depth_all>1200);
subplot(2,3,3); hold on
for i = i_sel_cell'
    if unit_info_all(i,1)==0
        color_tmp = 'k';
    elseif unit_info_all(i,1)==1
        color_tmp = 'b';
    elseif unit_info_all(i,1)==2
        color_tmp = 'r';
    end
    
    [dummy i_peak] = min(waveform_all{i});
    if unit_info_all(i,6)==1
        t_tmp = ((1:size(waveform_all{i},2))-i_peak)/19531*1000;
    elseif unit_info_all(i,6)==2
        t_tmp = ((1:size(waveform_all{i},2))-i_peak)/25000*1000;
    end        
    
    plot(t_tmp, waveform_all{i},color_tmp);
end
xlim([-.5 .6]);
title('Striatum')

subplot(2,3,6); hold on
hist(unit_info_all(i_sel_cell,2)*1000,0:.025:1);
xlim([0.1 .8])
line([0 0]+9/19531*1000,[0 15],'color','k');
line([0 0]+7/19531*1000,[0 15],'color','k');
xlabel('spike width (ms)')






%% individual experiment
exp_ID = {
    '1 VGAT-ChR2, S1 spatial mapping, protocol comparison';...
    '2 SOM x Ai32, S1 spatial mapping';...
    '3 PV x Ai32, S1 spatial mapping';...
    '4 VGAT-ChR2, striatum spatial mapping';...
    '5 Arch, S1 spatial mapping';...
    '6 ArchT, S1 spatial mapping';...
    '7 PV-cre inj, S1 spatial mapping';...
    '8 PVxReaChR, S1 spatial mapping';...
    '9 PVxReaChR, subcortical spatial mapping';...
    '10 PVxReaChR, ALM spatial mapping';...
    '11 VGAT-ChR2, ALM spatial mapping';...
    '12 VGAT-ChR2, M1 rebound mapping';...
};


FR_tmp = unit_info_all(:,5)./unit_info_all(:,4);
FR_tmp(FR_tmp>120)=120;
FR_tmp(FR_tmp==0)=.001;

figure
for i_exp = 1:12
    
    subplot(3,4,i_exp); hold on
    plot(FR_tmp(unit_info_all(:,1)==0 & exp_ind_all==i_exp,1),unit_info_all(unit_info_all(:,1)==0 & exp_ind_all==i_exp,2)*1000,'.k');
    plot(FR_tmp(unit_info_all(:,1)==1 & exp_ind_all==i_exp,1),unit_info_all(unit_info_all(:,1)==1 & exp_ind_all==i_exp,2)*1000,'.b');
    plot(FR_tmp(unit_info_all(:,1)==2 & exp_ind_all==i_exp,1),unit_info_all(unit_info_all(:,1)==2 & exp_ind_all==i_exp,2)*1000,'.r');
    plot(FR_tmp(unit_info_all(:,1)==0 & unit_info_all(:,9)<.01 & exp_ind_all==i_exp,1),unit_info_all(unit_info_all(:,1)==0 & unit_info_all(:,9)<.01 & exp_ind_all==i_exp,2)*1000,'ok');
    plot(FR_tmp(unit_info_all(:,1)==1 & unit_info_all(:,9)<.01 & exp_ind_all==i_exp,1),unit_info_all(unit_info_all(:,1)==1 & unit_info_all(:,9)<.01 & exp_ind_all==i_exp,2)*1000,'ob');
    plot(FR_tmp(unit_info_all(:,1)==2 & unit_info_all(:,9)<.01 & exp_ind_all==i_exp,1),unit_info_all(unit_info_all(:,1)==2 & unit_info_all(:,9)<.01 & exp_ind_all==i_exp,2)*1000,'or');
    set(gca,'xscale','log')
    xlim([.00099 120])
    ylim([.1 .8])
    line([1 1],[.1 .8],'color','k','linestyle',':','linewidth',2)
    title(exp_ID{i_exp})
end



figure
% VGAT
sel_exp_tmp = (exp_ind_all==1 | exp_ind_all==11 | exp_ind_all==12);
subplot(1,4,1); hold on
plot(FR_tmp(unit_info_all(:,1)==0 & sel_exp_tmp,1),unit_info_all(unit_info_all(:,1)==0 & sel_exp_tmp,2)*1000,'.k');
plot(FR_tmp(unit_info_all(:,1)==1 & sel_exp_tmp,1),unit_info_all(unit_info_all(:,1)==1 & sel_exp_tmp,2)*1000,'.b');
plot(FR_tmp(unit_info_all(:,1)==2 & sel_exp_tmp,1),unit_info_all(unit_info_all(:,1)==2 & sel_exp_tmp,2)*1000,'.r');
plot(FR_tmp(unit_info_all(:,1)==0 & unit_info_all(:,9)<.01 & sel_exp_tmp,1),unit_info_all(unit_info_all(:,1)==0 & unit_info_all(:,9)<.01 & sel_exp_tmp,2)*1000,'ok');
plot(FR_tmp(unit_info_all(:,1)==1 & unit_info_all(:,9)<.01 & sel_exp_tmp,1),unit_info_all(unit_info_all(:,1)==1 & unit_info_all(:,9)<.01 & sel_exp_tmp,2)*1000,'ob');
plot(FR_tmp(unit_info_all(:,1)==2 & unit_info_all(:,9)<.01 & sel_exp_tmp,1),unit_info_all(unit_info_all(:,1)==2 & unit_info_all(:,9)<.01 & sel_exp_tmp,2)*1000,'or');
set(gca,'xscale','log')
xlim([.00099 120])
ylim([.1 .8])
line([1 1],[.1 .8],'color','k','linestyle',':','linewidth',2)
title('VGAT-ChR2-EYFP')


% SOM tagging
sel_exp_tmp = (exp_ind_all==2);
subplot(1,4,2); hold on
plot(FR_tmp(unit_info_all(:,1)==0 & sel_exp_tmp,1),unit_info_all(unit_info_all(:,1)==0 & sel_exp_tmp,2)*1000,'.k');
plot(FR_tmp(unit_info_all(:,1)==1 & sel_exp_tmp,1),unit_info_all(unit_info_all(:,1)==1 & sel_exp_tmp,2)*1000,'.b');
plot(FR_tmp(unit_info_all(:,1)==2 & sel_exp_tmp,1),unit_info_all(unit_info_all(:,1)==2 & sel_exp_tmp,2)*1000,'.r');
plot(FR_tmp(unit_info_all(:,1)==0 & unit_info_all(:,9)<.01 & sel_exp_tmp,1),unit_info_all(unit_info_all(:,1)==0 & unit_info_all(:,9)<.01 & sel_exp_tmp,2)*1000,'ok');
plot(FR_tmp(unit_info_all(:,1)==1 & unit_info_all(:,9)<.01 & sel_exp_tmp,1),unit_info_all(unit_info_all(:,1)==1 & unit_info_all(:,9)<.01 & sel_exp_tmp,2)*1000,'ob');
plot(FR_tmp(unit_info_all(:,1)==2 & unit_info_all(:,9)<.01 & sel_exp_tmp,1),unit_info_all(unit_info_all(:,1)==2 & unit_info_all(:,9)<.01 & sel_exp_tmp,2)*1000,'or');
set(gca,'xscale','log')
xlim([.00099 120])
ylim([.1 .8])
line([1 1],[.1 .8],'color','k','linestyle',':','linewidth',2)
title('SOM-cre x Ai32')


% PV tagging
sel_exp_tmp = (exp_ind_all==3 | exp_ind_all==8 | exp_ind_all==10);
subplot(1,4,3); hold on
plot(FR_tmp(unit_info_all(:,1)==0 & sel_exp_tmp,1),unit_info_all(unit_info_all(:,1)==0 & sel_exp_tmp,2)*1000,'.k');
plot(FR_tmp(unit_info_all(:,1)==1 & sel_exp_tmp,1),unit_info_all(unit_info_all(:,1)==1 & sel_exp_tmp,2)*1000,'.b');
plot(FR_tmp(unit_info_all(:,1)==2 & sel_exp_tmp,1),unit_info_all(unit_info_all(:,1)==2 & sel_exp_tmp,2)*1000,'.r');
plot(FR_tmp(unit_info_all(:,1)==0 & unit_info_all(:,9)<.01 & sel_exp_tmp,1),unit_info_all(unit_info_all(:,1)==0 & unit_info_all(:,9)<.01 & sel_exp_tmp,2)*1000,'ok');
plot(FR_tmp(unit_info_all(:,1)==1 & unit_info_all(:,9)<.01 & sel_exp_tmp,1),unit_info_all(unit_info_all(:,1)==1 & unit_info_all(:,9)<.01 & sel_exp_tmp,2)*1000,'ob');
plot(FR_tmp(unit_info_all(:,1)==2 & unit_info_all(:,9)<.01 & sel_exp_tmp,1),unit_info_all(unit_info_all(:,1)==2 & unit_info_all(:,9)<.01 & sel_exp_tmp,2)*1000,'or');
set(gca,'xscale','log')
xlim([.00099 120])
ylim([.1 .8])
line([1 1],[.1 .8],'color','k','linestyle',':','linewidth',2)
title('PV-cre x Ai32 or ReaChR')


% Arch
sel_exp_tmp = (exp_ind_all==5);
subplot(1,4,4); hold on
plot(FR_tmp(unit_info_all(:,1)==0 & sel_exp_tmp,1),unit_info_all(unit_info_all(:,1)==0 & sel_exp_tmp,2)*1000,'.k');
plot(FR_tmp(unit_info_all(:,1)==1 & sel_exp_tmp,1),unit_info_all(unit_info_all(:,1)==1 & sel_exp_tmp,2)*1000,'.b');
plot(FR_tmp(unit_info_all(:,1)==2 & sel_exp_tmp,1),unit_info_all(unit_info_all(:,1)==2 & sel_exp_tmp,2)*1000,'.r');
plot(FR_tmp(unit_info_all(:,1)==0 & unit_info_all(:,9)<.01 & sel_exp_tmp,1),unit_info_all(unit_info_all(:,1)==0 & unit_info_all(:,9)<.01 & sel_exp_tmp,2)*1000,'ok');
plot(FR_tmp(unit_info_all(:,1)==1 & unit_info_all(:,9)<.01 & sel_exp_tmp,1),unit_info_all(unit_info_all(:,1)==1 & unit_info_all(:,9)<.01 & sel_exp_tmp,2)*1000,'ob');
plot(FR_tmp(unit_info_all(:,1)==2 & unit_info_all(:,9)<.01 & sel_exp_tmp,1),unit_info_all(unit_info_all(:,1)==2 & unit_info_all(:,9)<.01 & sel_exp_tmp,2)*1000,'or');
set(gca,'xscale','log')
xlim([.00099 120])
ylim([.1 .8])
line([1 1],[.1 .8],'color','k','linestyle',':','linewidth',2)
title('Emx1-cre x Ai35D')




% FS neurons vs. depth
figure; hold on
sel_exp_tmp = (exp_ind_all==1 | exp_ind_all==11 | exp_ind_all==12);
subplot(1,4,1); 
plot(FR_tmp(unit_info_all(:,1)==0 & sel_exp_tmp,1),-unit_info_all(unit_info_all(:,1)==0 & sel_exp_tmp,end-2),'.k');
plot(FR_tmp(unit_info_all(:,1)==1 & sel_exp_tmp,1),-unit_info_all(unit_info_all(:,1)==1 & sel_exp_tmp,end-2),'.b');
plot(FR_tmp(unit_info_all(:,1)==2 & sel_exp_tmp,1),-unit_info_all(unit_info_all(:,1)==2 & sel_exp_tmp,end-2),'.r');
plot(FR_tmp(unit_info_all(:,1)==0 & unit_info_all(:,9)<.01 & sel_exp_tmp,1),-unit_info_all(unit_info_all(:,1)==0 & unit_info_all(:,9)<.01 & sel_exp_tmp,end-2),'ok');
plot(FR_tmp(unit_info_all(:,1)==1 & unit_info_all(:,9)<.01 & sel_exp_tmp,1),-unit_info_all(unit_info_all(:,1)==1 & unit_info_all(:,9)<.01 & sel_exp_tmp,end-2),'ob');
plot(FR_tmp(unit_info_all(:,1)==2 & unit_info_all(:,9)<.01 & sel_exp_tmp,1),-unit_info_all(unit_info_all(:,1)==2 & unit_info_all(:,9)<.01 & sel_exp_tmp,end-2),'or');
% set(gca,'xscale','log')
xlim([.00099 120])
% ylim([.1 .8])
line([1 1],[.1 .8],'color','k','linestyle',':','linewidth',2)
title('VGAT-ChR2-EYFP')




%% SOM neurons

% SOM tagging
sel_exp_tmp = (exp_ind_all==2);
i_SOM = find(FR_tmp(:,1)>1 & sel_exp_tmp & unit_info_all(:,9)<.01)

figure; hold on
for i = 1:numel(waveform_all)
    if unit_info_all(i,1)==0
        color_tmp = 'k';
    elseif unit_info_all(i,1)==1
        color_tmp = 'b';
    elseif unit_info_all(i,1)==2
        color_tmp = 'r';
    end
    
    [dummy i_peak] = min(waveform_all{i});
    if unit_info_all(i,6)==1
        t_tmp = ((1:size(waveform_all{i},2))-i_peak)/19531;
    elseif unit_info_all(i,6)==2
        t_tmp = ((1:size(waveform_all{i},2))-i_peak)/25000;
    end        
    
    plot(t_tmp, waveform_all{i},color_tmp);
end


for i = i_SOM'
    
    [dummy i_peak] = min(waveform_all{i});
    if unit_info_all(i,6)==1
        t_tmp = ((1:size(waveform_all{i},2))-i_peak)/19531;
    elseif unit_info_all(i,6)==2
        t_tmp = ((1:size(waveform_all{i},2))-i_peak)/25000;
    end        
    
    plot(t_tmp, waveform_all{i},'g');
end


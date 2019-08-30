clear all
close all

load ./data/Fig1_data_unit_classification.mat

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
% % % colume 2:   spike width (in sec)
% % % colume 3:   spike amplitude (in V)
% % % colume 4:   spike rate baseline 
% % % colume 5:   spike rate dring photostimulation
% % % colume 6&7: probe_type_iSession   recording_depth_iSession   p_tmp   median(unit_tmp.channel)
% % % colume 8:   recording_depth_iSession   p_tmp   median(unit_tmp.channel)
% % % colume 9:   photostimulation vs. baseline t-test based on spike count across trials, p value
% % % colume 10:  channel the unit was recorded on 
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




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







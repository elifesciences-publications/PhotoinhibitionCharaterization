clear all
close all

load ./data/Fig5_data_photoinhibition_vs_dist.mat



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




laser_dist = [-.1:.25:3.5];



mycolor = {
    {[0 0 .6],[0 0 1],[.6 .6  1]};...  % 1 VGAT S1
    {[0 .6 0],[0 1 0],[.6  1 .6],[.6  1 .6]};...  % 2 SOM S1
    {[ .6 0 0],[1 0 0],[1 .6 .6]};...  % 3 PV S1
    {[0 0 0],[.2 .2 0],[.4 .4 0],[.55 .55  0], [.7 .7 0], [.8 .8 0], [.9 .9 0]};...  % 5 Arch S1
    {[0 0 0],[.4 0 0],[.75 0 0],[1 0 0],[1 .4 .4]};...  % 8 PV ReaChR S1
    {[0 0 0],[.4 0 0],[.75 0 0],[1 0 0],[1 .4 .4]};...  % 10 PV ReaChR ALM
    {[0 0 .6],[0 0 1],[.3 .3  1],[.6 .6  1]};...  % 11 VGAT ALM
    };
mytitle = {
    '1 VGAT S1'
    '2 SOM S1';...
    '3 PV S1';...
    '5 Arch S1';...
    '8 PV ReaChR S1';...
    '10 PV ReaChR ALM';...
    '11 VGAT ALM';...
    };

summarycolor = {
    {[0 0  1],['o']};...  % 1 VGAT S1
    {[0 1  0],['o']};...  % 2 SOM S1
    {[1 0  0],['o']};...  % 3 PV S1
    {[.7 .7 0],['o']};...  % 5 Arch S1
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
    if experiment_ID==1
        aom_power_all = [.42 .75 2.5];
        
    elseif experiment_ID==2
        aom_power_all = [.48 .83 3.4];
    end
    
    if experiment_ID==5 | experiment_ID==6
        response_data_tmp = cell2mat(response_data_all(unit_info_all(:,8)==experiment_ID,:));
        response_data_tmp(response_data_tmp(:,3)==.48 & response_data_tmp(:,6)==2,3) = 5.48;
        response_data_tmp(response_data_tmp(:,3)==.82 & response_data_tmp(:,6)==2,3) = 5.82;
        response_data_tmp(response_data_tmp(:,3)==2.4 & response_data_tmp(:,6)==2,3) = 7.4;
        response_data_tmp(response_data_tmp(:,3)==5 & response_data_tmp(:,6)==2,3) = 10;
        aom_power_all = unique(response_data_tmp(:,3));
        aom_power_all = aom_power_all(aom_power_all>0);
    end
    
    
    
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
                
                if flg_cell_sel
                    
                    if (unit_info_all(i_unit,3)==5)
                        electrode_offset = -(floor(unit_info_all(i_unit,5)/8.1))*.4;
                    elseif (unit_info_all(i_unit,3)==1) || (unit_info_all(i_unit,3)==2) || (unit_info_all(i_unit,3)==3)
                        electrode_offset = -(floor(unit_info_all(i_unit,5)/8.1))*.2;
                    end
                    unit_dist_offset = [electrode_offset-unit_info_all(i_unit,6) unit_info_all(i_unit,7)];
                    
                    
                    response_data_tmp = response_data_all{i_unit};
                    unit_dist_tmp = response_data_tmp(:,4)-unit_dist_offset(1);
                    
                    if experiment_ID==2
                        response_data_tmp(response_data_tmp(:,3)==.52,3) = .48;
                        response_data_tmp(response_data_tmp(:,3)==.5,3) = .48;
                        response_data_tmp(response_data_tmp(:,3)==.87,3) = .83;
                        response_data_tmp(response_data_tmp(:,3)==2.72,3) = 3.4;
                        response_data_tmp(response_data_tmp(:,3)==2.9,3) = 3.4;
                    end
                    
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


















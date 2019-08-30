clear all
close all

load ./data/Fig6_data_GtACR_photoinhibition_vs_dist.mat


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
% % %
% % % 14 -- Emx1 x GtACR, ALM, blue laser
% % % 15 -- Emx1 x GtACR, M1, blue laser
% % % 16 -- Emx1 x GtACR, S1, blue laser
% % % 17 -- Emx1 x GtACR, ALM, red laser
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
% % % colume 7:   spike rate dring the first 20ms of photostimulation
% % % colume 8:   spike rate dring the whole photostimulation period
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% -------------------- plot data --------------------
laser_dist = [0 .4:.5:3.5];



mycolor = {
    {[0 .3 .3],[0 .7 .7],[0 1 1],[.3 1 1],[.7 1 1]};...  % 14 GtACR blue light
    {[0 .3 .3],[0 .7 .7],[0 1 1],[.3 1 1],[.7 1 1]};...  % 15 GtACR blue light
    {[0 .3 .3],[0 .7 .7],[0 1 1],[.3 1 1],[.7 1 1]};...  % 16 GtACR blue light
    };
mytitle = {
    '14 GtACR blue light, ALM'
    '15 GtACR blue light, M1'
    '16 GtACR blue light, S1'
    };

summarycolor = {
    {['c'],['s']};...  % 14 GtACR blue light, ALM'
    {['c'],['^']};...  % 15 GtACR blue light, M1'
    {['c'],['o']};...  % 16 GtACR blue light, S1'
    };


for i_exp = 14:16
    
    aom_power_all = [.05 .1 .2 .4 .8];

    
    effect_all = [];
    for i_power = 1:numel(aom_power_all)
        n_dist = 0;
        for i_stim_dist = laser_dist
            n_dist = n_dist+1;
            
            
            FR_allCells = [];
            for i_unit = find(FA_all<0.005 & exp_ind_all==i_exp)'   %<<<<<<<<<<<<<<<<< units with ISI violation of 0.5% or less
                
                % cell selection
                clear flg_cell_sel
                flg_cell_sel = (unit_info_all(i_unit,1)==1);        %<<<<<<<<<<<<<<<<< pyramidal cells only
                
                if flg_cell_sel
                    
                    response_data_tmp = response_data_all{i_unit};
                    unit_dist_tmp = response_data_tmp(:,4);
                    
                    
                    if i_stim_dist == 0
                        i_sel_trial = find(unit_dist_tmp <= i_stim_dist+.4 & unit_dist_tmp> -inf  &  response_data_tmp(:,3)==aom_power_all(i_power));
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
    
    
    n_experiment = i_exp-13;
    
    figure(1);
    subplot(1,4,i_exp-13); hold on
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
            xlabel('Laser distance (mm)')
            ylabel('Relative spike rate')

        end
    end
    if i_exp==14
        title('GtACR ALM')
    elseif i_exp==15
        title('GtACR M1')
    elseif i_exp==16
        title('GtACR S1')
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
    figure(3); hold on
    plot(effect_size_allCondition, effect_spread_allCondition, summarycolor{n_experiment}{2},'linestyle', '-','color',summarycolor{n_experiment}{1})
    xlabel('fraction of spikes at center')
    ylabel('radius half max')
    

end





% red light
laser_dist = [0 .4:.5:3.5];  



mycolor = {
    {[.3 0 0],[.7 0 0],[1 0 0],[1 .3 .3],[1 .5 .5],[1 .7 .7]};... 
    };
mytitle = {
    '17 GtACR ALM red light'
    };

summarycolor = {
    {['r'],['s']};... 
    };


i_exp = 17;

aom_power_all = [.25 .5 1 2 4 8];


effect_all = [];
for i_power = 1:numel(aom_power_all)
    n_dist = 0;
    for i_stim_dist = laser_dist
        n_dist = n_dist+1;
        
        
        FR_allCells = [];
        for i_unit = find(FA_all<0.005 & exp_ind_all==i_exp)'   %<<<<<<<<<<<<<<<<< units with ISI violation of 0.5% or less
            
            % cell selection
            clear flg_cell_sel
            flg_cell_sel = (unit_info_all(i_unit,1)==1);        %<<<<<<<<<<<<<<<<< pyramidal cells only
            
            if flg_cell_sel
                
                response_data_tmp = response_data_all{i_unit};
                unit_dist_tmp = response_data_tmp(:,4);
                
                
                if i_stim_dist == 0
                    i_sel_trial = find(unit_dist_tmp <= i_stim_dist+.4 & unit_dist_tmp> -inf  &  response_data_tmp(:,3)==aom_power_all(i_power));
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


n_experiment = 1;

figure(1);
subplot(1,4,i_exp-13); hold on
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
        xlabel('Laser distance (mm)')
        ylabel('Relative spike rate')
    end
end
if i_exp==14
    title('GtACR ALM')
elseif i_exp==15
    title('GtACR M1')
elseif i_exp==16
    title('GtACR S1')
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
figure(3); hold on
plot(effect_size_allCondition, effect_spread_allCondition, summarycolor{n_experiment}{2},'linestyle', '-','color',summarycolor{n_experiment}{1})
xlabel('fraction of spikes at center')
ylabel('radius half max')







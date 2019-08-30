clear all
close all


load ./data/Fig2_data_GtACR_photoinhibition


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




% -------------------- plot effect vs. power --------------------

% blue light, ALM data only (exp=14)
aom_power_all = [.05 .1 .2 .4 .8];


effect_all = [];
for i_power = 1:numel(aom_power_all)
    
    
    FR_allCells = [];
    for i_unit = find(FA_all<0.005 & exp_ind_all==14)'                        %<<<<<<<<<<<<<<<<< units with ISI violation of 0.5% or less
        
        % cell selection
        clear flg_cell_sel
        flg_cell_sel = (unit_info_all(i_unit,1)==1);        %<<<<<<<<<<<<<<<<< pyramidal cells only
        
        if flg_cell_sel
            
            response_data_tmp = response_data_all{i_unit};
            unit_dist_tmp = response_data_tmp(:,4);
            
            
            i_sel_trial = find(abs(unit_dist_tmp)<=.4 &  response_data_tmp(:,3)==aom_power_all(i_power));
            
            FR_allCells(end+1,:) =  mean(response_data_tmp(i_sel_trial,1:2),1);
            
        end
        
    end
    FR_tmp = FR_allCells(:,2)./FR_allCells(:,1);
    FR_tmp(FR_allCells(:,1)<.4,:)=nan;
    
    effect_all(i_power,1) = nanmean(FR_tmp);
    effect_all(i_power,2) = nanstd(FR_tmp)/sqrt(sum(~isnan(FR_tmp)));
    
    n_units_all(i_power,1) = size(FR_allCells,1);
    
end

figure; hold on
plot(aom_power_all,effect_all(:,1),'linewidth',2,'color','c');
errorbar(aom_power_all,effect_all(:,1),effect_all(:,2),'color','c');
set(gca,'xscale','log')
xlim([0.02 40]);
ylim([0 1.4])
line([.02 40],[1 1],'linewidth',2,'linestyle',':','color','k')
xlabel('power (mW)')
ylabel('Rstim/Rbaseline')



% red light, ALM data only (exp=17)
aom_power_all = [.25 .5 1 2 4 8];


effect_all = [];
for i_power = 1:numel(aom_power_all)
    
    
    FR_allCells = [];
    for i_unit = find(FA_all<0.005 & exp_ind_all==17)'      %<<<<<<<<<<<<<<<<< units with ISI violation of 0.5% or less
        
        % cell selection
        clear flg_cell_sel
        flg_cell_sel = (unit_info_all(i_unit,1)==1);        %<<<<<<<<<<<<<<<<< pyramidal cells only
        
        if flg_cell_sel
            
            response_data_tmp = response_data_all{i_unit};
            unit_dist_tmp = response_data_tmp(:,4);
            
            
            i_sel_trial = find(abs(unit_dist_tmp)<=.4 &  response_data_tmp(:,3)==aom_power_all(i_power));
            
            FR_allCells(end+1,:) =  mean(response_data_tmp(i_sel_trial,1:2),1);
            
        end
        
    end
    FR_tmp = FR_allCells(:,2)./FR_allCells(:,1);
    FR_tmp(FR_allCells(:,1)<.4,:)=nan;
    
    effect_all(i_power,1) = nanmean(FR_tmp);
    effect_all(i_power,2) = nanstd(FR_tmp)/sqrt(sum(~isnan(FR_tmp)));
    
    n_units_all(i_power,1) = size(FR_allCells,1);
    
end

plot(aom_power_all,effect_all(:,1),'linewidth',2,'color','r');
errorbar(aom_power_all,effect_all(:,1),effect_all(:,2),'color','r');
set(gca,'xscale','log')
xlim([0.02 40]);
ylim([0 1.4])
line([.02 40],[1 1],'linewidth',2,'linestyle',':','color','k')
xlabel('power (mW)')
ylabel('Rstim/Rbaseline')



% -------------------- plot antidromic spike vs. power --------------------
figure;

for i_exp = 14:17
    
    if i_exp == 17
        % red light, ALM data only (exp=17)
        aom_power_all = [.25 .5 1 2 4 8];
    else
        % blue light, (exp=14-16)
        aom_power_all = [.05 .1 .2 .4 .8];
    end
    
    effect_all = [];
    for i_power = 1:numel(aom_power_all)
        
        
        FR_allCells = [];
        for i_unit = find(FA_all<0.005 & exp_ind_all==i_exp)'   %<<<<<<<<<<<<<<<<< units with ISI violation of 0.5% or less
            
            % cell selection
            clear flg_cell_sel
            flg_cell_sel = (unit_info_all(i_unit,1)==1);        %<<<<<<<<<<<<<<<<< pyramidal cells only
            
            if flg_cell_sel
                
                response_data_tmp = response_data_all{i_unit};
                unit_dist_tmp = response_data_tmp(:,4);
                
                
                i_sel_trial = find(abs(unit_dist_tmp)<=.4 &  response_data_tmp(:,3)==aom_power_all(i_power));
                
                FR_allCells(end+1,:) =  mean(response_data_tmp(i_sel_trial,[1 7]),1);
                
            end
            
        end
        FR_tmp = FR_allCells(:,2)./FR_allCells(:,1);
        FR_tmp(FR_allCells(:,1)<.4,:)=nan;
        
        effect_all(i_power,1) = nanmean(FR_tmp);
        effect_all(i_power,2) = nanstd(FR_tmp)/sqrt(sum(~isnan(FR_tmp)));
        
        n_units_all(i_power,1) = size(FR_allCells,1);
        
    end
    
    disp(['experiment_ID ',num2str(14),' -- n = ',num2str(max(n_units_all)),'    min ',num2str(min(n_units_all))]);
    
    subplot(1,4,i_exp-13); hold on
    if i_exp == 17
        plot(aom_power_all,effect_all(:,1),'linewidth',2,'color','r');
        errorbar(aom_power_all,effect_all(:,1),effect_all(:,2),'color','r');
    else
        plot(aom_power_all,effect_all(:,1),'linewidth',2,'color','c');
        errorbar(aom_power_all,effect_all(:,1),effect_all(:,2),'color','c');
    end
    set(gca,'xscale','log')
    xlim([0.02 40]);
    ylim([0 4.5])
    line([.02 40],[1 1],'linewidth',2,'linestyle',':','color','k')
    xlabel('power (mW)')
    ylabel('Rstim/Rbaseline')
    
end





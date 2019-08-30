clear all
close all


load ./data/Fig1_data_photoinhibition_vs_power.mat


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



laser_dist = [-.1:.5:3.5];

mytitle = {
    '1 VGAT S1'
    '2 SOM S1';...
    '3 PV S1';...
    '5 Arch S1';...
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
    {[0 .6 0],['o']};...  % 7 PV-cre inj S1
    {[.4 0 0],['o']};...  % 8 PV ReaChR S1
    {[.4 0 0],['s']};...  % 10 PV ReaChR ALM
    {[0 0 1],['s']};...  % 11 VGAT ALM
    };



figure; hold on

n_experiment = 0;
for experiment_ID = [1 2 3 5 7 8];
    n_experiment = n_experiment+1;
    
    
    response_data_tmp = cell2mat(response_data_all(unit_info_all(:,8)==experiment_ID,:));
    aom_power_all = unique(response_data_tmp(:,3));
    aom_power_all = aom_power_all(aom_power_all>0);
    
    % For SOM testing, combine power
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

    
    % exception: Arch/ArchT, only use continuous
    if experiment_ID==5 | experiment_ID==6
        aom_power_all = unique(response_data_tmp(response_data_tmp(:,6)==1,3));
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
            
            if flg_cell_sel
                
                if (unit_info_all(i_unit,3)==5)
                    electrode_offset = -(floor(unit_info_all(i_unit,5)/8.1))*.4;
                elseif (unit_info_all(i_unit,3)==1) || (unit_info_all(i_unit,3)==2) || (unit_info_all(i_unit,3)==3)
                    electrode_offset = -(floor(unit_info_all(i_unit,5)/8.1))*.2;
                end
                unit_dist_offset = [electrode_offset-unit_info_all(i_unit,6) unit_info_all(i_unit,7)];
                
                
                response_data_tmp = response_data_all{i_unit};
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
    
    
    plot(aom_power_all,effect_all(:,1),'linewidth',2,'color',summarycolor{n_experiment}{1});
    errorbar(aom_power_all,effect_all(:,1),effect_all(:,2),'color',summarycolor{n_experiment}{1});
    
    
end

set(gca,'xscale','log')
xlim([0.2 40]);
ylim([0 1.4])
line([.2 40],[1 1],'linewidth',2,'linestyle',':','color','k')


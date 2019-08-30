clear all
close all

load ./data/Fig10_data_paradoxical_effect.mat


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
% % % colume 4:   laser beam size, -10 correspond to the laser beam diameter 2mm condition
% % % colume 6:   photostimulation type
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%------------------ Effect across power cell data plot -------------------
response_data_tmp = cell2mat(response_data_all(unit_info_all(:,8)==8,:));
aom_power_all = unique(response_data_tmp(:,3));

   
disp(['FS interneuron -- n = ',num2str(sum(unit_info_all(:,1) == 2 & unit_info_all(:,8)==8))]);
disp(['pymidal neuron-- n = ',num2str(sum(unit_info_all(:,1) == 1 & unit_info_all(:,8)==8))]);


figure
beam_size = 2/2^2*pi;  %laser beam 2mm diameter


effect_allCells = [];
n_cell = 0;
for i_unit = 1:size(response_data_all,1)
    response_data_tmp = response_data_all{i_unit};
    
    n_cell = n_cell+1;
    i_power = 0;
    for i_stim_power = aom_power_all'
        i_power = i_power+1;
        
        i_photostim_select = response_data_tmp(:,4)==-10;
        
        i_select = find(i_photostim_select & (response_data_tmp(:,3) == i_stim_power) & (unit_info_all(i_unit,1) == 1));
        
        if length(i_select)>=5 & mean(response_data_tmp(i_select,1))>=1
            effect_allCells(n_cell,i_power) = mean(response_data_tmp(i_select,2))/mean(response_data_tmp(i_select,1));
        else
            effect_allCells(n_cell,i_power) = nan;
        end
    end
    
end


subplot(1,2,2);  hold on
plot(aom_power_all/beam_size, nanmean(effect_allCells), 'k','linewidth',3)
for i_tmp = 1:length(aom_power_all)
    errorbar(aom_power_all(i_tmp)/beam_size, nanmean(effect_allCells(:,i_tmp)),nanstd(effect_allCells(:,i_tmp))/sqrt(sum(~isnan(effect_allCells(:,i_tmp)))), 'k')
end
line([0.01 100],[1 1],'color','k','linestyle',':','linewidth', 2)
set(gca,'xscale','log')
xlabel('Power (mW)');
ylabel('R stim / R baseline');


effect_allCells = [];
n_cell = 0;
for i_unit = 1:size(response_data_all,1)
    response_data_tmp = response_data_all{i_unit};
    
    n_cell = n_cell+1;
    i_power = 0;
    for i_stim_power = aom_power_all'
        i_power = i_power+1;
        
        i_photostim_select = response_data_tmp(:,4)==-10;
        
        i_select = find(i_photostim_select & (response_data_tmp(:,3) == i_stim_power) & (unit_info_all(i_unit,1) == 2));
        
        if length(i_select)>=5 & mean(response_data_tmp(i_select,1))>=1
            effect_allCells(n_cell,i_power) = mean(response_data_tmp(i_select,2))/mean(response_data_tmp(i_select,1));
        else
            effect_allCells(n_cell,i_power) = nan;
        end
    end
    
end


hold on
plot(aom_power_all/beam_size, nanmean(effect_allCells), 'g','linewidth',3)
for i_tmp = 1:length(aom_power_all)
    errorbar(aom_power_all(i_tmp)/beam_size, nanmean(effect_allCells(:,i_tmp)),nanstd(effect_allCells(:,i_tmp))/sqrt(sum(~isnan(effect_allCells(:,i_tmp)))), 'g')
end
set(gca,'xscale','log');
ylim([0 4])
xlim([.01 50])
xlabel('Intensity (mW / mm2)');
ylabel('R stim / R baseline');




% ------------- plot individual cells --------------
n_cell = 0;
for i_unit = find(unit_info_all(:,8)==8)'
    
    response_data_tmp = response_data_all{i_unit};
    aom_power_all = unique(response_data_tmp(:,3));
    
    effect_tmp = [];
    n_power = 0;
    for i_stim_power = aom_power_all'
        n_power = n_power+1;
        
        i_photostim_select = response_data_tmp(:,4)==-10;
        
        i_select = find(i_photostim_select & (response_data_tmp(:,3) == i_stim_power));
        
        if length(i_select)>=5 & mean(response_data_tmp(i_select,1))>=1
            effect_tmp(n_power,1) = mean(response_data_tmp(i_select,2))/mean(response_data_tmp(i_select,1));
        else
            effect_tmp(n_power,1) = nan;
        end
    end
    
    if unit_info_all(i_unit,1) == 1
        my_color = [0 0 0];
    elseif unit_info_all(i_unit,1) == 2
        my_color = [0 1 0];
    elseif unit_info_all(i_unit,1) == 0
        my_color = [0.8 0.8 0.8];
    else
        error('');
    end
    
    subplot(1,2,1); hold on
    plot(aom_power_all/beam_size, effect_tmp, 'color',my_color)
    line([0.01 50],[1 1],'color','k','linestyle',':','linewidth', 2)
    set(gca,'xscale','log');
    ylim([0 4])
    xlabel('Intensity (mW / mm2)');
    ylabel('R stim / R baseline');
        
    
end






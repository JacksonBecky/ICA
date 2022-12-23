%%Matlab script to compute Jaccard similarity coefficient between one or more
%%template images and ICA component results. written by Claude Bajada and
%%Becky Jackson in the Neuroscience and Aphasia Research Unit, University
%%of Manchester
clc;clear;
%template_folder = '\\cbsu\data\imaging_new\rj02\ICA\HCP_TASK_ICA\HCP_TASK_ICA\templates\SMITH2009\using'; %uigetdir('','Please select folder containing all template images');
template_folder = '\\cbsu\data\imaging_new\rj02\ICA\HCP_TASK_ICA\HCP_TASK_ICA\for_figs_final\DMN';
results_folder = '\\cbsu\data\imaging_new\rj02\ICA\HCP_TASK_ICA\HCP_TASK_ICA\for_figs_final\DMN';
%results_folder = '\\cbsu\data\imaging_new\rj02\ICA\HCP_TASK_ICA\HCP_TASK_ICA\lang\output\all_components\new_thresh'; %uigetdir('','Please select folder containing all results images');
output_folder = results_folder;%'\\cbsu\data\imaging_new\rj02\ICA\HCP_TASK_ICA\HCP_TASK_ICA\gambling\output\all_components\new_thresh'; %uigetdir('','Please select folder to save output matrix');

templates = cellstr(ls(strcat(template_folder, '\*.img')));
results_data = cellstr(ls(strcat(results_folder, '\*.img')));

my_similarity_matrix_comp = zeros( length(templates) ,  length(results_data) );


for i = 1 : length(templates)

    %% Jaccard similarity (i.e. similarity of voxels that are involved in either component)

    template_image = extract_read_image(strcat(template_folder, '\', templates{i}));
    bin_template_image = +logical(template_image);
    
    for j = 1 : length(results_data)

        results_image = extract_read_image(strcat(results_folder,'\', results_data{j}));
        bin_results_image = +logical(results_image);
        comp_dif = abs(bin_template_image - bin_results_image);
        comp_dif_sum = sum(sum(sum(comp_dif)));
        comp_dif_total = sum(sum(sum(+logical(bin_template_image + bin_results_image))));
        comp_dif_pcnt = 1 - (comp_dif_sum / comp_dif_total);
        
        my_similarity_matrix_comp(i,j) = comp_dif_pcnt;
        
    end
    
end

%add labels to results matrix
my_similarity_matrix_comp_labelled = horzcat(templates, num2cell(my_similarity_matrix_comp));
e = zeros(length(results_data)+1, 1);
e=num2cell(e);
for i =2:(length(results_data)+1);
e(i, 1) = results_data(i-1, 1);
end

e=e';
my_similarity_matrix_comp_labelled=vertcat(e,my_similarity_matrix_comp_labelled)';

%save results matrix
cd(output_folder)
save my_similarity_matrix_comp_labelled.mat, my_similarity_matrix_comp_labelled
clearvars -except my_similarity_matrix_comp_labelled


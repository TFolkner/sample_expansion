clear 
clc 

%% macros =================================================================
macros.make_demo = 0;

%% init data ============================================================== 
data_folder = "../run/"; 
sFile_data_sample_xls = data_folder + "sample_data.xlsx"; 

%% make test sample ======================================================= 
if (macros.make_demo == 1) 
    try 
        subjects_values = 10; 
        answers_values = 30; 
        data_names = repmat (" ", subjects_values, 1); 
        
        % make_names 
        for i = 1:subjects_values 
            data_names(i) = "name_" + i; 
        end 
        
        data_names = data_names'; 
        fprintf ("[INFO] -- %s\n", "names created"); 

        % make some data to names 
        data_for_names = zeros (answers_values, subjects_values); 
        x_values = linspace (-1, 1, answers_values); 
        for i = 1:subjects_values 
            poli_coefs = randn (1, 10); 
            data_for_names(:, i) = polyval (poli_coefs, x_values); 
        end 
        fprintf ("[INFO] -- %s\n", "data created"); 
        clear subjects_values answers_values i poli_coefs x_values 
        
        % make table and save 
        table2save = array2table (data_for_names, 'VariableNames', data_names); 
        folder2save = data_folder+"sample_data.xlsx"; 
        writetable (table2save, folder2save); 
        fprintf ("[INFO] -- %s\n", "sample table created and saved"); 
        clear data_names data_for_names folder2save table2save 
    catch exception 
        fprintf ("[ERROR] -- %s\n", exception.message); 
    end 
end 

%% load and struct data =================================================== 
try 
    pFile_data = importdata (sFile_data_sample_xls); 
    clear sFile_data_sample_xls data_folder 
    
    fprintf ("[INFO] -- %s\n", "table load and saved"); 
catch exception 
    fprintf ("[ERROR] -- %s\n", exception.message); 
end 

%% expansion sample ======================================================= 

work_data = struct; 
work_data.default_data = pFile_data; 
work_data.default_result = size(pFile_data); 
work_data.expansion_result = 45; %int32(work_data.default_result * 1.5); 
default_ordinat = 1:1:work_data.default_result(1); 
new_ordinatre = linspace (1, work_data.default_result(1), work_data.expansion_result); 
work_data.new_data = zeros (work_data.expansion_result , work_data.default_result (2)); 

for i = 1:work_data.default_result (2) 
    work_data.new_data(:, i) = int64 (interp1 (default_ordinat, pFile_data(:, i), new_ordinatre, 'spline')); 
end




% shuffle data
for i = 1:work_data.default_result (2) 
    to_shuffle = work_data.new_data(:, i);
    work_data.new_data_shuffle(:, i) = to_shuffle(randperm(length(to_shuffle)));
end


%% plot
% плотность частот
% to_plot = work_data.new_data_shuffle(:, 1);
% xx = linspace (min(to_plot), max(to_plot), length(to_plot));
% yy = normpdf (xx, mean(to_plot), std(xx));
% 
% F1 = figure;
% histogram(to_plot, 15, 'Normalization', 'pdf')
% hold on
% plot(xx, yy, 'LineWidth', 2)


figure;
for i = 1:work_data.default_result (2)
    subplot (5, 5, i)
    to_plot = work_data.new_data_shuffle(:, i);
    xx = linspace (min(to_plot), max(to_plot), length(to_plot));
    yy = normpdf (xx, mean(to_plot), std(xx));

    histogram(work_data.new_data_shuffle(:, i), 10, 'Normalization', 'pdf')
    hold on
    plot(xx, yy, 'LineWidth', 2)
end

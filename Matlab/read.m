function [ dataset ] = read()
%read Reads a datafile
%   Read a 3 column datafile and stores it as a cell containing a 3 columns (and n rows)
[filename,path,filterindex] = uigetfile(...
{'*.txt', 'Text file (*.txt)';...
'*.mat','Mat file (*.mat)';...
'*.csv','Comma separated file (*.csv)'},...
'Pick a file');
switch filterindex
    case 0,
        dataset = 0;
        return
    case 1,
        dataset = dlmread(fullfile(path,filename));
    case 2,
        dataset = open(fullfile(path,filename));
    case 3,
        dataset = csvread(fullfile(path,filename));
end
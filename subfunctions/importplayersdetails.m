function playersdetails = importplayersdetails(filename, dataLines)
%IMPORTFILE Import data from a text file
%  PLAYERSDETAILS1 = IMPORTFILE(FILENAME) reads data from text file
%  FILENAME for the default selection.  Returns the numeric data.
%
%  PLAYERSDETAILS1 = IMPORTFILE(FILE, DATALINES) reads data for the
%  specified row interval(s) of text file FILENAME. Specify DATALINES as
%  a positive scalar integer or a N-by-2 array of positive scalar
%  integers for dis-contiguous row intervals.
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 20-May-2020 14:59:33

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 6);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ";";

% Specify column names and types
opts.VariableNames = ["player_id", "team_id", "frame_start", "frame_end", "position_line", "position_wing"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
% opts = setvaropts(opts, "name", "TrimNonNumeric", true);
% opts = setvaropts(opts, "name", "ThousandsSeparator", ",");

% Import the data
playersdetails = readtable(filename, opts);

%% Convert to output type
playersdetails = table2array(playersdetails);
end
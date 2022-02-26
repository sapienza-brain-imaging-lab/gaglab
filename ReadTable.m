function [varargout] = ReadTable (filename, varargin)
% READTABLE         Read tabular data from Microsoft Excel
%
% READTABLE imports tabular data from Microsoft Excel. A table is a
% contiguous range of cells (without empty columns or rows) starting with a
% header row containing column names, followed by data rows containing any
% type of data. The table name can be optionally included in the first
% column of the row preceding the header row. If the table name is not
% present, the sheet including the table is considered as the table name. Thus,
% if there is only one table in each sheet, the sheet names can identify
% each table. However, if there are multiple tables in each sheet, table
% names should be used in order to identify each table.
% READTABLE converts each table into a vector of structures, with one item
% for each row in the table, and with field names corresponding to the
% table column names. Character such as spaces and diacritical marks, which
% are not admitted as valid variable names in Matlab, are stripped from the
% column names.
%
% T = READTABLE(WORKBOOK,SHEET) imports the first available table in the
% worksheet named SHEET in the workbook whose file name is WORKBOOK.
% [T,N] = READTABLE(WORKBOOK,SHEET) imports all tables found in the given
% worksheet. T will be a cell array of table structures, and N a cell array
% of strings specifying table names.
% [T,N,S] = READTABLE(WORKBOOK) imports all tables found in all worksheets
% in the workbook. S will be a cell array of strings specifying the name of
% the worksheet for each found table.
% READTABLE(WORKBOOK,SHEET,'TRANSPOSE') will treat tables as transposed,
% i.e., field names will be taken from the first column and data values
% from the following columns.

[p,f,e] = fileparts(filename);
if ~strcmp(e, '.xlsx'), e = '.xls'; end
filename = fullfile(p, [f, e]);

E = excelfile.open(filename);
v = readtable(E, varargin{:});

% Return results
if nargout == 1
	varargout{1} = v(1).contents;
else
	varargout{1} = {v.contents};
	varargout{2} = {v.name};
	if nargout == 3
		varargout{3} = {v.sheet};
	end
end

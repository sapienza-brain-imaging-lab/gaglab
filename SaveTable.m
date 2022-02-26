function SaveTable (filename, varargin)
% SAVETABLE         Save a table to a Microsoft Excel file
%
% SAVETABLE exports data to a Microsoft Excel table. Data are given as one
% or more vector of structures. Each vector is saved to a separate table
% (i.e., to a continous range of cells) into the same Excel worksheet. Each
% table may have an optional title.
% SAVETABLE(WORKBOOK,SHEET,T) saves the vector of structures in T to the
% worksheet named SHEET in the workbook whose file name is WORKBOOK.
% The whole contents of the worksheet is replaced.
% The worksheet and eventually the workbook are created if necessary.
% SAVETABLE(WORKBOOK,SHEET,T,N) gives the table the name specified by N.
% T may be a cell array of vectors of structures, specifying multiple
% tables. In this case, specifying names for the tables is mandatory, and N
% must be a cell array of strings specifying table names.

try
	E = excelfile.open(filename);
catch %#ok<CTCH>
	E = excelfile.create(filename);
end
writetable(E, varargin{:});
save(E);

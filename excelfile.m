classdef excelfile
	% EXCELFILE        Interface with Excel documents (workbooks)
	%
	% W = EXCELFILE.OPEN(FILENAME) opens an Excel document.
	% W = EXCELFILE.CREATE(FILENAME) creates an Excel document.
	%
	properties (GetAccess = public, SetAccess = private)
		filename;
	end
	
	properties (Access = private)
		wbook;
	end
	
	methods (Static, Access = public)
		function obj = create (filename)
			excelfile.init;
			obj = excelfile(filename, '-create');
		end
		
		function obj = open (filename)
			excelfile.init;
			obj = excelfile(filename);
		end
		
		function init
			if isempty(which('org.apache.poi.ss.usermodel.WorkbookFactory'))
				f = {'commons-logging-1.1.jar', 'dom4j-1.6.1.jar', 'geronimo-stax-api_1.0_spec-1.0.jar', ...
					'log4j-1.2.13.jar', 'poi-3.7-20101029.jar', 'poi-ooxml-3.7-20101029.jar', ...
					'poi-ooxml-schemas-3.7-20101029.jar', 'xmlbeans-2.3.0.jar'};
				p = fullfile(fileparts(which('excelfile')), 'poi');
				for i=1:length(f)
					javaaddpath(fullfile(p, f{i}));
				end
			end
		end
	end
	
	methods (Access = public)
		function obj = excelfile (filename, arg)
			if nargin == 0 || (nargin > 1 && ~isequal(arg, '-create'))
				error('gaglab:excelfile:invsyntax', 'Usage: E = EXCELFILE(FILENAME);');
			end
			if nargin == 1
				obj.filename = validate_filename(filename);
				try
					obj.wbook = org.apache.poi.ss.usermodel.WorkbookFactory.create(java.io.FileInputStream(filename));
				catch e
					if ~isempty(regexp(e.message, 'RecordFormatException', 'once'))
						throwAsCaller(MException('excellib:recordformatexception', 'Can''t read this file: it may be corrupted, or there may be a bug in the POI library.'));
					else
						throwAsCaller(e);
					end
				end
			else
				obj.filename = abspath(filename);
				[p,f,e]  = fileparts(obj.filename);
				switch e
					case '.xlsx'
						obj.wbook = org.apache.poi.xssf.usermodel.XSSFWorkbook;
					case '.xls'
						obj.wbook = org.apache.poi.hssf.usermodel.HSSFWorkbook;
					otherwise
						error('excel:extension', 'Invalid file extension.');
				end
			end
		end
	end
	
	methods (Access = public)
		function s = sheets (obj)
			n = obj.wbook.getNumberOfSheets;
			s = cell(1,n);
			for i=1:n
				s{i} = char(obj.wbook.getSheetName(i-1));
			end
		end
		
		function obj = save (obj, filename)
			error(nargchk(1,2,nargin,'struct'));
			if ~isa(obj, 'excelfile')
				error('excelfile:syntax', 'Invalid call.');
			end
			if nargin > 1
				obj.filename = abspath(filename);
			end
			fOut = java.io.FileOutputStream(obj.filename);
			obj.wbook.write(fOut);
			fOut.flush();
			fOut.close();
		end
		
		function v = readsheet (obj, sheetname)
			% READSHEET     Read raw data from an Excel worksheet
			%
			% DATA = READSHEET(WORKBOOK, SHEETNAME) returns all data in a given Excel
			% worksheet as a cell array. SHEETNAME can be a cell array of sheet names,
			% or can be omitted if you want to read all worksheets. In this cases, DATA
			% will be a cell array of cell arrays of data.
			
			error(nargchk(1,2,nargin,'struct'));
			if ~isa(obj, 'excelfile')
				error('excelfile:syntax', 'Invalid call.');
			end
			if nargin == 1
				sheetname = sheets(obj);
			end
			singlesheet = ischar(sheetname);
			try
				sheetname = cellstr(sheetname);
			catch %#ok<CTCH>
				error('excelfile:sheetname', 'Invalid worksheet name.');
			end
			calendar = java.util.GregorianCalendar;
			v = cell(1, length(sheetname));
			for i=1:length(sheetname)
				s = obj.wbook.getSheet(sheetname{i});
				if isempty(s)
					error('ExcelWorkbook:nosheet', 'There is no worksheet named ''%s''.', sheetname{i});
				end
				lastrow = s.getLastRowNum;
				v{i} = cell(lastrow+1, 0);
				rit = s.rowIterator;
				while rit.hasNext
					r = rit.next;
					j = r.getRowNum;
					lastcell = r.getLastCellNum;
					if lastcell > 0
						v{i}{j+1,lastcell} = [];
					end
					cit = r.cellIterator;
					while cit.hasNext
						c = cit.next;
						k = c.getColumnIndex;
						type = c.getCellType;
						if type == 2    % CELL_TYPE_FORMULA
							type = c.getCachedFormulaResultType;
						end
						switch type
							case 0	% CELL_TYPE_NUMERIC
								if org.apache.poi.ss.usermodel.DateUtil.isCellDateFormatted(c)
									calendar.setTime(c.getDateCellValue);
									v{i}{j+1,k+1} = datenum(c.getNumericCellValue + 693960);
								else
									v{i}{j+1,k+1} = c.getNumericCellValue;
								end
							case 1	% CELL_TYPE_STRING
								v{i}{j+1,k+1} = char(c.getRichStringCellValue.getString);
							case 2	% CELL_TYPE_FORMULA
								error('This should not happen!');
							case 3	% CELL_TYPE_BLANK
								v{i}{j+1,k+1} = [];
							case 4	% CELL_TYPE_BOOLEAN
								v{i}{j+1,k+1} = logical(c.getBooleanCellValue);
							case 5	% CELL_TYPE_ERROR
								v{i}{j+1,k+1} = NaN;
						end
					end
				end
				if singlesheet
					v = v{1};
				end
			end
		end
		
		function writesheet (obj, sheetname, data)
			% WRITESHEET     Save raw data to an Excel worksheet
			%
			% WRITESHEET(WORKBOOK,SHEET,DATA) writes the cell matrix of data
			% given in DATA to the worksheet named SHEET in the Excel workbook
			% WORKBOOK. The worksheet and eventually the workbook are created if necessary.
			
			error(nargchk(3,3,nargin,'struct'));
			if ~isa(obj, 'excelfile')
				error('excelfile:syntax', 'Invalid call.');
			end
			singlesheet = ischar(sheetname);
			try
				sheetname = cellstr(sheetname);
			catch %#ok<CTCH>
				error('excelfile:sheetname', 'Invalid worksheet name.');
			end
			if singlesheet
				data = {data};
			end
			calendar = java.util.GregorianCalendar;
			for i=1:length(sheetname)
				if ~iscell(data{i})
					error('excelfile:data', 'Sheet data must be a cell matrix.');
				end
				s = obj.wbook.getSheet(sheetname{i});
				if isempty(s)
					s = obj.wbook.createSheet(sheetname{i});
				else
					while s.getFirstRowNum < s.getLastRowNum
						s.removeRow(s.getRow(s.getLastRowNum));
					end
					try %#ok<TRYNC>
						s.removeRow(s.getRow(0));
					end
				end
				
				emptycell = cellfun(@isempty, data{i});
				for j=1:size(data{i},1)
					if ~all(emptycell(j,:))
						r = s.createRow(j-1);
						for k=1:size(data{i},2)
							if ~emptycell(j,k)
								if isnumeric(data{i}{j,k})
									if isscalar(data{i}{j,k})
										c = r.createCell(k-1, 0);
										c.setCellValue(double(data{i}{j,k}));
									elseif isequal(size(data{i}{j,k}), [1 6]) % date vector
										c = r.createCell(k-1, 0);
										calendar.set(data{i}{j,k}(1), data{i}{j,k}(2)-1, data{i}{j,k}(3), data{i}{j,k}(4), data{i}{j,k}(5), data{i}{j,k}(6));
										c.setCellValue(calendar);
									else
										c = r.createCell(k-1, 1);
										tmp = cellstr(num2str(double(data{i}{j,k})));
										if length(tmp) == 1
											c.setCellValue(tmp{1});
										else
											c.setCellValue(sprintf('%s\n', tmp{:}));
										end
									end
								elseif ischar(data{i}{j,k})
									c = r.createCell(k-1, 1);
									c.setCellValue(data{i}{j,k});
								elseif islogical(data{i}{j,k})
									c = r.createCell(k-1, 4);
									c.setCellValue(data{i}{j,k});
								end
							end
						end
					end
				end
			end
		end
		
		function v = readtable (obj, sheetname, varargin)
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
			% T = READTABLE(WORKBOOK) imports all tables in the workbook.
			% T = READTABLE(WORKBOOK,SHEET) imports all tables found in the given
			% worksheet(s).
			% T = READTABLE(WORKBOOK,SHEET,'TRANSPOSE') will treat tables as transposed,
			% i.e., field names will be taken from the first column and data values
			% from the following columns.
			%
			% T will be a structure array with the following fields:
			%      name      name of the table
			%      sheet     name of the worksheet where the table is found
			%      data      structure array containing table data
			
			error(nargchk(1,3,nargin,'struct'));
			if ~isa(obj, 'excelfile')
				error('excelfile:syntax', 'Invalid call.');
			end
			if nargin == 1 || isempty(sheetname)
				sheetname = sheets(obj);
			elseif ischar(sheetname) && ~isempty(sheetname) && ndims(sheetname) == 2 && size(sheetname,2) == numel(sheetname)
				sheetname = cellstr(sheetname);
			elseif ~iscellstr(sheetname)
				error('excelfile:sheetname', 'Invalid sheet name.');
			end
			options = '';
			if nargin > 2
				if ~iscellstr(varargin)
					error('excelfile:options', 'Invalid options.');
				end
				for i=1:length(varargin)
					switch lower(varargin{i})
						case 'transpose'
							options = 'transpose';
						otherwise
							error('excelfile:options', 'Invalid options.');
					end
				end
			end
			
			% Read data from the workbook
			data = readsheet(obj, sheetname);
			
			% Parse sheet contents
			v = struct('sheet', {}, 'name', {}, 'contents', {}, 'startcell', {});
			for i=1:length(sheetname)
				v = [v, parse_sheet(data{i}, sheetname{i}, options)]; %#ok<AGROW>
			end
		end
		
		function writetable (obj, sheetname, data, tablename)
			% WRITETABLE         Save a table to a Microsoft Excel file
			%
			% WRITETABLE exports data to a Microsoft Excel table. Data are given as one
			% or more vector of structures. Each vector is saved to a separate table
			% (i.e., to a continous range of cells) into the same Excel worksheet. Each
			% table may have an optional title.
			% WRITETABLE(WORKBOOK,SHEET,T) saves the vector of structures in T to the
			% worksheet named SHEET in the workbook whose file name is WORKBOOK.
			% The whole contents of the worksheet is replaced.
			% The worksheet and eventually the workbook are created if necessary.
			% WRITETABLE(WORKBOOK,SHEET,T,N) gives the table the name specified by N.
			% T may be a cell array of vectors of structures, specifying multiple
			% tables. In this case, specifying names for the tables is mandatory, and N
			% must be a cell array of strings specifying table names.
			
			error(nargchk(2,4,nargin,'struct'));
			if ~isa(obj, 'excelfile')
				error('excelfile:syntax', 'Invalid call.');
			end
			if nargin == 2 && isstruct(sheetname) && all(ismember({'sheet','name','contents'}, fieldnames(sheetname)))
				data = {sheetname.contents};
				tablename = {sheetname.name};
				sheetname = {sheetname.sheet};
				numargs = 3;
			else
				numargs = nargin-1;
			end
			
			if numargs < 1
				sheetnums = 0;
			elseif ischar(sheetname)
				sheetname = {sheetname};
				sheetnums = 1;
			elseif iscellstr(sheetname)
				sheetnums = numel(sheetname);
			else
				sheetnums = 0;
			end
			
			if numargs < 2
				datanums = 0;
			elseif isstruct(data)
				data = {data};
				datanums = 1;
			elseif iscell(data) && all(cellfun(@isstruct, data))
				datanums = numel(data);
			else
				datanums = 0;
			end
			
			if numargs < 3
				namenums = 0;
			elseif ischar(tablename)
				tablename = {tablename};
				namenums = 1;
			elseif iscellstr(tablename)
				namenums = numel(tablename);
			else
				namenums = 0;
			end
			
			if sheetnums == 0 || datanums == 0
				error('excelfile:writetable', 'Invalid syntax.');
			end
			if namenums == 0
				if sheetnums ~= datanums
					error('excelfile:writetable', 'Invalid syntax.');
				end
				if sheetnums ~= numel(unique(sheetname))
					error('excelfile:dupsheet', 'Duplicate sheet name.');
				end
				v = struct('sheet', sheetname, 'name', '', 'contents', data);
			else
				if sheetnums ~= 1 && sheetnums ~= datanums
					error('excelfile:writetable', 'Invalid syntax.');
				end
				if namenums ~= datanums
					error('excelfile:writetable', 'Invalid syntax.');
				end
				v = struct('sheet', sheetname, 'name', tablename, 'contents', data);
			end
			
			[sheetname, a, idx] = unique({v.sheet});
			data = cell(size(sheetname));
			bold = cell(size(sheetname));
			italic = cell(size(sheetname));
			for i=1:length(sheetname)
				% Convert structures to tables
				data{i} = {};
				row = 1;
				jidx = find(idx == i);
				if length(jidx) > 1	&& any(cellfun(@isempty, {v(jidx).name}))
					error('excelfile:tablename', 'Empty table name.');
				end
				for j=jidx
					if ~isempty(v(j).name)
						data{i}{row,1} = v(j).name;
						bold{i} = [bold{i}, row];
						row = row + 1;
					end
					tmpdata = [fieldnames(v(j).contents), struct2cell(v(j).contents(:))]';
					data{i}(row:row+size(tmpdata,1)-1,1:size(tmpdata,2)) = tmpdata;
					italic{i} = [italic{i}, row];
					row = row + size(tmpdata,1) + 1;
				end
			end
			
			writesheet(obj, sheetname, data);
			setsimplestyles(obj, sheetname, bold, italic);
		end
		
		function setsimplestyles (obj, sheetname, bold, italic)
			error(nargchk(3,4,nargin,'struct'));
			if ~isa(obj, 'excelfile')
				error('excelfile:syntax', 'Invalid call.');
			end
			try
				sheetname = cellstr(sheetname);
			catch %#ok<CTCH>
				error('excelfile:sheetname', 'Invalid worksheet name.');
			end
			if ~iscell(bold)
				bold = repmat({bold}, size(sheetname));
			end
			if nargin < 4
				italic = cell(size(sheetname));
			elseif ~iscell(italic)
				italic = repmat({italic}, size(sheetname));
			end
			
			st = define_styles(obj.wbook);
			
			for i=1:length(sheetname)
				s = obj.wbook.getSheet(sheetname{i});
				setastyle(s, bold{i}, st(2));
				setastyle(s, italic{i}, st(3));
			end
		end
		
	end
end


% PARSE_SHEET
% Extracts tables from a raw data matrix

function table = parse_sheet (data, sheetname, options)
	
	emptycell = cellfun(@isempty, data);
	emptyrow = find(all(emptycell,2))';
	emptyrow = [0 emptyrow size(data,1)+1];
	
	table = struct('sheet', {}, 'name', {}, 'contents', {}, 'startcell', {});
	for i = 1:length(emptyrow)-1
		if emptyrow(i+1) > emptyrow(i) + 1
			[tab, tit, startpos] = parse_matrix(data(emptyrow(i)+1 : emptyrow(i+1)-1,:), options);
			if isstruct(tab)
				table(end+1).sheet = sheetname; %#ok<AGROW>
				table(end).name = tit;
				table(end).contents = tab;
				table(end).startcell = [emptyrow(i),0] + startpos;
			end
		end
	end
end


% PARSE_MATRIX
% Convert a raw data matrix into a structure

function [table, title, startpos] = parse_matrix (data, options)
	
	table = [];
	title = '';
	startpos = [1 1];
	if isempty(data), return; end
	
	emptycell = cellfun(@isempty, data);
	
	% Find title
	foundtitle = 0;
	if emptycell(1,1) == 0
		if size(data,2) == 1
			foundtitle = 1;
		elseif all(emptycell(1,2:end))
			foundtitle = 1;
		end
	end
	if foundtitle
		title = data{1,1};
		data(1,:) = [];
		emptycell(1,:) = [];
		startpos(1) = 2;
	end
	if isempty(data), return; end
	
	% Transpose if necessary
	if any(strcmpi(options, 'transpose'))
		data = data';
		emptycell = emptycell';
	end
	
	% Delete empty columns and columns without header
	emptycol = all(emptycell,1) | emptycell(1,:);
	if any(strcmpi(options, 'transpose'))
		startpos(1) = find(~emptycol,1);
	else
		startpos(2) = find(~emptycol,1);
	end
	data(:,emptycol) = [];
	if isempty(data), return; end
	
	% Check column names
	varname = checkvarname(data(1,:));
	
	% Convert to structure
	table = cell2struct(data(2:end,:), varname, 2);
end

function vname = checkvarname (name)
	
	vname = cell(size(name));
	for i=1:length(name)
		j = find(~ismember(name{i}, '1234567890'));
		if isempty(j)
			error(['Invalid variable name: ' name{i}]);
		end
		vname{i} = name{i}(j(1):end);
		vname{i} = vname{i}(ismember(vname{i},'1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_'));
		if isempty(vname{i})
			error(['Invalid variable name "' name{i}, '"']);
		end
	end
end


function st = define_styles (w)
	st = [org.apache.poi.ss.usermodel.CellStyle.ALIGN_GENERAL, org.apache.poi.ss.usermodel.CellStyle.BORDER_NONE, ...
		org.apache.poi.ss.usermodel.CellStyle.BORDER_NONE, org.apache.poi.ss.usermodel.CellStyle.BORDER_NONE, ...
		org.apache.poi.ss.usermodel.CellStyle.BORDER_NONE, 0, 64, 64, ...
		org.apache.poi.ss.usermodel.CellStyle.NO_FILL, 0, 0, ...
		8, 8, 8, 8, ...
		1, 0, org.apache.poi.ss.usermodel.CellStyle.VERTICAL_BOTTOM, 0, 0];
	st = repmat(st, 3, 1);
	st(:,end) = findfonts(w);
	[ex, j] = ismember(st, get_existing_styles(w), 'rows');
	for i=find(~ex')
		s = w.createCellStyle;
		s.setAlignment(st(i,1));
		s.setBorderBottom(st(i,2));
		s.setBorderLeft(st(i,3));
		s.setBorderRight(st(i,4));
		s.setBorderTop(st(i,5));
		s.setDataFormat(st(i,6));
		s.setFillBackgroundColor(st(i,7));
		s.setFillForegroundColor(st(i,8));
		s.setFillPattern(st(i,9));
		s.setHidden(st(i,10));
		s.setIndention(st(i,11));
		s.setBottomBorderColor(st(i,12));
		s.setLeftBorderColor(st(i,13));
		s.setRightBorderColor(st(i,14));
		s.setTopBorderColor(st(i,15));
		s.setLocked(st(i,16));
		s.setRotation(st(i,17));
		s.setVerticalAlignment(st(i,18));
		s.setWrapText(st(i,19));
		s.setFont(w.getFontAt(st(i,20)));
		j(i) = s.getIndex + 1;
	end
	j = j - 1;
	st = [w.getCellStyleAt(j(1)), w.getCellStyleAt(j(2)), w.getCellStyleAt(j(3))];
end

function st = get_existing_styles (w)
	num = w.getNumCellStyles;
	st = zeros(num, 20);
	for i=1:num
        try
    		s = w.getCellStyleAt(i-1);
        catch %#ok<CTCH>
            st(i:end,:) = [];
            return
        end
		st(i,:) = [s.getAlignment, s.getBorderBottom, s.getBorderLeft, s.getBorderRight, s.getBorderTop, ...
			s.getDataFormat, s.getFillBackgroundColor, s.getFillForegroundColor, s.getFillPattern, s.getHidden, s.getIndention, ...
			s.getBottomBorderColor, s.getLeftBorderColor, s.getRightBorderColor, s.getTopBorderColor, ...
			s.getLocked, s.getRotation, s.getVerticalAlignment, s.getWrapText, s.getFontIndex];
	end
end

function fontIndex = findfonts (w)
	fontIndex = [NaN NaN NaN]';
	num = w.getNumberOfFonts;
	for i=0:num-1
		f = w.getFontAt(i);
		if strcmp(f.getFontName, 'Arial') ...
				&& f.getColor == 32767 ...
				&& f.getFontHeightInPoints == 10 ...
				&& ~f.getStrikeout ...
				&& f.getTypeOffset == org.apache.poi.ss.usermodel.Font.SS_NONE ...
				&& f.getUnderline == org.apache.poi.ss.usermodel.Font.U_NONE
			if f.getBoldweight == org.apache.poi.ss.usermodel.Font.BOLDWEIGHT_NORMAL && ~f.getItalic
				fontIndex(1) = i;
			elseif f.getBoldweight == org.apache.poi.ss.usermodel.Font.BOLDWEIGHT_BOLD && ~f.getItalic
				fontIndex(2) = i;
			elseif f.getBoldweight == org.apache.poi.ss.usermodel.Font.BOLDWEIGHT_NORMAL && f.getItalic
				fontIndex(3) = i;
			end
		end
	end
	for i=find(isnan(fontIndex'))
		f = w.createFont;
		f.setFontName('Arial');
		f.setColor(32767);
		f.setFontHeightInPoints(10);
		f.setStrikeout(false);
		f.setTypeOffset(org.apache.poi.ss.usermodel.Font.SS_NONE);
		f.setUnderline(org.apache.poi.ss.usermodel.Font.U_NONE);
		if i==2
			f.setBoldweight(org.apache.poi.ss.usermodel.Font.BOLDWEIGHT_BOLD);
		else
			f.setBoldweight(org.apache.poi.ss.usermodel.Font.BOLDWEIGHT_NORMAL);
		end
		if i==3
			f.setItalic(true);
		else
			f.setItalic(false);
		end
		fontIndex(i) = f.getIndex;
	end
end

function setastyle (s, rows, style)
	for j=rows-1
		r = s.getRow(j);
		if ~isempty(r)
			cit = r.cellIterator;
			while cit.hasNext
				c = cit.next;
				c.setCellStyle(style);
			end
		end
	end
end


function fname = abspath (fname, cwd)
	%ABSPATH   Convert a partial or relative pathname to an absolute pathname.
	%   ABSPATH(P) returns the full absolute pathname computed from P. For
	%   example, if the current directory is /usr/local/bin, ABSPATH('..')
	%   will return '/usr/local'.
	%
	%   ABSPATH(P,CWD) computes the absolute pathname relative to CWD
	%   instead of the current directory.
	%
	%   See also PARTIALPATH, FULLFILE, FILEPARTS.
	%

	error(nargchk(1,2,nargin,'struct'));
	validateattributes(fname, {'char'}, {'row', 'nonempty'});
	f = java.io.File(fname);
	if ~isAbsolute(f)
		if nargin > 1
			validateattributes(cwd, {'char'}, {'row', 'nonempty'});
		else
			cwd = pwd;
		end
		f = java.io.File(cwd, fname);
	end
	[p,f,e] = fileparts(char(getAbsolutePath(f)));
	fname = fullfile(p, [f,e]);
end

function [varargout] = validate_filename (str, varargin)
	j = strcmp(varargin, 'wildcards');
	varargin(j) = [];
	expandwildcards = any(j);

	str = abspath(str);
	
	if expandwildcards
		[p,f,e] = fileparts(str);
		if any(ismember([f,e], '*'));
			d = dir(str);
			if isempty(d)
				throwAsCaller(MException('MATLAB:FileIO:FileNotFound', 'No files found: ''%s''.', str));
			end
			switch nargout
				case 0
					varargout = {};
				case 1
					varargout = {cellstr([repmat([p, filesep],length(d),1), char({d.name})])};
				case 2
					varargout = {p, {d.name}};
				otherwise
					[tmp,f,e] = cellfun(@fileparts, {d.name}, 'UniformOutput', false);
					varargout = {p, f, e};
			end
		else
			if exist(str, 'file') ~= 2
				throwAsCaller(MException('MATLAB:FileIO:FileNotFound', 'File not found: ''%s''.', str));
			end
			switch nargout
				case 0
					varargout = {};
				case 1
					varargout = {{str}};
				case 2
					[p,f,e] = fileparts(str);
					varargout = {p, {[f, e]}};
				otherwise
					[p,f,e] = fileparts(str);
					varargout = {p, {f}, {e}};
			end
		end
	else
		if exist(str, 'file') ~= 2
			throwAsCaller(MException('MATLAB:FileIO:FileNotFound', 'File not found: ''%s''.', str));
		end
		switch nargout
			case 0
				varargout = {};
			case 1
				varargout = {str};
			case 2
				[p,f,e] = fileparts(str);
				varargout = {p, [f, e]};
			otherwise
				[p,f,e] = fileparts(str);
				varargout = {p, f, e};
		end
	end
end


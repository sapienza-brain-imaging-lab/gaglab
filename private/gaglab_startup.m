function GL = gaglab_startup

%clear all
warning('off','MATLAB:dispatcher:InexactCaseMatch')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check computer, Matlab version, and GagLab version
if ispc == 0
	error('This version of GagLab only runs under Windows');
end
if isempty(which('verLessThan')) || verLessThan('matlab','7.6')
	error('This version of GagLab requires at least Matlab 7.6');
end
v = LocParseContentsFile(fullfile(fileparts(which('gaglabcmd')), 'Contents.m'));
if isempty(v)
	error('Invalid GagLab installation');
end
GL.Version = sprintf('GagLab %s (Rev %d)', v.Version, v.Release);

%addpath(fullfile(fileparts(which('gaglabcmd')), 'cogent'));
if isempty(which('org.apache.poi.ss.usermodel.WorkbookFactory'))
	f = {'poi/commons-logging-1.1.jar', 'poi/dom4j-1.6.1.jar', 'poi/geronimo-stax-api_1.0_spec-1.0.jar', ...
		'poi/log4j-1.2.13.jar', 'poi/poi-3.7-20101029.jar', 'poi/poi-ooxml-3.7-20101029.jar', ...
		'poi/poi-ooxml-schemas-3.7-20101029.jar', 'poi/xmlbeans-2.3.0.jar'};
	p = fileparts(which('excelfile'));
	for i=1:length(f)
		javaaddpath(fullfile(p, f{i}));
	end
end

if isempty(which('scansim'))
	addpath(fullfile(fileparts(which('gaglabcmd')), 'scansim'));
end
if isempty(which('testscreen'))
	addpath(fullfile(fileparts(which('gaglabcmd')), 'test'));
end

s = warning('off','MATLAB:dispatcher:InexactCaseMatch');
cgloadlib
warning(s);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check UserPort
if ~exist(fullfile(getenv('windir'),'system32','drivers','UserPort.sys'), 'file')
	try
		copyfile(fullfile(fileparts(which('gaglabcmd')),'private','UserPort.sys'), fullfile(getenv('windir'),'system32','drivers'));
		eval(['!' fullfile(fileparts(which('gaglabcmd')),'private','UserPort.exe')]);
	catch
		disp('Cannot install UserPort: try to use an administrative account');
	end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize default paths
SystemPath = fileparts(fileparts(which('gaglab')));
if ispref('GagLab', 'path') && exist(fileparts(getpref('GagLab', 'path')), 'dir')
	LocalPath = getpref('GagLab', 'path');
else
	LocalPath = getenv('USERPROFILE');
	if isempty(LocalPath)
		LocalPath = 'c:\';
	else
		if exist(fullfile(LocalPath, 'Google Drive'), 'dir')
			LocalPath = fullfile(LocalPath, 'Google Drive');
		else
			LocalPath = fullfile(LocalPath, 'Desktop');
		end
	end
	LocalPath = fullfile(LocalPath, 'GagLab');
	setpref('GagLab', 'path', LocalPath);
end

GL.ResultsPath    = fullfile(LocalPath, 'Results');
GL.LogPath        = fullfile(LocalPath, 'Log');
GL.SetupPath      = fullfile(LocalPath, 'Setup', 'v1');
GL.ExperimentPath = fullfile(LocalPath, 'Experiments', 'v1');
GL.ScreenDumpPath = fullfile(LocalPath, 'Screen Dumps');

gaglab_util_mkdir(GL.ResultsPath);
gaglab_util_mkdir(GL.LogPath);
gaglab_util_mkdir(GL.SetupPath);
gaglab_util_mkdir(GL.ExperimentPath);
gaglab_util_mkdir(GL.ScreenDumpPath);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now check the available monitor resolutions
GL.Resolutions = gaglab_setup_graphics(GL.SetupPath);
if isempty(GL.Resolutions)
	error('Cannot start GagLab: cannot determine available screen resolutions');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize experiment structure
GL.Experiment = struct( ...
	'Setup', 'Default', ...
	'Path', '', ...
	'Name', '', ...
	'Category', '', ...
	'Parameter', [], ...
	'Subject', '', ...
	'Session', 1, ...
	'Study', 1, ...
	'Series', 1 ...
);

GL.Running = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load current setup and experiment
GL = gaglab_setup_load(GL, GL.Experiment.Setup);
GL = gaglab_exp_load(GL);


%--------------------------------------------------------------------------
function structInfo=LocParseContentsFile(fName)
% LocParseContentsFile  Extract toolbox information from Contents.m file
% structInfo=LocParseContentsFile(fName)
% Input:
%     fName:  string vector containing full path to Contents.m file
% Return:
%     structInfo: scalar struct defining toolbox information

structInfo=struct('Name',{},'Version',{},'Release',{},'Date',{});

if exist(fName, 'file')
   if ispc
      fp = fopen(fName,'rb');
   else
      fp = fopen(fName,'r');
   end
   
   if fp>0
      s = fgetl(fp);
      if ~isstr(s)
         s = '';
      else
         s  = [s '  '];
         s(1:2) = [];
      end
      
      s1 = fgetl(fp);
      if ~isstr(s1)
         s1 = '';
      else
         s1 = [s1 '  '];
         s1(1:2) = [];
      end
      fclose(fp);
   else
      s='';
      s1='';
   end
   
   if ~isempty(findstr(fName, ['toolbox' filesep 'matlab' filesep 'general']))
      % Look for Version
      k = findstr('Version',s1);
      s = s1(1:k-1);
      s1 = s1(k:end);
   end
   
   s = deblank(s);
   % Remove any trailing period.
   if ~isempty(s) & s(end)=='.'
      s(end)=[];
   end
   
   % Force the name to fit within the specified number of characters
   productName=s;
   
   %remove trailing spaces
   s1 = deblank(s1);
   if ~isempty(s1)
      verLoc=findstr(lower(s1),'version ');
      if ~isempty(verLoc)
         s1=s1(verLoc+length('version '):end);
         %remove leading spaces
         s1= fliplr(deblank(fliplr(s1)));
         blankLoc=findstr(s1,' ');
         
         if length(blankLoc)>0
            %Version is everything from beginning to first space
            verNum=s1(1:blankLoc(1)-1);
            
            %Date is everything from last space to end
            dateString=s1(blankLoc(end)+1:end);
            dateString=LocCleanDate(dateString);

            %Release number is everything from first to last space
            releaseNum=s1(blankLoc(1):blankLoc(end));
            %remove leading and trailing blanks from releaseNum
            releaseNum=deblank(releaseNum);
            releaseNum=fliplr(deblank(fliplr(releaseNum)));
            [a,b,c] = regexp(releaseNum, '^\(R(\d+)\)$');
			if ~isempty(a)
				releaseNum = str2double(releaseNum(c{1}(1,1):c{1}(1,2)));
			end
            structInfo=struct('Name',productName,...
               'Version',verNum,...
               'Release',releaseNum,...
               'Date',dateString);
            
         end
      end
   end
   
else
   % Skip this directory since there's no Contents.m
end

return

%--------------------------------------------------------------------------
function cleanDate=LocCleanDate(dirtyDate);
%LocCleanDate forces a date to be in the format of DD-Mmm-YYYY

slashLoc=findstr(dirtyDate,'-');
if length(slashLoc)>1
   dayStr=dirtyDate(1:slashLoc(1)-1);
   monthStr=dirtyDate(slashLoc(1)+1:slashLoc(2)-1);
   yearStr=dirtyDate(slashLoc(2)+1:end);
   
   if length(dayStr)==1
      dayStr=['0' dayStr];
   end
   
   if length(monthStr)>2
      monthStr=[upper(monthStr(1)),lower(monthStr(2:3))];
   end
   
   cleanDate=[dayStr '-' monthStr '-' yearStr];
   
else
   cleanDate=dirtyDate;
end
%--------------------------------------------------------------------------

function Resolutions = gaglab_setup_graphics (where, varargin)
% GAGLAB_SETUP_GRAPHICS	Get info about possible monitor configurations
%
% R = GAGLAB_SETUP_GRAPHICS returns a list of all possible monitor
% configurations on this system. A matrix is returned with a row for each
% available monitor configuration, and 8 columns, indicating: 1) the monitor
% number; 2) the Cogent resolution number; 3) the number of horizontal pixels;
% 4) the number of vertical pixels; 5) the nominal refresh rate; 6) the actual
% refresh rate; 7) the number of bits per pixel; and 8) whether the
% graphics board really waits for vertical blanking interrupt when calling
% CGFLIP.
% If no information has been stored on the possible monitor configuration,
% GAGLAB_SETUP_GRAPHICS ask the user to perform a monitor test now. The test can
% be forced by calling GAGLAB_SETUP_GRAPHICS FORCE.

if nargin > 1 && ischar(varargin{1}) && strcmpi(varargin{1}, 'force')
	Resolutions = gaglab_setup_graphics_test(where);
	return
end

Resolutions = [];
if exist(fullfile(where, 'resolutions.mat'), 'file')
	Resolutions = load(fullfile(where, 'resolutions.mat'));
	Resolutions = Resolutions.R;
	if size(Resolutions,2) < 8, Resolutions = []; end
end

if isempty(Resolutions)
	switch questdlg('A monitor test needs to be performed now. This will take a while.', ...
		'GagLab','Cancel','OK','OK');
		case 'OK'
			Resolutions = gaglab_setup_graphics_test(where);
		case 'Cancel'
			Resolutions = [];
	end
end


function validres = gaglab_setup_graphics_test (where)

txt = evalc('cgopen(1,0,0,-1)');
numscreens = length(find(txt==10)) - 2;

reswh = [640 480; 800 600; 1024 768; 1152 864; 1280 1024; 1600 1200];
freq = [60 70 72 75 85 90 100 120]';
validres = [];

for mon = 1:numscreens
	fprintf('\nValid resolutions of monitor %d:\n', mon);
	for res = 1:size(reswh,1)
		fprintf('  %d x %d: ', reswh(res,:));
		info = try2open(mon, res, 0);
		if isempty(info)
        	fprintf('not supported\n');
		else
			fprintf('\n');
			for f = 1:length(freq)
				info = try2open(mon, res, freq(f));
				if ~isempty(info)
					[m,j] = min(abs(info(6) - freq));
					if j == f
						validres(end+1,:) = info; %#ok<AGROW>
						switch info(8)
							case 1
								fprintf('    %.0f Hz (actual %.2f), %d bit per pixels\n', info(5:7));
							case 0
								fprintf('    %.0f Hz (actual %.2f), %d bit per pixels*\n', info(5:7));
							case -1
								fprintf('    %.0f Hz (actual %.2f), %d bit per pixels**\n', info(5:7));
						end
					end
				end
			end
		end
	end
	fprintf('\n');
end
evalc('cgshut');
R = validres; %#ok<NASGU>
save(fullfile(where, 'resolutions.mat'), 'R');


function info = try2open (mon, res, freq)

evalc(sprintf('cgopen(%d, 0, %d, %d)', res, freq, mon));
try
	[t, GPD] = evalc('cggetdata(''GPD'')');
	if GPD.BitDepth < 16
		info = [];		% Palette mode not supported
	else
		if GPD.RefRate100 == 0
			GPD.RefRate100 = 60;
		end
		correct = testtiming(GPD,0);
		if ~correct
			correct = testtiming(GPD,1);
			if correct
                correct = 0;
            else
				correct = -1;
			end
		end
		info = [mon, res, GPD.PixWidth, GPD.PixHeight, freq, GPD.RefRate100 / 100, GPD.BitDepth, correct];
	end
catch %#ok<CTCH>
	info = [];
end
drawnow;


function correct = testtiming (GPD, forcewait)

numeroframe = 2;
frame = 100000 / GPD.RefRate100;
t = [];
for i=1:30
	endtime = floor(cogstd('sGetTime',-1) * 1000) + frame * (numeroframe-1) + 2;
	while floor(cogstd('sGetTime',-1) * 1000) < endtime
	end
	if forcewait
		t = [t, cgflip('V')]; %#ok<AGROW>
	else
		t = [t, cgflip]; %#ok<AGROW>
	end
end
realframe = mean(diff(t))*1000 / numeroframe;
correct = abs(realframe - frame) < 2;

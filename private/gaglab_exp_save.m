function GL = gaglab_exp_save (GL)
% GAGLAB_EXP_SAVE	    	Save results and log for all experimental sessions

if isempty(GL.Sessions), return; end
fprintf('Saving results and log...\n');
GL = rmfield(GL, 'Events');

Log = [];
for i=1:length(GL.Sessions)
	if ~isempty(GL.Sessions{i}.Log.Event)
		tmp = GL.Sessions{i}.Log.Event;
		[tmp.Session] = deal(i);
		Log = [Log, tmp];
	end
end
timestr = sprintf('%02d%02d%02d-%02d%02d', GL.Sessions{1}.StartTime(1:5));
fn = sprintf('%s-%s-%s', GL.Experiment.Name, GL.Experiment.Subject, timestr);

GL.Screen.Stimulus = rmfield(GL.Screen.Stimulus, 'Arg');
GL = rmfield(GL, 'Image');
GL.Sound = rmfield(GL.Sound, 'File');

save(fullfile(GL.Runtime.LogPath, [fn '.mat']), 'GL');
gaglab_exp_savetable(fullfile(GL.Runtime.LogPath, [fn '.log']), Log);

if ~isempty(GL.Experiment.Subject)
	R = [];
	E = [];
	for i=1:length(GL.Sessions)
		if length(GL.Sessions{i}.Response)
			[r(1:length(GL.Sessions{i}.Response)).Experiment] = deal(GL.Experiment.Name);
			if ~isempty(GL.Experiment.Parameter)
				[r.Parameter] = deal(GL.Experiment.Parameter);
			end
			[r.Subject] = deal(GL.Experiment.Subject);
			[r.Study] = deal(GL.Experiment.Study);
			[r.Series] = deal(GL.Experiment.Series);
			[r.Date] = deal(timestr);
			[r.Session] = deal(i);
			n = num2cell([1:length(r)]);
			[r.Trial] = deal(n{:});
			[r.Onset] = deal(GL.Sessions{i}.Response.T0);
			f = fieldnames(rmfield(GL.Sessions{i}.Response, {'T0', 'MaxT', 'ValidKeys', 'CorrectKey', 'Key', 'RT', 'Correct'}));
			f = [f; {'Key'; 'RT'; 'Correct'}];
			for j=1:length(f)
				[r.(f{j})] = deal(GL.Sessions{i}.Response.(f{j}));
			end
			R = [R, r];
			clear r
		end
		if ~isempty(GL.Sessions{i}.EyeData.value)
			e = cell2struct(num2cell(GL.Sessions{i}.EyeData.value)', GL.Sessions{i}.EyeData.name);
			[e.Experiment] = deal(GL.Experiment.Name);
			if ~isempty(GL.Experiment.Parameter)
				[e.Parameter] = deal(GL.Experiment.Parameter);
			end
			[e.Subject] = deal(GL.Experiment.Subject);
			[e.Study] = deal(GL.Experiment.Study);
			[e.Series] = deal(GL.Experiment.Series);
			[e.Date] = deal(timestr);
			[e.Session] = deal(i);
			E = [E, e]; %#ok<AGROW>
			clear e
		end
	end
	if ~isempty(R)
		gaglab_exp_savetable(fullfile(GL.Runtime.ResultsPath, [GL.Experiment.Subject '.res']), R);
	end
	if ~isempty(E)
		gaglab_exp_savetable(fullfile(GL.Runtime.ResultsPath, [GL.Experiment.Subject '.eye']), E);
	end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function gaglab_exp_savetable (file, results, fn)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fields = fieldnames(results);
if nargin < 3, fn = fields; end
n = length(fields);

fid = fopen(file, 'r');
existFile = (fid > 0);
if existFile, fclose(fid); end;

fid = fopen(file, 'a');
if fid < 0
	fprintf('Can''t save results!');
	return
end
errorStr = '';
try
	if existFile, fprintf(fid, '\n'); end;

	for i=1:length(fn)
		fprintf(fid, '%s', fn{i});
		if i==n, fprintf(fid, '\n'); else, fprintf(fid, '\t'); end;
	end

	for j=1:length(results)
		for i=1:n
			x = getfield(results(j), fields{i});
			if iscell(x)
				for k=1:prod(size(x))-1
					if ischar(x{k})
						fprintf(fid, '%s\t', x{k});
					else
						fprintf(fid, '%g\t', x{k});
					end
				end
				x = x{end};
			end					
			if ischar(x)
				fprintf(fid, '%s', x);
			else
				fprintf(fid, '%g', x);
			end
			if i==n, fprintf(fid, '\n'); else, fprintf(fid, '\t'); end;
		end
	end
catch
	fclose(fid);
	rethrow(lasterror);
end
fclose(fid);

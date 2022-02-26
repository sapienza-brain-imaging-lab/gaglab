function L = gaglab_exp_showlog (L, cmd)
% GAGLAB_EXP_SHOWLOG	    	Show the log incrementally
%
% L = GAGLAB_EXP_SHOWLOG(L) show the pending logged events on the command line.
% L = GAGLAB_EXP_SHOWLOG(L, 'ENABLE') enables online logging (default).
% L = GAGLAB_EXP_SHOWLOG(L, 'DISABLE'), disable online logging.

if isempty(L)
	L = struct('Event', [], 'Index', 1, 'Enable', 1);
end

if nargin > 1
	switch lower(cmd)
		case 'enable'
			L.Enable = 1;
		case 'disable'
			L.Enable = 0;
	end
	return
end

if L.Enable == 0, return; end

s = '';
while L.Index <= length(L.Event)
	if L.Event(L.Index).Type ~= '!'		% Mettere 'S' per disabilitare le slice
		s = [s, sprintf('%s %7.0f ', L.Event(L.Index).Type, L.Event(L.Index).Time)];
		for i=1:length(L.Event(L.Index).Info)
			s = logonething(s, L.Event(L.Index).Info{i});
		end
		s = [s, sprintf('\n')];
	end
	L.Index = L.Index + 1;
end
fprintf(s);


function str = logonething (s, v)

if iscell(v)
	for i=1:prod(size(v))
		str = sprintf('%s%s\t', s, logonething(v{i}));
	end
elseif ischar(v)
	str = sprintf('%s%s\t', s, v);
elseif prod(size(v)) > 1
	str = sprintf('%s[%s]\t', s, int2str(v));
else
	str = sprintf('%s%s\t', s, int2str(v));
end
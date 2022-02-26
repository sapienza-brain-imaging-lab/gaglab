function [varargout] = gaglab_snd_play (Snd, id, mode)

% gaglab_snd_play (Snd, id, mode)
% play sound id
%  mode = 0   -> play
%  mode = 1   -> stop playing
%  mode = 2   -> check if playing

if Snd.UseSound < 2
	if mode ==2, varargout{1} = 0; end
	return
end

try
	H = Snd.Stimulus(id).Handle;
catch
	H = [];
end
if isempty(H)
	error('You are trying to play/stop/wait for a nonexistent sound stimulus %d', id);
end

switch mode
	case 0
		CogSound('Play', H, Snd.Stimulus(id).Loop);
	case 1
		CogSound('Stop', H);
	case 2
		varargout{1} = CogSound('Playing', H);
end

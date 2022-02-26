function Snd = gaglab_snd_set (Snd, id, property, value)

try
	H = Snd.Stimulus(id).Handle;
catch
	H = [];
end
if isempty(H)
	error('You are trying to access a nonexistent sound stimulus %d', id);
end

switch lower(property)
	case 'volume'
		if value > 0 | value < -10000, error('Invalid sound volume'); end
		Snd.Stimulus(id).Volume = value;
		CogSound('Set', H, 'volume', value);
	case 'loop'
		Snd.Stimulus(id).Loop = value;
end

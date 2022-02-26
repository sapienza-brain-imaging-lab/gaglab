function Stimulus = gaglab_snd_create (Stimulus)

if ~isempty(Stimulus.Handle)
	CogSound('Destroy', Stimulus.Handle);
end

Stimulus.Handle = CogSound('Create', size(Stimulus.Data, 1), 'any', Stimulus.Nbits, Stimulus.FrequencyHz, size(Stimulus.Data, 2));
CogSound('Set', Stimulus.Handle, 'volume', Stimulus.Volume);

% Set buffer
if isa(Stimulus.Data, 'double')
	Stimulus.Data(Stimulus.Data < -1) = -1;
	Stimulus.Data(Stimulus.Data > 1) = 1;
	switch Stimulus.Nbits
		case 8
		   Stimulus.Data = (Stimulus.Data + 1) .* 127.5;
		case 16
		   Stimulus.Data = Stimulus.Data * 32767;
	end
	CogSound('SetWave', Stimulus.Handle, floor(Stimulus.Data)');
else
	CogSound('SetWave', Stimulus.Handle, double(Stimulus.Data)');
end
Stimulus.Data = [];

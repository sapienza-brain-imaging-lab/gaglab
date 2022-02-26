function ConfigSound = gaglab_snd_start (ConfigSound)
% GAGLAB_SND_START	Inizialize sound manager

if ConfigSound.UseSound
	try
		CogSound('Initialise', ConfigSound.Nbits, ConfigSound.FrequencyHz, ConfigSound.Stereo+1);
		for i=1:length(ConfigSound.Stimulus)
 			if ~isempty(ConfigSound.Stimulus(i).Data)
				ConfigSound.Stimulus(i) = gaglab_snd_create(ConfigSound.Stimulus(i));
			end
		end
		ConfigSound.UseSound = 2;
	catch
		disp('Cannot initialize sound output');
		ConfigSound.UseSound = 0;
	end
end

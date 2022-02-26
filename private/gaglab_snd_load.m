function [Sound, varargout] = gaglab_snd_load (Sound, sndfile, doload)

if ~isempty(Sound.File)
	j = find(strcmpi(sndfile, {Sound.File.Name}));
	if ~isempty(j)
		if nargout > 1
			if isempty(Sound.File(j).Data)
				Sound.File(j).Data = gaglab_snd_preparedata(wavread(Sound.File(j).Name), Sound.File(j).Nbits);
			end
			varargout{1} = Sound.File(j).Data;
			varargout{2} = Sound.File(j).FrequencyHz;
			varargout{3} = Sound.File(j).Nbits;
		end
		return
	end
end

try
	if nargin < 3 | doload
		[data, frequency, nbits] = wavread(sndfile);
		data = gaglab_snd_preparedata(data, nbits);
		siz = size(data);
	else
		data = [];
		[siz, frequency, nbits] = wavread(sndfile, 1);
		siz = wavread(sndfile, 'size');
	end
catch
	error('Cannot read sound %s', sndfile);
end

if Sound.UseSound < 2		% Preparing experiment
	if siz(2)==2 & Sound.Stereo == 0, Sound.Stereo = 1; end
	if frequency > Sound.FrequencyHz, Sound.FrequencyHz = frequency; end
	if nbits > Sound.Nbits, Sound.Nbits = nbits; end
end

S.Name = sndfile;
S.Stereo = siz(2)==2;
S.Duration = siz(1) / frequency * 1000;
S.FrequencyHz = frequency;
S.Nbits = nbits;
S.Data = data;

if nargout > 1
	if isempty(S.Data)
		S.Data = gaglab_snd_preparedata(wavread(S.Name), S.Nbits);
	end
	varargout{1} = S.Data;
	varargout{2} = S.FrequencyHz;
	varargout{3} = S.Nbits;
end

Sound.File(end+1) = S;


function data = gaglab_snd_preparedata (data, nbits)

switch nbits
	case 8
		data = uint8(floor((data + 1) .* 127.5));
	case 16
		data = int16(floor(data * 32767));
end   

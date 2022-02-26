function Snd = gaglab_snd_prepare (Snd, id, matrix, frequency, nbits)

% Snd = gaglab_snd_prepare (Snd, id, matrix, frequency, nbits)
%
% Transfers a sound matrix from the matlab workspace to a Cogent sound buffer.  Each column of the matrix is
% a channel waveform (1 column for mono, 2 for stereo).  Each waveform element is in the range -1 to 1.
%
%     volume  - volume of buffer in hundredths of decibels ( 0 to -10000 )


if ischar(matrix)
	[Snd, matrix, frequency, nbits] = gaglab_snd_load(Snd, matrix);
else
	if nargin < 4, frequency = Snd.FrequencyHz; end
	if nargin < 5, nbits = Snd.Nbits; end
	if ~any(size(matrix,2) == [1 2]), error('Invalid sound matrix'); end
	if ~any(frequency == [8000, 11025, 22050, 44100]), error('Invalid sound frequency'); end
	if ~any(nbits == [8 16]), error('Invalid number of bits'); end
end

if Snd.UseSound == 2		% Running experiment

	try
		Snd.Stimulus(id).Handle;
	catch
		error('Sound %d does not exist', id);
	end
	Snd.Stimulus(id).FrequencyHz = frequency;
	Snd.Stimulus(id).Nbits = nbits;
	Snd.Stimulus(id).Data = matrix;
	Snd.Stimulus(id) = gaglab_snd_create(Snd.Stimulus(id));
	
else				% Preparing experiment
	
	if size(matrix,2)==2 & Snd.Stereo == 0, Snd.Stereo = 1; end
	if frequency > Snd.FrequencyHz, Snd.FrequencyHz = frequency; end
	if nbits > Snd.Nbits, Snd.Nbits = bits; end
	Snd.UseSound = 1;
	
	if length(Snd.Stimulus) < id
		Snd.Stimulus(id).Volume = 0;
		Snd.Stimulus(id).Loop = 0;
	end
	Snd.Stimulus(id).FrequencyHz = frequency;
	Snd.Stimulus(id).Nbits = nbits;
	Snd.Stimulus(id).Data = matrix;
end

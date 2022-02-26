function t = senddata (ch, val)
% SENDDATA	Create an object to send data to external devices
%
% T = SENDDATA(CH, VAL) create an object that sends a value to an external
% device. This object can then be used in a PRESENT command to actually
% send the data at specified times.
% CH is a vector of channels over which to send data, and VAL is a sequence
% of data bytes to send.
%
% The actual implementation only supports sending individual bits over the
% parallel port. CH must be a vector of bit numbers (from 0 to 15), and VAL
% must be 1 or 0. With this minimal implementation, you can use SENDDATA
% for example to drive LEDs or similar devices over the parallel port.

if nargin < 1, ch = 0; end
if nargin < 2, val = 0; end
j = find(ch < 0 & ch > 15);
if length(j)
	error('Bit numbers must be in the range 0-15');
end
ch = ch(:)';
if numel(val) == 1
	val = repmat(val, 1, length(ch));
elseif numel(val) ~= length(ch)
	error('Incorrect number of values');
else
	val = val(:)';
end
val = (val ~= 0) .* 2 - 1;

t = struct('type', 'D', 'what', [ch; val]);

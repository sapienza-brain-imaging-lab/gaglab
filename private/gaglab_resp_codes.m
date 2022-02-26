function R = gaglab_resp_codes (R, j, varargin)
% GAGLAB_RESP_CODES		Define response codes
%
% R = GAGLAB_RESP_CODES(R, ID, VARNAME1, VALUE1, VARNAME2, VALUE2, ...)
% define variable names and corresponding values to be saved to the results file
% for the response ID.

if j < 1 | j > length(R)
	error('Invalid response ID');
end

i = 1;
while i <= length(varargin)
	if isstruct(varargin{i})
		fn = fieldnames(varargin{i});
		for k = 1:length(fn)
			R(j).(fn{k}) = varargin{i}.(fn{k});
		end
		i = i + 1;
	elseif ischar(varargin{i})
		if i == length(varargin)
			error('Invalid sequence of variable names / values');
		end
		R(j).(varargin{i}) = varargin{i+1};
		i = i + 2;
	else
		error('Invalid response code');
	end
end

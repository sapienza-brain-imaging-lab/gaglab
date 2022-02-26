function [key, rt] = gaglab_resp_get(R, j)
% GAGLAB_RESP_GET		Get the status of a response
%
% [KEY, RT] = GAGLAB_RESP_GET(R, ID) returns the current status of response ID.
	
if j < 1 | j > length(R)
	error('Invalid response ID');
end
key = R(j).Key;
rt = R(j).RT;

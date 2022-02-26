function R = DefineResponse (varargin)
% DEFINERESPONSE         Define a response
%
% DEFINERESPONSE(T0, MAXRT, CORRECTKEY, VALIDKEYS) informs GagLab that
% the experimental subject is expected to produce a response to an event
% that occurred at time T0. MAXRT is the maximum time (in msec) that the
% system has to wait for a response. VALIDKEYS is a vector including the
% codes of all the valid response keys, while CORRECTKEY is the code of the
% correct response key.
% The system will automatically associate any valid key press in the
% defined time period to this response object and save the key press event
% and its response time to the results file.
%
% DEFINERESPONSE(T0, MAXRT, CORRECTKEY, VALIDKEYS, VAR1, VALUE1, ...)
% additionally defines response codes for this response. See RESPONSECODES
% for more information.
%
% DEFINERESPONSE(T0, MINMAXRT, ...), where MINMAXRT is a vector of two
% items [MINRT, MAXRT], additionally specifies a minimum response time (in
% msec).
%
% R = DEFINERESPONSE(...) returns the response ID, that can be used to query the
% status of the response or to wait for the response to occur (see
% GETRESPONSE, WAITFORRESPONSE).


R = gaglabcmd('DefineResponse', varargin{:});

function T = Present (varargin)
% PRESENT         Present multimodal stimuli at specified times
%
% PRESENT(T, STIM, STIM, ...) presents all the stimuli specified by each
% STIM argument at time T (in msec from the start of the experiment).
%
% PRESENT(COND, COND, ..., STIM, STIM, ...) allows to specify more complex
% conditions as to when the stimuli have to be presented. Conditions must be
% specified as sets of condition objects. See WAITUNTIL for more information
% on how to specify conditions. Any combination of conditions valid for
% WAITUNTIL is also valid for PRESENT.
%
% Each stimulus STIM must be a stimulus object, as created by the
% following function calls:
%       VISUAL(S)        present stimulus S at the center of the screen
%       VISUAL(S, X, Y)  present stimulus S at coordinates X,Y
%       VISUAL           simply flip the screen and show the backbuffer
%       AUDITORY(S)      play sound S
%
% If any VISUAL stimulus is specified, the visual stimuli are soon copied to
% the backbuffer, and then the screen is flipped at presentation time.
% If you want to simply flip the screen, without previously copying any
% prepared stimulus, specify VISUAL with no argument.
% When visual stimuli are presented, by default the backbuffer is cleared
% to the experiment background color after screen flipping. Use
% CLEARONFLIP(0) before calling PRESENT if you do not want to clear the
% backbuffer. See CLEARONFLIP for more information.
%
% T = PRESENT(...) returns presentation time in msec from experiment start.
%
% Examples:
%      Present(time(30000), visual(2,0,5), auditory(3))
%            presents a visual and an auditory stimulus at time 30000
%      Present(response(3), time(30000), visual)
%            waits until the subjects responds to response 3 (but at
%            most until time 30000) and flips the screen

T = gaglabcmd('Present', varargin{:});
gaglabcmd('ShowLog');

function [GL, exittime, exitcond] = gaglab_exp_waitfor (GL, cond, videobug)
% GAGLAB_EXP_WAITFOR		Wait for a set of conditions
%
% [E,T,COND] = GAGLAB_EXP_WAITFOR(E, COND) waits for the complex condition set COND.
% COND is a cell vector of condition sets C. Each condition set C is a
% vector of condition objects. GAGLAB_EXP_WAITFOR returns when *any* of the
% condition sets in COND becomes true. In turn, each condition set C
% becomes true when *all* its component condition objects become true.
%
% Condition objects are created by the following function calls:
%       TIME(T)           to wait until time T
%       RESPONSE(R)       to wait for the subject to respond to
%                         response R, or for response R to time out
%       KEYPRESS(K)       to wait for any of the keys specified by K
%       KEYPRESS('start') to wait for the start key
%       VOLUME(V)         to wait for first slice of volume V
%       VOLUME(V,S)       to wait for Sth slice of volume V
%		ENDSOUND(S)       to wait until sound S has finished playing

if isempty(cond)
	GL = gaglab_exp_update(GL);
	exittime = gaglab_exp_time;
	return
end

for c=1:length(cond)
	[cond{c}.t] = deal(Inf);
	j = find([cond{c}.type] == 'S');
	for j=j
		[i,t] = gaglab_sync_slice2index(GL.Setup.Sync, cond{c}(j).what(1), cond{c}(j).what(2));
		if i==0
			cond{c}(j).type = 'T';
		elseif GL.Sync.UseSync
			cond{c}(j).what = i;
		else
			cond{c}(j).type = 'T';
			cond{c}(j).what = t;
		end
	end
end
exittime = Inf;
if nargin > 2 && videobug
	for c=1:length(cond)
		j = find([cond{c}.type] == 'T');
		for j=j
			cond{c}(j).what = cond{c}(j).what - 1000/GL.Screen.RefreshRate;
		end
	end
end
while isinf(exittime)
	GL = gaglab_exp_update(GL);
	t = gaglab_exp_time;
	for c=1:length(cond)
		for j=1:length(cond{c})
			if isinf(cond{c}(j).t)
				switch cond{c}(j).type
					case 'T'
						if t >= cond{c}(j).what
							cond{c}(j).t = cond{c}(j).what;
						end
					case 'K'
  						[GL, key, rt] = gaglab_exp_getkey(GL, cond{c}(j).what);
						if rt, cond{c}(j).t = rt; end
					case 'R'
						if cond{c}(j).what < 1 || cond{c}(j).what > length(GL.Events.Response)
							error('Invalid response ID');
						end
						if GL.Events.Response(cond{c}(j).what).RT ~= -1
							cond{c}(j).t = GL.Events.Response(cond{c}(j).what).T0 + GL.Events.Response(cond{c}(j).what).RT;
						end
					case 'S'
						if ~isempty(GL.Events.Slice) && GL.Events.Slice(end,1) >= cond{c}(j).what
							k = find(GL.Events.Slice(:,1) == cond{c}(j).what);
							cond{c}(j).t = GL.Events.Slice(k,2);
						end
					case '?'
						if gaglab_snd_play(GL.Sound, cond{c}(j).what, 2) == 0
							cond{c}(j).t = time;
						end
				end
			end
		end
		if all(isfinite([cond{c}.t]))
			exittime = max([cond{c}.t]);
            exitcond = cond{c};
			break;
		end
	end
end

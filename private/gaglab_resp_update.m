function Events = gaglab_resp_update (Events, Response, Sync)
	% GAGLAB_RESP_UPDATE         Read pending responses and stores them into buffers
	%
	% B = GAGLAB_RESP_UPDATE(B, R) read data from the serial ports, the keyboard, and the mouse,
	% depending on the current configuration R, interprets them in terms of
	% key and response events, and stores interpreted data
	% into the appropriate buffer B, together with their timestamps.

	actualtime = gaglab_exp_time;

	% Check special key presses
	k = gaglab_hidinput(Response.Keyboard.HKeyboard);
	j = find(k(:,1) == Response.SpecialKeys(1));
	if ~isempty(j)
		Events.Key = [Events.Key; [repmat(11,length(j),1), k(j,2)]];
		Events.Log = gaglab_exp_log(Events.Log, 'K', Events.Key(end,2), 'Start');
		k(j,:) = [];
	end
	j = find(k(:,1) == Response.SpecialKeys(2));
	if ~isempty(j)
		Events.StopKey = [Events.StopKey; k(j,2)];
		Events.Log = gaglab_exp_log(Events.Log, 'K', Events.StopKey(end), 'Stop');
		k(j,:) = [];
	end

	% Check normal keys

	% Keyboard
	K = gaglab_map_key(k, Response.KeyboardMap);

	% Mouse
	k = gaglab_hidinput(Response.Mouse.HMouse);
	if any(ismember([1 2], k(:,1)))
        try
    		Response.Position = cgmouse;
        end
	end
	K = [K; gaglab_map_key(k, Response.MouseMap)];

	if strcmpi(Response.Device, 'serial')
		k = gaglab_serialinput(Response.Serial.HPort);
		K = [K; gaglab_map_key(k, Response.SerialMap)];
	elseif strcmpi(Response.Device, 'xid')
		k = gaglab_xidinput;
		j = find(k(:,1) == 31);
		if ~isempty(j)
			if Sync.UseSync
				tslice = k(j,2);
				if isempty(Events.Slice)
					sliceidx = 1:length(tslice);
					Events.Slice = [sliceidx(:), tslice(:)];
				else
					sliceidx = Events.Slice(end,1)+(1:length(tslice));
					Events.Slice = [Events.Slice; [sliceidx(:), tslice(:)]];
				end
				[v, s] = gaglab_sync_index2slice(Sync, sliceidx);
				for i=1:length(tslice)
					Events.Log = gaglab_exp_log(Events.Log, 'S', tslice(i), v(i), s(i));
				end
			end
			k(j,:) = [];
		end
		K = [K; gaglab_map_key(k, Response.XIDMap)];
	end

	if ~isempty(K)
		% Interpret key presses as responses
		if ~isempty(Events.Response)
			for i=1:size(K,1)
				j = find([Events.Response.RT] == -1 ...
					& [Events.Response.MinT] < K(i,2) ...
					& [Events.Response.MaxT] > K(i,2));
				for j=j(end:-1:1)
					if isempty(Events.Response(j).ValidKeys) ...
							|| ismember(K(i,1), Events.Response(j).ValidKeys)
						Events.Response(j).Key = K(i,1);
						Events.Response(j).RT = K(i,2) - Events.Response(j).T0;
						Events.Response(j).Correct = any(Events.Response(j).Key == Events.Response(j).CorrectKey);
						Events.Log = gaglab_exp_log(Events.Log, 'R', K(i,2), j, Events.Response(j).RT, Events.Response(j).Key, Events.Response(j).Correct);
						str = {'wrong','correct'};
						fprintf('Response %d: RT = %d msec, key %d (%s)\n', j, Events.Response(j).RT, Events.Response(j).Key, str{Events.Response(j).Correct+1});
						break;
					end
				end
			end
		end

		% Save key presses
		Events.Key = [Events.Key; K];
		for i=1:size(K,1)
			Events.Log = gaglab_exp_log(Events.Log, 'K', K(i,2), K(i,1));
		end
	end

	% Check for response timeout
	if ~isempty(Events.Response)
		j = find([Events.Response.RT] == -1 ...
			& [Events.Response.MaxT] < actualtime);
		if ~isempty(j)
			for i=j
				Events.Log = gaglab_exp_log(Events.Log, 'R', Inf, i, 0, 0, Events.Response(i).CorrectKey);
				fprintf('Response %d: no response\n', i)
			end
			[Events.Response(j).Key] = deal(0);
			[Events.Response(j).RT] = deal(0);
		end
	end
end

function key = gaglab_map_key (key, map)
	% Map key codes to response key numbers
	[ex,idx] = ismember(key(:,1), map);
	key = [idx(ex), key(ex,2)];
end

function ct = gaglab_hidinput (device)
	[t, c, keydown] = CogInput('GetEvents', device);
	if isempty(t)
		ct = zeros(0,2);
	else
		j = find(keydown == 0);
		if ~isempty(j)
			c(j) = -c(j);
		end
		ct = [c(:), gaglab_exp_time(t(:))];
	end
end

function ct = gaglab_serialinput (device)
	[c, t] = CogSerial('GetEvents', device);
	ct = [c(:), gaglab_exp_time(t(:))];
end

function ct = gaglab_xidinput
	[c, t] = gaglab_xid('get');
	ct = [c(:), t(:)];
end

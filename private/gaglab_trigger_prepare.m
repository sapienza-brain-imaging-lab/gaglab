function trigdata = gaglab_trigger_prepare (Trigger, trig, data)

trigdata = [];
if isempty(Trigger), return; end

% Start with actual port value
trigdata = Trigger.data;

% Find channels where to send triggers
trigchan = ismember([0:15], trig);

% Compute data to send
if ~isempty(data)
	
	% If there are duplicate channels, take the last value
	[val,idx] = unique(data(1,:));
	data = data(:,idx);
	
	% Set channels with data=1 to ON
	j = find(data(2,:) == 1);
	if length(j)
		trigdata(data(1,j)+1) = 1;
		% trigdata = bitor(trigdata, sum(2.^(data(1,j))));
	end
	
	% Set channels with data=-1 to OFF
	j = find(data(2,:) == -1);
	if length(j)
		trigdata(data(1,j)+1) = 0;
		% trigdata = bitand(trigdata, bitcmp(sum(2.^(data(1,j))),8));
	end
	
	% If the same channel is defined both for data and for trigger,
	% use it for data
	trigchan(data(1,:)+1) = 0;
end

% Add triggers
j = find(trigchan);
if length(j)
	trigdata(2,:) = trigdata;
	trigdata(1,j) = 1;
	% trigdata = [bitor(trigdata, sum(2.^(j-1))), trigdata];
end

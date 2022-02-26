function synctest (numeroframe)

if nargin < 1, numeroframe = 3; end


config_display(1,3);
start_cogent
t = cggetdata('GPD');
frame = 100000 / t.RefRate100;

t = [];
for i=1:300
	wait(frame * (numeroframe-1) + 2);
	t = [t, cgflip];
end

tv = [];
for i=1:300
	wait(frame * (numeroframe-1) + 2);
	tv = [tv, cgflip('V')];
end

stop_cogent

plot([diff(t); diff(tv)]' *1000 / numeroframe);
figure(gcf);
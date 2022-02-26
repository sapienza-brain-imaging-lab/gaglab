function testscreen

TextFont(0, 'Arial', 0.6);
FixCross(0, 1);
for i=1:50
	DrawEllipse(0, [0 0], [2*i 2*i]);
	DrawText(0, num2str(i), [0 i]);
	DrawText(0, num2str(i), [0 -i]);
	DrawText(0, num2str(i), [i 0]);
	DrawText(0, num2str(i), [-i 0]);
end

StartExperiment

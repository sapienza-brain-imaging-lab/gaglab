function E = gaglab_eye_init (E)
	switch E.Type
		case 'ASL'
		    cgtracker('Open','ASL5000', E.Port, 1, 57600, 20, 20, 200, 200);
		case 'LiveTrack'
			gaglab_livetrack('Init', sprintf('COM%d', E.Port));
		case 'none'
		otherwise
			error('gaglab:eyetracker:type', 'Invalid eyetracker type.');
	end
end

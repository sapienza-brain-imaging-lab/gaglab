function gaglab_eye_shut (E)
	switch E.Type
		case 'ASL'
			cgtracker('Shut');
		case 'LiveTrack'
			gaglab_livetrack('Clear');
		case 'none'
		otherwise
			error('gaglab:eyetracker:type', 'Invalid eyetracker type.');
	end
end

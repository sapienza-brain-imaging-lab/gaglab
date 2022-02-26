function gaglab_eye_start (E)
	switch E.Type
		case 'ASL'
			cgtracker('Start');
		case 'none'
		otherwise
			error('gaglab:eyetracker:type', 'Invalid eyetracker type.');
	end
end

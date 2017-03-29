function data = gaglab_eye_stop (E)
	switch E.Type
		case 'ASL'
			data = cgtracker('stop');
			if ~isequal(data, 0)
				data = [gaglab_exp_time([data.Timestamp]); data.X; data.Y; data.Pupil; data.Status]';
			end
		case 'LiveTrack'
			gaglab_livetrack('Stop');
			data = [];
		case 'none'
			data = [];
		otherwise
			error('gaglab:eyetracker:type', 'Invalid eyetracker type.');
	end
end

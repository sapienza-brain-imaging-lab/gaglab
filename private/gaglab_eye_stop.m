function data = gaglab_eye_stop (E)
	switch E.Type
		case 'ASL'
			data = cgtracker('stop');
			if isequal(data, 0)
				data = struct('Time', {}, 'X', {}, 'Y', {}, 'Pupil', {}, 'Status', {});
			else
				data = struct('Time', num2cell(gaglab_exp_time([data.Timestamp])), ...
					'X', {data.X}, ...
					'Y', {data.Y}, ...
					'Pupil', {data.Pupil}, ...
					'Status', {data.Status});
			end
		case 'none'
			data = [];
		otherwise
			error('gaglab:eyetracker:type', 'Invalid eyetracker type.');
	end
end

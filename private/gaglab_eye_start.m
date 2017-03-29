function data = gaglab_eye_start (E)
	switch E.Type
		case 'ASL'
			cgtracker('Start');
			data.name  = {'Time','X','Y','Pupil','Status'};
			data.value = [];
		case 'LiveTrack'
			numEyes = gaglab_livetrack('Start');
			if numEyes == 2
				data.name  = {'Time','FrameCounter','Trigger','LeftGazeX','LeftGazeY','LeftGazeZ','LeftPupilWidth','LeftPupilHeight','RightGazeX','RightGazeY','RightGazeZ','RightPupilWidth','RightPupilHeight'};
			else
				data.name  = {'Time','FrameCounter','Trigger','GazeX','GazeY','GazeZ','PupilWidth','PupilHeight'};
			end
			data.value = [];
		case 'none'
			data.name  = {};
			data.value = [];
		otherwise
			error('gaglab:eyetracker:type', 'Invalid eyetracker type.');
	end
end

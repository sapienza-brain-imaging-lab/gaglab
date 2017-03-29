function Events = gaglab_eye_update (E)
	switch E.Type
		case 'LiveTrack'
			Events = gaglab_livetrack('Get');
		otherwise
			Events = [];
	end
end
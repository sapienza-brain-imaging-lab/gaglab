function d = gaglab_setup_list (GL)
% GAGLAB_SETUP_LIST	List available setup scripts
%
% C = GAGLAB_SETUP_LIST returns a list of available setup scripts.

d = dir(fullfile(GL.SetupPath, '*.m'));
d = sort({d.name});
for i=1:length(d), d{i}(end-1:end) = []; end
d(find(strcmpi(d, 'default'))) = [];
d = [{'Default'}, d];

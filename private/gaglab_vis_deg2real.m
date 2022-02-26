function pix = gaglab_vis_deg2real (arc, distance)
% GAGLAB_VIS_DEG2REAL   Convert degrees to real units

pix = tan(arc.*pi./180./2).*distance.*2;

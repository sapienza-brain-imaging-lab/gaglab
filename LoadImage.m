function X = LoadImage (fname)
% LOADIMAGE	Load an image into memory
%
% X = LOADIMAGE(FNAME) loads an image file into a matrix X, in a format
% that is ready to be used in DRAWIMAGE. X will be a W by H by 3 matrix
% (where W and H are the image width and height, respectively) holding
% integer elements in the range 0-255.

X = gaglab_vis_loadimage(fname);
X = X.Data;

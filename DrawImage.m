function DrawImage (id, varargin)
% DRAWIMAGE	Draw an image into a stimulus
%
% DRAWIMAGE(ID, FNAME, [CX CY], [W H]) draws the image from file FNAME
% into stimulus ID at coordinates [CX CY]. You can optionally
% specify the size of the image in [W H]. All file names and paths
% are relative to the experiment directory.
% DRAWIMAGE checks whether the specified image has been preloaded using the
% LOADIMAGES function. If so, it uses the copy of the image already in
% memory to speed up image display. Otherwise, it reads the image from the
% file and displays it.
%
% DRAWIMAGE(ID, X, ...) draws the contents of matrix X, that should be a W
% by H by 3 matrix (where W and H are the width and height of the image)
% containing RGB values in the range 0-255.

gaglabcmd('Image', id, varargin{:});

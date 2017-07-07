function as_stitch_WriteTileConfiguration(fname,ColPos,RowPos)
% as_stitch_WriteTileConfiguration(fname,ColPos,RowPos)
% writes the file TileConfiguration_matlab.txt
%
% Example: Create a default Tile Configuration for a mosaic 14x17 with
% images of size 5652x8192:
%
% [ColPos,RowPos]=meshgrid([0:8193:8192*17]',[0:5653:5652*14]');
% as_stitch_WriteTileConfiguration(sct_tools_ls('*.png'),RowPos(:),ColPos(:))

fid = fopen('TileConfiguration_matlab.txt','w');
fprintf(fid,'%s\n%s\n\n%s\n','# Define the number of dimensions we are working on','dim = 2','# Define the image coordinates');

for i=1:length(fname)
fprintf(fid, '%s; ; (%f,%f)\n', fname{i}, ColPos(i), RowPos(i));
end
fclose(fid);
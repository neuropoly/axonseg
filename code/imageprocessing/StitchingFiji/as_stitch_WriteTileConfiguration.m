function as_stitch_WriteTileConfiguration(fname,ColPos,RowPos)
% as_stitch_WriteTileConfiguration(fname,ColPos,RowPos)
% writes the file TileConfiguration_matlab.txt

fid = fopen('TileConfiguration_matlab.txt','w');
fprintf(fid,'%s\n%s\n\n%s\n','# Define the number of dimensions we are working on','dim = 2','# Define the image coordinates');

for i=1:length(fname)
fprintf(fid, '%s; ; (%f,%f)\n', fname{i}, ColPos(i), RowPos(i));
end
fclose(fid);
function PixelSize=as_improc_pixelsize(scale)
if ~exist('scale','var')
    scale=inputdlg('length of the bar in µm');
    scale=str2double(scale{1}); %µm : scale of the bar that appears in your image
end
if ~isnan(scale)
    h=imline;
    PixelSize=scale/length(find(h.createMask));
    h.delete;
else
    error('Please provide a number')
end
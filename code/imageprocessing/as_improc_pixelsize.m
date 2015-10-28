function PixelSize=as_improc_pixelsize(scale)
if ~exist('scale','var')
    scale=inputdlg('length of the bar in µm');
    if ~isempty(scale)
        scale=str2double(scale{1}); %µm : scale of the bar that appears in your image
    end
end
if ~isempty(scale) && ~isnan(scale)
    h=imline;
    PixelSize=scale/length(find(h.createMask));
    h.delete;
else
    warning('Please provide a number')
    PixelSize=0;
end
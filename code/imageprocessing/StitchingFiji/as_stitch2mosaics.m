NL= [16 12];
LEFT = 16*11+1:16*12; % index of right column used to stitch
NR= [16 5];
RIGHT = 1:16; % index of left column used to stitch
FolderLeft = './';
FolderRight = '16x5/';
%% REMOVE OUTLIERS AND LOAD STITCH PORTIONS
cur = pwd;
cd(FolderLeft)
as_stitch_CorrectOutliers('TileConfiguration.registered.txt',NL);
drawnow;
[LEFT_img , fnameL,ColPosL,RowPosL ]= as_StitchfromTileConfig('TileConfiguration_matlab.txt',LEFT);
cd(cur)
cd(FolderRight)
as_stitch_CorrectOutliers('TileConfiguration.registered.txt',NR);
drawnow;
[RIGHT_img, fnameR,ColPosR,RowPosR ] = as_StitchfromTileConfig('TileConfiguration_matlab.txt',RIGHT);

reduced = max(1,round(max([size(LEFT_img) size(RIGHT_img)])/15000));

%% REGISTER USING MANUAL MATLAB REG

[moving_out,fixed_out] = cpselect(RIGHT_img(1:reduced:end,1:reduced:end,:),LEFT_img(1:reduced:end,1:reduced:end,:),'Wait',true);
moving_out = cpcorr(moving_out,fixed_out,RIGHT_img(1:reduced:end,1:reduced:end,:),LEFT_img(1:reduced:end,1:reduced:end,:));
tform = fitgeotrans(moving_out,fixed_out,'NonreflectiveSimilarity');
%tform=invert(tform);

%%
[fname,ColPosRL,RowPosRL] = as_stitch_LoadTileConfiguration('TileConfiguration_matlab.txt');
ColPosRL = ColPosRL - (ColPosR(1) - ColPosL(1));
RowPosRL = RowPosRL - (RowPosR(1) - RowPosL(1));

ColPosRL = ColPosRL+tform.T(3,1)*reduced;
RowPosRL = RowPosRL+tform.T(3,2)*reduced;

%% Move Data
cd(cur)
init=max(LEFT);
for ff=1:length(fname)
    init = init+1;
    sct_unix(['cp ' FolderRight filesep fname{ff} ' ' FolderLeft filesep num2str(init) '.png'])
    fname{ff} = [num2str(init) '.png'];
end

%% append corrected TileConfiguration
cd(FolderLeft)
init=max(LEFT);
[fnameL,ColPosLall,RowPosLall ]= as_stitch_LoadTileConfiguration('TileConfiguration_matlab.txt');
fnameLR = cat(1,fnameL(1:init),fname);
ColPosLR = [ColPosLall(1:init); ColPosRL];
RowPosLR = [RowPosLall(1:init); RowPosRL];
plot(ColPosLR,RowPosLR,'x')
%% write
as_stitch_WriteTileConfiguration(fnameLR,ColPosLR,RowPosLR)
%% CHECK
as_StitchfromTileConfig('TileConfiguration_matlab.txt',LEFT(1):(LEFT(end)+length(RIGHT)));
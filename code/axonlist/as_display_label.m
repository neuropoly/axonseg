function [im_out,AxStats]=as_display_label( axonlist,matrixsize,metric,displaytype, writeimg, verbose)
%[im_out,AxStats]=AS_DISPLAY_LABEL(axonlist, matrixsize, metric);
%[im_out,AxStats]=AS_DISPLAY_LABEL(axonlist, matrixsize, metric, displaytype, writeimg?);
%
% --------------------------------------------------------------------------------
% INPUTS:   
%   metric {'gRatio' | 'axonEquivDiameter' | 'myelinThickness' | 'axon number' | 'random'}
%   Units: gRatio in percents / axonEquivDiameter in  um x 10 /
%   myelinThickness in um x 10
%   displaytype {'axon' | 'myelin'} = 'myelin'
%   writeimg {img,0} = 0
%
% --------------------------------------------------------------------------------
% EXAMPLE:
%   bw_axonseg=as_display_label(axonlist,size(img),'axonEquivDiameter','axon');
%   RGB = ind2rgb8(bw_axonseg,hot(150)); % create rgb mask [0 15um].
%   as_display_LargeImage(RGB+repmat(img,[1 1 3])); % DISPLAY!


% If no displaytype specified in argument, 'myelin' by default
if nargin<4; displaytype='myelin';end
% If writeimg not specified in input, false
if ~exist('writeimg','var') || max(writeimg(:))==0, writeimg=[]; end
if ~exist('verbose','var'), verbose=1; end

% Init. output image
im_out=zeros(matrixsize,'uint8');

% Get number of axons contained in the axon list
Naxon=length(axonlist);

% Copy axonlist
AxStats=axonlist;

if verbose
    tic
    disp('Loop over axons...')
end
for i=Naxon:-1:1
    if ~mod(i,1000), disp(i); end
    if size(axonlist(i).data,1)>5
        index=round(axonlist(i).data);
        %     tmp=index(1)<matrixsize(:,1) | index(:,1)>matrixsize(1);
        %     index(find(tmp))=[];
        %     tmp=index(2)<matrixsize(:,2) | index(:,2)>matrixsize(2);
        %     index(find(tmp))=[];
        
        %   If 'axon' display type is specified, find axon index instead of
        %   myelin index
        if strcmp(displaytype,'axon')
            index=as_myelin2axon(max(1,index));
        end
        
        
        ind=sub2ind(matrixsize,min(matrixsize(1),max(1,index(:,1))),min(matrixsize(2),max(1,index(:,2))));
        
        
        if ~isempty(AxStats(i))
            switch metric
                case 'gRatio'
                    scale = 100; unit = '';
                    im_out(ind)=uint8(AxStats(i).gRatio(1)*scale);
                case 'axonEquivDiameter'
                    scale = 10; unit = 'um';
                    im_out(ind)=uint8(AxStats(i).axonEquivDiameter(1)*scale);
                case 'myelinThickness'
                    scale = 10; unit = 'um';
                    im_out(ind)=uint8(AxStats(i).myelinThickness(1)*scale);
                case 'axon number'
                    scale = 1; unit = '';
                    im_out(ind)=i;
                case 'random'
                    scale = 1; unit = '';
                    im_out(ind)=uint8(rand*254+1);
                otherwise
                    if ~exist('scale','var')
                        values = max([AxStats.(metric)]);
                        scale = 10^floor(log10(255/values));
                        unit = '';
                    end
                    
                    if isempty(AxStats(i).(metric)), AxStats(i).(metric)=0; end
                    im_out(ind)=AxStats(i).(metric)*scale;
            end
            
        end
    end
end

if verbose
    disp('done')
    toc
end

if ~isempty(writeimg)
    writeimg = imadjust(uint8(writeimg));
    im_out_NZ = im_out(im_out>0);
    if ~isempty(im_out_NZ)
        maxval=ceil(prctile(im_out(im_out>0),99));
    else
        maxval = 1; scale =1; unit = '_NoAxonsDetected';
    end
    try
    reducefactor=max(1,ceil(max(size(writeimg))/25000));   
    RGB = ind2rgb8(im_out(1:reducefactor:end,1:reducefactor:end,:),hot(maxval));
    if reducefactor>1 % if quality is reduced
        warning('Image too big. Output image quality will is  reduced.')
    end
    
    catch % ind2rgb8 not installed
        try %  install ind2rgb8
            ind2rgb8dir = fileparts(fileparts(mfilename('fullpath')));
            mex([ind2rgb8dir filesep 'utils' filesep 'ind2rgb8.c'])
            RGB = ind2rgb8(im_out(1:reducefactor:end,1:reducefactor:end,:),hot(maxval));
        catch % reduce quality
            reducefactor=max(1,ceil(max(size(writeimg))/5000));   
            if reducefactor>1 % if quality is reduced
                warning('ind2rgb8 not installed correctly for your OS. Output image quality will is  reduced.')
            end
            RGB = uint8(ind2rgb(im_out(1:reducefactor:end,1:reducefactor:end,:),hot(maxval)));
        end
    end
    I=0.5*RGB+0.5*repmat(writeimg(1:reducefactor:end,1:reducefactor:end),[1 1 3]);
    colorB = hot(size(I,1))*255; colorB = colorB(end:-1:1,:);
    imwrite(cat(2,I,permute(repmat(colorB,[1 1 max(1,round(0.025*size(I,2)))]),[1 3 2])),[metric '_(' displaytype ')_0_' num2str(double(maxval)/scale) unit '.png'])
end
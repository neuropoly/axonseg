function [vol]=imreadBF(datname,zplanes,tframes,channel)
%[vol]=imreadBF(datname,zplanes,tframes,channel)
%
%imports images using the BioFormats package
%you can load multiple z and t slices at once, e.g. zplanes=[1 2 5] loads
%first,second and fifth z-slice in a 3D-Stack 
%
%if loading multiple z slices and tframes, everything is returned in one 3D
%Stack with order ZT. Only one channel can be imported at once
%
%use imreadBFmeta() to get corresponding metadata of the image file
%
%To use the function, you have to download loci_tools.jar here: http://www.loci.wisc.edu/bio-formats/downloads
%make sure to have copied the file loci_tools.jar, in the folder where the
%function is placed (or to your work folder)
%
%
%
% For static loading, you can add the library to MATLAB's class path:
%     1. Type "edit classpath.txt" at the MATLAB prompt.
%     2. Go to the end of the file, and add the path to your JAR file
%        (e.g., C:/Program Files/MATLAB/work/loci_tools.jar).
%     3. Save the file and restart MATLAB.
%
%modified from bfopen.m
%christoph moehl 2011, cmohl@yahoo.com



path = fullfile(fileparts(mfilename('fullpath')), 'loci_tools.jar')
javaaddpath(path);

if exist('lurawaveLicense')
    path = fullfile(fileparts(mfilename('fullpath')), 'lwf_jsdk2.6.jar');
    javaaddpath(path);
    java.lang.System.setProperty('lurawave.license', lurawaveLicense);
end

% check MATLAB version, since typecast function requires MATLAB 7.1+
canTypecast = versionCheck(version, 7, 1);

% check Bio-Formats version, since makeDataArray2D function requires trunk
bioFormatsVersion = char(loci.formats.FormatTools.VERSION);
isBioFormatsTrunk = versionCheck(bioFormatsVersion, 5, 0);

% initialize logging
loci.common.DebugTools.enableLogging('INFO');








r = loci.formats.ChannelFiller();
r = loci.formats.ChannelSeparator(r);
r.setId(datname);

width = r.getSizeX();
height = r.getSizeY();
pixelType = r.getPixelType();

bpp = loci.formats.FormatTools.getBytesPerPixel(pixelType);
fp = loci.formats.FormatTools.isFloatingPoint(pixelType);
little = r.isLittleEndian();
sgn = loci.formats.FormatTools.isSigned(pixelType);



channel=channel-1;
zplane=zplanes-1;
tframe=tframes-1;



vol=zeros(height,width,length(zplane)*length(tframe));
zahler=0;
    for j=1:length(tframe)

        for i=1:length(zplane)
            %['importing file via bioFormats\\ ',num2str(100*zahler/(length(tframe)*length(zplane))),'%']

            index=r.getIndex(zplane(i),channel,tframe(j));
            plane = r.openBytes(index);
            zahler=zahler+1;
            arr = loci.common.DataTools.makeDataArray2D(plane, ...
                        bpp, fp, little, height);
            vol(:,:,zahler)=arr;

        end

    end
    
    
end
    
    
    
function [result] = versionCheck(v, maj, min)

tokens = regexp(v, '[^\d]*(\d+)[^\d]+(\d+).*', 'tokens');
majToken = tokens{1}(1);
minToken = tokens{1}(2);
major = str2num(majToken{1});
minor = str2num(minToken{1});
result = major > maj || (major == maj && minor >= min);
end    
    
            
            
            
            
            
  
            
            

        
   
   
   
   
   
            
            
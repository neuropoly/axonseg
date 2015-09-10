function meta=imreadBFmeta(datname)
%function meta=imreadBFmeta(datname)
%
%returns metadata of specified image file using the BioFormats package
%
%
%OUT:
% meta.width : image width
% meta.height : image height
% meta.zsize : number of z slices
% meta.nframes : number of time frames
% meta.channels : number of channels
% meta.raw : all metadata as java hashtable
% for some image formats, voxelsizes are also returned (psizeX,psizeY,psizeZ,psizeT)
% 
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
r.setId(datname);

    
    
    meta.width = r.getSizeX();
    meta.height = r.getSizeY();
    meta.zsize=r.getSizeZ();
    meta.nframes=r.getSizeT();
    meta.channels=r.getSizeC();
    
    
    
    
    
    metadataList = r.getMetadata();
    %m=r.getMetadataStore();
    
    
    subject = metadataList.get('parameter scale');
    subject
    if ~isempty(subject)% if possible pixelsizes are added (only ics files)
    voxelsizes=str2num(subject);
    
    
    meta.voxelsizes=voxelsizes;
    
    if voxelsizes>1
    meta.psizeX=voxelsizes(2);
    meta.psizeY=voxelsizes(3);
    meta.psizeZ=voxelsizes(4);
    meta.psizeT=voxelsizes(5);
    
    
        
    end
    
   
    
    end 
    
    
    meta.raw=metadataList;%metadata as java hashtable
    
    %readout of java hashtable
    meta.parameterNames=meta.raw.keySet.toArray;
    meta.parameterValues=meta.raw.values.toArray;

    
end
            
            
 function [result] = versionCheck(v, maj, min)

tokens = regexp(v, '[^\d]*(\d+)[^\d]+(\d+).*', 'tokens');
majToken = tokens{1}(1);
minToken = tokens{1}(2);
major = str2num(majToken{1});
minor = str2num(minToken{1});
result = major > maj || (major == maj && minor >= min);
end               
  
            
            
   
        
   
   
   
   
   
            
            
            
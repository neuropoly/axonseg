function MyelSeg=as_tools_segchosenax(AxonSeg,img)
%MyelSeg=as_tools_segchosenax(AxonSeg,img)

imshow(imfuse(img,AxonSeg));

chosenAxon=as_select_obj(AxonSeg);
backBW=AxonSeg & ~chosenAxon;
[MyelSeg] = myelinInitialSegmention(img, chosenAxon, backBW,1,1);

figure(92);
imshow(imfuse(img,MyelSeg));
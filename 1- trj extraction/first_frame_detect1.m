function [first_frame , centroid1,I] = first_frame_detect1(video)
% detects the frame in which the hand appears in the scene

nof=video.NumberOfFrames;
m = video.Height;  % number of rows
n = video.Width; 

f=cell(1,nof);
centroid=cell(1,nof);
f1=read(video,1);

for k=2:nof

    f=read(video,k);
    BG_sub=f-f1;
    BG_sub_gray=rgb2gray(BG_sub);
    I=zeros(m,n);
    for i=round((m/3)*2) : m  % search the down 1/3 of image for first frame  
        for j=1:n            
            if BG_sub_gray(i,j)>80
               I(i,j)=1;
            end 
        end
    end
    
%% removing unwanted objects
I=imfill(I,'holes');
cc=bwconncomp(I);
%C=cc2.PixelIdxList
numPixels = cellfun(@numel,cc.PixelIdxList);

for i=1:cc.NumObjects;
if numPixels(i)<500
    I(cc.PixelIdxList{i}) = 0;
end
end

se = strel('disk',1);
I = imdilate(I,se);
    
%% getting the centroid of the object
cent=regionprops(I,'centroid');
centroid{k}=cat(1,cent.Centroid);
sum_I=sum(I(:));
if sum_I==0
   centroid{k}=[0,0];
end    

if centroid{k}~= [0,0]
    centroid1=centroid{k};
    first_frame=k;
    return      
end
end


function [J,centroid,Ar,Ecc,Ori,nof,f_f,l_f]=Hand_Data(video) 
%  Hand_Data extracts x-y positions plus shape information of the hand in each
% frame
% shape information include: area, eccentricity and orientation

nof=video.NumberOfFrames;
m = video.Height;  % number of rows
n = video.Width;
centroid=cell(1,nof);

Ar=zeros(1,nof);
Ecc=zeros(1,nof);
Ori=zeros(1,nof);

for i=1:nof, centroid{i}=[0,0]; end
for i=1:nof, centroid_r{i}=[0,0]; end
for i=1:nof, centroid_g{i}=[0,0]; end
for i=1:nof, centroid_y{i}=[0,0]; end

%% getting the first frame
f=cell(1,nof);
[first_frame , centroid1,J_f] = first_frame_detect1(video);
f_f=first_frame;

%% getting the features of the first frame

centroid{first_frame}=centroid1;

Ar_f=regionprops(J_f,'Area');
Ar(first_frame)=Ar_f.Area;
Ecc_f=regionprops(J_f,'Eccentricity');
Ecc(first_frame)=Ecc_f.Eccentricity;
Ori_f=regionprops(J_f,'Orientation');
Ori(first_frame)=Ori_f.Orientation;

f{first_frame}=read(video,first_frame);

% mean values:

    r_m_w=201.3484;
    g_m_w=212.9680;  
    b_m_w=201.9680;
%% Hand detection
for k=first_frame+1:nof
    
    f=double(read(video,k));
 
% seed
x=round(centroid{k-1}(2));y=round(centroid{k-1}(1)); %centroid1(2)=raw , centroid1(1)=column 

[seedx,seedy]=seed_find(x,y,f);
            
% region growing
JJ{k} = rgb_regiongrowing(f,floor(seedx),floor(seedy),80);
J{k}=imfill(JJ{k},'holes'); 

%% getting the features of the object

Ar_k=regionprops(J{k},'Area');
Ar(k)=Ar_k.Area;
Ecc_k=regionprops(J{k},'Eccentricity');
Ecc(k)=Ecc_k.Eccentricity;
Ori_k=regionprops(J{k},'Orientation');
Ori(k)=Ori_k.Orientation;

%% getting the centroid of the object
cent{k}=regionprops(J{k},'centroid');
centroid{k}=cat(1,cent{k}.Centroid);

if k>(nof/2) && centroid{k}(2)> 950 % or 1050
    l_f=k;
    %centroid{k}=[0,0]; 
    return
end

end












%%%% Hand Trajectory Extraction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
%%
video=VideoReader('video.avi');
[J,centroid,Area,Ecc,Ori,nof,f_f,l_f]=Hand_Data(video);
% x-y positions of the hand:
    xx1=zeros(1,nof);
    yy1=zeros(1,nof);
for j=1:nof
    xx1(j)=centroid{j}(:,1);
    yy1(j)=centroid{j}(:,2);
end
% A1 contains x-y positions plus shape information of the hand in each
% frame:
    A1=[xx1;yy1;Area;Ecc;Ori];
%     save('trjData.mat',A1)


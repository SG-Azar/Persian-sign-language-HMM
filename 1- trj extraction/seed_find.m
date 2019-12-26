function [seedx,seedy]=seed_find(x,y,f)
% finds seed for region growing
r=f(:,:,1);
g=f(:,:,2);
b=f(:,:,3);
[m,n]=size(r);

    r_m_w=201.3484;
    g_m_w=212.9680;  
    b_m_w=201.9680;
    
startx=x-199;
endx=x+200;

if startx<1 ; startx=1; end
if endx > m ; endx=m; end

starty=y-199;
endy=y+200;

if starty<1 ; starty=1; end
if endy > n ; endy=n; end

I=zeros(m,n);
for i=startx:endx
    for j=starty:endy
        
r_abs(i,j)=abs(r(i,j)-r_m_w);
g_abs(i,j)=abs(g(i,j)-g_m_w);
b_abs(i,j)=abs(b(i,j)-b_m_w);
radius=sqrt(r_abs(i,j)^2+ g_abs(i,j)^2+ b_abs(i,j)^2);
if radius<70
    I(i,j)=1;
end
           
    end
end
cent=regionprops(I,'centroid');
centroid=cat(1,cent.Centroid);
seedx=centroid(2);  % raws
seedy=centroid(1); 

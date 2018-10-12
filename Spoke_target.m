r = 512;                                    %px, radius of star
cycles = 128;                               %number of spokes (triangles)
a = 2*pi/cycles/2;                          %angle subtended by 1 spoke
[x,y] = pol2cart(-a/2:a:2*pi-a,r);          %coordinates of outer corners
x = [ x(1:2:end); x(2:2:end); zeros(1,length(x)/2) ] + r+1;  %(x1;x2;x0)
y = [ y(1:2:end); y(2:2:end); zeros(1,length(y)/2) ] + r+1;  %(y1;y2;y0)
star = poly2mask(x(:),y(:),2*r+1,2*r+1);    %fills triangles (5x5 subsampling)
imshow(star,[]);
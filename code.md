```java
// REDADS THREE IMAGES:
// "original"
// "filtered"
// "kernel"

xsteps=16;
ysteps=20;
one=1; two=256; three=1+256+256*256;


selectWindow("original");
w=getWidth();
h=getHeight();
if((w % xsteps != 0) || (h % ysteps != 0)) exit("image dimensions do not match step");
cx=w/xsteps;
cy=h/ysteps;
O=newArray(w*h);
for(x=0; x<w;x++) for(y=0; y<h; y++) O[x+w*y]=getPixel(x,y);

selectWindow("filtered");
if((w!=getWidth()) || (h!=getHeight())) exit("images mismatch in size");
F=newArray(w*h);
for(x=0; x<w;x++) for(y=0; y<h; y++) F[x+w*y]=getPixel(x,y);

// read the kernel
selectWindow("kernel");
kw=getWidth();
kh=getHeight();
K=newArray(kw*kh);
for(x=0; x<kw;x++) for(y=0; y<kh; y++) K[x+kw*y]=getPixel(x,y);

//cap
for(i=0; i<w*h; i++) {
 if(O[i]<0) O[i]=0; else if (O[i]>255) O[i]=255;
 if(F[i]<0) F[i]=0; else if (F[i]>255) F[i]=255;
}

for(i=0; i<kw*kh; i++) if(O[i]<0) O[i]=0; else if (O[i]>255) O[i]=255;


N=xsteps*ysteps+1;
newImage("anime", "RGB Black", w, h, N);


for(z=0; z<N-1; z++) {
 setSlice(z+1);
 YY=floor(z/xsteps);
 XX=z % xsteps;
 //print("z="+z+" XX="+XX+" YY="+YY);
 for(y=0; y<YY; y++) for(ky=y*cy; ky<y*cy+cy; ky++) for(kx=0; kx<w; kx++) setPixel(kx,ky,F[kx+ky*w]*one);
for(x=XX; x<xsteps; x++) for(ky=YY*cy; ky<YY*cy+cy; ky++) for(kx=x*cx; kx<x*cx+cx; kx++) setPixel(kx,ky,O[kx+ky*w]*two);
 for(y=YY+1; y<ysteps; y++) for(ky=y*cy; ky<y*cy+cy; ky++) for(kx=0; kx<w; kx++) setPixel(kx,ky,O[kx+ky*w]*two);
    //for(x=0; x<w;x++)  setPixel(x,y,O[x*y*w]*one);
    XK=XX*cx+cx/2-kw/2; YK=YY*cy+cy/2-kh/2;
    for(x=0; x<kw; x++) for(y=0; y<kh; y++) setPixel(XK+x, YK+y,K[x+kw*y]*three);
}
setSlice(N);
for(x=0; x<w; x++) for(y=0; y<h; y++) setPixel(x,y,F[x+w*y]*one);
//exit("urk");

```

```java
// bessel constant
J1root1=3.8317;
J1root2=7.0156;

// optical parameters
lambda=530;
NA=1.0;
res=0.61*lambda/NA;


//for(x=0; x<108; x+=0.02) print(""+airy(x));


PSF(3.14*3,256,256,0.5,0);

// a=phase range - first zero around +/1 1.57
// do not eet >5*Pi without increasing the # of iterations
// w,h wihd amd height in pixels
// ox,oy phase offsets from pixel center
function PSF(a,w,h,ox,oy) {
 q=q=J1root1/res;
 w2=w/2;
 h2=h/2;
 newImage("airy","32-bit",w,h,0);
 for(y=0; y<h; y++) for(x=0; x<w; x++) {
  r=sqrt(((x-w2)*a-ox)*((x-w2)*a-ox)+((y-h2)*a-oy)*((y-h2)*a-oy));
  phase=r*q;
  I=airy(phase);
  //setPixel(x,y,I); // original
  setPixel(x,y,sqrt(abs(I))); // square-root enhanced
 }
}

function airy(z) {
  N=60;
  sum=0.0;
  prod=1.0;
  fact=1.0;
  q=(0.25*z*z);
  for(k=0; k<N; k+=2) {
   Teven=prod/(fact*fact*(k+1));
   fact=fact*(k+1);
   prod=prod*q;
   Todd=prod/(fact*fact*(k+2));
   sum+=Teven-Todd;
   fact=fact*(k+2);
   prod=prod*q;
  }
  return sum;
}
```


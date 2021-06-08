clc;
clear all;
close all;
I = imread('House.png');
figure, imshow(I);
% Y = I;
YCbCr = rgb2ycbcr(I);
figure, imshow(YCbCr);
Y = YCbCr(:,:, 1);
figure, imshow(Y);
[h, w] = size(Y);
r = h/8;
c = w/8;
s = 1;
q50 = [16 11 10 16 24 40 51 61;
       12 12 14 19 26 58 60 55;
       14 13 16 24 40 57 69 56;
       14 17 22 29 51 87 80 62;
       18 22 37 56 68 109 103 77;
       24 35 55 64 81 104 113 92;
       49 64 78 87 103 121 120 101;
       72 92 95 98 112 100 103 99];
% COMPRESSION
% Fuzzy logic Compression Algorithm based on DCT
for i=1:r
 e = 1;
 for j=1:c
 block = Y(s:s+7,e:e+7);
 cent = double(block) - 128;
 for m=1:8
 for n=1:8
 if m == 1
 u = 1/sqrt(8);
 else
 u = sqrt(2/8);
 end
 if n == 1
 v = 1/sqrt(8);
 else
 v = sqrt(2/8);
 end
 comp = 0;
 for x=1:8
 for y=1:8
 comp = comp + cent(x, y)*(cos((((2*(x-1))+1)*(m-1)*pi)/16))*(cos((((2*(y-1))+1)*(n-1)*pi)/16));
 end
 end
 F(m, n) = v*u*comp;
 end
 end
 for x=1:8
 for y=1:8
 cq(x, y) = round(F(x, y)/q50(x, y));
 end
 end
 Q(s:s+7,e:e+7) = cq;
 e = e + 8;
 end
 s = s + 8;
end
% DECOMPRESSION
%Fuzzy Logic Decompression using DCT

s = 1;
for i=1:r
 e = 1;
 for j=1:c
 cq = Q(s:s+7,e:e+7);
 for x=1:8
 for y=1:8
 DQ(x, y) = q50(x, y)*cq(x, y); %DQ Description part of Fuzzy logic
 end
 end
 %%huffman coding description (fuzziness of Image block)
 for m=1:8
 for n=1:8
 if m == 1
 u = 1/sqrt(8); %Compression factor
 else
 u = sqrt(2/8);
 end
 if n == 1
 v = 1/sqrt(8);
 else
 v = sqrt(2/8);
 end
 comp = 0;
 for x=1:8
 for y=1:8
 comp = comp + u*v*DQ(x, y)*(cos((((2*(x-1))+1)*(m-1)*pi)/16))*(cos((((2*(y-1))+1)*(n-1)*pi)/16));
 end
 end
 bf(m, n) = round(comp)+128;
 end
 end
 Org(s:s+7,e:e+7) = bf;
 e = e + 8;
 end
 s = s + 8;
 end
imwrite(Y,'F:\hou.jpg');
imwrite(uint8(Org),'F:\chithra.jpg');
return;
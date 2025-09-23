
%=====================================
% [] = pointage1()
%-------------------------------------
% Test de "pointage" de route
%-------------------------------------
% Laman - 06/08/2024 - 03:30
% modif - 25/08/2024 - 23:00
%=====================================

function [] = pointage1()

im0 = imread('plan1.png'); % EN DUR !!!
[h,w] = size(im0);
im1 = double(im0);
im1 = (im1(1:2:end,:,:)+im1(2:2:end,:,:))/2;
im1 = (im1(:,1:2:end,:)+im1(:,2:2:end,:))/2;
im1 = repmat(uint8(im1),[1,1,3]);
im2 = zeros(h/2,h/2,3,'uint8');

fprintf('\n--- Presser "q" pour quitter ---\n\n');

[tx,ty] = meshgrid(1:(h/2),1:(h/2));
[ux,uy] = meshgrid(1:5,1:5);
XY = zeros(1000,2);

q = 0;
p = 0;
r = 0;
tt = 'Test de "pointage" de route (%i pts)';
imshow([im1,im2]); title(sprintf(tt,p));

d = (h/8-1)/2;

while q ~= 113 % valeur numerique du caractere "q"
  [x,y,q] = ginput(1);
  if x<(w/2)
    x0 = min(max(round(2*x),1),w);
    y0 = min(max(round(2*y),1),h);
    vx = min(max(x0-d+tx,1),w);
    vy = min(max(y0-d+ty,1),h);
    v = sub2ind([h,w],vy,vx);
    t = im0;
    im2 = repmat(t(v),[1,1,3]);
    r = 1;
  endif
  if (x>(w/2))&&(r>0)
    r = 0;
    p = p+1;
    x1 = min(max(((x-w/2)-d+x0),1),w);
    y1 = min(max((y-d+y0),1),h);
    XY(p,:) = [x1,y1];
    vx = min(max(round(x1/2-5+ux),1),w/2);
    vy = min(max(round(y1/2-5+uy),1),h/2);
    v = sub2ind([h/2,w/2],vy,vx);
    u = im1(:,:,1); 
    u(v) = uint8(255);
    im1(:,:,1) = u;
    u = im1(:,:,2); 
    u(v) = uint8(0);
    im1(:,:,2) = u;
    u = im1(:,:,3); 
    u(v) = uint8(0);
    im1(:,:,3) = u;
  endif
  imshow([im1,im2]); title(sprintf(tt,p));
endwhile

XY = XY(1:p,:);
dlmwrite('pointage1.txt',XY);

endfunction

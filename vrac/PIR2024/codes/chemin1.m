
%=====================================
% [] = chemin1()
%-------------------------------------
% Interpolation du "pointage"
%-------------------------------------
% Laman - 17/07/2024 - 16:40
% modif - 25/08/2024 - 23:15
%=====================================

function [] = chemin1()

t = load('pointage1.txt');
L = t(2:end,:)-t(1:(end-1),:);
L = sqrt(L(:,1).^2 + L(:,2).^2);

C = [0;L];
C = cumsum(C);
L = floor(C(end));
C = C/C(end);
fprintf('\nChemin = %i points\n\n',L);

x = t(:,1);
y = t(:,2);
t = C; %---------------- echantillonnage !
u = (0:(L-1))/(L-1);
xi = interp1(t,x,u','spline');
yi = interp1(t,y,u','spline');
xj = interp1(t,x,u','linear');
yj = interp1(t,y,u','linear');
xk = interp1(t,x,u','cubic');
yk = interp1(t,y,u','cubic');
dlmwrite('chemin1.txt',[xi,yi,xj,yj,xk,yk]);

t = imread('plan1.png'); % EN DUR !!!
[h,w] = size(t);

%------------------------------- display spline
xi = min(max(round(xi),1),w);
yi = min(max(round(yi),1),h);
u = sub2ind([h,w],yi,xi);
im1 = ones(h,w);
im1(u) = 0;
im1 = imerode(im1,ones(3));
im1 = repmat(im1,[1,1,3]);
im1(:,:,1) = 1-im1(:,:,1);
u = uint8(255*im1);
%------------------------------- display linear
xj = min(max(round(xj),1),w);
yj = min(max(round(yj),1),h);
v = sub2ind([h,w],yj,xj);
im1 = ones(h,w);
im1(v) = 0;
im1 = imerode(im1,ones(3));
im1 = repmat(im1,[1,1,3]);
im1(:,:,2) = 1-im1(:,:,2);
v = uint8(255*im1);
%------------------------------- display cubic
xk = min(max(round(xk),1),w);
yk = min(max(round(yk),1),h);
a = sub2ind([h,w],yk,xk);
im1 = ones(h,w);
im1(a) = 0;
im1 = imerode(im1,ones(3));
im1 = repmat(im1,[1,1,3]);
im1(:,:,3) = 1-im1(:,:,3);
a = uint8(255*im1);

u(:,:,1) = max(t,u(:,:,1));
u(:,:,2) = min(t,u(:,:,2));
u(:,:,3) = min(t,u(:,:,3));
v(:,:,1) = min(t,v(:,:,1));
v(:,:,2) = max(t,v(:,:,2));
v(:,:,3) = min(t,v(:,:,3));
a(:,:,1) = min(t,a(:,:,1));
a(:,:,2) = min(t,a(:,:,2));
a(:,:,3) = max(t,a(:,:,3));

imwrite(min(min(u,v),a),'chemin1.png');

endfunction


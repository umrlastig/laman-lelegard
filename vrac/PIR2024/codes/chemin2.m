
%=====================================
% [] = chemin2()
%-------------------------------------
% Grille elastique sur le "pointage"
% + utiliser INV et jamais PINV !!! 
% + lissage "iteratif"
%-------------------------------------
% Laman - 19/07/2024 - 01:20
% modif - 24/08/2024 - 23:23
%=====================================

function [] = chemin2()

xx = load('chemin1.txt');
yy = xx(:,4);
xx = xx(:,3); % interpolation lineaire

t = imread('plan1.png'); % EN DUR !!!
[h,w] = size(t);

xk = min(max(round(xx),1),w);
yk = min(max(round(yy),1),h);
a = sub2ind([h,w],yk,xk);
v = ones(h,w);
v(a) = 0;
v = imerode(v,ones(7));
v = repmat(v,[1,1,3]);
v(:,:,2) = 1-v(:,:,2);
v = uint8(255*v);
v(:,:,1) = min(t,v(:,:,1));
v(:,:,2) = max(t,v(:,:,2));
v(:,:,3) = min(t,v(:,:,3));
%--------------------------- END display linear

o = load('pointage1.txt');
L = o(2:end,:)-o(1:(end-1),:);
L = sqrt(L(:,1).^2 + L(:,2).^2);

C = [0;L];
C = floor(cumsum(C));
L = C(end);

tic;
fprintf('Matrices grille elastique :');

AX = zeros(length(C),L);
AY = AX;
C = max(C,1);
u = sub2ind([length(C),L],(1:length(C))',C);
AX(u) = 1;
AY(u) = 1;

GE = [eye(L-2),zeros(L-2,2)]+[zeros(L-2,2),eye(L-2)];
GE = [zeros(L-2,1),2*eye(L-2),zeros(L-2,1)]-GE;

CC = GE'*GE;
AAx = AX'*AX;
AAy = AY'*AY;
Bx = AX'*o(:,1);
By = AY'*o(:,2);

fprintf('%i sec\n',round(toc));

if ~exist('chemin2','dir')
  mkdir('chemin2');
endif

%pp = round(100+100*sqrt(2).^[1:10]); % poids
pp = round(630+[1:10]); % poids

for k = 0:9
  pk = pp(k+1);
  M = AAx + (pk^2)*CC;
  xk = inv(M)*Bx;
  M = AAy + (pk^2)*CC;
  yk = inv(M)*By;;
  dk = max(sqrt((xk-xx).^2 + (yk-yy).^2));
  %----------------------------- courbure :
  dX = gradient(xk);
  dY = gradient(yk);
  ddX = gradient(dX);
  ddY = gradient(dY);
  R = sqrt(dX.^2 + dY.^2).^3;
  R = R./(dX.*ddY - dY.*ddX);
  R = floor(min(abs(R)));
  %----------------------------- display GE :
  xk = min(max(round(xk),1),w);
  yk = min(max(round(yk),1),h);
  a = sub2ind([h,w],yk,xk);
  u = ones(h,w);
  u(a) = 0;
  u = imerode(u,ones(7));
  u = repmat(u,[1,1,3]);
  u(:,:,1) = 1-u(:,:,1);
  u = uint8(255*u);
  u(:,:,1) = max(t,u(:,:,1));
  u(:,:,2) = min(t,u(:,:,2));
  u(:,:,3) = min(t,u(:,:,3));
  %imwrite(min(u,v),['chemin2/',num2str(k),'.png']);
  imwrite(min(u,v),['chemin2/1',num2str(k),'.png']);
  fprintf('- %i - P: %i / D: %i / R: %i)\n',k,pp(k+1),dk,R);
endfor

endfunction


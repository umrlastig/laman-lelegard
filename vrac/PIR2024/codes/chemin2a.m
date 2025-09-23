
%=====================================
% [] = chemin2a()
%-------------------------------------
% Grille elastique sur le "pointage"
% + utiliser INV et jamais PINV !!! 
% + lissage "iteratif"
%-------------------------------------
% Laman - 19/07/2024 - 01:20
% modif - 25/08/2024 - 23:23
% modif - 26/08/2024 - 02:13
%=====================================

function [] = chemin2a()

xx = load('chemin1.txt');
yy = xx(:,4);
xx = xx(:,3); % interpolation lineaire

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

N = 12;
pp = round(100+100*sqrt(2).^[1:N]); % poids
MM = zeros(L,2*N);

for k = 1:N
  pk = pp(k);
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
  fprintf('- %i - P: %i / D: %i / R: %i)\n',k,pp(k),dk,R);
  MM(:,(2*k-1):(2*k)) = [xk,yk];
endfor

dlmwrite('chemin2a.txt',MM);

endfunction


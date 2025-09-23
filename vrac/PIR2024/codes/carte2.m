
%=====================================
% [] = carte2()
%-------------------------------------
% Cartes lineraires "chemin2a.txt"
%-------------------------------------
% Laman - 23/07/2024 - 16:00
% modif - 26/08/2024 - 03:30
%=====================================

function [] = carte2()

T0 = imread('plan1.png');
[H,W] = size(T0);

C0 = ones(H,W);
X = load('chemin1.txt');
Y = min(max(round(X(:,4)),1),H);
X = min(max(round(X(:,3)),1),W);
U = sub2ind([H,W],Y,X);
C0(U) = 0;
C0 = imerode(C0,ones(7));
C0 = uint8(255*C0);

L = length(X); % longeur de la bande en pixels
N = 160;  % demi-largeur de la bande en pixels

XY = load('chemin2a.txt');

if ~exist('carte2','dir')
  mkdir('carte2');
endif

TT = uint8(255*ones(904,1412,3));

for k = 1:12
  
  X = XY(:,2*k-1);
  Y = XY(:,2*k);
  
  dX = gradient(X);
  dY = gradient(Y);
  ddX = gradient(dX);
  ddY = gradient(dY);
  R = sqrt(dX.^2 + dY.^2).^3;
  R = R./(dX.*ddY - dY.*ddX);

  dX = dX./sqrt(dX.^2 + dY.^2);
  dY = dY./sqrt(dX.^2 + dY.^2);
  X1 = X + N*dY;
  X2 = X - N*dY;
  Y1 = Y - N*dX;
  Y2 = Y + N*dX;
  XX = X1 + (X2-X1)*(0:(2*N))/(2*N+1);
  YY = Y1 + (Y2-Y1)*(0:(2*N))/(2*N+1);
  
  K0 = ones(H,W);
  X = min(max(round(X),1),W);
  Y = min(max(round(Y),1),H);
  U = sub2ind([H,W],Y,X);
  K0(U) = 0;
  K0 = imerode(K0,ones(7));
  K0 = uint8(255*K0);
  
  T2 = repmat(T0,[1,1,3]);
  T2(:,:,1) = min(T2(:,:,1),C0);
  T2(:,:,2) = min(T2(:,:,2),K0);
  T2(:,:,3) = min(min(T2(:,:,3),C0),K0);

  %---------- DEFORMATION SANS INTERPOLATION :
   
  X1 = min(max(round(XX),1),W);
  Y1 = min(max(round(YY),1),H);
  U1 = sub2ind([H,W],Y1,X1);
  T1 = flip(T0(U1),1);

  C1 = flip(C0(U1),1);

  F1 = max(imread('fleche_60.png'),[],3);
  W1 = floor(W/60);
  H1 = floor(H/60);
  V1 = uint8(255*ones(H,W));
  V1(1:(60*H1),1:(60*W1)) = repmat(F1,[H1,W1]);
  V1 = flip(V1(U1),1);

  VV = max(255*(1-2*(((-N):N)/N).^2),0);
  V1 = max(V1,repmat(uint8(VV),[L,1]));
  RR = repmat(-N:N,[L,1]);
  R1 = double(abs(RR-R)>3);
  RR = (abs(R) - repmat(sign(R),[1,2*N+1]).*RR)>0;
  R1 = min(R1,(double(RR)+1)/2);
  R1 = uint8(255*flip(R1,1));
  R1 = max(R1,repmat(uint8(VV),[L,1]));

  T1 = repmat(T1,[1,1,3]);
  T1(:,:,1) = min(T1(:,:,1),R1);
  T1(:,:,2) = min(T1(:,:,2),V1);
  T1(:,:,3) = min(T1(:,:,3),V1);
  T1(:,:,1) = min(T1(:,:,1),max(C1,64));
  T1(:,:,3) = min(T1(:,:,3),C1);
  
  TT((end-320):end,:,1) = flip(T1(2:end,:,1)',2);
  TT((end-320):end,:,2) = flip(T1(2:end,:,2)',2);
  TT((end-320):end,:,3) = flip(T1(2:end,:,3)',2);
  TT(1:(H-300),46:(45+W),:) = T2(161:(end-140),:,:);
  n = num2str(100+k);
  n = ['carte2/',n(2:end),'.png'];
  imwrite(TT,n);
  
endfor

endfunction


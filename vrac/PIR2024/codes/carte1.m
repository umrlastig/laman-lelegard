
%=====================================
% [] = carte1()
%-------------------------------------
% Carte lineraire "chemin3.txt"
%-------------------------------------
% Laman - 23/07/2024 - 16:00
% modif - 26/08/2024 - 00:16
%=====================================

function [] = carte1()

X = load('chemin3.txt');
Y = X(:,2);
X = X(:,1);
L = length(X); % longeur de la bande en pixels
N = 160;  % demi-largeur de la bande en pixels

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

%---------- VERSION SANS INTERPOLATION :
T1 = imread('plan1.png');
[H,W] = size(T1);

C1 = ones(H,W);
X = load('chemin1.txt');
Y = min(max(round(X(:,4)),1),H);
X = min(max(round(X(:,3)),1),W);
U = sub2ind([H,W],Y,X);
C1(U) = 0;
C1 = imerode(C1,ones(13));
C1 = uint8(255*C1);
 
X1 = min(max(round(XX),1),W);
Y1 = min(max(round(YY),1),H);
U1 = sub2ind([H,W],Y1,X1);
T1 = flip(T1(U1),1);

C1 = flip(C1(U1),1);

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
imwrite(T1,'carte1.png');

endfunction


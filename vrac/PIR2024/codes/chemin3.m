
%=====================================
% [] = chemin3()
%-------------------------------------
% Chemin grille elastique optimale
%-------------------------------------
% Laman - 26/08/2024 - 0:15
%=====================================

function [] = chemin3()

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

pp = 634; % poids OPTIMAL !!!  :-D
M = AAx + (pp^2)*CC;
x = inv(M)*Bx;
M = AAy + (pp^2)*CC;
y = inv(M)*By;
dlmwrite('chemin3.txt',[x,y]);

endfunction


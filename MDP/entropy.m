function [ H ] = entropy( P,D,V,Z)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
renorm = false;
H1= repmat( zeros, [128 128]);

P1 = repmat (zeros, [128 128]);

for rx= 1:128
    for ry=1:128
        P1(rx, ry)= P(1, rx, ry);
    end;
end;

% Calculation of position independent part


D1= repmat (zeros, [255 255]);

for i= 1:255
    for j= 1:255
        
        D1(i,j)= D(1, abs(i - 128)+1, abs(j - 128)+1)*D(1, abs(i - 128)+1, abs(j - 128)+1);
    end;
end;

[m,n] = size(P1);
[mb,nb] = size(D1); 
% output size 
mm = m + mb - 1;
nn = n + nb - 1;

% pad, multiply and transform back
C = ifft2(fft2(P1,mm,nn).* fft2(D1,mm,nn));

% padding constants (for output of size == size(A))
padC_m = ceil((mb-1)./2);
padC_n = ceil((nb-1)./2);

% frequency-domain convolution result
H1 = C(padC_m+1:m+padC_m, padC_n+1:n+padC_n);

H2= repmat( zeros, [128 128]);

P2 = repmat (zeros, [128 128]);

for rx= 1:128
    for ry=1:128
        P2(rx, ry)= P(2, rx, ry);
    end;
end;


D2= repmat (zeros, [255 255]);

for i= 1:255
    for j= 1:255       
        D2(i,j)= D(2, abs(i - 128)+1, abs(j - 128)+1)*D(2, abs(i - 128)+1, abs(j - 128)+1);
    end;
end;

[m,n] = size(P2);
[mb,nb] = size(D2); 
% output size 
mm = m + mb - 1;
nn = n + nb - 1;

% pad, multiply and transform back
C = ifft2(fft2(P2,mm,nn).* fft2(D2,mm,nn));

% padding constants (for output of size == size(A))
padC_m = ceil((mb-1)./2);
padC_n = ceil((nb-1)./2);

% frequency-domain convolution result
H2 = C(padC_m+1:m+padC_m, padC_n+1:n+padC_n);


colormap('winter');
imagesc(H2);
set(gca,'YDir','normal')
colorbar;
drawnow;
pause(2);


colormap('hot');
imagesc(H1);
set(gca,'YDir','normal')
colorbar;
drawnow;
pause(2);

if renorm
%calculation of renormalization coefficients
S1= repmat(1, [128 128]);
R= 10;
for i=1:128
    for j=1:128
        lowboundx= max(1, i-R);
        upboundx= min(128, i+R);
        lowboundy= max(1, j-R);
        upboundy= min(128, j+R);
        for rx = lowboundx:upboundx
            for ry =  lowboundy:upboundy
                N= P1(rx,ry) *D(1, abs(i - rx)+1, abs(j - ry)+1)*D(1, abs(i - rx)+1, abs(j - ry)+1);
                S1(i,j)= S1(i,j) - P1(rx,ry)*N/(1+N);
            end
        end
    end
end

for i=1:128
    for j=1:128
        H1(i,j)= H1(i,j)*S1(i,j);
    end;
end;


%calculation of second renormalization coefficient
S2= repmat(1, [128 128]);
R= 20;
for i=1:128
    for j=1:128
        lowboundx= max(1, i-R);
        upboundx= min(128, i+R);
        lowboundy= max(1, j-R);
        upboundy= min(128, j+R);
        for rx = lowboundx:upboundx
            for ry =  lowboundy:upboundy
                N= P2(rx,ry) *D(2, abs(i - rx)+1, abs(j - ry)+1)*D(2, abs(i - rx)+1, abs(j - ry)+1);
                S2(i,j)= S2(i,j) - P2(rx,ry)*N/(1+N);
            end
        end
    end
end

for i=1:128
    for j=1:128
        H2(i,j)= H2(i,j)*S2(i,j);
    end;
end;
end;
%result
H= H1*Z(1)+H2*Z(2);
end


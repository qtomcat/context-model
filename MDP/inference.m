function [ B ] = inference(P1,P0,P10,P01,I )
% this function update the believe state according to observation vector O
B= repmat (zeros, [2 128 128]);
%following eqn 17 report
%updating child probaility
PI0= repmat(zeros, [128 128]);
for ry = 1:128 
    for rx = 1:128           
        %Applying Bayes rule
        PI0(ry, rx)= P0(ry, rx)*I(2, rx,ry);        
    end
end

PIY = repmat( zeros, [128]);
for ry= 1:128 
    for rx = 1:128
        PIY(ry)= PIY(ry)+PI0(ry,rx);
    end;
end;

PICY= repmat(zeros, [128]);
for ryy=1:128
    for ry= 1:128
        PICY(ryy)= PICY(ryy)+PIY(ry)*P10(ryy, ry);
    end;
end;

PIC = repmat(zeros, [128 128]);
for ry=1:128
    for rx= 1:128
        PIC(ry,rx)= PICY(ry);
    end;
end;
%applying Bayes rule
for rx=1:128
    for ry= 1:128
        PIC(rx,ry)= PIC(rx,ry)*I(1,rx,ry);
    end;
end;
%calculation of denominator
S=0;
for rx = 1:128 
    for ry = 1:128                      
        S= S + PIC(rx, ry);       
    end
end

%normalization of inference
for rx = 1:128 
    for ry = 1:128           
        PIC(rx, ry)= PIC(rx, ry)/S;        
    end
end

for rx = 1:128
    for ry = 1:128
        B(1, rx, ry)= PIC(rx, ry);
    end;
end;


%parent object probability update
PI1= repmat(zeros, [128 128]);
for ry = 1:128 
    for rx = 1:128           
        %Applying Bayes rule
        PI1(ry, rx)= P1(ry, rx)*I(1, rx,ry);        
    end
end

PIY = repmat( zeros, [128]);
for ry= 1:128 
    for rx = 1:128
        PIY(ry)= PIY(ry)+PI1(ry,rx);
    end;
end;

PICY= repmat(zeros, [128]);
for ryy=1:128
    for ry= 1:128
        PICY(ryy)= PICY(ryy)+PIY(ry)*P01(ryy, ry);
    end;
end;

PIC = repmat(zeros, [128 128]);
for ry=1:128
    for rx= 1:128
        PIC(ry,rx)= PICY(ry);
    end;
end;
%applying Bayes rule
for rx=1:128
    for ry= 1:128
        PIC(rx,ry)= PIC(rx,ry)*I(2,rx,ry);
    end;
end;

%calculation of denominator
S=0;
for rx = 1:128 
    for ry = 1:128                      
        S= S + PIC(rx, ry);       
    end
end

%normalization of inference
for rx = 1:128 
    for ry = 1:128           
        PIC(rx, ry)= PIC(rx, ry)/S;        
    end
end

for rx = 1:128
    for ry = 1:128
        B(2, rx, ry)= PIC(rx, ry);
    end;
end;

end
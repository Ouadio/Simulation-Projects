function ydot = doublePend(t,y)
ydot = zeros(4,1);
s = sin(y(1) - y(3));          %Sin(Theta-Phi)
c = cos(y(1) - y(3));         %Cos(Theta-Phi)
ydot(1) = y(2);                %ThetaPoint
ydot(3) = y(4);                %PhiPoint
ydot(2) = (- y(4)*y(4)*s - 2*sin(y(1))- y(2)*y(2)*s*c + sin(y(3))*c)/(2 - c*c);
ydot(4) = (2*y(2)*y(2)*s - 2*sin(y(3))+ y(4)*y(4)*s*c + 2*sin(y(1))*c)/(2 - c*c);
end
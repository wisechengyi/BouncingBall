function Vout = boundV(currPosition, Vin,bounds)
Vout = Vin;

temp = currPosition + Vin;
tempX = temp(1);
tempY= temp(2);


x = bounds(2);
y = bounds(1);

if (tempX > x)
    Vout(1)= -abs(Vout(1));
end

if tempX < 1
    Vout(1) = abs(Vout(1));
end

if tempY > y
    Vout(2) = - abs(Vout(2));
end

if tempY < 1
    Vout(2) = abs(Vout(2));
end




end
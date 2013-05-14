function Vout = getVelocity(gradient,position, Vin)
blocksize= 30;
x = position(1);
y = position(2);


block = gradient( max(x-blocksize,1):min(x+blocksize,end), max(y-blocksize,1):min(y+blocksize,end));
%% ax + by + c = 0
%% [ x y 1] [a; b; c] = 0
[height width] = size(block);
A = zeros(0,3);

for i=1:height
    for j=1:width
        if (block(i,j)~=0)
            A(end+1,:) = [j i 1];
        end
    end
end

if size(A,1)==0
    Vout = Vin;
    return
end

[U, S, V] = svd(A);
co = V(:,end);
normalVector = [co(1) ;co(2)]./norm([co(1); co(2)]);
x = -dot(Vin,normalVector)*normalVector;
a = Vin + x;
Vout = x + a;

end
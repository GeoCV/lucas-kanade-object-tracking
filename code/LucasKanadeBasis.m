function [u, v] = LucasKanadeBasis(It, It1, rect, basis)

u = 0;
v = 0;
tol = 0.01;
[m,n,l] = size(basis);
basis_weights = zeros(1,l);
basis_vectors = zeros(m*n, l);

It = double(It);
It1 = double(It1);

x = rect(1):rect(3);
y = rect(2):rect(4);

rectangle = double(It(y,x));
[dX,dY] = gradient(double(rectangle));

for i=1:size(basis)
    current_basis = basis(i);
    basis_vectors(:,i) = current_basis(:);
end

rectangleGrad = double([dX(:), dY(:), basis_vectors]);
H = rectangleGrad'*rectangleGrad;

for i=1:100
    p = [u,v,basis_weights];
    x = (rect(1)+p(1)):(rect(3)+p(1));
    y = (rect(2)+p(2)):(rect(4)+p(2));
    [X,Y] = meshgrid(x,y);
    warpedIt1 = interp2(It1, X, Y);
    
    deltaIt = double(rectangle - warpedIt1);
    deltaIt = deltaIt(:);

    delta_p = H\(rectangleGrad'*deltaIt);
    u = p(1)+delta_p(1);
    v = p(2)+delta_p(2);
    basis_weights = delta_p(3:12)';
    
	if (norm(delta_p) < tol)
        break
    end
end

end


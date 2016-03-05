function M = LucasKanadeAffine(It, It1)

p = zeros(6,1);
tol = 0.0001;

It = medfilt2(double(It/255.0));
It1 = medfilt2(double(It1/255.0));

[m,n] = size(It);
[X,Y] = meshgrid(1:n,1:m);
[Dx,Dy] = gradient(double(It));
deltaIt = It1-It;

X = X(:);
Y = Y(:);

for i=1:100
    Dx = Dx(:);
    Dy = Dy(:);
    deltaIt = deltaIt(:);

    % constructing linearized system for estimating p and therefore M
    A = [X.*Dx Y.*Dx Dx X.*Dy Y.*Dy Dy];
    
    delta_p = -(A'*A)\(A'*deltaIt);
    
    p = p + delta_p;
    
    M = [1+p(1)	p(2)	p(3); 
        p(4)	1+p(5)	p(6); 
        0	0	1];
    
    if (norm(delta_p) < tol)
        break
    end
    
    warpedIt = medfilt2(warpH(It,M,[size(It1,1) size(It1,2)]));
    deltaIt = It1-warpedIt;
    [Dx, Dy] = gradient(double(warpedIt));
end

end


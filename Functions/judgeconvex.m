function [ mark ] = judgeconvex( vector, r, dr )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

mark = 0;
for j = (r-dr):(r-1)
    if ( vector(j) > vector(j+1) )
        return;
    end
end
for j = (r+1):(r+dr)
    if ( vector(j-1) < vector(j) )
        return;
    end
end
mark = 1;

end


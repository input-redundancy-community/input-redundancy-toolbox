function V_int = ints(V1, V2)
%INTS Compute the intersection of two subspaces.
%
%   Syntax:
%       V_int = geometric.ints(V1, V2)
%
%   Description:
%       V_int = geometric.ints(V1, V2) computes an orthonormal basis for the 
%       intersection of two subspaces given by their respective basis matrices 
%       V1 and V2.
%       Mathematically: span(V1) INTERSECT span(V2)
%
%   Inputs:
%       V1 - Matrix whose columns form a basis of the first subspace (size n-by-p1)
%       V2 - Matrix whose columns form a basis of the second subspace (size n-by-p2)
%
%   Outputs:
%       V_int - Orthonormal basis matrix of the intersection (size n-by-k)
%
%   Example:
%       V1 = [1 0; 0 1; 0 0];
%       V2 = [1 1; 0 1; 0 0];
%       V_int = geometric.ints(V1, V2);
%
%   See also: geometric.invt, null, orth
%
%   Author: JK

    % 1. Input validation
    narginchk(2, 2);

    if isempty(V1) || isempty(V2)
        V_int = [];
        return;
    end

    % 2. Dimension validation
    [n1, ~] = size(V1);
    [n2, ~] = size(V2);

    if n1 ~= n2
        error('geometric:ints:DimensionMismatch', ...
              'Dimension mismatch: V1 and V2 must have the same number of rows (ambient space dimension). Got %d for V1 and %d for V2.', n1, n2);
    end

    % 3. Solve V1 * x1 = V2 * x2 <=> [V1, -V2] * [x1; x2] = 0
    M = [V1, -V2];
    N = null(M);
    
    n_cols_V1 = size(V1, 2);
    
    % Extract coordinates for V1 and reconstruct the intersection subspace
    X1 = N(1:n_cols_V1, :);
    V_int = orth(V1 * X1);
end
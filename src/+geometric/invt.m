function V_inv = invt(B, V)
%INVT Compute the inverse image of a subspace under a matrix.
%
%   Syntax:
%       V_inv = geometric.invt(B, V)
%
%   Description:
%       V_inv = geometric.invt(B, V) computes an orthonormal basis for the 
%       inverse image (or pull-back) of the subspace spanned by the columns 
%       of V under the linear mapping represented by the matrix B.
%       Mathematically: { u | B * u in span(V) }
%
%   Inputs:
%       B - Matrix representing the linear map (size m-by-n)
%       V - Matrix whose columns form a basis of the target subspace (size m-by-p)
%
%   Outputs:
%       V_inv - Orthonormal basis matrix of the inverse image (size n-by-k)
%
%   Example:
%       B = [1 2 0; 0 1 1];
%       V = [1; 0];
%       V_inv = geometric.invt(B, V);
%
%   See also: geometric.ints, null, orth
%
%   Author: JK

    % 1. Input validation
    narginchk(2, 2);

    if isempty(B)
        error('geometric:invt:EmptyMatrix', 'Matrix B cannot be empty.');
    end

    % 2. Dimension validation
    [mB, ~] = size(B);
    
    if ~isempty(V)
        [mV, ~] = size(V);
        if mV ~= mB
            error('geometric:invt:DimensionMismatch', ...
                  'Dimension mismatch: Matrix V must have the same number of rows as B (got %d rows for B and %d rows for V).', mB, mV);
        end
    end

    % 3. Handle empty V case
    if isempty(V)
        V_inv = null(B);
        return;
    end

    % 4. Solve B * u = V * z <=> [B, -V] * [u; z] = 0
    M = [B, -V];
    N = null(M);
    
    n_u = size(B, 2);
    
    % Extract the first n_u rows corresponding to the u space and orthogonalize
    V_inv = orth(N(1:n_u, :));
end
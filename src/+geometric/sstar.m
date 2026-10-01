function S_star = sstar(varargin)
%SSTAR Compute the supremal conditioned invariant subspace (S*).
%
%   Signatures:
%       S_star = sstar(sys)
%       S_star = sstar(A, B, C, D)
%
%   Description:
%       S_star = sstar(...) computes an orthonormal basis for the 
%       supremal conditioned invariant subspace. By duality, S* is computed 
%       using the vstar algorithm applied to the dual system matrices.
%
%   Inputs:
%       - sys : State-space model (sys = ss(A,B,C,D))
%       OR
%       - A, B, C, D : State-space matrices
%
%   Outputs:
%       - S_star : Orthonormal basis matrix of the supremal conditioned invariant subspace
%
%   Author: JK

    % 1. Input parsing
    narginchk(1, 4);

    if nargin == 1
        sys = varargin{1};
        A = sys.A;
        B = sys.B;
        C = sys.C;
        D = sys.D;
    elseif nargin == 4
        A = varargin{1};
        B = varargin{2};
        C = varargin{3};
        D = varargin{4};
    else
        error('geometric:sstar:InvalidInputs', ...
              'You must provide either a single state-space model (sys) or exactly 4 matrices (A, B, C, D).');
    end

    % 2. Dimension validation
    [nA_rows, nA_cols] = size(A);
    [nB_rows, ~] = size(B);
    [pC_rows, nC_cols] = size(C);
    [pD_rows, mD_cols] = size(D);

    if nA_rows ~= nA_cols
        error('geometric:sstar:DimensionMismatch', 'Matrix A must be square.');
    elseif (nB_rows ~= nA_rows) || (nC_cols ~= nA_rows)
        error('geometric:sstar:DimensionMismatch', ...
              'Matrices A, B, and C have incompatible inner dimensions regarding the number of states.');
    elseif (pD_rows ~= pC_rows) || (mD_cols ~= size(B, 2))
        error('geometric:sstar:DimensionMismatch', ...
              'Matrix D dimensions do not match C outputs and B inputs.');
    end

    n = nA_rows;

    % 3. Duality principle for conditioned invariants:
    % S* for (A, B, C, D) is related to V* of the dual system (A', C', B', D')
    V_star_dual = geometric.vstar(A', C', B', D');
    
    % 4. S* is the orthogonal complement of the dual V* subspace
    if isempty(V_star_dual)
        S_star = eye(n);
    else
        S_star = null(V_star_dual');
    end
    
    if ~isempty(S_star)
        S_star = orth(S_star);
    else
        S_star = zeros(n, 0);
    end
end
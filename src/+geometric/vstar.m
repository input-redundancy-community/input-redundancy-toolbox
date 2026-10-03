function [V_star, F] = vstar(varargin)
%VSTAR Compute the weakly unobservable subspace and optionally a friend matrix F.
%
%   Signatures:
%       V_star = vstar(sys)
%       [V_star, F] = vstar(sys)
%       V_star = vstar(A, B, C, D)
%       [V_star, F] = vstar(A, B, C, D)
%
%   Description:
%       Computes V^* following the exact geometric recurrence relation:
%       V_{0} = X (output constraint space)
%       V_{t+1} = X \cap A^{-1}(V_t + Im(B))
%       accounting correctly for direct feedthrough D when defining constraints.
%
%   Inputs:
%       - sys : State-space model (sys = ss(A,B,C,D))
%       OR
%       - A, B, C, D : State-space matrices
%
%   Outputs:
%       - V_star : Orthonormal basis matrix of the weakly unobservable subspace
%       - F      : Friend matrix such that (A + B*F)*V_star subset V_star and (C + D*F)*V_star = 0
%
%   Example:
%       % 1. Define state-space matrices
%       A = [-1  1  0; 
%             0 -2  1; 
%             0  0 -3];
%       B = [0; 
%            1; 
%            0];
%       C = [1  0  0];
%       D = 0;
%       
%       % 2. Compute the weakly unobservable subspace V*
%       V_star = vstar(A, B, C, D);
%       
%       % 3. Compute V* and its friend matrix F using a sys object
%       sys = ss(A, B, C, D);
%       [V_star, F] = vstar(sys);
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
        error('geometric:vstar:InvalidInputs', ...
              'You must provide either a single state-space model (sys) or exactly 4 matrices (A, B, C, D).');
    end

    % 2. Dimension validation
    [nA_rows, nA_cols] = size(A);
    [nB_rows, ~] = size(B);
    [pC_rows, nC_cols] = size(C);
    [pD_rows, mD_cols] = size(D);

    if nA_rows ~= nA_cols
        error('geometric:vstar:DimensionMismatch', 'Matrix A must be square.');
    elseif (nB_rows ~= nA_rows) || (nC_cols ~= nA_rows)
        error('geometric:vstar:DimensionMismatch', ...
              'Matrices A, B, and C have incompatible inner dimensions regarding the number of states.');
    elseif (pD_rows ~= pC_rows) || (mD_cols ~= size(B, 2))
        error('geometric:vstar:DimensionMismatch', ...
              'Matrix D dimensions do not match C outputs and B inputs.');
    end

    n = nA_rows;
    
    % 3. Initial subspace X (depending on C and D constraints)
    if norm(D, 'fro') == 0
        X = null(C);
    else
        X = eye(n); 
    end

    if isempty(X)
        V_star = zeros(n, 0);
        if nargout > 1
            F = zeros(size(B, 2), n);
        end
        return;
    end

    % 4. Initialization of the sequence
    V = X;
    V_prev = zeros(n, size(X, 1) + 1); 
    max_iter = n;
    iter = 0;

    % 5. Recurrence loop: V_{t+1} = X \cap A^{-1}(V_t + Im(B))
    while size(V, 2) ~= size(V_prev, 2) && iter < max_iter
        V_prev = V;
        iter = iter + 1;
        
        V_plus_ImB = orth([V_prev, B]);
        InvImg_A = geometric.invt(A, V_plus_ImB);
        V = geometric.ints(X, InvImg_A);
        
        if isempty(V)
            V = zeros(n, 0);
            break;
        end
    end

    V_star = orth(V);

    % 6. Optional computation of the friend matrix F
    if nargout > 1
        if nargin == 1
            F = geometric.effe(varargin{1}, V_star);
        else
            F = geometric.effe(A, B, C, D, V_star);
        end
    end
end
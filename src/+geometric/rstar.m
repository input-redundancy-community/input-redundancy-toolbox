function [Rs, F] = rstar(varargin)
%RSTAR Compute the largest controllable part of the weakly unobservable subspace R* and optionally one friend matrix F.
%
%   Signatures:
%       Rs = rstar(sys)
%       [Rs, F] = rstar(sys)
%       Rs = rstar(A, B, C, D)
%       [Rs, F] = rstar(A, B, C, D)
%
%   Description:
%       Computes R* by intersecting the weakly unobservable subspace V* 
%       and the supremal conditioned invariant subspace S*.
%
%   Inputs:
%       - sys : State-space model (sys = ss(A,B,C,D))
%       OR
%       - A, B, C, D : State-space matrices
%
%   Outputs:
%       - Rs : Orthonormal basis matrix of the supremal reachability subspace R*
%       - F  : Friend matrix for R*
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
        error('geometric:rstar:InvalidInputs', ...
              'You must provide either a single state-space model (sys) or exactly 4 matrices (A, B, C, D).');
    end

    % 2. Dimension validation
    [nA_rows, nA_cols] = size(A);
    [nB_rows, ~] = size(B);
    [pC_rows, nC_cols] = size(C);
    [pD_rows, mD_cols] = size(D);

    if nA_rows ~= nA_cols
        error('geometric:rstar:DimensionMismatch', 'Matrix A must be square.');
    elseif (nB_rows ~= nA_rows) || (nC_cols ~= nA_rows)
        error('geometric:rstar:DimensionMismatch', ...
              'Matrices A, B, and C have incompatible inner dimensions regarding the number of states.');
    elseif (pD_rows ~= pC_rows) || (mD_cols ~= size(B, 2))
        error('geometric:rstar:DimensionMismatch', ...
              'Matrix D dimensions do not match C outputs and B inputs.');
    end

    % 3. Step 1: Compute V*
    V_star = geometric.vstar(A, B, C, D);
    
    % 4. Step 2: Compute S*
    S_star = geometric.sstar(A, B, C, D);
    
    % 5. Step 3: R* is the intersection of V* and S*
    Rs = geometric.ints(V_star, S_star);
    
    if ~isempty(Rs)
        Rs = orth(Rs);
    else
        Rs = zeros(size(A, 1), 0);
    end

    % 6. Optional computation of the friend matrix F
    if nargout > 1
        if nargin == 1
            F = geometric.effe(varargin{1}, Rs);
        else
            F = geometric.effe(A, B, C, D, Rs);
        end
    end
end
function [sys_decomp, T, U, F] = irDecomp(varargin)
% irDecomp Perform the triangular decomposition of a state-space model.
%
%   Signatures:
%       [sys_decomp, T, U, F] = irDecomp(sys)
%       [sys_decomp, T, U, F] = irDecomp(A, B, C, D)
%
%   Description:
%       This function separates the system into:
%         - External and uncontrollable internal dynamics
%         - Controllable internal dynamics
%       by applying the coordinate changes:
%         x = T * xi
%         u = F * x + U * w
%
%   Outputs:
%       - sys_decomp : The triangular decomposition of the system where
%                      A_bar = T \ (A + B*F) * T
%                      B_bar = T \ B * U
%                      C_bar = (C + D*F) * T
%                      D_bar = D * U
%       - T          : State change of coordinates matrix
%       - U          : Input change of coordinates matrix
%       - F          : Regular feedback matrix (friend of R*)
%
%   Examples:
%       % Example 1: Using a state-space model object
%       A = [0 1; -2 -3]; B = [1 0; 0 1]; C = [1 0]; D = [0 0];
%       sys = ss(A, B, C, D);
%       [sys_decomp, T, U, F] = irDecomp(sys);
%
%       % Example 2: Passing matrices directly
%       [sys_decomp, T, U, F] = irDecomp(A, B, C, D);
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
        error('irDecomp:InvalidInputs', ...
              'You must provide either a single state-space model (sys) or exactly 4 matrices (A, B, C, D).');
    end

    % 2. Dimension validation
    [nA_rows, nA_cols] = size(A);
    [nB_rows, mB_cols] = size(B);
    [pC_rows, nC_cols] = size(C);
    [pD_rows, mD_cols] = size(D);

    if nA_rows ~= nA_cols
        error('irDecomp:DimensionMismatch', 'Matrix A must be square.');
    elseif (nB_rows ~= nA_rows) || (nC_cols ~= nA_rows)
        error('irDecomp:DimensionMismatch', ...
              'Matrices A, B, and C have incompatible inner dimensions regarding the number of states.');
    elseif (pD_rows ~= pC_rows) || (mD_cols ~= mB_cols)
        error('irDecomp:DimensionMismatch', ...
              'Matrix D dimensions do not match C outputs and B inputs.');
    end

    % 3. Compute R* and its friend matrix F in a single clean call
    if nargin == 1
        [T1, F] = geometric.rstar(sys);
    else
        [T1, F] = geometric.rstar(A, B, C, D);
    end

    % 4. State transformation (Triangular decomposition)
    T2 = null(T1');                % Complete the state space basis
    T = [T1, T2];                  % State transformation
    T = T(:, any(T, 1));           % Remove empty columns

    % 5. Input transformation
    U0 = null([B; D]);              % Basis of the kernel of B and D
    U1 = geometric.invt(B, T1);              % Basis of the intersection of B^{-1}R* and ker(D) 
    U2 = null([U0'; U1']);          % Complete the input basis
    U = [U0, U1, U2];              % Input transformation
    U = U(:, any(U, 1));           % Remove empty columns

    % 6. Resulting state space
    % Using left division (T \ ...) instead of inv(T) for numerical stability
    A_F_bar = T \ ((A + B * F) * T);
    B_bar   = T \ (B * U);
    C_F_bar = (C + D * F) * T;
    D_bar   = D * U;

    sys_decomp = ss(A_F_bar, B_bar, C_F_bar, D_bar);
end
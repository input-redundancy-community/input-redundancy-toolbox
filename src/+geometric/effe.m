function F = effe(varargin)
%EFFE Compute a friend matrix F for a subspace V (controlled invariant and output-nulling).
%
%   Signatures:
%       F = effe(sys, V)         % Controlled invariant + output-nulling (using sys)
%       F = effe(A, B, V)        % Pure controlled invariance (no output constraints)
%       F = effe(A, B, C, D, V)  % Controlled invariant + output-nulling explicitly
%
%   Description:
%       Computes a state feedback matrix F such that the closed-loop system 
%       preserves the subspace V (invariance) and nulls the output on V 
%       (output invisibility / output-nulling):
%         1) (A + B*F) * V subset V
%         2) (C + D*F) * V = 0  (if C and D are provided)
%
%   Inputs:
%       - sys, V  OR  - A, B, V  OR  - A, B, C, D, V
%
%   Outputs:
%       - F : State feedback matrix (size m-by-n)
%
%   Example:
%       % 1. Define a simple 2D system
%       A = [1 1; 1 2];
%       B = [0; 1];
%       C = [1 1];
%       D = 1;
%       
%       % 2. Define a subspace V (span of the first basis vector)
%       V = [1; 0];
%       
%       % 3. Pure controlled invariance
%       F_inv = effe(A, B, V);
%       
%       % 4. Controlled invariance + output-nulling
%       F_null = effe(A, B, C, D, V);
%       
%       % 5. Using the sys object signature
%       sys = ss(A, B, C, D);
%       F_sys = effe(sys, V);
%
%   Author: JK

    % 1. Clean input parsing
    has_output_constraints = false;

    if nargin == 2
        % Case: effe(sys, V)
        sys = varargin{1};
        A = sys.A; 
        B = sys.B; 
        C = sys.C; 
        D = sys.D;
        V = varargin{2};
        has_output_constraints = true;
    elseif nargin == 3
        % Case: effe(A, B, V)
        A = varargin{1};
        B = varargin{2};
        V = varargin{3};
        has_output_constraints = false;
    elseif nargin == 5
        % Case: effe(A, B, C, D, V)
        A = varargin{1};
        B = varargin{2};
        C = varargin{3};
        D = varargin{4};
        V = varargin{5};
        has_output_constraints = true;
    else
        error('geometric:effe:InvalidInputs', ...
              'Invalid number of arguments. Use effe(sys, V), effe(A, B, V), or effe(A, B, C, D, V).');
    end

    % 2. Dimension validation
    [nA_rows, nA_cols] = size(A);
    [nB_rows, mB_cols] = size(B);

    if nA_rows ~= nA_cols
        error('geometric:effe:DimensionMismatch', 'Matrix A must be square.');
    elseif nB_rows ~= nA_rows
        error('geometric:effe:DimensionMismatch', ...
              'Matrix B must have the same number of rows as state matrix A.');
    end

    n = nA_rows;
    m = mB_cols;

    if isempty(V)
        F = zeros(m, n);
        return;
    end

    [nV_rows, ~] = size(V);
    if nV_rows ~= n
        error('geometric:effe:DimensionMismatch', ...
              'Subspace basis V must have the same number of rows as state dimension (dim A).');
    end

    if has_output_constraints
        [pC_rows, nC_cols] = size(C);
        [pD_rows, mD_cols] = size(D);
        if nC_cols ~= n || pD_rows ~= pC_rows || mD_cols ~= m
            error('geometric:effe:DimensionMismatch', ...
                  'Dimensions of C and D do not match state space (A, B) dimensions.');
        end
    end

    % 3. Subspace completion: form a full state-space basis [V, V2]
    V2 = null(V');
    if isempty(V2)
        T_full = V;
    else
        T_full = [V, V2];
    end
    
    % 4. Transform system matrices into the new coordinate system
    A_bar = T_full \ (A * T_full);
    B_bar = T_full \ B;
    
    dim_V = size(V, 2);
    
    % Extract cross-coupling blocks for state invariance
    A_21 = A_bar(dim_V + 1:end, 1:dim_V);
    B_2  = B_bar(dim_V + 1:end, :);
    
    % 5. Compute F_sub based on constraints
    if has_output_constraints
        C_bar = C * T_full;
        C_1   = C_bar(:, 1:dim_V);
        
        M_lhs = [B_2; D];
        M_rhs = [-A_21; -C_1];
        
        if rank(M_lhs) > 0
            F_sub = M_lhs \ M_rhs;
        else
            F_sub = zeros(m, dim_V);
        end
    else
        if rank(B_2) > 0
            F_sub = -B_2 \ A_21;
        else
            F_sub = zeros(m, dim_V);
        end
    end
    
    % 6. Reconstruct F in original coordinates
    F = [F_sub, zeros(m, n - dim_V)] / T_full;
    
end
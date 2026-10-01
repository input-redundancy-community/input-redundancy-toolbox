function sys_ann = annihilator(varargin)
%ANNIHILATOR Compute the state-space realization of the dynamic/static input annihilator.
%
%   Signatures:
%       sys_ann = annihilator(sys)
%       sys_ann = annihilator(A, B, C, D)
%
%   Description:
%       Computes the annihilator system using geometric control theory (R* and F).
%       The internal dynamics and matrices are obtained by restriction:
%         - An = (A + B*F)|_{R*}
%         - Bn = B|_{B^{-1}R*}
%         - Cn = F|_{R*}
%         - Dn = I_{B^{-1}R*}
%
%   Inputs:
%       - sys : State-space model (sys = ss(A,B,C,D))
%       OR
%       - A, B, C, D : State-space matrices
%
%   Outputs:
%       - sys_ann : State-space model representing the annihilator
%
%   Author: JK

    % 1. Unified input parsing & normalization to ss object
    narginchk(1, 4);

    if nargin == 1
        sys = varargin{1};
    elseif nargin == 4
        sys = ss(varargin{1}, varargin{2}, varargin{3}, varargin{4});
    else
        error('annihilator:InvalidInputs', ...
              'You must provide either a single state-space model (sys) or exactly 4 matrices (A, B, C, D).');
    end

    A = sys.A; 
    B = sys.B; 
    C = sys.C; 
    D = sys.D;

    % 2. Dimension validation
    [nA_rows, nA_cols] = size(A);
    [nB_rows, mB_cols] = size(B);
    [pC_rows, nC_cols] = size(C);
    [pD_rows, mD_cols] = size(D);

    if nA_rows ~= nA_cols
        error('annihilator:DimensionMismatch', 'Matrix A must be square.');
    elseif (nB_rows ~= nA_rows) || (nC_cols ~= nA_rows)
        error('annihilator:DimensionMismatch', ...
              'Matrices A, B, and C have incompatible inner dimensions regarding the number of states.');
    elseif (pD_rows ~= pC_rows) || (mD_cols ~= mB_cols)
        error('annihilator:DimensionMismatch', ...
              'Matrix D dimensions do not match C outputs and B inputs.');
    end

    % 3. Compute R* and its friend matrix F
    [R, F] = geometric.rstar(sys);

    % 4. Compute the image inverse B^{-1}R*
    B_inv_R = geometric.invt(B, R);

    % 5. Restriction of matrices to R* and B^{-1}R* subspaces
    A_cl = A + B * F;

    An = R \ (A_cl * R);
    Bn = B * B_inv_R;
    Cn = F * R;
    Dn = B_inv_R;

    % 6. Build the annihilator state-space system
    sys_ann = ss(An, Bn, Cn, Dn);
end
function [kind, rho, nu] = ir(varargin)
% ir Determine the input redundancy of a state-space model.
%
%   Signatures: 
%       [kind, rho, nu] = ir(sys)
%       [kind, rho, nu] = ir(A, B, C, D)
%
%   Inputs:
%       - sys : State-space model (sys = ss(A,B,C,D))
%       OR
%       - A, B, C, D : State-space matrices
%
%   Outputs:
%       - kind : The kind of input redundancy of the system:
%                1 = first kind  (rho > 0, nu = 0)
%                2 = second kind (rho = 0, nu > 0)
%                3 = third kind  (rho > 0, nu > 0)
%                [] = not input redundant
%
%       - rho  : Static redundancy degree
%                rho = dim( ker[B; D] )
%
%       - nu   : Dynamic redundancy degree
%                nu = dim( B^{-1}R* INTERSECT ker(D) ) - rho
%                (where R* is the largest controllable invariant subspace)
%
%   Description:
%       When used without output arguments, it prints the classification
%       and degrees of redundancy to the console.
%
%   Example:
%       % 1. Define state-space matrices with a duplicated input
%       A = [-1  1; 
%             0 -2];
%       B = [1  1; 
%            0  0];
%       C = [1  0];
%       D = [0  0];
%       
%       % 2. Check input redundancy using matrices (outputs kind, rho, nu)
%       [kind, rho, nu] = ir(A, B, C, D);
%       
%       % 3. Check input redundancy using a sys object
%       sys = ss(A, B, C, D);
%       ir(sys); % Called without outputs, it prints the result to the console
%
%   Author: JK

    % 1. Input parsing
    narginchk(1, 4); % Ensure between 1 and 4 arguments are provided

    if nargin == 1
        % Case 1: A single state-space object is provided
        sys = varargin{1};
        A = sys.A;
        B = sys.B;
        C = sys.C;
        D = sys.D;
        
        sys_name = inputname(1);
    elseif nargin == 4
        % Case 2: 4 distinct matrices are provided
        A = varargin{1};
        B = varargin{2};
        C = varargin{3};
        D = varargin{4};
        
        sys_name = 'sys';
    else
        error('ir:InvalidInputs', 'You must provide either a single state-space model (sys) or exactly 4 matrices (A, B, C, D).');
    end

    if isempty(sys_name)
        sys_name = 'sys';
    end

    % 2. Dimension validation
    [nA_rows, nA_cols] = size(A);
    [nB_rows, mB_cols] = size(B);
    [pC_rows, nC_cols] = size(C);
    [pD_rows, mD_cols] = size(D);

    if nA_rows ~= nA_cols
        error('ir:DimensionMismatch', 'Matrix A must be square.');
    elseif (nB_rows ~= nA_rows) || (nC_cols ~= nA_rows)
        error('ir:DimensionMismatch', 'Matrices A, B, and C have incompatible inner dimensions regarding the number of states.');
    elseif (pD_rows ~= pC_rows) || (mD_cols ~= mB_cols)
        error('ir:DimensionMismatch', 'Matrix D dimensions (%dx%d) do not match C outputs (%d) and B inputs (%d).', pD_rows, mD_cols, pC_rows, mB_cols);
    end

    % 3. Core subspace computations using native +geometric package
    Rs = geometric.rstar(A, B, C, D);        % Basis of the largest controllable/controlled invariant subspace
    BmRs = geometric.invt(B, Rs);            % Basis of the inverse map of Rs from B
    BmRsKerD = geometric.ints(BmRs, null(D));% Basis of the intersection of BmRs and ker(D)

    % 4. Degrees of input redundancy
    var_rho = size(null([B; D]), 2);
    var_nu = size(BmRsKerD, 2) - var_rho;

    % 5. Input redundancy classification
    if (var_rho > 0 && var_nu == 0)     % first kind
        var_kind = 1;
    elseif (var_rho == 0 && var_nu > 0) % second kind
        var_kind = 2;
    elseif (var_rho > 0 && var_nu > 0)  % third kind
        var_kind = 3;
    else                                % not IR
        var_kind = [];
    end

    % 6. Display information if no output arguments are requested
    if nargout == 0
        if ~isempty(var_kind)
            fprintf('System ''%s'' is input redundant of kind %d, with degrees rho = %d and nu = %d.\n', ...
                    sys_name, var_kind, var_rho, var_nu);
        else
            fprintf('System ''%s'' is not input redundant.\n', sys_name);
        end
        return;
    end

    % 7. Assign outputs
    kind = var_kind;
    rho = var_rho;
    nu = var_nu;
end
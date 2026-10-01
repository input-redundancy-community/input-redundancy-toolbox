function flag = is_ir(varargin)
%IS_IR Check if a state-space system exhibits input redundancy.
%
%   Signatures:
%       flag = is_ir(sys)
%       flag = is_ir(A, B, C, D)
%
%   Description:
%       Determines whether the system is input redundant based on the 
%       redundancy classification `kind` returned by `ir`:
%         - 1 = first kind  (rho > 0, nu = 0)
%         - 2 = second kind (rho = 0, nu > 0)
%         - 3 = third kind  (rho > 0, nu > 0)
%         - [] = not input redundant
%
%   Author: JK

    narginchk(1, 4);

    % Call the core ir function with the provided inputs
    kind = ir(varargin{:});
    
    % Evaluate redundancy status
    flag = ~isempty(kind) && any(kind == [1, 2, 3]);
end
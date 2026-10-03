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
%   Example:
%       % 1. Define state-space matrices with a duplicated input
%       A = [-1  1; 
%             0 -2];
%       B = [1  1; 
%            0  0];
%       C = [1  0];
%       D = [0  0];
%       
%       % 2. Check if the system is input redundant using matrices
%       flag_mat = is_ir(A, B, C, D); % Returns logical 1 (true)
%       
%       % 3. Check using a sys object
%       sys = ss(A, B, C, D);
%       flag_sys = is_ir(sys);
%
%   Author: JK

    narginchk(1, 4);

    % Call the core ir function with the provided inputs
    kind = ir(varargin{:});
    
    % Evaluate redundancy status
    flag = ~isempty(kind) && any(kind == [1, 2, 3]);
end
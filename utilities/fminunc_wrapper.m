function [f,g,h] = fminunc_wrapper(x,F,G,H, errFcn,extraFcn)
% [f,g,h] = fminunc_wrapper( x, F, G, H, errFcn )
% for use with Matlab's "fminunc" and other optimization programs
%   with similar conventions.
%   Here, "x" is the current point, "F" is the objective function,
%   "G" is the gradient of F, and "H" is the Hessian of F.
%
%   "errFcn", if provided, will be evaulated at x and the results
%   stored in the "errHist" variable.
%
% [fHist,errHist] = fminunc_wrapper()
%       will return the function history
%       (and error history as well, if errFcn was provided)
%       and reset the history to zero.
%
% Written by Stephen Becker, 2011, stephen.beckr@gmail.com
% Feb 2015, if F is vector-valued, then the history feature
%   is disabled (could fix it if I need this feature)

persistent errHist fcnHist nCalls
if nargin == 0
    % we are in [fHist,errHist] = fminunc_wrapper(); mode )
   f = fcnHist(1:nCalls);
   g = errHist(1:nCalls);
   fcnHist = [];
   errHist = [];
   nCalls  = 0;
   return;
end
if isempty( fcnHist )
    [errHist,fcnHist] = deal( zeros(100,1) );
end

f = F(x);
if numel(f)==1
    % Record this:
    nCalls = nCalls + 1;
    if length( errHist ) < nCalls
        % allocate more memory
        errHist(end:2*end) = 0;
        fcnHist(end:2*end) = 0;
    end
    fcnHist(nCalls) = f;
    if nargin >= 6 && ~isempty(extraFcn)
        % this is used when we want to record the objective function
        % for something non-smooth, and this routine is used only for the smooth
        % part. So for recording purposes, add in the nonsmooth part
        % But do NOT return it as a function value or it will mess up the
        % optimization algorithm.
        fcnHist(nCalls) = f + extraFcn(x);
    end
end

if nargin > 2 && nargout > 1
    g = G(x);
end
if nargin > 3 && ~isempty(H) && nargout > 2
    h = H(x);
end

% and if error is requested...
if nargin >= 5 && ~isempty( errFcn)
    if length( errHist ) < nCalls
        % allocate more memory
        errHist(end:2*end) = 0;
    end
    errHist(nCalls) = errFcn(x);
end

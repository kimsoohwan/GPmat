function [g1, g2] = ggwhiteXggwhiteKernGradient(ggwhiteKern1, ggwhiteKern2, ...
    x, x2, covGrad)

% GGWHITEXGGWHITEKERNGRADIENT Compute a cross gradient between two GG WHITE kernels.
% FORMAT
% DESC computes cross gradient of parameters of a cross kernel between two
%	gg white kernels for the multiple output kernel.
% RETURN g1 : gradient of the parameters of the first kernel, for ordering
%	   see ggwhiteKernExtractParam.
% RETURN g2 : gradient of the parameters of the second kernel, for ordering
%	   see ggwhiteKernExtractParam.
% ARG ggwhiteKern1 : the kernel structure associated with the first GG white
%	   kernel.
% ARG ggwhiteKern2 : the kernel structure associated with the second GG white
%	   kernel.
% ARG x : inputs for which kernel is to be computed.
% ARG covgrad : gradient of the objective function with respect to the
%	   elements of the cross kernel matrix.
%
% FORMAT
% DESC computes cross kernel terms between two GG WHITE kernels for the multiple
%	output kernel.
% RETURN g1 : gradient of the parameters of the first kernel, for ordering
%	   see ggwhiteKernExtractParam.
% RETURN g2 : gradient of the parameters of the second kernel, for ordering
%	   see ggwhiteKernExtractParam.
% ARG ggwhiteKern1 : the kernel structure associated with the first GG WHITE
%	   kernel.
% ARG ggwhiteKern2 : the kernel structure associated with the second GG WHITE
%	   kernel.
% ARG x : row inputs for which kernel is to be computed.
% ARG x2 : column inputs for which kernel is to be computed.
% ARG covgrad : gradient of the objective function with respect to the
%	   elements of the cross kernel matrix.
%
% SEEALSO : multiKernParamInit, multiKernCompute, ggwhiteKernParamInit,
% ggwhiteKernExtractParam
%
% COPYRIGHT : Mauricio A. Alvarez and Neil D. Lawrence, 2008
  
% KERN
if nargin < 5
    covGrad = x2;
    x2 = x;
end
[K, Pinv, Lqrinv, Lsrinv] = ggwhiteXggwhiteKernCompute(ggwhiteKern1, ggwhiteKern2, x, x2);
P = 1./Pinv;
matGradLqr = zeros(ggwhiteKern1.inputDimension,1);
matGradLsr = zeros(ggwhiteKern1.inputDimension,1);

for i=1:ggwhiteKern1.inputDimension
    X = repmat(x(:,i),1, size(x2,1));
    X2 = repmat(x2(:,i)',size(x,1),1);
    X_X2 = (X - X2).*(X - X2);    
    matGradLqr(i) = sum(sum(0.5*covGrad.*K.*...
        (Lqrinv(i)*P(i)*Lqrinv(i) - Lqrinv(i)*P(i)*X_X2*P(i)*Lqrinv(i))));
    matGradLsr(i) = sum(sum(0.5*covGrad.*K.*...
        (Lsrinv(i)*P(i)*Lsrinv(i) - Lsrinv(i)*P(i)*X_X2*P(i)*Lsrinv(i))));
end

grad_sigma2Noise = sum(sum(covGrad.*K))/ggwhiteKern1.sigma2Noise;
grad_variance1 = sum(sum(covGrad.*K))/ggwhiteKern1.variance;
grad_variance2 = sum(sum(covGrad.*K))/ggwhiteKern2.variance;
    

% only pass the gradient with respect to the inverse width to one
% of the gradient vectors ... otherwise it is counted twice.
g1 = [matGradLqr(:)' grad_sigma2Noise grad_variance1];
g2 = [matGradLsr(:)' 0 grad_variance2];



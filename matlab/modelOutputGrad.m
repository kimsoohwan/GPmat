function g = modelOutputGrad(model, X)

% MODELOUTPUTGRAD Compute derivatives with respect to params of model outputs.

% MLTOOLS

fhandle = str2func([model.type 'OutputGrad']);
g = fhandle(model, X);
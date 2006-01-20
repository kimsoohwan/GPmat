function Y = modelOut(model, X)

% MODELOUT Give the output of a model for given X.

% MLTOOLS

fhandle = str2func([model.type 'Out']);
Y = fhandle(model, X);
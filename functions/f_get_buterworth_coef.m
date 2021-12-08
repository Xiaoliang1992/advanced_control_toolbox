function coef = f_get_buterworth_coef(Np, fc)
if Np > 8
    error('Np should be within [1, 8]')
end
switch Np
    case 0
        coef = 1.0;
    case 1
        coef = [1.0     1.0];
    case 2
        coef = [1.0   1.414213562373095   1.0];
    case 3
        coef = [1.0   2.0   2.0   1.0];
    case 4
        coef = [1.0   2.613125929752753   3.414213562373095   2.613125929752753   1.0];
    case 5
        coef = [1.0   3.236067977499789   5.236067977499789   5.236067977499789   3.236067977499789   1.0];
    case 6
        coef = [1.0   3.863703305156273   7.464101615137753   9.141620172685640   7.464101615137753   3.863703305156273   1.0];
    case 7
        coef = [1.0   4.493959207434933  10.097834679044610  14.591793886479543  14.591793886479543  10.097834679044610   4.493959207434933   1.0];
    case 8
        coef = [1.0   5.125830895483012  13.137071184544089  21.846150969207624  25.688355931461274  21.846150969207628  13.137071184544089   5.125830895483013   1.0];
end

for i = 1:Np
    coef(i) = coef(i) / (2*pi*fc)^(Np + 1 - i);
end
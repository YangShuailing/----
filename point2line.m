function [dis]=point2line(x,y,a,b,c)

dis=(a*x+b*y+c)/sqrt(a*a+b*b);

return
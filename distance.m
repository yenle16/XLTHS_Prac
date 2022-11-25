function [sum] = distance(VectorA,VectorB)
    sum=0;
    for i=1:length(VectorA)
        sum = sum + (VectorB(i)-VectorA(i))*(VectorB(i)-VectorA(i));
    end
    d = sqrt(sum);
end
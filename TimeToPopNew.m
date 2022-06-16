function Result = TimeToPopNew(initPop, goalPop)
coefGrowth = 0.01 + (0.05 - 0.01)*rand(1,5); %gives 5 random coef
Result = log(goalPop/initPop)./coefGrowth; 
end
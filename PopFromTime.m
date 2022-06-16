function Result = PopFromTime(initPop, time, coefGrowth)
Result = initPop * exp(coefGrowth*time);
end
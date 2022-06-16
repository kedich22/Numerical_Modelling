function popultation = PopAtTlog(time, initPop, gr, cap)
popultation = cap*initPop./(initPop+(cap-initPop)...
    .*exp(-gr.*time));
end
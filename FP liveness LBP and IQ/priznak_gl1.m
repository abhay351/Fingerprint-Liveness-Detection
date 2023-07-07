

function GL1 = priznak_gl1(otisk, maska)

    [counts, ~] = imhist(otisk(maska == 1));

    GL1 = sum(counts(150:253)) / sum(counts(1:149));

end
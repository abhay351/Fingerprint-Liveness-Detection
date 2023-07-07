
function GL2 = priznak_gl2(otisk, maska)

    [counts, ~] = imhist(otisk(maska == 1));

    GL2 = sum(counts(246:256)) / sum(counts(1:245));

end
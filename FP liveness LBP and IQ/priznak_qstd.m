

function Q_STD = priznak_qstd(maska, otisk)

    Q_STD = std2(otisk(maska == 1));

end
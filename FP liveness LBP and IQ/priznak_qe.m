

function [Q_E] = priznak_qe(otisk)
    
    n = 20;
    T = 15;
    t = 0:T - 1;

    [M, N] = size(otisk);
    a_ind = floor(M/2);
    b_ind = floor(N/2);

    OBRAZ = fft2(otisk);
    OBRAZ = fftshift(OBRAZ);
    vykon_spektrum = (abs(OBRAZ)) .^ 2;
    Et = zeros(1,T-1);
    Rt = pp_filtry(n, T, t, M, N, a_ind, b_ind);
    for i = 1:T-1
        Et(i) = sum(sum(Rt{i} .* vykon_spektrum));
    end

    Pt = Et ./ sum(Et);
    E =  - sum(Pt .* log10(Pt));
    Q_E = log10(T) - E;

end


function Rt = pp_filtry(n, T, t, M, N, a_ind, b_ind)

    H = cell(1, T);
    Rt = cell(1, T-1);
    
    for i = 1:T
        m = 0.06 + t(i) * ((0.5 - 0.06) / T);
        for k = 1:M
            for l = 1:N
                H{i}(k,l) = 1 / (1 + (1 / m ^ (2 * n)) * (((k - a_ind) / M) ^ 2 ...
                + ((l - b_ind) / N) ^ 2) ^ n);
            end
        end
    end

    for i = 1:T - 1
        Rt{i} = H{i+1} - H{i};
    end
end

function [sym_list, probs_list] = Probs(keyword)
    sym_list = unique(keyword);
    counts = hist(keyword(:), sym_list(:));
    probs_list = double(counts) ./ sum(counts);
end



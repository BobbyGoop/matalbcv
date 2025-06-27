function code = HE(msg, syms, probs)
    dict = huffmandict(syms, probs);
    code = huffmanenco(msg, dict);
    disp(dict)
    fprintf('%.0f', code)
    fprintf('\n\nLength: %.0f\n\n', length(code))
end
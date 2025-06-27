import json

def decode_message(codes, bin_str):
    list_codes = [c[1] for c in codes.keys()]
    
    reverted_dict = dict.fromkeys(list_codes)
    for key, value in codes.items():
        reverted_dict[value[1]] = key
    
    # print(code_table)
    # print(reverted_dict)
    
    tmp = ""
    res = ""    
    for b in bin_str:
        tmp += b
        if tmp not in codes:
            continue
        else:

            print(tmp, codes[tmp])
            res += codes[tmp] + " "
            tmp = ""
    return res


if __name__ == "__main__":

    with open ("lumAC.json", 'r') as f:
        store = json.load(f)

    print(store)

    DC = "001 11101111 "
    input_str = "1111001010101111100110000111110010001011101001100101110001111010010110101111111010011011011101110111010101111110011001000"

    # encoded = encode_message(input_str)
    # print(f"Исходное сообщение: {input_str}")
    # print(f"Закодированное: {encoded}")
    decoded = decode_message(store, input_str)
    print(f"Декодированное: {decoded.split()}")
    print(f"Декодированы: {len(decoded.split())}")
    # print(f"Вес кода: {len(encoded)} бит")
    # print(f"Вес исходного: {len(input_str) * 8} бит")
    # print(f"Коэффициент: {(len(input_str) * 8) / len(encoded)}")
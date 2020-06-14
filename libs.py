
def convert_to_dict(keys, value):
    return dict(zip(keys, value))

def get_digit_nubmer_in_string(string):
    digit = [int(i) for i in string.split() if i.isdigit()]
    digitNum = str(digit)
    s = digitNum.replace('[', '')
    g = s.replace(']', '')
    return g

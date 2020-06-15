import re


def convert_to_dict(keys, value):
    return dict(zip(keys, value))


def get_digit_number_in_string(string):
    digit = [int(i) for i in string.split() if i.isdigit()]
    digit_num = str(digit)
    s = digit_num.replace('[', '')
    g = s.replace(']', '')
    return g


def extract_number(string):
    return (re.findall('\d+', string))[0]


def get_variable_type(variable):
    v = type(variable)
    string = (str(v).split('\''))
    t = string[1]
    return t

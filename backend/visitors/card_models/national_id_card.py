import pytesseract                                   
from PIL import Image 


class NationalIdCard:
    def __init__(self):
        pass

    def parse(self, text):
        try:
            parsed_array = []
            array = text.split("\n")
            for line in array:
                if "<<<" in line:
                    parsed_array.append(line)
            if len(parsed_array) != 2:
                raise Exception("Given image does not match National Card id patterns")
            else:
                if not "BEN" in parsed_array[0]:
                    raise Exception("Error while processing image make sure you have 'C<BEN*****' in your image or try another card")
                else:
                    pos = parsed_array[0].rfind("BEN")
                    str = parsed_array[0][(pos + len("BEN")):]
                    split = str.split("<")
                    while("" in split):
                        split.remove("")
                    last_name = split[0]
                    first_names = ""
                    i = 1
                    while(i < len(split)):
                        if (i + 1 == len(split)):
                            first_names += split[i]
                        else:
                            first_names += split[i] + " "
                        i += 1
                    return {
                        'last_name': last_name,
                        'first_names': first_names,
                    }
        except:
            print("something went wrong")
            return None
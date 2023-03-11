import pytesseract, random                              
from PIL import Image 
from visitors.card_models.national_id_card import NationalIdCard
from visitors.models import Visitor


class CardModelDetector:
    def __init__(self, langage):
        self._parser = None
        self._text = ""
        self._langage = langage

    def detect_card_model(self, imagepath):
        
        try:
            image = Image.open(imagepath)
            print('good')
            text = pytesseract.image_to_string(image, lang=self._langage)
            print(text)
            self._text = text
            if ("<<<") in text and "NATIONAL" in text:
                print("Found")
                self._parser = NationalIdCard()
            else:
                print("Not found")
                raise Exception("Undefined Card id patterns")
        except:
            print("Could not detect card model")
            return

    def parse(self):
        if self._parser:
            return self._parser.parse(self._text)
        else:
            return None

    def generate_username(self, name):
        username = ''.join(name).lower()
        if not Visitor.objects.filter(username=username).exists():
            return username
        else:
            random_username = username + str(random.randint(1000, 99999))
            return self.generate_username(random_username)


    def validate(self):
        visitor = self.parse()
        if not visitor:
            return None
        else:
            last_name = visitor.get('last_name')
            first_names = visitor.get('first_names')
            print(f"Visitor: {last_name}  {first_names}")
            if not last_name or last_name == "":
                return None
            if not first_names or first_names == "":
                return None
            suggested_username = last_name + first_names
            #username = self.generate_username(suggested_username)
            valid_data = {
                'last_name': last_name,
                'first_names': first_names,
                'username': suggested_username,
            }
            return valid_data
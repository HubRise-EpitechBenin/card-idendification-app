from django.db import models
from django.conf import settings
from phonenumber_field.modelfields import PhoneNumberField
from django.contrib.auth.models import BaseUserManager
import os


def image_dir_path(instance, filename):
    base_dir = "visitors_cards"
    visitor = instance.username
    return os.path.join(base_dir, visitor, filename)


class VisitorManager(BaseUserManager):
    def create_visitor(self, card_image, last_name, first_names, username, email=None, phone_number=None, sex=None):
        if last_name is None:
            raise TypeError('Visitors always should have a last_name')
        if first_names is None:
            raise TypeError('Visitors always should have first_names')
        if username is None:
            raise TypeError('Visitors always should have an username')
        if card_image is None:
            raise TypeError('Visitors always should have a card_image')
        visitor = self.model(
            last_name=last_name, 
            first_names=first_names, 
            username=username, 
            card_image=card_image, 
            email=email, 
            phone_number=phone_number, 
            sex=sex
        )
        print(visitor)
        print("saving")
        visitor.save()
        return visitor


class Visitor(models.Model):
    last_name = models.CharField(max_length=128, blank=False)
    first_names = models.CharField(max_length=555, blank=False)
    username = models.CharField(max_length=128, blank=False, unique=True)
    card_image = models.CharField(max_length=555, blank=False, null=False, unique=True)
    email = models.EmailField(max_length=128, blank=True, null=True, default=settings.DEFAULT_EMAIL)
    phone_number = PhoneNumberField(blank=True, null=True, unique=True)
    sex = models.CharField(max_length=15, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)


    USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = ['last_name', 'first_names', 'card_image']

    objects = VisitorManager()

    def __str__(self) -> str:
        return f"{self.username}"

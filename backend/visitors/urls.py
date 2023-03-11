from django.urls import path
from visitors.views import (
    RegistrationView,
)


urlpatterns = [
    path('register/', RegistrationView.as_view(), name="register_visitor"),
]

from django.urls import path
from visitors.views import (
    VisitorList,
    VisitorDetail
)


urlpatterns = [
    path('', VisitorList.as_view(), name="visitors"),
    path('<str:username>', VisitorDetail.as_view(), name="visitor_detail"),
]

from django.urls import path
from visitors.views import (
    VisitList,
    VisitDetail
)


urlpatterns = [
    path('', VisitList.as_view(), name="visits"),
    path('<int:id>', VisitDetail.as_view(), name="visit_detail"),
]

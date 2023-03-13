from django.urls import path
from visitors.views import (
    ApiScanView,
)


urlpatterns = [
    path('', ApiScanView.as_view(), name="scan_visitor_card"),
]

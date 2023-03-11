from django.contrib import admin
from django.urls import path, include
from rest_framework import permissions
from drf_yasg.views import get_schema_view
from drf_yasg import openapi
from django.conf.urls.static import static
from django.conf import settings


schema_view = get_schema_view(
    openapi.Info(
        title="Hub Reception System API",
        default_version='v0.5',
        description="Welcome to Hub Reception System",
        contact=openapi.Contact(email=""),
        license=openapi.License(name="DEV License"),
    ),
    public=True,
    permission_classes=[permissions.AllowAny],
)

urlpatterns = [
    path('', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
    path('about.json/', schema_view.without_ui(cache_timeout=0), name='schema-swagger-ui'),
    path('admin/', admin.site.urls),
    path('api/visitors/', include('visitors.urls')),
    path('redoc/', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc'),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

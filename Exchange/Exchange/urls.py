from django.contrib import admin
from django.urls import path, include


urlpatterns = [
    path("admin/", admin.site.urls),
    path("", include('dashboard.urls')),
    path("", include('users.urls')),
    path("", include('trading.urls')),
    path('', include('django_prometheus.urls')),

]

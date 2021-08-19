from django.urls import path

from . import views

app_name = "oc_lettings_site"

urlpatterns = [
    path('', views.index, name='index'),
    # path('', include('profiles.urls')),
    # path('', include('lettings.urls')),
]

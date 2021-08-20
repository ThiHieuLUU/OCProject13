from django.test import TestCase
from django.urls import reverse
from django.db.models.query import QuerySet
from django.contrib.auth.models import User

from .models import Profile


class TestProfile(TestCase):
    def setUp(self) -> None:
        self.new_user = User.objects.create_user(
            username="john",
            first_name='John',
            last_name="Paul",
            email='lennon@thebeatles.com',
            password='johnpassword'
        )
        self.new_profile = Profile.objects.create(
            user=self.new_user,
            favorite_city="Buenos Aires"
        )
        self.length_of_profiles = len(Profile.objects.all())

    def test_profiles_index(self):
        url = reverse('profiles:profiles_index')
        response = self.client.get(url)

        self.assertTemplateUsed(response, 'profiles/index.html')

        string = b'<title>Profiles</title>'
        self.assertEqual(True, string in response.content)

        # Assert the presence of the profile list
        self.assertEqual(type(response.context['profiles_list']), QuerySet)
        self.assertEqual(len(response.context['profiles_list']), self.length_of_profiles)

        # Verify links in the content
        self.assertContains(
            response,
            '<a href="%s">Home</a>' % reverse("oc_lettings_site:index"),
            html=True
        )

        self.assertContains(
            response,
            '<a href="%s">Lettings</a>' % reverse("lettings:lettings_index"),
            html=True
        )

        self.assertEqual(response.status_code, 200)

    def test_profiles_profile(self):
        profile = self.new_profile
        username = profile.user.username

        url = reverse('profiles:profile', kwargs={'username': username})
        response = self.client.get(url)

        self.assertTemplateUsed(response, 'profiles/profile.html')

        string = str.encode(f"<title>{username}</title>")
        self.assertEqual(True, string in response.content)

        string = str.encode(f'<p>Favorite city: {profile.favorite_city}</p>')
        self.assertEqual(True, string in response.content)

        # Verify links in the content
        self.assertContains(
            response,
            '<a href="%s">Back</a>' % reverse("profiles:profiles_index"),
            html=True
        )

        self.assertContains(
            response,
            '<a href="%s">Home</a>' % reverse("oc_lettings_site:index"),
            html=True
        )

        self.assertContains(
            response,
            '<a href="%s">Lettings</a>' % reverse("lettings:lettings_index"),
            html=True
        )

        self.assertEqual(response.status_code, 200)

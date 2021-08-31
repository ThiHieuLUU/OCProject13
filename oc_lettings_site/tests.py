# -*- coding: UTF-8 -*-
from django.test import TestCase
from django.urls import reverse


class TestOcLettingsSite(TestCase):
    def setUp(self):
        pass

    def test_index(self):
        # Get the home page
        url = reverse('oc_lettings_site:index')
        response = self.client.get(url)

        # Verify template used
        self.assertTemplateUsed(response, 'oc_lettings_site/index.html')

        # Verify content
        string = b'<h1>Welcome to Holiday Homes</h1>'
        self.assertEqual(True, string in response.content)
        self.assertEqual(response.status_code, 200)

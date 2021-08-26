from django.test import TestCase
from django.urls import reverse
from django.db.models.query import QuerySet

from .models import Address, Letting


class TestLetting(TestCase):
    def setUp(self) -> None:
        self.new_address = Address.objects.create(
            number=340,
            street="Wintergreen Avenue",
            city="Newport",
            state="VA",
            zip_code=23601,
            country_iso_code="USA"
        )

        self.new_letting = Letting.objects.create(
            title="test",
            address=self.new_address
        )

        self.length_of_lettings = len(Letting.objects.all())

    def test_lettings_index(self):
        url = reverse('lettings:lettings_index')
        response = self.client.get(url)

        # Assert template
        self.assertTemplateUsed(response, 'lettings/index.html')

        # Assert content
        string = b'<title>Lettings</title>'
        self.assertEqual(True, string in response.content)

        # Assert the presence of the letting list
        self.assertEqual(type(response.context['lettings_list']), QuerySet)
        self.assertEqual(len(response.context['lettings_list']), self.length_of_lettings)

        self.assertEqual(response.status_code, 200)

    def test_lettings_letting(self):
        # Get letting to test
        letting = self.new_letting
        letting_id = letting.id
        address = letting.address
        title = letting.title

        # Get detail of a letting
        url = reverse('lettings:letting', kwargs={'letting_id': letting_id})
        response = self.client.get(url)

        # Verify template used
        self.assertTemplateUsed(response, 'lettings/letting.html')

        # Verify content
        string = str.encode(f"<title>{title}</title>")
        self.assertEqual(True, string in response.content)

        string = str.encode(f'<p>{address.city}, {address.state} {address.zip_code}</p>')
        self.assertEqual(True, string in response.content)

        self.assertEqual(response.status_code, 200)

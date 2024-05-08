import json

from django.test import TestCase, Client


client = Client()


class ViewRegisterTest(TestCase):
    def setUp(self):
        pass

    def test_hello_world(self):
        response = client.get("/api/register/hello/")
        self.assertEqual(200, response.status_code)
        data: dict = json.loads(response.content)
        self.assertEqual(1, len(data))
        self.assertEqual("world", data["hello"])

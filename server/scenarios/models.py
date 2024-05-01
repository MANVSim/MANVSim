import threading

from django.db import models


# Create your models here.
class Scenario(models.Model):
    name = models.CharField(max_length=255)

    # insert update queries here pay attention to lock using
    def update_resource(self):
        lock = threading.Lock()
        with lock:
            pass

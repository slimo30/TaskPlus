from django.db import models
from colorfield.fields import ColorField
import shortuuid 

from django.db.models import Max  # Import Max here

##adding bthe workspace created aoutamoticly when the 

class Workspace(models.Model):
    name = models.CharField(max_length=255, verbose_name="Workspace Name")
    sector = models.CharField(max_length=255)
    invite_code = models.CharField(max_length=22, unique=True, default=shortuuid.uuid, editable=False, verbose_name="Invite Code")

    def __str__(self):
        return self.name



class Member(models.Model):
    
    password = models.CharField(max_length=255)
    workspace = models.ForeignKey(Workspace, on_delete=models.SET_NULL, null=True, blank=True, related_name='members')
    device_token = models.CharField(max_length=255, null=True, blank=True)
    username = models.CharField(max_length=255)
    superuser = models.BooleanField(default=  False)
    name = models.CharField(max_length=255, default='Default Name')
    def __str__(self):
        return self.username


        
class Mission(models.Model):
    PRIORITY_CHOICES = [
        ('high', 'High'),
        ('medium', 'Medium'),
        ('low', 'Low'),
    ]

    title = models.CharField(max_length=255)
    priority = models.CharField(max_length=10, choices=PRIORITY_CHOICES)
    ordered = models.BooleanField(default=False)
    category = models.ForeignKey('Category', on_delete=models.CASCADE)
    workspace = models.ForeignKey(Workspace, on_delete=models.CASCADE)
    time_created = models.DateTimeField()

    def __str__(self):
        return self.title


class Task(models.Model):
    STATE_CHOICES = [
        ('missed', 'Missed'),
        ('complete', 'Complete'),
        ('incomplete', 'Incomplete'),
    ]

    PRIORITY_CHOICES = [
        ('high', 'High'),
        ('medium', 'Medium'),
        ('low', 'Low'),
    ]

    task_id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=255)
    description = models.TextField()
    priority = models.CharField(max_length=10, choices=PRIORITY_CHOICES)
    state = models.CharField(max_length=10, choices=STATE_CHOICES)
    task_owner = models.ForeignKey('Member', on_delete=models.CASCADE, related_name='tasks_owned')
    deadline = models.DateTimeField()
    file_attachment = models.FileField(null=True, blank=True)
    mission = models.ForeignKey('Mission', on_delete=models.CASCADE)
    time_created = models.DateTimeField()
    order_position = models.IntegerField(blank=True, null=True)
    time_to_alert = models.DurationField()
    notification_sent = models.BooleanField(default=False)
    notification_sent_alert = models.BooleanField(default=False)

    class Meta:
        unique_together = ('mission', 'order_position')

    def calculate_alert_time(self):
        if self.deadline and self.time_to_alert:
            return self.deadline - self.time_to_alert
        return None

    def __str__(self):
        return self.title

    def save(self, *args, **kwargs):
        if self.order_position is None:
            max_order = Task.objects.filter(mission=self.mission).aggregate(Max('order_position'))['order_position__max']
            self.order_position = (max_order or 0) + 1
        super(Task, self).save(*args, **kwargs)


class Comment(models.Model):
    text = models.TextField()
    employee = models.ForeignKey(Member, on_delete=models.CASCADE)
    task = models.ForeignKey(Task, on_delete=models.CASCADE, related_name='comments')
    time_posted = models.DateTimeField(auto_now_add=True)
    workspace = models.ForeignKey(Workspace, on_delete=models.CASCADE, related_name='comment_workspace', default=1)

    def __str__(self):
        return f"Comment by {self.employee.full_name} on {self.task.title}"
        

class Category(models.Model):
    name = models.CharField(max_length=255)
    color = ColorField(default='#FF0000')
    workspace = models.ForeignKey(Workspace, on_delete=models.CASCADE, default=1)
    def __str__(self):
        return self.name
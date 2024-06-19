from django.core.management.base import BaseCommand
from api.models import Task
from api.views import send_notification
import schedule
import time
from django.utils import timezone

class Command(BaseCommand):
    help = 'Send notifications when a certain datetime is reached'

    def handle(self, *args, **kwargs):
        print("Starting the scheduler...")
        schedule.every(10).seconds.do(self.check_and_send_notifications)

        while True:
            print("Running pending tasks...")
            schedule.run_pending()
            time.sleep(1)

    def check_and_send_notifications(self):
        print("Checking and sending notifications...")

        tasks = Task.objects.filter(state='incomplete', task_owner__device_token__isnull=False)

        for task in tasks:
            current_datetime = timezone.now()
            target_datetime = task.deadline
            alert_datetime = target_datetime - task.time_to_alert

            # Send an alert notification before the deadline if not already sent
            if current_datetime >= alert_datetime and not task.notification_sent_alert:
                print(f"Sending alert notification for task '{task.title}'...")
                send_notification(
                    task.task_owner.device_token,
                    f"Alert for task '{task.title}'",
                    f"The deadline for task '{task.title}' is approaching."
                )

                # Update the task's notification_sent_alert field to True
                Task.objects.filter(task_id=task.task_id).update(notification_sent_alert=True)

            # Send notification when the deadline is reached if not already sent
            if current_datetime >= target_datetime and not task.notification_sent:
                print(f"Sending notification for task '{task.title}'...")
                send_notification(
                    task.task_owner.device_token,
                    f"The deadline for task '{task.title}' has passed.",
                    f"Subtitle for task '{task.title}'"
                )

                # Update the task's notification_sent field to True and set the state to 'missed'
                Task.objects.filter(task_id=task.task_id).update(notification_sent=True, state='missed')

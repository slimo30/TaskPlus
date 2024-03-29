# Generated by Django 4.1.6 on 2024-03-06 23:43

from django.db import migrations, models
import shortuuid.main


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='task',
            name='notification_sent',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='task',
            name='notification_sent_alert',
            field=models.BooleanField(default=False),
        ),
        migrations.AlterField(
            model_name='workspace',
            name='invite_code',
            field=models.CharField(default=shortuuid.main.ShortUUID.uuid, editable=False, max_length=22, unique=True, verbose_name='Invite Code'),
        ),
    ]

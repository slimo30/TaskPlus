# Generated by Django 5.0.3 on 2024-03-28 20:50

import shortuuid.main
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0008_alter_workspace_invite_code'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='member',
            name='email',
        ),
        migrations.AlterField(
            model_name='workspace',
            name='invite_code',
            field=models.CharField(default=shortuuid.main.ShortUUID.uuid, editable=False, max_length=22, unique=True, verbose_name='Invite Code'),
        ),
    ]

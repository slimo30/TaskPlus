# Generated by Django 5.0.3 on 2024-06-15 09:37

import shortuuid.main
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0015_alter_workspace_invite_code_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='task',
            name='order_position',
            field=models.IntegerField(blank=True, null=True),
        ),
        migrations.AlterField(
            model_name='workspace',
            name='invite_code',
            field=models.CharField(default=shortuuid.main.ShortUUID.uuid, editable=False, max_length=22, unique=True, verbose_name='Invite Code'),
        ),
    ]

from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import action, api_view, permission_classes, authentication_classes
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework import generics, viewsets
from rest_framework.authtoken.models import Token

from django.http import HttpResponse
from django.contrib.auth import authenticate
from django.contrib.auth.models import User
from rest_framework.authentication import TokenAuthentication, SessionAuthentication

from .models import * 
from .serializers import *  # 

import os
from pathlib import Path  # Import Path from pathlib module
from rest_framework import viewsets, status
from rest_framework.response import Response
from django.http import HttpResponse
from .models import Task
from .serializers import TaskSerializer
from rest_framework.decorators import action
import requests
from django.db.models import F  



    

@api_view(["POST"])
@permission_classes([AllowAny])
def signup(request):
    user_serializer = UserSerializer(data=request.data)
    if user_serializer.is_valid():
        user = user_serializer.save()

        # Create an associated Member instance
        member_data = {
            'user': user.id,
            'username': user.username,
            'name': request.data.get('name'),
            'password': request.data.get('password'),
            'workspace': request.data.get('workspace'),
            'device_token': request.data.get('device_token'),
            'superuser': request.data.get('superuser', False)
        }

        member_serializer = MemberSerializer(data=member_data)
        if member_serializer.is_valid():
            member_serializer.save()
            token, _ = Token.objects.get_or_create(user=user)
            user_data = UserSerializer(user).data
            # Exclude the 'password' field from the response
            del user_data['password']
            return Response({"user": user_data, "token": token.key}, status=status.HTTP_201_CREATED)
        else:
            user.delete()
            return Response(member_serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    return Response(user_serializer.errors, status=status.HTTP_400_BAD_REQUEST)



@api_view(["POST"])
@permission_classes([AllowAny])
def login(request):
   
    data = request.data
    usernamestring = data['username']
    user = authenticate(username=data['username'], password=data['password'])

    if user:
        token, created_token = Token.objects.get_or_create(user=user)
        member = Member.objects.filter(username=usernamestring).first()
        if member:
            response_data = {
                'token': token.key,
                'id': member.id,
            }
            return Response(response_data)
        else:
            return Response({"detail": "Member not found"}, status=status.HTTP_404_NOT_FOUND)

    return Response({"detail": "Invalid credentials"}, status=status.HTTP_400_BAD_REQUEST)


@api_view(["POST"])
def change_password(request, member_id):
    try:
        member = Member.objects.get(id=member_id)
    except Member.DoesNotExist:
        return Response({"detail": "Member not found."}, status=status.HTTP_404_NOT_FOUND)

    # Ensure that the authenticated user is the owner of the member record or a superuser
   
    serializer = PasswordChangeSerializer(data=request.data)
    if serializer.is_valid():
        old_password = serializer.validated_data['old_password']
        new_password = serializer.validated_data['new_password']

        user = User.objects.get(username=member.username)
        
        if not user.check_password(old_password):
            return Response({"detail": "Old password is incorrect."}, status=status.HTTP_400_BAD_REQUEST)

        # Update password in User model
        user.set_password(new_password)
        user.save()

        # Update password in Member model
        member.password = new_password
        member.save()

        return Response({"detail": "Password changed successfully."}, status=status.HTTP_200_OK)

    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)



class MemberRetrieveUpdateView(generics.RetrieveUpdateAPIView):
    queryset = Member.objects.all()
    serializer_class = MemberSerializer

class MemberListAPIView(generics.ListAPIView):
    queryset = Member.objects.all()
    serializer_class = MemberSerializer


class MemberInWorkspaceListView(generics.ListAPIView):
    serializer_class = MemberSerializer

    def get_queryset(self):
        workspace_pk = self.kwargs.get('workspace_pk')
        
        queryset = Member.objects.filter(workspace__id=workspace_pk)
        
        return queryset


class WorkspaceListView(generics.ListAPIView):
    queryset = Workspace.objects.all()
    serializer_class = WorkspaceSerializer1

class WorkspaceRetrieveView(generics.RetrieveAPIView):
    queryset = Workspace.objects.all()
    serializer_class = WorkspaceSerializer1

# This view is used to create a workspace and make the member creator as superuser and assign the workspace to the creator

class WorkspaceCreateView(generics.CreateAPIView):
    serializer_class = WorkspaceSerializer

    def perform_create(self, serializer):
        # Retrieve the member ID from the URL parameters
        member_id = self.kwargs.get('member_id')

        # Fetch the member instance using the provided member ID
        member = Member.objects.get(pk=member_id)

        # Create the workspace
        workspace = serializer.save()

        # Associate the workspace with the member
        member.workspace = workspace
        member.superuser = True
        member.save()

        return Response(serializer.data, status=status.HTTP_201_CREATED)        


class MissionListView(generics.ListCreateAPIView):
    queryset = Mission.objects.all()
    serializer_class = MissionSerializer

class MissionListViewByWorkspace(generics.ListAPIView):
    serializer_class = MissionSerializer

    def get_queryset(self):
        workspace_id = self.kwargs['workspace_id']
        return Mission.objects.filter(workspace_id=workspace_id)

#maybe not needed
class MissionDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Mission.objects.all()
    serializer_class = MissionSerializer

class WorkspaceMissionListView(generics.ListAPIView):
    serializer_class = MissionSerializer

    def get_queryset(self):
        workspace_id = self.kwargs['workspace_id']
        return Mission.objects.filter(workspace_id=workspace_id)
        
class TaskListViewByMission(generics.ListAPIView):
    serializer_class = TaskSerializer

    def get_queryset(self):
        mission_id = self.kwargs['mission_id']
        return Task.objects.filter(mission__id=mission_id).order_by('order_position')


class TaskListViewByMember(generics.ListAPIView):
    serializer_class = TaskSerializer

    def get_queryset(self):
        member_id = self.kwargs['member_id']
        return Task.objects.filter(task_owner__id=member_id)


class TaskListViewByMemberHistory(generics.ListAPIView):
    serializer_class = TaskSerializer

    def get_queryset(self):
        member_id = self.kwargs['member_id']
        return Task.objects.filter(
            task_owner__id=member_id,
            state__in=['missed', 'complete']
        ).order_by('time_created')


class TaskViewSet(viewsets.ModelViewSet):
    queryset = Task.objects.all()
    serializer_class = TaskSerializer

    def perform_destroy(self, instance):
        mission = instance.mission
        order_position = instance.order_position
        instance.delete()
        Task.objects.filter(mission=mission, order_position__gt=order_position).update(order_position=F('order_position') - 1)

    @action(detail=True, methods=['get'])
    def download_file(self, request, pk=None):
        task = self.get_object()
        file_path = task.file_attachment.path if task.file_attachment else None

        if file_path and Path(file_path).exists():
            with open(file_path, 'rb') as file:
                response = HttpResponse(file.read(), content_type='application/octet-stream')
                response['Content-Disposition'] = f'attachment; filename="{Path(file_path).name}"'
                return response
        else:
            return Res
            

class CommentListCreateView(generics.ListCreateAPIView):
    queryset = Comment.objects.all()
    serializer_class = CommentSerializer

class CommentRetrieveUpdateDestroyView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Comment.objects.all()
    serializer_class = CommentSerializer

class CommentListViewByTask(generics.ListAPIView):
    serializer_class = CommentSerializer

    def get_queryset(self):
        task_id = self.kwargs['task_id']
        return Comment.objects.filter(task_id=task_id).order_by('time_posted')

class CategoryListCreateView(generics.ListCreateAPIView):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer

class CategoryRetrieveUpdateDestroyView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer
class CategoryListCreateViewByWorkspace(generics.ListCreateAPIView):
    serializer_class = CategorySerializer

    def get_queryset(self):
        workspace_id = self.kwargs['workspace_id']
        return Category.objects.filter(workspace_id=workspace_id)

class JoinWorkspaceAPIView(APIView):
    def post(self, request, *args, **kwargs):
        # Get data from request
        member_id = request.data.get('member_id')
        invite_code = request.data.get('invite_code')

        try:
            # Retrieve the member and workspace
            member = Member.objects.get(id=member_id)
            workspace = Workspace.objects.get(invite_code=invite_code)

            # Associate the member with the workspace
            member.workspace = workspace
            member.save()

            # Send notification to all workspace members
            self.send_notification_to_workspace_members(workspace, f'Member {member.username} joined Workspace {workspace.name}.')

            return Response({'detail': f'Member {member.username} joined Workspace {workspace.name}.'}, status=status.HTTP_200_OK)
        except Member.DoesNotExist:
            return Response({'detail': 'Member not found.'}, status=status.HTTP_404_NOT_FOUND)
        except Workspace.DoesNotExist:
            return Response({'detail': 'Invalid invite code.'}, status=status.HTTP_400_BAD_REQUEST)
   ##############################################################33 #fix this issue
    def send_notification_to_workspace_members(self, workspace, message):

        # Get all members in the workspace
        members = Member.objects.filter(workspace=workspace).exclude(device_token__in=['', None])

        # Send a separate notification for each member
        for member in members:
            # Prepare the FCM notification payload for the current member

            send_notification(member.device_token,"Workspace Notification",message)
           



class WorkspaceHistoryAPIView(APIView):
    def get(self, request, workspace_id, format=None):
        # Get all completed and missed tasks for the given workspace, combined and ordered by deadline
        tasks = Task.objects.filter(mission__workspace_id=workspace_id, state__in=['complete', 'missed']).order_by('deadline')

        # Serialize the tasks
        task_serializer = TaskSerializer(tasks, many=True)

        # Return the serialized data
        return Response({'tasks': task_serializer.data}, status=status.HTTP_200_OK)





# def send_notification(device_token, title, body, subtitle=None):
#     try:
#         # Your notification sending logic here
#         # Example: Send an HTTP request to FCM
#         fcm_url = 'https://fcm.googleapis.com/fcm/send'
#         headers = {
#             'Content-Type': 'application/json',
#             'Authorization': 'key=AAAA2XJqoZU:APA91bEN0c0-qzOuaezMX6_hlFPI7j_lGumkHEU8NlQAFF2I9L2m-bhQROssaAktc_2PtOzJ3X0HtFO-DhgS-6OcE17QVJ6ERJ513Dq8yPr2_8E5vf8yKOkFUL5suLn6BLBrWQjfs_x3',  # Replace with your FCM server key
#         }

#         payload = {
#             'to': device_token,
#             'notification': {
#                 'title': title,
#                 'body': body,
#                 'subtitle': subtitle,
#             }
#         }

#         response = requests.post(fcm_url, json=payload, headers=headers)
#         print('Sent')
#         return response.status_code
#     except Exception as e:
#         print(f"An error occurred during notification sending: {e}")













from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.shortcuts import get_object_or_404
from .models import Task
from .serializers import TaskSerializer

class CompleteTaskView(APIView):
    def post(self, request, task_id):
        task = get_object_or_404(Task, pk=task_id)
        
        if task.mission.ordered:
            # Retrieve all pending tasks in the mission
            pending_tasks = Task.objects.filter(
                mission=task.mission,
                state='incomplete'
            ).order_by('order_position')
            
            # Check if the task to be completed has the smallest order position
            if pending_tasks.exists() and pending_tasks.first().order_position != task.order_position:
                return Response(
                    {"detail": "You must complete tasks in order. Please complete preceding tasks first."},
                    status=status.HTTP_400_BAD_REQUEST
                )
        
        task.state = 'complete'
        task.save()
        serializer = TaskSerializer(task)
        return Response(serializer.data, status=status.HTTP_200_OK)





class CreateWorkspaceView(APIView):
    def post(self, request):
        serializer = WorkspaceSerializer(data=request.data)
        if serializer.is_valid():
            workspace = serializer.save()
            member_id = request.data.get('member_id')
            try:
                member = Member.objects.get(id=member_id)
                member.workspace = workspace
                member.superuser = True
                member.save()
            except Member.DoesNotExist:
                return Response(status=status.HTTP_404_NOT_FOUND)
            
            return Response(status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from django.shortcuts import get_object_or_404

@api_view(['GET'])
def get_invite_code(request, workspace_id):
    workspace = get_object_or_404(Workspace, id=workspace_id)
    return Response({'invite_code': workspace.invite_code}, status=status.HTTP_200_OK)




from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.shortcuts import get_object_or_404

class AssignTaskView(APIView):
    def post(self, request, member_id):
        member = get_object_or_404(Member, id=member_id)
        task_title = request.data.get('task_title', 'New Task Assigned')
        task_body = request.data.get('task_body', 'You have been assigned a new task.')
        
        if member.device_token:
            send_notification(member.device_token, task_title, task_body)
            return Response({'status': 'Notification sent'}, status=status.HTTP_200_OK)
        else:
            return Response({'status': 'Member has no device token'}, status=status.HTTP_400_BAD_REQUEST)
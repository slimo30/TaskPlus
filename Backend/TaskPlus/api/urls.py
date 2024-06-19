# in your app's urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('signup/', views.signup, name='signup'),
    path('login/', views.login, name='login'),
    # path('logout/', views.logout, name='logout'),

    path('members/<int:pk>/', views.MemberRetrieveUpdateView.as_view(), name='member-retrieve-update'),
    path('members/', views.MemberListAPIView.as_view(), name='member-list'),
    path('workspaces/<int:workspace_pk>/members/', views.MemberInWorkspaceListView.as_view(), name='member-list'),
    path('join-workspace/', views.JoinWorkspaceAPIView.as_view(), name='join-workspace'),
    path('workspace/<int:workspace_id>/history/', views.WorkspaceHistoryAPIView.as_view(),),

    path('workspaces/', views.WorkspaceListView.as_view(), name='workspace-list'),
    path('workspaces/<int:pk>/', views.WorkspaceRetrieveView.as_view(), name='workspace-retrieve'),
    path('workspaces/create/<int:member_id>/', views.WorkspaceCreateView.as_view(), name='create_workspace'),
    
    path('workspaces/<int:workspace_id>/missions/', views.WorkspaceMissionListView.as_view(), name='workspace-missions'),
    #add meisson by workspace
    path('missions/', views.MissionListView.as_view(), name='mission-list'),
    path('missions/<int:pk>/', views.MissionDetailView.as_view(), name='mission-detail'),
    path('workspace/<int:workspace_id>/missions/', views.MissionListViewByWorkspace.as_view(), name='mission-list-by-workspace'),

    #add fix this tasks by mession
    path('tasks/', views.TaskViewSet.as_view({'get': 'list', 'post': 'create'}), name='task-list'),
    path('task/<int:task_id>/complete/', views.CompleteTaskView.as_view(), name='api_complete_task'),
    path('tasks/member/history/<int:member_id>/', views.TaskListViewByMemberHistory.as_view(), name='tasks-by-member-history'),


    path('tasks/<int:pk>/', views.TaskViewSet.as_view({'get': 'retrieve', 'put': 'update', 'delete': 'destroy'}), name='task-detail'),
    path('tasks/<int:pk>/download_file/', views.TaskViewSet.as_view({'get': 'download_file'}), name='task-download-file'),
    path('missions/<int:mission_id>/tasks/', views.TaskListViewByMission.as_view(), name='task-list-by-mission'),
    path('members/<int:member_id>/tasks/', views.TaskListViewByMember.as_view(), name='task-list-by-member'),

    path('comments/', views.CommentListCreateView.as_view(), name='comment-list-create'),
    path('comments/<int:pk>/', views.CommentRetrieveUpdateDestroyView.as_view(), name='comment-retrieve-update-destroy'),
    path('comments/workspace/<int:workspace_id>/', views.CommentListViewByWorkspace.as_view(), name='comments-by-workspace'),


    path('categories/workspace/<int:workspace_id>/', views.CategoryListCreateViewByWorkspace.as_view(), name='category-list-create-by-workspace'),
    path('categories/', views.CategoryListCreateView.as_view(), name='category-list-create'),
    path('categories/<int:pk>/', views.CategoryRetrieveUpdateDestroyView.as_view(), name='category-retrieve-update-destroy'),

]

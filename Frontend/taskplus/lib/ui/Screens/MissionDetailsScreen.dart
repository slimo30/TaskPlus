import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taskplus/Bloc/member/member_bloc.dart';
import 'package:taskplus/Bloc/member/member_event.dart';
import 'package:taskplus/Bloc/member/member_state.dart';
import 'package:taskplus/Bloc/task/task_bloc.dart';
import 'package:taskplus/Controller/Authentification.dart';
import 'package:taskplus/Controller/member_repo.dart';
import 'package:taskplus/Controller/task_repo.dart';
import 'package:taskplus/Controller/themeProvider.dart';
import 'package:taskplus/Model/Category.dart';
import 'package:taskplus/Model/Member.dart';
import 'package:taskplus/Model/Messions.dart';
import 'package:taskplus/Model/TaskModel.dart';
import 'package:taskplus/ui/Screens/CommentScreen.dart';
import 'package:taskplus/ui/Screens/MissionsScreen.dart';
import 'package:taskplus/ui/Widgets/Appbar.dart';
import 'package:taskplus/ui/Widgets/Button.dart';
import 'package:taskplus/utils/TextStyle.dart';
import 'package:taskplus/utils/colors.dart';
import 'package:taskplus/utils/link.dart';
import 'package:http/http.dart' as http;

class MissionDetailsScreen extends StatelessWidget {
  final Mission mission;
  final Category category;

  MissionDetailsScreen({
    required this.mission,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MemberRepository>(
          create: (context) =>
              MemberRepository(baseurl), // Replace with your baseurl
        ),
        RepositoryProvider<TaskRepository>(
          create: (context) =>
              TaskRepository(baseUrl: baseurl), // Replace with your baseurl
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TaskBloc>(
            create: (context) => TaskBloc(
              taskRepository: RepositoryProvider.of<TaskRepository>(context),
            )..add(LoadTasksByMission(mission.id)),
          ),
          BlocProvider<MemberBloc>(
            create: (context) {
              final memberRepository =
                  RepositoryProvider.of<MemberRepository>(context);
              return MemberBloc(memberRepository: memberRepository)
                ..add(FetchMembers());
            },
          ),
        ],
        child: MissionDetailsPage(
          mission: mission,
          category: category,
        ),
      ),
    );
  }
}

class MissionDetailsPage extends StatefulWidget {
  final Mission mission;
  final Category category;
  const MissionDetailsPage(
      {super.key, required this.mission, required this.category});

  @override
  State<MissionDetailsPage> createState() => _MissionDetailsPageState();
}

class _MissionDetailsPageState extends State<MissionDetailsPage> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: customAppBar(
        "Mission",
        AppColor.blackColor,
        context,
      ),
      backgroundColor:
          !isDarkMode ? AppColor.backgroundColor : AppColor.blackColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: !isDarkMode
                      ? AppColor.whiteColor
                      : AppColor.darkModeBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.mission.title,
                                style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? AppColor.whiteColor
                                        : AppColor.blackColor),
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  DateFormat('yyyy-MM-dd HH:mm')
                                      .format(widget.mission.timeCreated),
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: isDarkMode
                                          ? AppColor.whiteColor
                                          : AppColor.blackColor),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.date_range_outlined,
                                  color: isDarkMode
                                      ? AppColor.whiteColor
                                      : AppColor.blackColor,
                                  size: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: getPriorityColor(widget.mission.priority),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            widget.mission.priority,
                            style: GoogleFonts.inter(
                              color: AppColor.whiteColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(int.parse(widget.category.color
                                .replaceFirst('#', '0xff'))),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            widget.category.name,
                            style: GoogleFonts.inter(
                              color: getTextColor(Color(int.parse(widget
                                  .category.color
                                  .replaceFirst('#', '0xff')))),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        widget.mission.ordered
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColor.greenColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  'Ordered',
                                  style: GoogleFonts.inter(
                                    color: AppColor.whiteColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    widget.mission.ordered
                        ? Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColor
                                      .greenColor), // Assuming AppColors.green is defined elsewhere
                              borderRadius: BorderRadius.circular(
                                  5), // Example radius value
                            ),
                            padding: EdgeInsets.all(
                                8.0), // Optional: To add some padding inside the container
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Attention: ",
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "Tasks in this mission must be added and completed sequentially, with each task being completed before moving on to the next.",
                                    style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode
                                            ? AppColor.whiteColor
                                            : AppColor.blackColor),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                  ]),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                child: InkWell(
                  onTap: () async {
                    int owner = await getMemberIdFromPrefs();
                    final taskBloc = BlocProvider.of<TaskBloc>(context);
                    showTaskFormBottomSheet(
                      context: context,
                      onSave: (title, description, priority, deadline,
                          timeToAlert) {
                        context.read<TaskBloc>().add(CreateTask(
                            Task(
                                taskId: 0,
                                title: title,
                                description: description,
                                priority: priority,
                                state: 'incomplete',
                                deadline: deadline,
                                timeCreated: DateTime.now(),
                                orderPosition: 0,
                                timeToAlert: timeToAlert,
                                notificationSent: false,
                                notificationSentAlert: false,
                                taskOwner: owner,
                                mission: widget.mission.id),
                            missionId: widget.mission.id));
                      },
                      taskBloc: taskBloc,
                    );
                  },
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColor.greenColor,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Add Task",
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColor.whiteColor,
                          ),
                        ),
                        SizedBox(width: 10), // Space between text and icon
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.add,
                            color: AppColor.greenColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Tasks",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: BlocBuilder<TaskBloc, TaskState>(
                    builder: (BuildContext context, TaskState taskState) {
                      return BlocBuilder<MemberBloc, MemberState>(
                          builder: (context, memberstate) {
                        if (taskState is TaskLoading ||
                            memberstate is MemberLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColor.greenColor,
                            ),
                          );
                        } else if (taskState is TaskLoadSuccess &&
                            memberstate is MemberLoaded) {
                          final memebers = memberstate.members;
                          final tasks = taskState.tasks;

                          return ListView.builder(
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              final task = tasks[index];
                              final owner = memebers.firstWhere(
                                  (member) => member.id == task.taskOwner,
                                  orElse: () => Member(
                                      id: 0,
                                      username: "Unknown",
                                      superuser: false,
                                      name: "Unknown"));
                              return TaskBody(task, owner, context);
                            },
                          );
                        } else {
                          return Container();
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding TaskBody(Task task, Member owner, BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColor.darkModeBackgroundColor
              : AppColor.whiteColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: getStateColor(task.state),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      task.state,
                      style: GoogleFonts.inter(
                        color: AppColor.whiteColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: getPriorityColor(task.priority),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      task.priority,
                      style: GoogleFonts.inter(
                        color: AppColor.whiteColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (widget.mission.ordered)
                    Container(
                      width: 30, // Adjust the width and height as needed
                      height: 30,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.white
                            : Colors.black, // Black circle
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          task.orderPosition.toString(),
                          style: GoogleFonts.inter(
                            color: !isDarkMode
                                ? Colors.white
                                : Colors.black, // White number
                            fontSize: 16, // Adjust font size as needed
                            fontWeight: FontWeight
                                .bold, // Optionally, adjust font weight
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      "${task.title}",
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? AppColor.whiteColor
                              : AppColor.blackColor),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      "${task.description}",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: isDarkMode
                              ? AppColor.whiteColor
                              : AppColor.blackColor),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Task owner : ${owner.name}",
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        color: isDarkMode
                            ? AppColor.whiteColor
                            : AppColor.blackColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Deadline: ${DateFormat('yyyy-MM-dd HH:mm').format(task.deadline)}",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: isDarkMode
                          ? AppColor.whiteColor
                          : AppColor.blackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Divider(
                color: AppColor.iconsColor,
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      "Actions",
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? AppColor.whiteColor
                              : AppColor.blackColor),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (task.fileAttachment == null)
                      ? GestureDetector(
                          onTap: () async {
                            try {
                              File? file = await pickFile();
                              if (file != null) {
                                await createTaskWithAttachment(
                                    task: task, file: file);
                                final taskBloc =
                                    BlocProvider.of<TaskBloc>(context);

                                taskBloc
                                    .add(LoadTasksByMission(widget.mission.id));
                              } else {
                                print('No file picked');
                              }
                            } catch (e) {
                              print('Error creating task with attachment: $e');
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColor.blueColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "Attach file",
                                  style: GoogleFonts.inter(
                                    color: AppColor.whiteColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                    width: 8), // Added a SizedBox for spacing
                                SizedBox(
                                  width:
                                      12, // Adjust the width based on your text font size
                                  height:
                                      12, // Adjust the height to match the icon size
                                  child: Icon(
                                    Icons.attach_file,
                                    color: AppColor.whiteColor,
                                    size:
                                        12, // Set the icon size to match the text font size
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            try {
                              String filePath = await downloadFile(task.taskId);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Download completed. File saved to: $filePath'),
                                ),
                              );
                              print(
                                  'Download completed. File saved to: $filePath');
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error downloading file: $e'),
                                ),
                              );
                              print('Error downloading file: $e');
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColor.redColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "Download file",
                                  style: GoogleFonts.inter(
                                    color: AppColor.whiteColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: Icon(
                                    Icons.download_rounded,
                                    color: AppColor.whiteColor,
                                    size:
                                        12, // Set the icon size to match the text font size
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColor.darkGreenColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Assign",
                            style: GoogleFonts.inter(
                              color: AppColor.whiteColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8), // Added a SizedBox for spacing
                          SizedBox(
                            width:
                                12, // Adjust the width based on your text font size
                            height:
                                12, // Adjust the height to match the icon size
                            child: Icon(
                              Icons.assignment_turned_in,
                              color: AppColor.whiteColor,
                              size:
                                  12, // Set the icon size to match the text font size
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      final taskBloc = BlocProvider.of<TaskBloc>(context);
                      final memberBloc = BlocProvider.of<MemberBloc>(context);
                      _showMemberSelectionBottomSheet(
                          context, memberBloc, taskBloc, task);
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentScreen(task: task),
                          ));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColor.iconsColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Comments",
                            style: GoogleFonts.inter(
                              color: AppColor.whiteColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8), // Added a SizedBox for spacing
                          SizedBox(
                            width:
                                12, // Adjust the width based on your text font size
                            height:
                                12, // Adjust the height to match the icon size
                            child: Icon(
                              Icons.comment,
                              color: AppColor.whiteColor,
                              size:
                                  12, // Set the icon size to match the text font size
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: AppColor.iconsColor,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      final taskBloc = BlocProvider.of<TaskBloc>(context);
                      _showDeleteConfirmationDialog(
                          context, task.taskId, widget.mission.id, taskBloc);
                    },
                    child: Icon(
                      Icons.delete,
                      color: AppColor.redColor,
                    ),
                  ),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () async {
                      int owner = await getMemberIdFromPrefs();
                      final taskBloc = BlocProvider.of<TaskBloc>(context);
                      bool deadline_changed = false;
                      bool duration_changed = false;
                      showTaskUpdateFormBottomSheet(
                        context: context,
                        onSave: (title, description, priority, deadline,
                            timeToAlert, deadline_changed, duration_changed) {
                          print("$deadline_changed $duration_changed");
                          taskBloc.add(
                            UpdateTask(
                              Task(
                                taskId: task
                                    .taskId, // Assuming taskId is required for update
                                title: title,
                                description: description,
                                priority: priority,
                                state: task.state, // Adjust state as needed
                                deadline: deadline,
                                timeCreated: task
                                    .timeCreated, // Keep the original timeCreated
                                orderPosition: task
                                    .orderPosition, // Keep the original orderPosition
                                timeToAlert: timeToAlert,
                                notificationSent: deadline_changed
                                    ? false
                                    : task
                                        .notificationSent, // Keep the original notificationSent
                                notificationSentAlert: deadline_changed
                                    ? false
                                    : duration_changed
                                        ? false
                                        : task
                                            .notificationSentAlert, // Keep the original notificationSentAlert
                                taskOwner: owner,
                                mission: widget.mission
                                    .id, // Assuming you have access to widget.mission.id
                              ),
                              missionId: widget.mission.id,
                            ),
                          );
                        },
                        taskBloc: taskBloc,
                        task: task,
                      );
                    },
                    child: Icon(
                      Icons.edit,
                      color: AppColor.orangeColor,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                            DateFormat('yyyy-MM-dd HH:mm')
                                .format(task.timeCreated),
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                color: isDarkMode
                                    ? AppColor.whiteColor
                                    : AppColor.blackColor)),
                        SizedBox(width: 8),
                        Icon(
                          Icons.date_range_outlined,
                          color: isDarkMode
                              ? AppColor.whiteColor
                              : AppColor.blackColor,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getTextColor(Color backgroundColor) {
    int brightness = ((backgroundColor.red * 299) +
            (backgroundColor.green * 587) +
            (backgroundColor.blue * 114)) ~/
        1000;
    return brightness > 128 ? Colors.black : Colors.white;
  }

  Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return AppColor.orangeColor;
      case 'high':
        return AppColor.redColor;
      default:
        return Colors.grey;
    }
  }

  Color getStateColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'complete':
        return Colors.green;
      case 'incomplete':
        return AppColor.orangeColor;
      case 'missed':
        return AppColor.redColor;
      default:
        return Colors.grey;
    }
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, int taskId, int missionId, TaskBloc taskBloc) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

          return AlertDialog(
            backgroundColor:
                isDarkMode ? AppColor.blackColor : AppColor.whiteColor,
            title: Text(
              "Delete Task",
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: !isDarkMode ? AppColor.blackColor : AppColor.whiteColor,
              ),
            ),
            content: Text(
              "Are you sure you want to delete this task?",
              style: GoogleFonts.inter(
                fontSize: 16,
                color: !isDarkMode ? AppColor.blackColor : AppColor.whiteColor,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Cancel",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: AppColor.redColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Close the dialog
                },
              ),
              TextButton(
                child: Text(
                  "Delete",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: AppColor.greenColor,
                  ),
                ),
                onPressed: () {
                  taskBloc.add(DeleteTask(taskId, missionId: missionId));
                  Navigator.of(dialogContext).pop(); // Close the dialog
                },
              ),
            ],
          );
        });
  }
}

void showTaskFormBottomSheet({
  required BuildContext context,
  required Function(
    String title,
    String description,
    String priority,
    DateTime deadline,
    String timeToAlert,
  ) onSave,
  required TaskBloc taskBloc,
}) {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timeToAlertController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  final List<String> _priorities = ['low', 'medium', 'high'];
  String _selectedPriority = 'low';
  DateTime _selectedDeadline = DateTime.now();
  Duration _selectedTimeToAlert = Duration(hours: 1);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

      return Container(
        color: !isDarkMode
            ? AppColor.whiteColor
            : AppColor.darkModeBackgroundColor,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Title',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: !isDarkMode
                              ? AppColor.blackColor
                              : AppColor.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    key: const Key('title_field'),
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      labelStyle: GoogleFonts.inter(
                        color: Colors.grey.shade600,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Description',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: !isDarkMode
                                ? AppColor.blackColor
                                : AppColor.whiteColor,
                          )),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    key: const Key('description_field'),
                    minLines: 3, // Minimum lines to show
                    maxLines: 3, // Maximum lines to allow
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      labelStyle: GoogleFonts.inter(
                        color: Colors.grey.shade600,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Priority',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: !isDarkMode
                                ? AppColor.blackColor
                                : AppColor.whiteColor,
                          )),
                    ],
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedPriority,
                    items: _priorities.map((String priority) {
                      return DropdownMenuItem<String>(
                        value: priority,
                        child: Text(priority.capitalize()),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      _selectedPriority = value!;
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Priority',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      labelStyle: GoogleFonts.inter(
                        color: Colors.grey.shade600,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a priority';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Deadline',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: !isDarkMode
                                ? AppColor.blackColor
                                : AppColor.whiteColor,
                          )),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _deadlineController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Select Deadline',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      labelStyle: GoogleFonts.inter(
                        color: Colors.grey.shade600,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDeadline,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          final DateTime combinedDateTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          _selectedDeadline = combinedDateTime;
                          _deadlineController.text =
                              DateFormat('yyyy-MM-dd HH:mm')
                                  .format(combinedDateTime);
                        }
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a deadline';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Time to Alert',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: !isDarkMode
                                ? AppColor.blackColor
                                : AppColor.whiteColor,
                          )),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _timeToAlertController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Select Time to Alert',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      labelStyle: GoogleFonts.inter(
                        color: Colors.grey.shade600,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                    ),
                    onTap: () async {
                      Duration? pickedDuration = await showDurationPicker(
                        context: context,
                        initialTime: _selectedTimeToAlert,
                      );
                      if (pickedDuration != null) {
                        _selectedTimeToAlert = pickedDuration;
                        _timeToAlertController.text =
                            _formatDuration(pickedDuration);
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a time to alert';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  CustomElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          onSave(
                            _titleController.text,
                            _descriptionController.text,
                            _selectedPriority,
                            _selectedDeadline,
                            _selectedTimeToAlert.toString(),
                          );
                          Navigator.pop(context);
                        }
                      },
                      text: 'Add Task'),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

String _formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
}

void showTaskUpdateFormBottomSheet({
  required BuildContext context,
  required Function(
    String title,
    String description,
    String priority,
    DateTime deadline,
    String timeToAlert,
    bool is_deadline_changed,
    bool is_duration_changed,
  ) onSave,
  required TaskBloc taskBloc,
  required Task task, // Task to update
}) {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController =
      TextEditingController(text: task.title);
  final TextEditingController _descriptionController =
      TextEditingController(text: task.description);
  final TextEditingController _timeToAlertController =
      TextEditingController(text: task.timeToAlert);
  final TextEditingController _deadlineController = TextEditingController();

  final List<String> _priorities = ['low', 'medium', 'high'];
  String _selectedPriority =
      task.priority.toLowerCase(); // Pre-select current priority
  DateTime _selectedDeadline = task.deadline;
  String timeToAlertString = task.timeToAlert;

  List<String> parts = timeToAlertString.split(":");

  Duration _selectedTimeToAlert = Duration(
    hours: int.parse(parts[0]),
    minutes: int.parse(parts[1]),
    seconds: int.parse(parts[2]),
  );
  _deadlineController.text =
      DateFormat('yyyy-MM-dd HH:mm').format(task.deadline);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

      return Container(
        color: !isDarkMode
            ? AppColor.backgroundColor
            : AppColor.darkModeBackgroundColor,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Title',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: !isDarkMode
                              ? AppColor.blackColor
                              : AppColor.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    key: const Key('title_field'),
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      labelStyle: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: !isDarkMode
                              ? AppColor.blackColor
                              : AppColor.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    key: const Key('description_field'),
                    controller: _descriptionController,
                    minLines: 3, // Minimum lines to show
                    maxLines: 3, // Maximum lines to allow
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      labelStyle: TextStyle(color: Colors.grey.shade600),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Priority',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: !isDarkMode
                              ? AppColor.blackColor
                              : AppColor.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedPriority,
                    items: _priorities.map((String priority) {
                      return DropdownMenuItem<String>(
                        value: priority,
                        child: Text(priority.capitalize()),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      _selectedPriority = value!;
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Priority',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      labelStyle: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a priority';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Deadline',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: !isDarkMode
                              ? AppColor.blackColor
                              : AppColor.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _deadlineController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Select Deadline',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      labelStyle: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          final DateTime combinedDateTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          _selectedDeadline = combinedDateTime;
                          _deadlineController.text =
                              DateFormat('yyyy-MM-dd HH:mm')
                                  .format(combinedDateTime);
                        }
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a deadline';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Time to Alert',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: !isDarkMode
                              ? AppColor.blackColor
                              : AppColor.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _timeToAlertController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Select Time to Alert',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      labelStyle: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                    ),
                    onTap: () async {
                      Duration? pickedDuration = await showDurationPicker(
                        context: context,
                        initialTime: _selectedTimeToAlert,
                      );
                      if (pickedDuration != null) {
                        _selectedTimeToAlert = pickedDuration;
                        _timeToAlertController.text =
                            _formatDuration(pickedDuration);
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a time to alert';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  CustomElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        bool deadlineChanged =
                            _selectedDeadline != task.deadline;
                        bool durationChanged = _selectedTimeToAlert !=
                            Duration(
                              hours: int.parse(parts[0]),
                              minutes: int.parse(parts[1]),
                              seconds: int.parse(parts[2]),
                            );
                        onSave(
                          _titleController.text,
                          _descriptionController.text,
                          _selectedPriority,
                          _selectedDeadline,
                          _formatDuration(_selectedTimeToAlert),
                          deadlineChanged,
                          durationChanged,
                        );
                        Navigator.pop(context);
                      }
                    },
                    text: 'Update Task',
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

void _showMemberSelectionBottomSheet(
  BuildContext context,
  MemberBloc memberBloc,
  TaskBloc taskBloc,
  Task task,
) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return BlocBuilder<MemberBloc, MemberState>(
        bloc: memberBloc,
        builder: (context, state) {
          if (state is MemberLoading) {
            return _buildLoadingState();
          } else if (state is MemberLoaded) {
            return _buildLoadedState(context, state, task, taskBloc);
          } else if (state is MemberError) {
            return _buildErrorState(state);
          } else {
            return _buildUnknownState();
          }
        },
      );
    },
  );
}

Widget _buildLoadingState() {
  return Center(
    child: CircularProgressIndicator(),
  );
}

Widget _buildLoadedState(
  BuildContext context,
  MemberLoaded state,
  Task task,
  TaskBloc taskBloc,
) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'Select a Member',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Current Task Owner: ${task.taskOwner}'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      SizedBox(height: 16),
      Expanded(
        child: ListView.builder(
          itemCount: state.members.length,
          itemBuilder: (context, index) {
            Member member = state.members[index];
            bool isCurrentOwner = member.id == task.taskOwner;
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(member.name),
                  SizedBox(width: 8),
                  Icon(
                    Icons.send,
                    color: isCurrentOwner
                        ? AppColor.darkGreenColor
                        : AppColor.iconsColor,
                  ),
                ],
              ),
              onTap: () {
                Task newTask = Task(
                  taskId: task.taskId,
                  title: task.title,
                  description: task.description,
                  priority: task.priority,
                  state: task.state,
                  deadline: task.deadline,
                  timeCreated: task.timeCreated,
                  orderPosition: task.orderPosition,
                  timeToAlert: task.timeToAlert,
                  notificationSent: task.notificationSent,
                  notificationSentAlert: task.notificationSentAlert,
                  taskOwner: member.id,
                  mission: task.mission,
                );
                taskBloc.add(UpdateTask(newTask, missionId: task.mission));
                Navigator.pop(context); // Close the bottom sheet
              },
            );
          },
        ),
      ),
    ],
  );
}

Widget _buildErrorState(MemberError state) {
  return Center(
    child: Text(state.message),
  );
}

Widget _buildUnknownState() {
  return Center(
    child: Text('Unknown state'),
  );
}

Future<File?> pickFile() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        // allowedExtensions: ['jpg', 'pdf', 'doc'],
        );

    if (result != null && result.files.single.path != null) {
      PlatformFile file = result.files.first;
      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);

      File pickedFile = File(result.files.single.path!);

      return pickedFile;
    } else {
      print('No file selected');
      return null;
    }
  } catch (e) {
    print('Error picking file: $e');
    return null;
  }
}

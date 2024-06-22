// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
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
import 'package:taskplus/Model/Member.dart';
import 'package:taskplus/Model/TaskModel.dart';
import 'package:taskplus/ui/Screens/MissionDetailsScreen.dart';
import 'package:taskplus/ui/Widgets/Appbar.dart';
import 'package:taskplus/utils/colors.dart';
import 'package:taskplus/utils/link.dart';

class MyTasksScreen extends StatefulWidget {
  const MyTasksScreen();

  @override
  State<MyTasksScreen> createState() => _MyTasksScreenState();
}

class _MyTasksScreenState extends State<MyTasksScreen> {
  int? memberId;

  @override
  void initState() {
    super.initState();
    _fetchMemberId();
  }

  Future<void> _fetchMemberId() async {
    int id = await getMemberIdFromPrefs();
    setState(() {
      memberId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (memberId == null) {
      return Center(
          child: CircularProgressIndicator(
        color: AppColor.greenColor,
      ));
    }

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
            )..add(LoadTasksByMember(memberId!)),
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
        child: MyTasksPage(
          memberId: memberId!,
        ),
      ),
    );
  }
}

class MyTasksPage extends StatefulWidget {
  final int memberId;
  const MyTasksPage({
    Key? key,
    required this.memberId,
  }) : super(key: key);

  @override
  State<MyTasksPage> createState() => _MyTasksPageState();
}

class _MyTasksPageState extends State<MyTasksPage> {
  late List<Task> tasks;
  String sortBy = 'Priority'; // Default sort by priority

  @override
  void initState() {
    super.initState();
    tasks = [];
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: customAppBarwithoutleading(
        "My Tasks",
        AppColor.blackColor,
        context,
      ),
      backgroundColor:
          !isDarkMode ? AppColor.backgroundColor : AppColor.blackColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            _buildFilterDropdown(),
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
                        tasks = taskState.tasks
                            .where((task) =>
                                task.state == 'incomplete' &&
                                task.taskOwner == widget.memberId)
                            .toList();

                        // Sort tasks based on sortBy criteria
                        switch (sortBy) {
                          case 'Priority':
                            tasks.sort((a, b) =>
                                _comparePriority(a.priority, b.priority));
                            break;
                          case 'Newest':
                            tasks.sort((a, b) =>
                                b.timeCreated.compareTo(a.timeCreated));
                            break;
                          case 'Closest':
                            tasks.sort(
                                (a, b) => a.deadline.compareTo(b.deadline));
                            break;
                        }

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
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: !isDarkMode
                                      ? AppColor.whiteColor
                                      : AppColor.darkModeBackgroundColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: getStateColor(task.state),
                                              borderRadius:
                                                  BorderRadius.circular(5),
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
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: getPriorityColor(
                                                  task.priority),
                                              borderRadius:
                                                  BorderRadius.circular(5),
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
                                                color: !isDarkMode
                                                    ? AppColor.blackColor
                                                    : AppColor.whiteColor,
                                              ),
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
                                                color: !isDarkMode
                                                    ? AppColor.blackColor
                                                    : AppColor.whiteColor,
                                              ),
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
                                                color: !isDarkMode
                                                    ? AppColor.blackColor
                                                    : AppColor.whiteColor,
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
                                              color: !isDarkMode
                                                  ? AppColor.blackColor
                                                  : AppColor.whiteColor,
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
                                                color: !isDarkMode
                                                    ? AppColor.blackColor
                                                    : AppColor.whiteColor,
                                              ),
                                              softWrap: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          (task.fileAttachment == null)
                                              ? GestureDetector(
                                                  onTap: () async {
                                                    try {
                                                      File? file =
                                                          await pickFile();
                                                      if (file != null) {
                                                        await createTaskWithAttachment(
                                                            task: task,
                                                            file: file);
                                                        final taskBloc =
                                                            BlocProvider.of<
                                                                    TaskBloc>(
                                                                context);

                                                        taskBloc.add(
                                                            LoadTasksByMember(
                                                                widget
                                                                    .memberId));
                                                      } else {
                                                        print('No file picked');
                                                      }
                                                    } catch (e) {
                                                      print(
                                                          'Error creating task with attachment: $e');
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: AppColor.blueColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Attach file",
                                                          style:
                                                              GoogleFonts.inter(
                                                            color: AppColor
                                                                .whiteColor,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            width:
                                                                8), // Added a SizedBox for spacing
                                                        SizedBox(
                                                          width:
                                                              12, // Adjust the width based on your text font size
                                                          height:
                                                              12, // Adjust the height to match the icon size
                                                          child: Icon(
                                                            Icons.attach_file,
                                                            color: AppColor
                                                                .whiteColor,
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
                                                      String filePath =
                                                          await downloadFile(
                                                              task.taskId);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Download completed. File saved to: $filePath'),
                                                        ),
                                                      );
                                                      print(
                                                          'Download completed. File saved to: $filePath');
                                                    } catch (e) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Error downloading file: $e'),
                                                        ),
                                                      );
                                                      print(
                                                          'Error downloading file: $e');
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: AppColor.redColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Download file",
                                                          style:
                                                              GoogleFonts.inter(
                                                            color: AppColor
                                                                .whiteColor,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            width:
                                                                8), // Added a SizedBox for spacing
                                                        SizedBox(
                                                          width:
                                                              12, // Adjust the width based on your text font size
                                                          height:
                                                              12, // Adjust the height to match the icon size
                                                          child: Icon(
                                                            Icons
                                                                .download_rounded,
                                                            color: AppColor
                                                                .whiteColor,
                                                            size:
                                                                12, // Set the icon size to match the text font size
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: AppColor.iconsColor,
                                              borderRadius:
                                                  BorderRadius.circular(5),
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
                                                SizedBox(
                                                    width:
                                                        8), // Added a SizedBox for spacing
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
                                          GestureDetector(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Complete",
                                                    style: GoogleFonts.inter(
                                                      color:
                                                          AppColor.whiteColor,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          8), // Added a SizedBox for spacing
                                                  SizedBox(
                                                    width:
                                                        12, // Adjust the width based on your text font size
                                                    height:
                                                        12, // Adjust the height to match the icon size
                                                    child: Icon(
                                                      Icons.check_box,
                                                      color:
                                                          AppColor.whiteColor,
                                                      size:
                                                          15, // Set the icon size to match the text font size
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            onTap: () async {
                                              final taskBloc =
                                                  BlocProvider.of<TaskBloc>(
                                                      context);
                                              final memberBloc =
                                                  BlocProvider.of<MemberBloc>(
                                                      context);
                                              int statuscode =
                                                  await completeTask(
                                                      task.taskId);
                                              if (statuscode == 200) {
                                                taskBloc.add(LoadTasksByMember(
                                                    widget.memberId));
                                              } else if (statuscode == 400) {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                      dialogContext) {
                                                    return AlertDialog(
                                                      backgroundColor: !isDarkMode
                                                          ? AppColor
                                                              .backgroundColor
                                                          : AppColor.blackColor,
                                                      title: Text(
                                                        "Incomplete Tasks",
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: isDarkMode
                                                              ? AppColor
                                                                  .backgroundColor
                                                              : AppColor
                                                                  .blackColor,
                                                        ),
                                                      ),
                                                      content: Text(
                                                        "You must complete tasks in order. Please complete preceding tasks first.",
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 16,
                                                          color: isDarkMode
                                                              ? AppColor
                                                                  .backgroundColor
                                                              : AppColor
                                                                  .blackColor,
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text(
                                                            "OK",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: AppColor
                                                                    .greenColor),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    dialogContext)
                                                                .pop(); // Close the dialog
                                                          },
                                                        ),
                                                      ],
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      elevation: 10,
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: AppColor.iconsColor,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                    DateFormat(
                                                            'yyyy-MM-dd HH:mm')
                                                        .format(
                                                            task.timeCreated),
                                                    style: GoogleFonts.inter(
                                                      fontSize: 14,
                                                      color: !isDarkMode
                                                          ? AppColor.blackColor
                                                          : AppColor.whiteColor,
                                                    )),
                                                SizedBox(width: 8),
                                                Icon(
                                                  Icons.date_range_outlined,
                                                  color: !isDarkMode
                                                      ? AppColor.blackColor
                                                      : AppColor.whiteColor,
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
            SizedBox(
              height: 50,
            ),
          ]),
        ),
      ),
    );
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

  Widget _buildFilterDropdown() {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Sort by:",
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: !isDarkMode ? AppColor.blackColor : AppColor.whiteColor,
          ),
        ),
        SizedBox(width: 10),
        DropdownButton<String>(
          value: sortBy,
          icon: Icon(
            Icons.arrow_drop_down,
            size: 30,
            color: !isDarkMode ? AppColor.blackColor : AppColor.whiteColor,
          ),
          iconSize: 24,
          elevation: 16,
          style: GoogleFonts.inter(fontSize: 16, color: Colors.black),
          onChanged: (String? newValue) {
            setState(() {
              sortBy = newValue!;
            });
          },
          items: <String>['Priority', 'Newest', 'Closest']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value[0].toUpperCase() + value.substring(1),
                style: GoogleFonts.inter(
                    fontSize: 16,
                    color:
                        !isDarkMode ? AppColor.blackColor : AppColor.greenColor,
                    fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  int _comparePriority(String priority2, String priority1) {
    List<String> priorities = ['low', 'medium', 'high'];
    return priorities.indexOf(priority1) - priorities.indexOf(priority2);
  }
}

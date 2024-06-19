import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taskplus/Bloc/member/member_bloc.dart';
import 'package:taskplus/Bloc/member/member_event.dart';
import 'package:taskplus/Bloc/member/member_state.dart';
import 'package:taskplus/Bloc/task/task_bloc.dart';
import 'package:taskplus/Controller/Authentification.dart';
import 'package:taskplus/Controller/member_repo.dart';
import 'package:taskplus/Controller/task_repo.dart';
import 'package:taskplus/Model/Member.dart';
import 'package:taskplus/Model/TaskModel.dart';
import 'package:taskplus/ui/Screens/MissionDetailsScreen.dart';
import 'package:taskplus/ui/Widgets/Appbar.dart';
import 'package:taskplus/utils/colors.dart';
import 'package:taskplus/utils/link.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen();

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
      return Center(child: CircularProgressIndicator());
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
            )..add(LoadTasksByHistory(memberId!)),
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

class MyTasksPage extends StatelessWidget {
  final int memberId;
  const MyTasksPage({
    Key? key,
    required this.memberId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarwithoutleading(
        "History",
        AppColor.blackColor,
        context,
      ),
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
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

                          // Sort tasks based on sortBy criteria
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
                                    color: AppColor.whiteColor,
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
                                                color:
                                                    getStateColor(task.state),
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
                                                        color:
                                                            AppColor.blackColor,
                                                      )),
                                                  SizedBox(width: 8),
                                                  Icon(
                                                    Icons.date_range_outlined,
                                                    color: AppColor.blackColor,
                                                    size: 20,
                                                  ),
                                                ],
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
                                                  color: Colors.black,
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
                                                  color: Colors.black,
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
                                                  color: Colors.black,
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
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          color: AppColor.iconsColor,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            (task.fileAttachment == null)
                                                ? Container()
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
                                                        color:
                                                            AppColor.redColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Download file",
                                                            style: GoogleFonts
                                                                .inter(
                                                              color: AppColor
                                                                  .whiteColor,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                      Icons.comment,
                                                      color:
                                                          AppColor.whiteColor,
                                                      size:
                                                          12, // Set the icon size to match the text font size
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (task.state == 'missed')
                                              GestureDetector(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: AppColor.orangeColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "Reschedule",
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
                                                          Icons.update,
                                                          color: AppColor
                                                              .whiteColor,
                                                          size:
                                                              15, // Set the icon size to match the text font size
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onTap: () async {
                                                  DateTime selectedDeadline =
                                                      task.deadline;
                                                  final taskBloc =
                                                      BlocProvider.of<TaskBloc>(
                                                          context);

                                                  DateTime? pickedDate =
                                                      await showDatePicker(
                                                    context: context,
                                                    initialDate:
                                                        selectedDeadline,
                                                    firstDate: DateTime.now(),
                                                    lastDate: DateTime(2100),
                                                  );
                                                  if (pickedDate != null) {
                                                    TimeOfDay? pickedTime =
                                                        await showTimePicker(
                                                      context: context,
                                                      initialTime:
                                                          TimeOfDay.now(),
                                                    );
                                                    if (pickedTime != null) {
                                                      final DateTime
                                                          combinedDateTime =
                                                          DateTime(
                                                        pickedDate.year,
                                                        pickedDate.month,
                                                        pickedDate.day,
                                                        pickedTime.hour,
                                                        pickedTime.minute,
                                                      );
                                                      selectedDeadline =
                                                          combinedDateTime;
                                                      // String deadlineController =
                                                      //     DateFormat(
                                                      //             'yyyy-MM-dd HH:mm')
                                                      //         .format(
                                                      //             combinedDateTime);
                                                      print(selectedDeadline
                                                          .toIso8601String());
                                                      Task newTask = Task(
                                                          taskId: task.taskId,
                                                          title: task.title,
                                                          description:
                                                              task.description,
                                                          priority:
                                                              task.priority,
                                                          state: 'incomplete',
                                                          deadline:
                                                              selectedDeadline,
                                                          timeCreated:
                                                              task.timeCreated,
                                                          orderPosition: task
                                                              .orderPosition,
                                                          timeToAlert:
                                                              task.timeToAlert,
                                                          notificationSent:
                                                              false,
                                                          notificationSentAlert:
                                                              false,
                                                          taskOwner:
                                                              task.taskOwner,
                                                          mission:
                                                              task.mission);
                                                      taskBloc.add(UpdateTask(
                                                          newTask,
                                                          memberIdHistory:
                                                              memberId));
                                                    }
                                                  }
                                                },
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
            ],
          ),
        ),
      ),
    );
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
}

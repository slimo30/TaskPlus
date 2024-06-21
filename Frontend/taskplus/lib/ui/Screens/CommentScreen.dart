import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taskplus/Bloc/comment/comment_bloc.dart';
import 'package:taskplus/Bloc/comment/comment_event.dart';
import 'package:taskplus/Bloc/comment/comment_state.dart';
import 'package:taskplus/Bloc/member/member_bloc.dart';
import 'package:taskplus/Bloc/member/member_event.dart';
import 'package:taskplus/Bloc/member/member_state.dart';
import 'package:taskplus/Controller/Authentification.dart';
import 'package:taskplus/Controller/commrnt_repo.dart';
import 'package:taskplus/Controller/member_repo.dart';
import 'package:taskplus/Controller/task_repo.dart';
import 'package:taskplus/Controller/themeProvider.dart';
import 'package:taskplus/Model/Member.dart';
import 'package:taskplus/Model/TaskModel.dart';
import 'package:taskplus/ui/Widgets/Appbar.dart';
import 'package:taskplus/utils/colors.dart';
import 'package:taskplus/utils/link.dart';

import '../../Model/CommentModel.dart';

class CommentScreen extends StatelessWidget {
  final Task task;

  const CommentScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MemberRepository>(
          create: (context) => MemberRepository(baseurl),
        ),
        RepositoryProvider<CommentRepository>(
          create: (context) => CommentRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<CommentBloc>(
            create: (context) => CommentBloc(
              repository: RepositoryProvider.of<CommentRepository>(context),
            )..add(FetchComments(task.taskId)),
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
        child: CommentPage(task: task),
      ),
    );
  }
}

class CommentPage extends StatelessWidget {
  final Task task;
  const CommentPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: customAppBar("Comments", AppColor.blackColor, context),
      backgroundColor:
          !isDarkMode ? AppColor.backgroundColor : AppColor.blackColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Existing widgets for displaying task details and comments list
              BlocBuilder<MemberBloc, MemberState>(
                builder: (context, memberstate) {
                  if (memberstate is MemberLoading) {
                    return Center(
                      child:
                          CircularProgressIndicator(color: AppColor.greenColor),
                    );
                  } else if (memberstate is MemberLoaded) {
                    final members = memberstate.members;
                    final member =
                        members.firstWhere((mem) => mem.id == task.taskOwner);
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Task details and state
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
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
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                task.title,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: !isDarkMode
                                      ? AppColor.blackColor
                                      : AppColor.whiteColor,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                task.description,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: !isDarkMode
                                      ? AppColor.blackColor
                                      : AppColor.whiteColor,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Task owner: ${member.name}",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: !isDarkMode
                                      ? AppColor.blackColor
                                      : AppColor.whiteColor,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Deadline: ${DateFormat('yyyy-MM-dd HH:mm').format(task.deadline)}",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: !isDarkMode
                                      ? AppColor.blackColor
                                      : AppColor.whiteColor,
                                ),
                              ),
                              const Divider(color: AppColor.iconsColor),
                              Row(
                                children: [
                                  if (task.fileAttachment != null)
                                    GestureDetector(
                                      onTap: () async {
                                        try {
                                          String filePath =
                                              await downloadFile(task.taskId);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Download completed. File saved to: $filePath'),
                                            ),
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Error downloading file: $e'),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColor.redColor,
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                            const SizedBox(width: 8),
                                            const Icon(
                                              Icons.download_rounded,
                                              color: AppColor.whiteColor,
                                              size: 12,
                                            ),
                                          ],
                                        ),
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
                                            color: !isDarkMode
                                                ? AppColor.blackColor
                                                : AppColor.whiteColor,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
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
                  } else {
                    return Container();
                  }
                },
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Comments",
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
              const SizedBox(height: 5),
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: BlocBuilder<CommentBloc, CommentState>(
                    builder: (BuildContext context, CommentState commentState) {
                      return BlocBuilder<MemberBloc, MemberState>(
                        builder:
                            (BuildContext context, MemberState memberstate) {
                          if (commentState is CommentLoading ||
                              memberstate is MemberLoading) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColor.greenColor,
                              ),
                            );
                          } else if (commentState is CommentLoaded &&
                              memberstate is MemberLoaded) {
                            final members = memberstate.members;
                            final comments = commentState.comments;

                            return ListView.builder(
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                final comment = comments[index];
                                final commenter = members.firstWhere(
                                  (mem) => mem.id == comment.employee,
                                  orElse: () => Member(
                                      id: 0,
                                      username: "Unknown",
                                      superuser: false,
                                      name: "Unknown"),
                                );

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
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SvgPicture.asset(
                                                !isDarkMode
                                                    ? 'assets/images/profile.svg'
                                                    : 'assets/images/profile2.svg',
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                commenter.name,
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
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                comment.text,
                                                style: GoogleFonts.inter(
                                                  fontSize: 17,
                                                  color: !isDarkMode
                                                      ? AppColor.blackColor
                                                      : AppColor.whiteColor,
                                                ),
                                                softWrap: true,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                DateFormat('yyyy-MM-dd HH:mm')
                                                    .format(comment.timePosted),
                                                style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  color: !isDarkMode
                                                      ? AppColor.blackColor
                                                      : AppColor.whiteColor,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Icon(
                                                Icons.date_range_outlined,
                                                color: !isDarkMode
                                                    ? AppColor.blackColor
                                                    : AppColor.whiteColor,
                                                size: 20,
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
                            return Container(
                              child: Text(
                                'No comments available',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
              CommentInput(
                onSubmit: (commentString, dateCreated) async {
                  int empId = await getMemberIdFromPrefs();
                  BlocProvider.of<CommentBloc>(context).add(
                    CreateComment(Comment(
                        task: task.taskId,
                        text: commentString,
                        timePosted: dateCreated,
                        employee: empId,
                        id: 0)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
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

class CommentInput extends StatefulWidget {
  final Function(String, DateTime) onSubmit;

  const CommentInput({super.key, required this.onSubmit});

  @override
  _CommentInputState createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              style: GoogleFonts.inter(
                color: !isDarkMode ? AppColor.blackColor : AppColor.whiteColor,
              ),
              decoration: InputDecoration(
                hintText: 'Add comments...',
                hintStyle: GoogleFonts.inter(
                  color:
                      !isDarkMode ? AppColor.blackColor : AppColor.whiteColor,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                // Reduced height
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0), // Rounded corners
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0), // Space between TextField and IconButton
          IconButton(
            onPressed: () {
              final text = _textController.text.trim();
              if (text.isNotEmpty) {
                widget.onSubmit(text, DateTime.now());
                _textController.clear();
              }
            },
            icon: const Icon(Icons.send, color: AppColor.greenColor),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

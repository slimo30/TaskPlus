import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:taskplus/Bloc/member/member_bloc.dart';
import 'package:taskplus/Bloc/member/member_event.dart';
import 'package:taskplus/Bloc/member/member_state.dart';
import 'package:taskplus/Controller/Authentification.dart';
import 'package:taskplus/Controller/member_repo.dart';
import 'package:taskplus/Controller/themeProvider.dart';
import 'package:taskplus/Model/Member.dart';
import 'package:taskplus/ui/Widgets/Appbar.dart';
import 'package:taskplus/utils/colors.dart';
import 'package:taskplus/utils/link.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen();

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
        ),
      );
    }

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MemberRepository>(
          create: (context) =>
              MemberRepository(baseurl), // Replace with your baseurl
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<MemberBloc>(
            create: (context) {
              final memberRepository =
                  RepositoryProvider.of<MemberRepository>(context);
              return MemberBloc(memberRepository: memberRepository)
                ..add(FetchMembers());
            },
          ),
        ],
        child: SettingsPage(
          memberId: memberId!,
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  final int memberId;
  const SettingsPage({super.key, required this.memberId});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: customAppBar(
        "Settings",
        AppColor.blackColor,
        context,
      ),
      backgroundColor:
          !isDarkMode ? AppColor.backgroundColor : AppColor.blackColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    color: !isDarkMode
                        ? AppColor.whiteColor
                        : AppColor.darkModeBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),

                        spreadRadius: 4,
                        blurRadius: 6,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: BlocBuilder<MemberBloc, MemberState>(
                    builder: (context, memberstate) {
                      if (memberstate is MemberLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColor.greenColor,
                          ),
                        );
                      } else if (memberstate is MemberLoaded) {
                        final members = memberstate.members;
                        final owner =
                            members.firstWhere((mem) => mem.id == memberId);
                        return Container(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Image(
                                      image:
                                          AssetImage('assets/images/Logo.png'),
                                      width: 40,
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            '${owner.name}',
                                            style: GoogleFonts.inter(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: !isDarkMode
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Account Settings',
                                      style: GoogleFonts.inter(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor
                                            .darkModeBackgroundAccentColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Change workspace name',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: !isDarkMode
                                              ? AppColor.blackColor
                                              : Colors.white,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 16,
                                        color: !isDarkMode
                                            ? AppColor.blackColor
                                            : Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Change password',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: !isDarkMode
                                              ? AppColor.blackColor
                                              : Colors.white,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 16,
                                        color: !isDarkMode
                                            ? AppColor.blackColor
                                            : Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Dark mode',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: !isDarkMode
                                            ? AppColor.blackColor
                                            : Colors.white,
                                      ),
                                    ),
                                    Switch(
                                      value: isDarkMode,
                                      onChanged: (value) {
                                        Provider.of<ThemeProvider>(context,
                                                listen: false)
                                            .toggleTheme();
                                      },
                                      activeColor: AppColor.greenColor,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Logout',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: !isDarkMode
                                              ? AppColor.blackColor
                                              : Colors.white,
                                        ),
                                      ),
                                      Icon(
                                        Icons.logout,
                                        size: 20,
                                        color: AppColor.redColor,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'More',
                                      style: GoogleFonts.inter(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: !isDarkMode
                                            ? AppColor.iconsColor
                                            : AppColor
                                                .darkModeBackgroundAccentColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'About us',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: !isDarkMode
                                              ? AppColor.blackColor
                                              : Colors.white,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 16,
                                        color: !isDarkMode
                                            ? AppColor.blackColor
                                            : Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Privacy policy',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: !isDarkMode
                                              ? AppColor.blackColor
                                              : Colors.white,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 16,
                                        color: !isDarkMode
                                            ? AppColor.blackColor
                                            : Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Terms and conditions',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: !isDarkMode
                                              ? AppColor.blackColor
                                              : Colors.white,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 16,
                                        color: !isDarkMode
                                            ? AppColor.blackColor
                                            : Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                if (owner.superuser)
                                  Container(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Super User Access',
                                                style: GoogleFonts.inter(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: !isDarkMode
                                                      ? AppColor.iconsColor
                                                      : AppColor
                                                          .darkModeBackgroundAccentColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: members.length,
                                            itemBuilder: (context, index) {
                                              final member = members[index];
                                              final memberBloc =
                                                  BlocProvider.of<MemberBloc>(
                                                      context);

                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '${member.name}',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: !isDarkMode
                                                          ? AppColor.blackColor
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                  Switch(
                                                    value: member.superuser,
                                                    onChanged: (bool value) {
                                                      Member newMember = Member(
                                                          id: member.id,
                                                          username:
                                                              member.username,
                                                          superuser: value,
                                                          name: member.name,
                                                          workspace:
                                                              member.workspace,
                                                          deviceToken: member
                                                              .deviceToken);
                                                      memberBloc.add(
                                                          UpdateMember(
                                                              newMember));
                                                    },
                                                    activeColor:
                                                        AppColor.greenColor,
                                                  ),
                                                ],
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

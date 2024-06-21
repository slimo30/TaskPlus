import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taskplus/Bloc/category/category_bloc.dart';
import 'package:taskplus/Bloc/category/category_event.dart';
import 'package:taskplus/Bloc/category/category_state.dart';
import 'package:taskplus/Bloc/mission/mission_bloc.dart';
import 'package:taskplus/Bloc/mission/mission_event.dart';
import 'package:taskplus/Bloc/mission/mission_state.dart';
import 'package:taskplus/Controller/Authentification.dart';
import 'package:taskplus/Controller/MmberServices.dart';
import 'package:taskplus/Controller/category_repo.dart';
import 'package:taskplus/Controller/mission_repo.dart';
import 'package:taskplus/Controller/themeProvider.dart';
import 'package:taskplus/Controller/workspaceService.dart';
import 'package:taskplus/Model/Category.dart';
import 'package:taskplus/Model/Member.dart';
import 'package:taskplus/Model/Messions.dart';
import 'package:taskplus/Model/workspace.dart';
import 'package:taskplus/ui/Screens/MissionDetailsScreen.dart';
import 'package:taskplus/ui/Screens/settingsScreen.dart';
import 'package:taskplus/ui/Widgets/Button.dart';
import 'package:taskplus/utils/TextStyle.dart';
import 'package:taskplus/utils/colors.dart';
import 'package:taskplus/ui/Widgets/Appbar.dart';
import 'package:taskplus/utils/link.dart';

class MissionScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => MissionRepository()),
        RepositoryProvider(create: (context) => CategoryRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MissionBloc(
              missionRepository:
                  RepositoryProvider.of<MissionRepository>(context),
            )..add(LoadMissions()),
          ),
          BlocProvider(
            create: (context) => CategoryBloc(
              categoryRepository:
                  RepositoryProvider.of<CategoryRepository>(context),
            )..add(LoadCategories()),
          ),
        ],
        child: MissionScreen(),
      ),
    );
  }
}

class MissionScreen extends StatefulWidget {
  const MissionScreen({Key? key}) : super(key: key);

  @override
  _MissionScreenState createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  @override
  void initState() {
    super.initState();
    loadMemberAndWorkspaceData();
  }

  void loadMemberAndWorkspaceData() async {
    try {
      int memberId = await getMemberIdFromPrefs();
      MemberService memberService = MemberService(baseUrl: baseurl);
      Member memberModel = await memberService.getMember(memberId);
      String truncatedUsername = memberModel.name.substring(0, 7);

      setState(() {
        username = truncatedUsername;
      });

      int workspaceId = await getWorkspaceId();
      Workspace workspaceModel =
          await WorkspaceService.fetchWorkspace(workspaceId);
      setState(() {
        workspace = workspaceModel.name;
      });
    } catch (e) {
      print('Error in initState: $e');
    }
  }

  String username = "";
  String workspace = "";

  String? selectedCategory;
  String? selectedPriority;
  bool orderedOnly = false;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: customAppBarWithoutLeadingWithActions(
        "Missions",
        AppColor.blackColor,
        context,
        () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsScreen(),
              ));
        },
      ),
      backgroundColor:
          !isDarkMode ? AppColor.backgroundColor : AppColor.blackColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 110,
                child: Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      width: MediaQuery.of(context).size.width * 0.55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color:
                              !isDarkMode ? AppColor.blackColor : Colors.white,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Hello, $username",
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: !isDarkMode
                                  ? AppColor.blackColor
                                  : Colors.white,
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Image(
                                      image:
                                          AssetImage('assets/images/Logo.png'),
                                      width: 35,
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Start working at , ",
                                              style: GoogleFonts.inter(
                                                color: !isDarkMode
                                                    ? AppColor.blackColor
                                                    : Colors.white,
                                              ),
                                            ),
                                            TextSpan(
                                              text: workspace,
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                                color: !isDarkMode
                                                    ? AppColor.blackColor
                                                    : Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () async {
                        int workspaceId = await getWorkspaceId();
                        final categoryBloc =
                            BlocProvider.of<CategoryBloc>(context);
                        final missionBloc =
                            BlocProvider.of<MissionBloc>(context);
                        showMissionFormBottomSheet(
                          context: context,
                          onSave: (title, priority, ordered, category) {
                            context.read<MissionBloc>().add(AddMission(
                                  Mission(
                                    id: 0,
                                    title: title,
                                    priority: priority,
                                    ordered: ordered,
                                    timeCreated: DateTime.now(),
                                    category: category,
                                    workspace: workspaceId,
                                  ),
                                ));
                          },
                          categoryBloc: categoryBloc,
                          missionBloc: missionBloc,
                        );
                        print(DateTime.now().toIso8601String());
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        width: MediaQuery.of(context).size.width * 0.30,
                        decoration: BoxDecoration(
                          color: AppColor.greenColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColor.whiteColor,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: AppColor.greenColor,
                                ),
                              ),
                              SizedBox(height: 13),
                              Text(
                                "New Mission",
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text("Filters",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: !isDarkMode ? AppColor.blackColor : Colors.white,
                  )),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      iconEnabledColor: AppColor.greenColor,
                      hint: Text("Category"),
                      value: selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                      items: buildCategoryDropdownItems(context),
                    ),
                  ),
                  Expanded(
                    child: DropdownButton<String>(
                      iconEnabledColor: AppColor.greenColor,
                      hint: Text("Priority"),
                      value: selectedPriority,
                      onChanged: (value) {
                        setState(() {
                          selectedPriority = value;
                        });
                      },
                      items: buildPriorityDropdownItems(),
                    ),
                  ),
                  SizedBox(width: 10),
                  Checkbox(
                    side: BorderSide(
                        color: isDarkMode
                            ? AppColor.whiteColor
                            : AppColor.blackColor,
                        width: 2),
                    value: orderedOnly,
                    activeColor: AppColor.greenColor,
                    onChanged: (value) {
                      setState(() {
                        orderedOnly = value ?? false;
                      });
                    },
                  ),
                  Text(
                    "Ordered Only",
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: !isDarkMode
                            ? AppColor.blackColor
                            : AppColor.whiteColor),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text("Missions",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: !isDarkMode ? AppColor.blackColor : Colors.white,
                  )),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: BlocBuilder<MissionBloc, MissionState>(
                    builder: (context, missionState) {
                      return BlocBuilder<CategoryBloc, CategoryState>(
                        builder: (context, categoryState) {
                          if (missionState is MissionLoadInProgress ||
                              categoryState is CategoryLoadInProgress) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColor.greenColor,
                              ),
                            );
                          } else if (missionState is MissionLoadSuccess &&
                              categoryState is CategoryLoadSuccess) {
                            final missions =
                                missionState.missions.where((mission) {
                              return (selectedCategory == null ||
                                      mission.category.toString() ==
                                          selectedCategory) &&
                                  (selectedPriority == null ||
                                      mission.priority.toLowerCase() ==
                                          selectedPriority!.toLowerCase()) &&
                                  (!orderedOnly || mission.ordered);
                            }).toList();

                            final categories = categoryState.categories;

                            return ListView.builder(
                              itemCount: missions.length,
                              itemBuilder: (context, index) {
                                final mission = missions[index];
                                final category = categories.firstWhere(
                                  (category) => category.id == mission.category,
                                  orElse: () => Category(
                                    id: 0,
                                    name: 'Unknown',
                                    color: '#000000',
                                    workspace: 0,
                                  ),
                                );

                                return MissionBody(context, mission, category);
                              },
                            );
                          } else if (missionState is MissionOperationFailure ||
                              categoryState is CategoryOperationFailure) {
                            return Center(
                              child: Text(
                                'Failed to load missions: ${missionState is MissionOperationFailure ? missionState.error : ''}\nFailed to load categories: ${categoryState is CategoryOperationFailure ? categoryState.error : ''}',
                              ),
                            );
                          } else {
                            return Center(child: Text('No Missions'));
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector MissionBody(
      BuildContext context, Mission mission, Category category) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MissionDetailsScreen(
                mission: mission,
                category: category,
              ),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          decoration: BoxDecoration(
            color: !isDarkMode
                ? AppColor.whiteColor
                : AppColor.darkModeBackgroundColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  mission.title,
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: !isDarkMode
                          ? AppColor.blackColor
                          : AppColor.whiteColor),
                ),
                trailing: Icon(Icons.arrow_forward),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showDeleteConfirmationDialog(context, mission.id);
                          },
                          child: Icon(
                            Icons.delete,
                            color: AppColor.redColor,
                          ),
                        ),
                        SizedBox(width: 16),
                        GestureDetector(
                          onTap: () {
                            showEditMissionFormBottomSheet(
                              context: context,
                              mission: mission,
                              onSave: (String title, String priority,
                                  int category) {
                                context.read<MissionBloc>().add(
                                      UpdateMission(
                                        Mission(
                                          id: mission.id,
                                          title: title,
                                          priority: priority,
                                          ordered: mission.ordered,
                                          timeCreated: mission.timeCreated,
                                          category: category,
                                          workspace: mission.workspace,
                                        ),
                                      ),
                                    );
                              },
                            );
                          },
                          child: Icon(
                            Icons.edit,
                            color: AppColor.orangeColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          DateFormat('yyyy-MM-dd HH:mm')
                              .format(mission.timeCreated),
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: !isDarkMode
                                  ? AppColor.blackColor
                                  : AppColor.whiteColor),
                        ),
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
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: getPriorityColor(mission.priority),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(mission.priority,
                          style: GoogleFonts.inter(
                            color: AppColor.whiteColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(int.parse(
                            category.color.replaceFirst('#', '0xff'))),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(category.name,
                          style: GoogleFonts.inter(
                            color: getTextColor(Color(int.parse(
                                category.color.replaceFirst('#', '0xff')))),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    SizedBox(width: 8),
                    mission.ordered
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColor.greenColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text('Ordered',
                                style: GoogleFonts.inter(
                                  color: AppColor.whiteColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                )),
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> buildCategoryDropdownItems(
      BuildContext context) {
    List<DropdownMenuItem<String>> items = [];

    items.add(
      DropdownMenuItem(
        value: null,
        child: Text(
          "All",
          style: TextStyle(
            color: AppColor.greenColor,
          ),
        ),
      ),
    );

    final categoryState = context.read<CategoryBloc>().state;
    if (categoryState is CategoryLoadSuccess) {
      items.addAll(categoryState.categories.map((category) {
        return DropdownMenuItem<String>(
          value: category.id.toString(),
          child: Text(
            category.name,
            style: TextStyle(
              color: AppColor.blackColor,
            ),
          ),
        );
      }).toList());
    }

    return items;
  }

  List<DropdownMenuItem<String>> buildPriorityDropdownItems() {
    List<DropdownMenuItem<String>> items = [];

    items.add(
      DropdownMenuItem(
        value: null,
        child: Text(
          "All",
          style: TextStyle(
            color: AppColor.greenColor,
          ),
        ),
      ),
    );

    items.addAll(["low", "medium", "high"].map((priority) {
      return DropdownMenuItem<String>(
        value: priority,
        child: Text(priority.capitalize()),
      );
    }).toList());

    return items;
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

  void _showDeleteConfirmationDialog(BuildContext context, int missionId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

        return AlertDialog(
          backgroundColor:
              isDarkMode ? AppColor.blackColor : AppColor.whiteColor,
          title: Text(
            "Delete Mission",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: !isDarkMode ? AppColor.blackColor : AppColor.whiteColor,
            ),
          ),
          content: Text(
            "Are you sure you want to delete this mission?",
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
                BlocProvider.of<MissionBloc>(context)
                    .add(DeleteMission(missionId));
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 10,
        );
      },
    );
  }

  void showMissionFormBottomSheet({
    required BuildContext context,
    required CategoryBloc categoryBloc,
    required MissionBloc missionBloc,
    required Function(
      String title,
      String priority,
      bool ordered,
      int category,
    ) onSave,
  }) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _categoryController = TextEditingController();

    // Priority options
    final List<String> _priorities = ['low', 'medium', 'high'];
    String _selectedPriority = 'low';
    bool _ordered = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BlocProvider.value(
          value: categoryBloc,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<CategoryBloc>.value(value: categoryBloc),
            ],
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    bool isDarkMode =
                        Provider.of<ThemeProvider>(context).isDarkMode;

                    return Container(
                      color: isDarkMode
                          ? AppColor.blackColor
                          : AppColor.whiteColor,
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
                                              : AppColor.whiteColor),
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
                                    Text(
                                      'Priority',
                                      style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: !isDarkMode
                                              ? AppColor.blackColor
                                              : AppColor.whiteColor),
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
                                    setState(() {
                                      _selectedPriority = value!;
                                    });
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
                                    Text(
                                      'Category',
                                      style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: !isDarkMode
                                              ? AppColor.blackColor
                                              : AppColor.whiteColor),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  child: IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          flex: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: state is CategoryLoadSuccess
                                                ? DropdownButtonFormField<int>(
                                                    value: null,
                                                    items: state.categories
                                                        .map((category) {
                                                      return DropdownMenuItem<
                                                          int>(
                                                        value: category.id,
                                                        child:
                                                            Text(category.name),
                                                      );
                                                    }).toList(),
                                                    onChanged: (int? value) {
                                                      setState(() {
                                                        _categoryController
                                                                .text =
                                                            value.toString();
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Select Category',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          Colors.grey.shade200,
                                                      labelStyle:
                                                          GoogleFonts.inter(
                                                        color: Colors
                                                            .grey.shade600,
                                                      ),
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 10.0,
                                                      ),
                                                    ),
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return 'Please select a category';
                                                      }
                                                      return null;
                                                    },
                                                  )
                                                : Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            child: IconButton(
                                              onPressed: () {
                                                final categoryBloc =
                                                    BlocProvider.of<
                                                        CategoryBloc>(context);
                                                showColorPickerDialog(
                                                    context, categoryBloc);
                                              },
                                              icon: Icon(
                                                Icons.add,
                                                color: AppColor.greenColor,
                                              ),
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Ordered',
                                      style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: !isDarkMode
                                              ? AppColor.blackColor
                                              : AppColor.whiteColor),
                                    ),
                                    Switch(
                                      value: _ordered,
                                      onChanged: (bool value) {
                                        setState(() {
                                          _ordered = value;
                                        });
                                      },
                                      activeColor: AppColor.greenColor,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                CustomElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      onSave(
                                        _titleController.text,
                                        _selectedPriority,
                                        _ordered,
                                        int.parse(_categoryController.text),
                                      );
                                      Navigator.pop(context);
                                    }
                                  },
                                  text: 'Add Mission',
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
              },
            ),
          ),
        );
      },
    );
  }

  void showEditMissionFormBottomSheet({
    required BuildContext context,
    required Mission mission,
    required Function(
      String title,
      String priority,
      int category,
    ) onSave,
  }) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _titleController =
        TextEditingController(text: mission.title);
    final TextEditingController _categoryController =
        TextEditingController(text: mission.category.toString());

    // Priority options
    final List<String> _priorities = ['low', 'medium', 'high'];
    String _selectedPriority = mission.priority;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider<MissionRepository>(
              create: (context) => MissionRepository(),
            ),
            RepositoryProvider<CategoryRepository>(
              create: (context) => CategoryRepository(),
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<CategoryBloc>(
                create: (context) {
                  final CategoryBloc _categoryBloc = CategoryBloc(
                    categoryRepository:
                        RepositoryProvider.of<CategoryRepository>(context),
                  );
                  _categoryBloc.add(LoadCategories());
                  return _categoryBloc;
                },
              ),
            ],
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                bool isDarkMode =
                    Provider.of<ThemeProvider>(context).isDarkMode;

                return Container(
                  color: isDarkMode ? AppColor.blackColor : AppColor.whiteColor,
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Padding(
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
                                        color: AppColor.blackColor,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: AppColor.secondColor,
                                    labelStyle: GoogleFonts.inter(
                                      color: AppColor.iconsColor,
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
                                      'Priority',
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
                                DropdownButtonFormField<String>(
                                  value: _selectedPriority,
                                  items: _priorities.map((String priority) {
                                    return DropdownMenuItem<String>(
                                      value: priority,
                                      child: Text(priority.capitalize()),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedPriority = value!;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Select Priority',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: const BorderSide(
                                        color: AppColor.blackColor,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: AppColor.secondColor,
                                    labelStyle: GoogleFonts.inter(
                                      color: AppColor.iconsColor,
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
                                      'Category',
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
                                state is CategoryLoadSuccess
                                    ? DropdownButtonFormField<int>(
                                        value: mission.category,
                                        items: state.categories.map((category) {
                                          return DropdownMenuItem<int>(
                                            value: category.id,
                                            child: Text(category.name),
                                          );
                                        }).toList(),
                                        onChanged: (int? value) {
                                          setState(() {
                                            _categoryController.text =
                                                value.toString();
                                          });
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Select Category',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: const BorderSide(
                                              color: AppColor.blackColor,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: AppColor.secondColor,
                                          labelStyle: GoogleFonts.inter(
                                            color: AppColor.iconsColor,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 10.0,
                                            horizontal: 10.0,
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please select a category';
                                          }
                                          return null;
                                        },
                                      )
                                    : CircularProgressIndicator(),
                                SizedBox(height: 20),
                                CustomElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      onSave(
                                        _titleController.text,
                                        _selectedPriority,
                                        int.parse(_categoryController.text),
                                      );
                                      Navigator.pop(context);
                                    }
                                  },
                                  text: 'Update Mission',
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> showColorPickerDialog(
      BuildContext context, CategoryBloc categoryBloc) async {
    Color selectedColor = Colors.blue; // Default color
    TextEditingController categoryNameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

        return BlocProvider.value(
          value: categoryBloc,
          child: AlertDialog(
            backgroundColor:
                isDarkMode ? AppColor.blackColor : AppColor.whiteColor,
            title: Text(
              'Add New Category',
              style: GoogleFonts.inter(
                color: !isDarkMode ? AppColor.blackColor : AppColor.whiteColor,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Category Name:',
                    style: GoogleFonts.inter(
                      color: !isDarkMode
                          ? AppColor.blackColor
                          : AppColor.whiteColor,
                    ),
                  ),
                  TextFormField(
                    controller: categoryNameController,
                    style: GoogleFonts.inter(
                      color: !isDarkMode
                          ? AppColor.blackColor
                          : AppColor.whiteColor,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter category name',
                      hintStyle: GoogleFonts.inter(
                        color: !isDarkMode
                            ? AppColor.blackColor
                            : AppColor.whiteColor,
                      ),
                      errorStyle: GoogleFonts.inter(color: Colors.red),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Category Color:',
                    style: GoogleFonts.inter(
                      color: !isDarkMode
                          ? AppColor.blackColor
                          : AppColor.whiteColor,
                    ),
                  ),
                  BlockPicker(
                    pickerColor: selectedColor,
                    onColorChanged: (Color color) {
                      selectedColor = color;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.inter(
                    color: AppColor.redColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  // Validate and save category
                  if (categoryNameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please enter category name',
                          style: GoogleFonts.inter(
                            color: !isDarkMode
                                ? AppColor.blackColor
                                : AppColor.whiteColor,
                          ),
                        ),
                      ),
                    );
                    return;
                  }
                  var workspaceId = await getWorkspaceId();
                  String colorHex = '#' +
                      selectedColor.value
                          .toRadixString(16)
                          .substring(2)
                          .toUpperCase();
                  print(colorHex);

                  final newCategory = Category(
                    id: 0, // Adjust according to your data model
                    name: categoryNameController.text,
                    color: colorHex,
                    workspace:
                        workspaceId, // Assuming you have a function to get workspace ID
                  );

                  // Add category using Bloc
                  categoryBloc.add(AddCategory(newCategory));

                  // Close dialog
                  Navigator.of(context).pop();
                },
                child: Text('Add Category',
                    style: GoogleFonts.inter(
                      color: AppColor.greenColor,
                    )),
              ),
            ],
          ),
        );
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/widgets/snackbars.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/home/cubit/tasks_cubit.dart';
import 'package:frontend/features/home/pages/home_page.dart';
import 'package:frontend/generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class AddNewTaskPage extends StatefulWidget {
  static const routeName = '/addNewTask';
  const AddNewTaskPage({super.key});

  @override
  State<AddNewTaskPage> createState() => _AddNewTaskPageState();
}

class _AddNewTaskPageState extends State<AddNewTaskPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  Color selectedColor = const Color.fromRGBO(246, 222, 194, 1);
  final formKey = GlobalKey<FormState>();
  final GlobalKey _titleKey = GlobalKey();
  final GlobalKey _descriptionKey = GlobalKey();
  final GlobalKey _colorKey = GlobalKey();
  final GlobalKey _dateKey = GlobalKey();
  bool _showShowcase = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowShowcase();
    });
  }

  Future<void> _checkAndShowShowcase() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    _showShowcase = !(prefs.getBool('hasSeenAddTaskShowcase') ?? false);

    if (_showShowcase) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          ShowCaseWidget.of(context).startShowCase([
            _titleKey,
            _descriptionKey,
            _colorKey,
            _dateKey,
          ]);
          prefs.setBool('hasSeenAddTaskShowcase', true);
        }
      });
    }
  }

  void createNewTask() async {
    if (formKey.currentState!.validate()) {
      AuthLoggedIn user = context.read<AuthCubit>().state as AuthLoggedIn;
      context.read<TasksCubit>().createTask(
            title: titleController.text.trim(),
            description: descriptionController.text.trim(),
            color: selectedColor,
            token: user.user.token,
            uid: user.user.id,
            dueAt: selectedDate,
          );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.addTask),
        actions: [
          Showcase(
            key: _dateKey,
            description: S.current.selectDueDateShowcase,
            child: GestureDetector(
              onTap: () async {
                final selectedDateValue = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 90)),
                );

                if (selectedDateValue != null) {
                  setState(() {
                    selectedDate = selectedDateValue;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  DateFormat("MM-d-y").format(selectedDate),
                ),
              ),
            ),
          )
        ],
      ),
      body: BlocConsumer<TasksCubit, TasksState>(
        listener: (context, state) {
          if (state is TasksError) {
            AppSnackbars.showErrorSnackbar(context, message: state.error);
          } else if (state is AddNewTaskSuccess) {
            AppSnackbars.showSuccessSnackbar(context,
                message: S.current.addTaskSuccess);
            Navigator.pushNamedAndRemoveUntil(
                context, HomePage.routeName, (_) => false);
          }
        },
        builder: (context, state) {
          if (state is TasksLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  spacing: 10,
                  children: [
                    Showcase(
                      key: _titleKey,
                      description: S.current.enterTaskTitleShowcase,
                      child: TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          hintText: S.current.title,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return S.current.titleEmpty;
                          }
                          return null;
                        },
                      ),
                    ),
                    Showcase(
                      key: _descriptionKey,
                      description: S.current.enterTaskDescriptionShowcase,
                      child: TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          hintText: S.current.description,
                        ),
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return S.current.descriptionEmpty;
                          }
                          return null;
                        },
                      ),
                    ),
                    Showcase(
                      key: _colorKey,
                      description: S.current.selectColorforTask,
                      child: ColorPicker(
                        heading: Text(S.current.selectColor),
                        subheading: Text(S.current.selectShade),
                        onColorChanged: (Color color) {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                        color: selectedColor,
                        pickersEnabled: const <ColorPickerType, bool>{
                          ColorPickerType.both: false,
                          ColorPickerType.primary: true,
                          ColorPickerType.accent: false,
                          ColorPickerType.bw: false,
                          ColorPickerType.custom: false,
                          ColorPickerType.wheel: true,
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: createNewTask,
                      child: Text(S.current.save.toUpperCase(),
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                  )),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

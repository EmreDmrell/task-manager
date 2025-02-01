import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/home/cubit/tasks_cubit.dart';
import 'package:frontend/features/home/pages/home_page.dart';
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
        title: const Text("Add New Task"),
        actions: [
          Showcase(
            key: _dateKey,
            description: 'Tap here to select due date',
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is AddNewTaskSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Task added successfully!")),
            );
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
              child: Column(
                spacing: 10,
                children: [
                  Showcase(
                    key: _titleKey,
                    description: 'Enter your task title here',
                    child: TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Title cannot be empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  Showcase(
                    key: _descriptionKey,
                    description: 'Enter your task description here',
                    child: TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Description',
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Description cannot be empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  Showcase(
                    key: _colorKey,
                    description: 'Select a color for your task',
                    child: ColorPicker(
                      heading: const Text('Select Color'),
                      subheading: const Text('Select a different shade'),
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
                    child: const Text(
                      'SUBMIT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

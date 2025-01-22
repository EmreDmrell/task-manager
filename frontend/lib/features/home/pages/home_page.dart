import 'package:flutter/material.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/features/home/widgets/date_selector.dart';
import 'package:frontend/features/home/widgets/task_card.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Tasks"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Column(
          children: [
            DateSelector(
              selectedDate: selectedDate,
              onTap: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Row(
                    children: [
                      Expanded(
                        child: TaskCard(
                          color: task['color'] as Color,
                          headerText: task['headerText'] as String,
                          descriptionText: task['descriptionText'] as String,
                        ),
                      ),
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: strengthenColor(
                            task['color'] as Color,
                            0.69,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          DateFormat.jm().format(task['dueAt'] as DateTime),
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ));
  }
}

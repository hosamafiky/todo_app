// ignore_for_file: avoid_print
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class NewTasksScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is ChangeBottomSheetState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'New Tasks',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    );
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) {
                          return Form(
                            key: formKey,
                            child: Container(
                              padding: const EdgeInsets.all(20.0),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomFormField(
                                    controller: titleController,
                                    type: TextInputType.text,
                                    validateFunc: (value) {
                                      if (value!.isEmpty) {
                                        return 'Task title is required!';
                                      }
                                      return null;
                                    },
                                    label: 'Task Title',
                                    prefix: Icons.title,
                                  ),
                                  const SizedBox(height: 10.0),
                                  CustomFormField(
                                    controller: timeController,
                                    type: TextInputType.datetime,
                                    onFieldTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timeController.text =
                                            value!.format(context);
                                      });
                                    },
                                    validateFunc: (value) {
                                      if (value!.isEmpty) {
                                        return 'Task time is required!';
                                      }
                                      return null;
                                    },
                                    label: 'Task Time',
                                    prefix: Icons.watch_later_outlined,
                                  ),
                                  const SizedBox(height: 10.0),
                                  CustomFormField(
                                    controller: dateController,
                                    type: TextInputType.datetime,
                                    onFieldTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2050),
                                      ).then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    validateFunc: (value) {
                                      if (value!.isEmpty) {
                                        return 'Task date is required!';
                                      }
                                      return null;
                                    },
                                    label: 'Task date',
                                    prefix: Icons.calendar_month_outlined,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        elevation: 15.0,
                      )
                      .closed
                      .then((value) {
                        cubit.changeBottomSheetState(
                          isShown: false,
                          icon: Icons.edit,
                        );
                        titleController.text = '';
                        timeController.text = '';
                        dateController.text = '';
                      });
                  cubit.changeBottomSheetState(
                    isShown: true,
                    icon: Icons.add,
                  );
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            body: ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return CustomTaskItem(
                  taskTime: cubit.tasks[index]['time'],
                  taskTitle: cubit.tasks[index]['title'],
                  taskDate: cubit.tasks[index]['date'],
                );
              },
              separatorBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    height: 1.0,
                    color: Colors.grey[300],
                  ),
                );
              },
              itemCount: cubit.tasks.length,
            ),
          );
        },
      ),
    );
  }
}

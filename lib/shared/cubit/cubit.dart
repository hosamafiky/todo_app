import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/New%20Tasks/new_tasks_screen.dart';
import 'package:todo_app/shared/cubit/states.dart';

import '../../modules/Archived Tasks/archived_tasks_screen.dart';
import '../../modules/Done Tasks/done_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitState());

  static AppCubit get(context) => BlocProvider.of(context);

  var currentIndex = 0;
  Database? database;
  List<Map> tasks = [];

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> screenTitles = const [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks'
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(ChangeBotNavBarState());
  }

  void createDatabase() {
    openDatabase(
      'todoApp.db',
      version: 1,
      onCreate: (database, version) {
        print('Database Created!');
        // Create Table..
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)')
            .then((value) {
          print('Table Created!');
        }).catchError((error) {
          print('Error in creating table\n${error.toString()}');
        });
      },
      onOpen: (database) {
        print('Database Opened!');
        getDataFromDatabase(database).then((value) {
          tasks = value;
          emit(GetDataFromDatabase());
        });
      },
    ).then((value) {
      database = value;
      emit(CreateDatabaseState());
    });
  }

  Future insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) {
    return database!.transaction((txn) async {
      await txn
          .rawInsert(
        'INSERT INTO tasks(title, time, date, status) VALUES("$title", "$time", "$date", "New")',
      )
          .then((value) {
        //print("$value data inserted successfully.");
        emit(InsertToDatabaseState());
        getDataFromDatabase(database).then((value) {
          tasks = value;
          emit(GetDataFromDatabase());
          changeBottomSheetState(isShown: false, icon: Icons.edit);
          emit(ChangeBottomSheetState());
        });
      }).catchError((error) {
        print('Error inserting a new data : ${error.toString()}');
      });
    });
  }

  Future<List<Map>> getDataFromDatabase(database) async {
    List<Map> tasks = await database!.rawQuery('SELECT * FROM tasks');
    return tasks;
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShown,
    required IconData icon,
  }) {
    isBottomSheetShown = isShown;
    fabIcon = icon;
    emit(ChangeBottomSheetState());
  }
}

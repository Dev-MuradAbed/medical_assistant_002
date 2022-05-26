import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:medical_assistant_002/provider/doctor_provider/todo_provider/todo_calender_provider.dart';
import 'package:medical_assistant_002/widgets/todo_widget/patient_todo_widget/input_field.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../models/doctor_models/todo_model/calender_model.dart';
import '../../../models/doctor_models/todo_model/patient_todo_model.dart';
import '../../../provider/doctor_provider/todo_provider/todo_doctor_provider.dart';
import '../../../provider/doctor_provider/todo_provider/todo_patient_provider.dart';
import '../../../theme.dart';
import '../../../utils/helpers.dart';
import '../../../widgets/todo_widget/patient_todo_widget/button.dart';


class DoctorHomeTodo extends StatefulWidget {
  const DoctorHomeTodo({Key? key}) : super(key: key);

  @override
  State<DoctorHomeTodo> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<DoctorHomeTodo>with Helper {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<CalenderTaskProvider>(context, listen: false).getTask();
    super.initState();
  }

  final CalenderTaskProvider _taskController = CalenderTaskProvider();
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _notecontroller = TextEditingController();
  final TextEditingController _idPataincontroller=TextEditingController();
  DateTime _selectedTime = DateTime.now();
  DateTime nextvisit = DateTime.now();
  String startTime = DateFormat('hh:mm aaa').format(DateTime.now()).toString();
  String endTime = DateFormat('hh:mm aaa')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selecRemind = 5;
  List<int> RemindList = [5, 10, 15, 20];
  String _selectRepeat = 'None';
  List<String> repsetList = ['None', 'Delay', 'Weekly', 'Monthly'];
  int _selectedColore = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                InputField(
                  controller: _idPataincontroller,
                  title: "Enter id Patina",
                  hint: "id Patina",
                ),
                InputField(
                  title: AppLocalizations.of(context)!.note,
                  hint: AppLocalizations.of(context)!.enter_note_task,
                  controller: _notecontroller,
                ),
                InputField(
                  title: AppLocalizations.of(context)!.date,
                  hint: DateFormat.yMd().format(_selectedTime),
                  widget: IconButton(
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () => _getDate(),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: InputField(
                          title: 'Start Time',
                          hint: startTime,
                          widget: IconButton(
                            onPressed: () => _getTime(isStart: true),
                            icon: const Icon(Icons.access_time, color: Colors.grey),
                          ),
                        )),
                    const SizedBox(width: 12),
                    Expanded(
                        child: InputField(
                          title: AppLocalizations.of(context)!.end_time,
                          hint: AppLocalizations.of(context)!.end_time,
                          widget: IconButton(
                            onPressed: () => _getTime(isStart: false),
                            icon: const Icon(
                              Icons.access_time,
                              color: Colors.grey,
                            ),
                          ),
                        )),
                  ],
                ),
                InputField(
                  title: 'Next visit Date',
                  hint: DateFormat.yMd().format(nextvisit),
                  widget: IconButton(
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () => _getDatevisit(),
                  ),
                ),

                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column_methode(),
                    MyButton(
                        label: AppLocalizations.of(context)!.create_task,
                        onTap: () {
                          validateTask();
                        }),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  Column Column_methode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.color),
        Wrap(
          children: List.generate(
              3,
                  (index) => GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColore = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: index == 0
                        ? primaryClr
                        : index == 1
                        ? pinkClr
                        : orangeClr,
                    radius: 14,
                    child: _selectedColore == index
                        ? const Icon(Icons.done,
                        size: 16, color: Colors.white)
                        : null,
                  ),
                ),
              )),
        )
      ],
    );
  }

  validateTask() async {
    if ( _notecontroller.text.isNotEmpty) {
      _addTaskToDb();
    } else if ( _notecontroller.text.isEmpty) {
      showSnackBar( context,message: AppLocalizations.of(context)!.required_title_and_note, error: true);
    } else {

    }
  }

  _addTaskToDb() async {
    try {
      print(_idPataincontroller.text);
       await FirebaseFirestore.instance.collection('UserData')
        .doc(_idPataincontroller.text).collection('DoctorNote').doc().set(
        {
                'title': _titlecontroller.text,
                'note': _notecontroller.text,
                'color': _selectedColore,
                'isCompleted': 0,
                'startTime': startTime,
                'endTime': endTime,
                'date': DateFormat.yMd().format(_selectedTime),
                'remind': _selecRemind,
                'repeat': _selectRepeat,
        }
      );
      int value = await _taskController.addTask(
          task: Calender(
            title: _titlecontroller.text,
            note: _notecontroller.text,
            startTime: startTime,
            endTime: endTime,
            date: DateFormat.yMd().format(nextvisit),
          ));
      Provider.of<CalenderTaskProvider>(context,listen: false).getTask();
    }on FirebaseAuthException catch (e) {
      showSnackBar(context, message: e.code, error: true);

    }
  }

  _getDatevisit() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: nextvisit,
      firstDate: DateTime(2010),
      lastDate: DateTime(2040),
    );
    if (_pickedDate != null) {
      setState(() {
        nextvisit = _pickedDate;
      });
    } else {


    }
  }
  _getDate() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedTime,
      firstDate: DateTime(2010),
      lastDate: DateTime(2040),
    );
    if (_pickedDate != null) {
      setState(() {
        _selectedTime = _pickedDate;
      });
    } else {


    }
  }

  _getTime({required bool isStart}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: isStart
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
        DateTime.now().add(
          const Duration(minutes: 15),
        ),
      ),
    );
    String _formatDate = _pickedTime!.format(context);
    if (isStart) {
      setState(() {
        startTime = _formatDate;
      });
    } else if (!isStart) {
      setState(() {
        endTime = _formatDate;
      });
    } else {


    }
  }
}

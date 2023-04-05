import 'package:flutter/material.dart';
import 'package:timeline/native.dart';

class Production extends StatefulWidget {
  const Production({super.key});

  @override
  State<Production> createState() => _ProductionState();
}

class _ProductionState extends State<Production> {
  late var _currentDate = DateTime.now().toString().split(" ")[0];
  late var _currentTime = "${DateTime.now().hour}:${DateTime.now().minute}";
  String _line = "70.8";
  String _errorMessage = "";
  bool _insertData = false;

  @override
  void initState() {
    super.initState();
  }

  Future displayDatePicker(BuildContext context) async {
    /*
    Function to display en register the date
    */
    var date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      setState(() {
        _currentDate = date.toLocal().toString().split(" ")[0];
      });
    }
  }

  Future displayTimePicker(BuildContext context) async {
    /* Fucntion to display and register the time */
    var time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _currentTime = "${time.hour}:${time.minute}";
      });
    }
  }

  void changeLineState(String val) {
    /* Function to change the line on the app, 
    need to be alone because of how the listViewLine is made */
    setState(() {
      _line = val;
    });
  }

  List<Widget> listViewLine(StateSetter setState) {
    /* Create the list of widget for chosing the line */
    var lines = [
      "70.1",
      "70.2",
      "70.3",
      "70.4",
      "70.5",
      "70.6",
      "70.7",
      "70.8",
      "70.9",
      "70.10"
    ];
    var lineList = <Widget>[];

    for (var line in lines) {
      lineList.add(
        ListTile(
          title: Text(line),
          leading: Radio<String>(
            groupValue: _line,
            value: line,
            onChanged: (String? newVal) {
              changeLineState(newVal!);
              setState(
                () => {
                  _line = newVal,
                },
              );
            },
          ),
        ),
      );
    }
    return lineList;
  }

  Widget productionLine(BuildContext context) {
    /* Create the button that trigger  */
    return TextButton(
      onPressed: () => showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("line"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) => SizedBox(
              width: 100,
              height: 100,
              child: SingleChildScrollView(
                child: Column(children: listViewLine(setState)),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () => Navigator.pop(context, 'OK'),
            ),
          ],
        ),
      ),
      child: const Text("Change line"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextButton(
          onPressed: () {
            displayDatePicker(context);
            displayTimePicker(context);
          },
          child: const Text("Change Date & Time"),
        ),
        Text("$_currentDate $_currentTime"),
        productionLine(context),
        Text(_line),
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black),
          ),
          child: Text(
            "message : $_errorMessage",
          ),
        ),
        ElevatedButton(
          child: const Icon(Icons.send),
          onPressed: () async {
            var str = await api.addSample(
                date: "$_currentDate $_currentTime", line: _line);
            setState(() {
              _errorMessage = str;
            });
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:timeline/native.dart';
import 'constant.dart';

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
  final double _widthColumn = 500;
  final double _heighRow = 300;

  @override
  void initState() {
    super.initState();
  }

  

  Future displayDatePicker(BuildContext context) async {
    /*
    Function to display and register the date
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
          title: Text(
            "line",
            style: tStyle,
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) => SizedBox(
              width: 100,
              height: 500,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.ads_click),
          Text(
            "Change line",
            style: tStyle,
          ),
        ],
      ),
    );
  }

  Widget datePicker() {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            displayDatePicker(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.ads_click),
              Text(
                "Change Date",
                style: tStyle,
              ),
            ],
          ),
        ),
        Text(
          _currentDate,
          style: tStyle,
        )
      ],
    );
  }

  Widget timePicker() {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            displayTimePicker(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.ads_click),
              Text(
                "Change Time",
                style: tStyle,
              ),
            ],
          ),
        ),
        Text(
          _currentTime,
          style: tStyle,
        )
      ],
    );
  }

  Widget linePicker() {
    return Column(children: [
      productionLine(context),
      Text(
        _line,
        style: tStyle,
      )
    ]);
  }

  Widget selectDateAndTime() {
    return Container(
      padding: const EdgeInsets.all(20),
      height: _heighRow,
      width: _widthColumn,
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        children: [
          datePicker(),
          const Spacer(
            flex: 1,
          ),
          timePicker(),
          const Spacer(
            flex: 1,
          ),
          linePicker(),
        ],
      ),
    );
  }

  Widget qrCodeHandler() {
    return Container(
      height: _heighRow,
      width: _widthColumn,
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: selectDateAndTime(),
          ),
          qrCodeHandler(),
        ]),
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

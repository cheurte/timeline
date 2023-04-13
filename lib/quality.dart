import 'package:flutter/services.dart';
import 'package:timeline/native.dart';
import 'package:flutter/material.dart';
import 'constant.dart';

class Quality extends StatefulWidget {
  const Quality({super.key});

  @override
  State<Quality> createState() => _QualityState();
}

class _QualityState extends State<Quality> {
  late String _datetime = "";
  late String _lineNumber = "";
  late String charge = "";
  late String product = "";
  late String _l = "";
  late String _a = "";
  late String _b = "";
  late String _yi = "";
  final List<String> _samples = [];
  final double _widthColumn = 500;
  final double _heighRow = 300;
  String _line = "";
  @override
  void initState() {
    super.initState();
  }

  Widget bottomInformation() {
    /* Information container to be place at the bottom */
    return SizedBox(
      width: _widthColumn,
      height: 110,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  "Date and Time",
                  style: tStyle,
                ),
                Text(
                  _datetime,
                  style: rStyle,
                ),
              ],
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  "Line",
                  style: tStyle,
                ),
                Text(
                  _lineNumber,
                  style: rStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void changeLineState(String val) {
    /* Function to change the line on the app, 
    need to be alone because of how the listViewLine is made */
    setState(() => _line = val);
    _line.split(";").asMap().forEach((key, value) {
      if (key == 0) {
        setState(() => _datetime = value);
      }
      if (key == 1) {
        setState(() => _lineNumber = value);
      }
      if (key == 2) {
        setState(() => _l = value);
      }
      if (key == 3) {
        setState(() => _a = value);
      }
      if (key == 4) {
        setState(() => _b = value);
      }
      if (key == 5) {
        setState(() => _yi = value);
      }
    });
  }

  List<Widget> listRowSampels(String row) {
    /* List of informations to print in the list */
    List<Widget> output = [];
    for (var value in row.split(";")) {
      output.add(
        Text(
          value,
          style: lStyle,
        ),
      );
    }
    return output;
  }

  List<Widget> listViewLine(StateSetter setState) {
    /* Create the list of samples */
    var lineList = <Widget>[];
    for (var line in _samples) {
      lineList.add(
        ListTile(
          title: Row(
            children: [
              Padding(
                  padding: const EdgeInsets.only(right: 50),
                  child: listRowSampels(line)[0]),
              listRowSampels(line)[1],
            ],
          ),
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

  Widget entries(BuildContext contex) {
    /* Display the list of samples with no quality yet */
    return AlertDialog(
      title: Row(
        children: const [
          Padding(
            padding: EdgeInsets.only(left: 80),
            child: Text("Date & Time"),
          ),
          Padding(
            padding: EdgeInsets.only(left: 90),
            child: Text("Line"),
          ),
        ],
      ),
      // title: Center(
      //     child: Text(
      //   "Samples",
      //   style: tStyle,
      // )),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => SizedBox(
          width: _widthColumn,
          height: _heighRow,
          child: SingleChildScrollView(
            child: Column(children: listViewLine(setState)),
          ),
        ),
      ),
      actions: <Widget>[
        FloatingActionButton(
          child: const Icon(Icons.refresh),
          onPressed: () async {
            setState(() {
              _samples.clear();
              _line = "";
            });
            List<String> listSamples = await api.sendUnmarkedSamples();
            setState(
              () {
                _samples.addAll(listSamples);
                listViewLine(setState);
              },
            );
          },
        ),
      ],
    );
  }

  Widget formEntry() {
    return SizedBox(
      // decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
      width: _widthColumn,
      height: _heighRow,
      child: Column(
        children: [
          Row(children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(40.0),
                child: TextFormField(
                  controller: TextEditingController(text: _l),
                  decoration: const InputDecoration(
                    labelText: 'L',
                    hintText: 'L value',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                    TextInputFormatter.withFunction(
                      (oldValue, newValue) => newValue.copyWith(
                        text: newValue.text.replaceAll('.', ','),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(40.0),
                child: TextFormField(
                  controller: TextEditingController(text: _a),
                  decoration: const InputDecoration(
                    labelText: 'a',
                    hintText: 'a Value',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                    TextInputFormatter.withFunction(
                      (oldValue, newValue) => newValue.copyWith(
                        text: newValue.text.replaceAll('.', ','),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
          Row(
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(40.0),
                  child: TextFormField(
                    controller: TextEditingController(text: _b),
                    decoration: const InputDecoration(
                      labelText: 'b',
                      hintText: 'b Value',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                      TextInputFormatter.withFunction(
                        (oldValue, newValue) => newValue.copyWith(
                          text: newValue.text.replaceAll('.', ','),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(40.0),
                  child: TextFormField(
                    controller: TextEditingController(text: _yi),
                    decoration: const InputDecoration(
                      labelText: 'YI',
                      hintText: 'YI Value',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                      TextInputFormatter.withFunction(
                        (oldValue, newValue) => newValue.copyWith(
                          text: newValue.text.replaceAll('.', ','),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            entries(context),
            Padding(
              padding: const EdgeInsets.all(10),
              child: bottomInformation(),
            ),
          ],
        ),
        SizedBox(
          width: 0.05 * width,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: formEntry(),
            ),
            FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.send),
            ),
          ],
        ),
      ],
    );
  }
}

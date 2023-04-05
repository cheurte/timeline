import 'package:timeline/native.dart';
import 'package:flutter/material.dart';

class Quality extends StatefulWidget {
  const Quality({super.key});

  @override
  State<Quality> createState() => _QualityState();
}

class _QualityState extends State<Quality> {
  late String datetime = "";
  late String line = "";
  late String charge = "";
  late String product = "";
  late String l = "";
  late String a = "";
  late String b = "";
  late String yi = "";
  final List<String> _samples =[""];

  @override
  void initState() {
    super.initState();
  }

  Widget bottomInformation() {
    /* Information container to be place at the bottom */
    return Column(
      children: [
        Row(
          children: [
            const Text("Charge"),
            Text(charge),
            const Text("Date & Time"),
            Text(datetime)
          ],
        ),
        Row(
          children: [
            const Text("Line"),
            Text(line),
            const Text("Product"),
            Text(product)
          ],
        )
      ],
    );
  }

  List<Widget> listViewLine(StateSetter setState) {
    /* Create the list of samples */
    var lineList = <Widget>[];
    for (var value in _samples) {
        lineList.add(Text(value));
    }

    return lineList;
  }

  Widget entries(BuildContext contex) {
    /* Display the list of samples with no quality yet */
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
            // Update the list
          ],
        ),
      ),
      child: const Icon(Icons.menu),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        entries(context),
        Column(
          children: [
            Row(
              children: [const Text("L"), Text(l), const Text("a"), Text(a)],
            ),
            Row(
              children: [const Text("b"), Text(b), const Text("YI"), Text(yi)],
            )
          ],
        ),
        FloatingActionButton(
          child: const Icon(Icons.send),
          onPressed: () {},
        ),
        FloatingActionButton(
          child: const Icon(Icons.refresh),
          onPressed: () async {
            List<String> listSamples = await api.sendUnmarkedSamples();
            setState(
              () {
                _samples.addAll(listSamples);
              },
            );
          },
        ),
        // Text(_samples),
      ],
    );
  }
}

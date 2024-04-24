import 'package:flutter/material.dart';

class CounterButton extends StatelessWidget {
  const CounterButton({super.key, required this.onUpdate});
  final Function(int) onUpdate;
  @override
  @override
  Widget build(BuildContext context) {
    int counter = 0;
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter mystate) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            color: const Color.fromARGB(255, 240, 142, 135),
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  if (counter > 0) {
                    mystate(
                      () {
                        counter--;
                        onUpdate(counter);
                      },
                    );
                  }
                },
                icon: const Icon(Icons.remove),
              ),
              Text("$counter"),
              IconButton(
                onPressed: () {
                  mystate(
                    () {
                      counter++;
                      onUpdate(counter);
                    },
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        );
      },
    );
  }
}

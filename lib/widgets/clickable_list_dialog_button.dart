import 'package:flutter/material.dart';

class ClickableListDialog extends StatelessWidget {
  final List<String> items;
  final ValueChanged<String> onItemSelected;

  ClickableListDialog({
    required this.items,
    required this.onItemSelected,
  });

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a component'),
          content: SizedBox(
            width: double.minPositive,
            child: ListView.builder(
                shrinkWrap: true, // Ensures the list takes minimal space
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(items[index]),
                    onTap: () {
                      onItemSelected(items[index]);
                      Navigator.pop(context); // Close the dialog on item tap
                    },
                  );
                }),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Text("Add component"),
      onPressed: () {
        _showMyDialog(context);
      },
    );
  }
}

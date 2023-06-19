import 'package:flutter/material.dart';

class EditMenuItem extends StatelessWidget {
  const EditMenuItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text('Edit Menu Item'),
      content: Row(
        children: [
          Flexible(
              child: TextField(
            decoration: InputDecoration(label: Text('Nama Menu')),
          )),
          Padding(padding: EdgeInsets.only(left: 8)),
          Flexible(
              child: TextField(
            decoration: InputDecoration(label: Text('Harga')),
          )),
        ],
      ),
    );
  }
}

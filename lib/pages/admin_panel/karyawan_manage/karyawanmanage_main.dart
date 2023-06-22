import 'package:flutter/material.dart';

class KaryawanManageMain extends StatelessWidget {
  const KaryawanManageMain({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Column(
        children: [
          Text('Karyawan Management'),
          Text('Karyawan List:'),
          Text('Karyawan 1'),
          Text('Karyawan 2'),
          Text('Karyawan 3'),
          Text('Tambah Karyawan +'),
        ],
      ),
    );
  }
}

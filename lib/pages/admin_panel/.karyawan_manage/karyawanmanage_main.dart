import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/repo/karyawan_authrepo.dart';

class KaryawanManageMain extends StatelessWidget {
  const KaryawanManageMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
          future:
              RepositoryProvider.of<KaryawanAuthRepo>(context).karyawanList(),
          builder: (context, snap) {
            print(snap.data);
            if (snap.hasData) {
              return ListView.builder(
                itemCount: snap.data!.length,
                itemBuilder: (context, index) => ListTile(
                    title: Text(snap.data![index]["username"].toString())),
              );
            }
            return const Column(
              children: [
                Text('Karyawan Management'),
                Text('Karyawan List:'),
                Text('Karyawan 1'),
                Text('Karyawan 2'),
                Text('Karyawan 3'),
                Text('Tambah Karyawan +'),
              ],
            );
          }),
    );
  }
}

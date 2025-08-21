import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/repo/karyawan_authrepo.dart';

class KaryawanManageMain extends StatelessWidget {
  const KaryawanManageMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Karyawan info'),
      ),
      body: FutureBuilder(
          future:
              RepositoryProvider.of<KaryawanAuthRepo>(context).karyawanList(),
          builder: (context, snap) {
            debugPrint(snap.data.toString());
            if (snap.hasData) {
              return ListView.builder(
                itemCount: snap.data!.docs.length,
                itemBuilder: (context, index) => ListTile(
                    title: Text(snap.data!.docs[index].data().toString())),
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

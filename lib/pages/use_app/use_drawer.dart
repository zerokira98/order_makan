part of 'use_main.dart';

class UseDrawer extends StatelessWidget {
  const UseDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(58.0),
            child: FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                var a = snapshot.data?.getString('globalSetting') ?? '{}';
                var b = jsonDecode(a);
                return Text('Kafe ${b['namaresto']}');
              },
            ),
          ),
          Divider(),
          Expanded(child: Container()),
          ListTile(
            title: const Text('Catat Pengeluaran'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PengeluaranPage(
                      fromusemain: true,
                    ),
                  ));
              // var a =
              //     RepositoryProvider.of<KaryawanAuthRepo>(context).currentUser;
              // debugPrint(a);
              // BlocProvider.of<KaryawanauthBloc>(context).add(SignOut());
            },
          ),
          ListTile(
            title: const Text('Penjualan Hari ini'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoriPenjualanHarian(),
                  ));
              // var a =
              //     RepositoryProvider.of<KaryawanAuthRepo>(context).currentUser;
              // debugPrint(a);
              // BlocProvider.of<KaryawanauthBloc>(context).add(SignOut());
            },
          ),
          if ((BlocProvider.of<KaryawanauthBloc>(context).state
                  as KaryawanAuthenticated)
              .user
              .isAdmin)
            ListTile(
                onTap: () {
                  showDialog<bool?>(
                    context: context,
                    builder: (context) =>
                        KeyLock(tendigits: '392785', title: 'Lock'),
                  ).then(
                    (value) {
                      if (value != null && value) {
                        return Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminPanel(),
                            ));
                      }
                    },
                  );
                },
                title: const Text('Admin Panel')),
          ListTile(
            title: const Text('LogOut'),
            onTap: () {
              BlocProvider.of<KaryawanauthBloc>(context).add(SignOut());
            },
          )
        ],
      )),
    );
  }
}

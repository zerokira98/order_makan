import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/antrian/antrian_bloc.dart';
import 'package:order_makan/bloc/struk/struk_state.dart';
import 'package:order_makan/model/strukitem_model.dart';
import 'package:order_makan/pages/antrian/time_periodic.dart';
import 'package:order_makan/pages/histori_struk.dart';
part 'antrian_card.dart';

class AntrianPage extends StatelessWidget {
  const AntrianPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Antrian'),
        actions: [
          IconButton(
              onPressed: () =>
                  BlocProvider.of<AntrianBloc>(context).add(InitiateAntrian()),
              icon: Icon(Icons.refresh))
        ],
      ),
      body: BlocListener<AntrianBloc, AntrianState>(
        listener: (context, state) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(
                    content: Text(
                        "${state.msg?['status'] as String} ${state.msg?['details'] as String}")))
                .closed
                .then((a) => BlocProvider.of<AntrianBloc>(context)
                    .add(InitiateAntrian()));
        },
        child: BlocBuilder<AntrianBloc, AntrianState>(
          builder: (context, state) {
            return GridView.count(
              shrinkWrap: true,
              childAspectRatio: 3,
              crossAxisCount: 2,
              children: state.antrianStruks.map((e) {
                return InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => DisplayStruk(data: e),
                      );
                    },
                    child: AntrianCard(
                      e: e,
                    ));
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

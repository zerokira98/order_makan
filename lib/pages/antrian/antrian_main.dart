import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/antrian/antrian_bloc.dart';
import 'package:order_makan/bloc/use_struk/struk_state.dart';
import 'package:order_makan/helper.dart';
import 'package:order_makan/model/strukitem_model.dart';
import 'package:order_makan/pages/antrian/time_periodic.dart';
import 'package:order_makan/pages/histori_struk.dart';
import 'package:order_makan/repo/strukrepo.dart';
part 'antrian_card.dart';

class AntrianPage extends StatefulWidget {
  final bool fromcheckout;
  const AntrianPage({super.key, this.fromcheckout = false});

  @override
  State<AntrianPage> createState() => _AntrianPageState();
}

class _AntrianPageState extends State<AntrianPage> {
  @override
  void initState() {
    if (widget.fromcheckout) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        RepositoryProvider.of<StrukRepository>(context).getAntrian().then(
          (value) {
            showDialog(
                context: context,
                builder: (context) => DisplayStruk(data: value.last));
          },
        );
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    ScaffoldMessenger.of(context).clearSnackBars();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

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
        listenWhen: (previous, current) => current.msg != previous.msg,
        listener: (context, state) {
          if (mounted) {
            ScaffoldMessenger.of(context).clearSnackBars();
            if (state.msg != null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(
                      content: Text(
                          "${state.msg?['status'] as String} ${state.msg?['details'] as String}")))
                  .closed
                  .then((a) =>
                      BlocProvider.of<AntrianBloc>(context).add(ClrMsg()));
            }
          }
        },
        child: BlocBuilder<AntrianBloc, AntrianState>(
          builder: (context, state) {
            if (state.antrianStruks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Empty'),
                    IconButton(
                        onPressed: () => BlocProvider.of<AntrianBloc>(context)
                            .add(InitiateAntrian()),
                        icon: Icon(Icons.refresh))
                  ],
                ),
              );
            }
            if (state.isloading) {
              return Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 8,
                crossAxisCount: 1,
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
              ),
            );
          },
        ),
      ),
    );
  }
}

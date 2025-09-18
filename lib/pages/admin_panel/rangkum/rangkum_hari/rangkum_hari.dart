import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/pages/admin_panel/rangkum/bloc/rangkuman_bloc.dart';

class RangkumHari extends StatelessWidget {
  const RangkumHari({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rangkuman Harian'),
      ),
      body: BlocBuilder<RangkumanBloc, RangkumanState>(
        builder: (context, state) {
          return Container();
        },
      ),
    );
  }
}

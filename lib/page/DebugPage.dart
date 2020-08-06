import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/DebugBloc.dart';
import '../widget/CodeWidget.dart';
import '../widget/SettingWidget.dart';

class DebugPage extends StatefulWidget {
  @override
  _DebugPageState createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debug Page'),
      ),
      backgroundColor: Colors.white70,
      body: BlocBuilder<DebugBloc, DebugState>(builder: (context, debugState) {
        if (debugState is DebugShowState) {
          if (debugState.isCodeCheck) {
            return SettingWidget(debugShowState: debugState);
          } else {
            return CodeWidget(debugShowState: debugState);
          }
        }
        return Container();
      }),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../bloc/DebugBloc.dart';

// ignore: must_be_immutable
class CodeWidget extends StatefulWidget {
  DebugShowState debugShowState;

  CodeWidget({this.debugShowState});

  @override
  _CodeWidgetState createState() => _CodeWidgetState();
}

class _CodeWidgetState extends State<CodeWidget> {
  StreamController<ErrorAnimationType> errorController;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.debugShowState.isCodeError) {
      errorController.add(ErrorAnimationType.shake);
    }
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        children: <Widget>[
          PinCodeTextField(
              appContext: context,
              length: 4,
              autoFocus: true,
              obscureText: false,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(10),
                fieldHeight: 56,
                fieldWidth: 56,
                borderWidth: 1,
              ),
              mainAxisAlignment:MainAxisAlignment.spaceEvenly,
              animationDuration: Duration(milliseconds: 300),
                errorAnimationController: errorController,
              keyboardType: TextInputType.phone,
              onCompleted: (code) {
                BlocProvider.of<DebugBloc>(context).add(DebugCodeEvent(code: code));
              },
              onChanged: (value) {
              }
          )
        ],
      ),
    );
  }
}

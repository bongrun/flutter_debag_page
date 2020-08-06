import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/DebugBloc.dart';
import '../model/HostModel.dart';

// ignore: must_be_immutable
class SettingWidget extends StatefulWidget {
  DebugShowState debugShowState;

  SettingWidget({this.debugShowState});

  @override
  _SettingWidgetState createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  String _character;

  @override
  void initState() {
    _character = widget.debugShowState.host.code;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white70,
      child: ListView(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 10),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Server:'),
                    ...widget.debugShowState.hosts.map((HostModel host) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(host.code, style: TextStyle(fontSize: 14)),
                          subtitle: Text(host.host, style: TextStyle(fontSize: 10)),
                          leading: Radio(
                            value: host.code,
                            groupValue: _character,
                            onChanged: (String value) {
                              setState(() {
                                _character = value;
                              });
                              BlocProvider.of<DebugBloc>(context).add(DebugServerChangeEvent(hostModel: widget.debugShowState.hosts.where((element) => element.code == value).first));
                            },
                          ),
                        ))
                  ],
                ),
              )),
          Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 10),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Container(
//                height: 20,
//                width: 500,
                child: CheckboxListTile(
                  title: Text("Use proxy"),
                  value: widget.debugShowState.proxyUsed,
                  onChanged: (newValue) {
                    setState(() {
                      widget.debugShowState.proxyUsed = newValue;
                    });
                    BlocProvider.of<DebugBloc>(context).add(DebugProxyUsedEvent(used: newValue));
                  },
                  controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                ),
              )),
        ],
      ),
    );
  }
}

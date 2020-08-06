import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:http_proxy/http_proxy.dart';
import 'package:shake/shake.dart';

import '../model/HostModel.dart';
import '../page/DebugPage.dart';
import '../repository/AbstractDebugRepository.dart';

class DebugBloc extends Bloc<DebugEvent, DebugState> {
  AbstractDebugRepository debugRepository;
  HostModel _currentHost;
  static final DebugBloc _singleton = DebugBloc._internal();

  factory DebugBloc({AbstractDebugRepository debugRepository}) {
    if (debugRepository != null) {
      _singleton.debugRepository = debugRepository;
    }
    return _singleton;
  }

  DebugBloc._internal();

  ShakeDetector detector;

  @override
  DebugState get initialState => DebugHideState();

  @override
  Stream<DebugState> mapEventToState(DebugEvent event) async* {
    if (event is DebugInitEvent) {
      proxyUsedChange();
      detector = ShakeDetector.autoStart(
          shakeSlopTimeMS: 5000,
          onPhoneShake: () {
            if (state is DebugHideState || (state is DebugShowState && DateTime.now().difference((state as DebugShowState).openTime).inSeconds > 10)) {
              add(DebugOpenEvent());
            }
          });
    }
    if (event is DebugOpenEvent) {
      yield DebugShowState(openTime: DateTime.now());
      Get.to(DebugPage());
    }
    if (event is DebugCodeEvent) {
      if (event.code == await debugRepository.code()) {
        yield DebugShowState(openTime: (state as DebugShowState).openTime, isCodeCheck: true, isCodeError: false, hosts: await debugRepository.hosts(), host: await getCurrentHost(), proxyUsed: await debugRepository.getProxyUsed());
      } else {
        yield DebugShowState(openTime: (state as DebugShowState).openTime, isCodeCheck: false, isCodeError: true);
      }
    }
    if (event is DebugServerChangeEvent) {
      _currentHost = event.hostModel;
      await debugRepository.save(event.hostModel);
      yield DebugShowState(openTime: (state as DebugShowState).openTime, isCodeCheck: true, isCodeError: false, hosts: await debugRepository.hosts(), host: await getCurrentHost(), proxyUsed: await debugRepository.getProxyUsed());
    }
    if (event is DebugProxyUsedEvent) {
      await debugRepository.setProxyUsed(event.used);
      await proxyUsedChange();
      yield DebugShowState(openTime: (state as DebugShowState).openTime, isCodeCheck: true, isCodeError: false, hosts: await debugRepository.hosts(), host: await getCurrentHost(), proxyUsed: await debugRepository.getProxyUsed());
    }
  }

  Future<void> proxyUsedChange() async {
    if (await debugRepository.getProxyUsed()) {
      HttpProxy httpProxy = await HttpProxy.createHttpProxy();
      HttpOverrides.global = httpProxy;
    }
  }

  Future<HostModel> getCurrentHost() async {
    if (_currentHost == null) {
      _currentHost = await debugRepository.host();
    }
    return _currentHost;
  }

  @override
  Future<void> close() {
    detector.stopListening();
    return super.close();
  }
}

abstract class DebugState {}

class DebugHideState extends DebugState {}

class DebugShowState extends DebugState {
  DateTime openTime;
  bool isCodeCheck = false;
  bool isCodeError = false;
  List<HostModel> hosts = [];
  HostModel host;
  bool proxyUsed;

  DebugShowState({this.openTime, this.isCodeCheck = false, this.isCodeError = false, this.hosts, this.host, this.proxyUsed});
}

abstract class DebugEvent {}

class DebugFetchEvent extends DebugEvent {}

class DebugInitEvent extends DebugEvent {}

class DebugOpenEvent extends DebugEvent {}

class DebugCodeEvent extends DebugEvent {
  String code;

  DebugCodeEvent({this.code});
}

class DebugServerChangeEvent extends DebugEvent {
  HostModel hostModel;

  DebugServerChangeEvent({this.hostModel});
}

class DebugProxyUsedEvent extends DebugEvent {
  bool used;

  DebugProxyUsedEvent({this.used});
}

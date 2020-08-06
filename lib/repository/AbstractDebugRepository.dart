
import 'package:shared_preferences/shared_preferences.dart';

import '../model/HostModel.dart';

abstract class AbstractDebugRepository {
  Future<String> code();

  Future<List<HostModel>> hosts();

  Future<HostModel> host() async {
    String hostCodeCurrent = (await SharedPreferences.getInstance()).get('host_code_current1');
    if (hostCodeCurrent != null) {
      for (HostModel host in await this.hosts()) {
        if (host.code == hostCodeCurrent) {
          return host;
        }
      }
    }
    for (HostModel host in await this.hosts()) {
      if (host.isDefault != null && host.isDefault) {
        return host;
      }
    }
    throw 'Host is not defined by default';
  }

  Future<bool> save(HostModel host) async {
    (await SharedPreferences.getInstance()).setString('host_code_current1', host.code);
    return true;
  }

  Future<bool> getProxyUsed() async {
    bool proxyUsed = (await SharedPreferences.getInstance()).get('proxy_used');
    if (proxyUsed == null) {
      return false;
    }
    return proxyUsed;
  }

  Future<void> setProxyUsed(bool proxyUsed) async {
    (await SharedPreferences.getInstance()).setBool('proxy_used', proxyUsed);
  }
}

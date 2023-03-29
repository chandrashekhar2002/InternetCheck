// ignore_for_file: non_constant_identifier_names, unrelated_type_equality_checks

import 'dart:async';
import 'package:checkinternetstreams/details.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:network_info_plus/network_info_plus.dart';

class nextPage extends StatefulWidget {
  const nextPage({Key? key}) : super(key: key);

  @override
  State<nextPage> createState() => _nextPageState();
}

class _nextPageState extends State<nextPage> {
  late StreamSubscription connection;
  String str = '';
  String? wifiName, wifiBSSID, IP, IPv6, subMask, BroadCast, GateWay;
  final NetworkInfo _details = NetworkInfo();
  bool _internet = false;
  bool _displayData = false;

  @override
  void initState() {
    _ChecKConnection();
    _checkNames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('wifiName : ${wifiName?.length}');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Text(
                  'This Application checks for internet connectivity all the time... '),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          const Divider(
            color: Colors.grey,
            height: 3,
          ),
          Expanded(
            child: _internet
                ? Lottie.asset('assets/112092-iot-house.json')
                : Lottie.asset('assets/45721-no-internet.json'),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: GestureDetector(
              onTap: () {
                print('wifiName : $wifiName');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => detailsPage(
                          wifiName == null ? 'Unable to get' : wifiName!,
                          wifiBSSID == null ? 'Unable to get' : wifiBSSID!,
                          IP == null ? 'Unable to get' : IP!,
                          IPv6 == null ? 'Unable to get' : IPv6!,
                          subMask == null ? 'Unable to get' : subMask!,
                          BroadCast == null ? 'Unable to get' : BroadCast!,
                          GateWay == null ? 'Unable to get' : GateWay!),
                    ));
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: Text(str),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Future<void> _ChecKConnection() async {
    print('called');
    connection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult event) async {
      _internet = await InternetConnectionChecker().hasConnection;
      var s = await InternetConnectionChecker().connectionStatus;
      print('sssssssss : $s');
      final res = Connectivity().checkConnectivity();
      print('Internet  : $_internet');
      if (!_internet) {
        setState(() {
          str = 'No Internet';
        });
      } else {
        if (res == ConnectivityResult.mobile) {
          setState(() {
            str = 'Connected to Mobile Network';
          });
          print('Mobile Network');
        } else if (res == ConnectivityResult.wifi) {
          setState(() {
            str = 'Connected to Wifi';
          });
          print('Wifi');
        } else {
          setState(() {
            str = 'Connected, Don\'t Know the Source';
          });
          print('Don\'t Know the Source');
        }
      }
    });
  }

  @override
  void dispose() {
    print('wifiName : $wifiName');
    connection.cancel();
    super.dispose();
  }

  Future<void> _checkNames() async {
    final NetworkInfo _networkInfo = NetworkInfo();
    wifiName = await _networkInfo.getWifiName();
    wifiBSSID = await _networkInfo.getWifiBSSID();
    IP = await _networkInfo.getWifiIP();
    IPv6 = await _networkInfo.getWifiIPv6();
    subMask = await _networkInfo.getWifiSubmask();
    BroadCast = await _networkInfo.getWifiBroadcast();
    GateWay = await _networkInfo.getWifiGatewayIP();
  }
}

AppBar appBar(String title) {
  return AppBar(
    title: Text(title),
    shadowColor: Colors.grey,
    backgroundColor: Colors.black,
    centerTitle: true,
    toolbarOpacity: 0.6,
    automaticallyImplyLeading: true,
  );
}

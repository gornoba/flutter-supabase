import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:food_pick_app/common/snackbar_util.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late NaverMapController _mapController;
  Completer<NaverMapController> mapControllerComplter = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NaverMap(
        options: const NaverMapViewOptions(
          indoorEnable: true, // 실내지도 사용 여부
          locationButtonEnable: true, // 내위치 버튼 사용 여부
          consumeSymbolTapEvents: false, // 심볼 탭 이벤트 사용 여부
        ),
        onMapReady: (controller) async {
          _mapController = controller;

          try {
            // 현재위치 카메라 위치 추출
            NCameraPosition myPosition = await getMyLocation();

            // 현재위치로 카메라 update
            controller
                .updateCamera(NCameraUpdate.fromCameraPosition(myPosition));
            mapControllerComplter.complete((_mapController));
          } catch (e) {
            showSnackBar(context, '위치 정보를 가져오지 못했습니다.', Colors.redAccent);
          }
        },
      ),
    );
  }

  Future<NCameraPosition> getMyLocation() async {
    // 위치 권한을 체크해서 권한 허용이 되어 있다면 내 현재 위치 정보 가져오기
    bool serviceEnable = false;
    LocationPermission permission;

    // 위치 서비스를 이용할 수 있는지 체크
    serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      return Future.error('위치 서비스를 활성화 해주세요.');
    }

    // 위치권한 현재상태 체크
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // 위치권한 팝업표시
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('위치 권한을 허용해주세요.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('위치 권한을 허용해야 합니다.');
    }

    // 현재 디바이스 기준 GPS 센서 값을 가져옴
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return NCameraPosition(
      target: NLatLng(
        position.latitude,
        position.longitude,
      ),
      zoom: 16,
    );
  }
}

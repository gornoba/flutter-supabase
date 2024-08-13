import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:food_pick_app/common/snackbar_util.dart';
import 'package:food_pick_app/widget/button.dart';
import 'package:food_pick_app/widget/text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/food_store.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late NaverMapController _mapController;
  Completer<NaverMapController> mapControllerComplter = Completer();
  final supabase = Supabase.instance.client;

  Future<List<FoodStoreModel>>? _dataFutere;
  List<FoodStoreModel>? _lstFoodStore; // 맛집 정보들

  @override
  void initState() {
    _dataFutere = fetchStoreInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _dataFutere,
        builder: (BuildContext context,
            AsyncSnapshot<List<FoodStoreModel>> snapshot) {
          // 예외처리
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            );
          }

          _lstFoodStore = snapshot.data;
          return NaverMap(
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

                // 서버에 등록된 음식점 리스트 정보를 지도에 표시
                _buildMarkers();

                // 현재위치로 카메라 update
                controller
                    .updateCamera(NCameraUpdate.fromCameraPosition(myPosition));
                mapControllerComplter.complete((_mapController));
              } catch (e) {
                showSnackBar(context, '위치 정보를 가져오지 못했습니다.', Colors.redAccent);
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/edit');
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

  Future<List<FoodStoreModel>>? fetchStoreInfo() async {
    final foodListMap = await supabase.from('food_store').select();
    List<FoodStoreModel> lstFoodStore =
        foodListMap.map((e) => FoodStoreModel.fromJson(e)).toList();
    return lstFoodStore;
  }

  void _buildMarkers() {
    // 지도에 표시된 마커들을 모두 삭제
    _mapController.clearOverlays();

    // 서버에서 가져온 음식점 정보를 지도에 표시
    for (FoodStoreModel foddStoreModel in _lstFoodStore!) {
      final marker = NMarker(
        id: foddStoreModel.id.toString(),
        position: NLatLng(foddStoreModel.latitude, foddStoreModel.longitude),
        caption: NOverlayCaption(
          text: foddStoreModel.storeName,
        ),
      );

      // 마커 클릭 기능 부여
      marker.setOnTapListener((overlay) {
        // 맛집 상세정보 표시
        _showBottomSummaryDialog(foddStoreModel);
      });
      _mapController.addOverlay(marker);
    }
  }

  void _showBottomSummaryDialog(FoodStoreModel foddStoreModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return Wrap(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // header
                  Row(
                    children: [
                      SectionText(
                        text: foddStoreModel.storeName,
                        textColor: Colors.black,
                      ),
                      const Spacer(),
                      GestureDetector(
                        child: Icon(
                          Icons.close,
                          size: 24,
                          color: Colors.black,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // body,
                  foddStoreModel.storeImgUrl?.isNotEmpty == true
                      ? CircleAvatar(
                          radius: 32,
                          backgroundImage:
                              NetworkImage(foddStoreModel.storeImgUrl!),
                        )
                      : const Icon(
                          Icons.image_not_supported,
                          size: 32,
                        ),
                  const SizedBox(height: 15),
                  Text(
                    foddStoreModel.comment,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // footer,
                  Container(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButtonCustom(
                        text: '상세보기',
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        onPressed: () {
                          // 상세보기 페이지로 이동
                        }),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

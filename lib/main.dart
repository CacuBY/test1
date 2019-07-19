
import 'package:amap_base/amap_base.dart';
import 'package:flutter/material.dart';

void main() async {
  //高德地图 iOS 端 Key
  await AMap.init('3341168cf46b69f984b0050eddc9b544');
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '地图 Demo'),
    );
  }
}






class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _amapLocation = AMapLocation();//定位对象
  AMapController _controller;//地图控制器
  MyLocationStyle _myLocationStyle = MyLocationStyle();

  @override
  void initState() {
    super.initState();
    //_updateMyLocationStyle(context, showMyLocation: true);
    _amapLocation.init();//初始化定位对象
  }

  @override
  void dispose() {
    _amapLocation.stopLocate();//释放对象
    super.dispose();
  }

  // void _updateMyLocationStyle(
  //   BuildContext context, {
  //   String myLocationIcon,
  //   double anchorU,
  //   double anchorV,
  //   Color radiusFillColor,
  //   Color strokeColor,
  //   double strokeWidth,
  //   int myLocationType,
  //   int interval,
  //   bool showMyLocation,
  //   bool showsAccuracyRing,
  //   bool showsHeadingIndicator,
  //   Color locationDotBgColor,
  //   Color locationDotFillColor,
  //   bool enablePulseAnnimation,
  //   String image,
  // }) async {
  //   if (await Permissions().requestPermission()) {
  //     _myLocationStyle = _myLocationStyle.copyWith(
  //       myLocationIcon: myLocationIcon,
  //       anchorU: anchorU,
  //       anchorV: anchorV,
  //       radiusFillColor: radiusFillColor,
  //       strokeColor: strokeColor,
  //       strokeWidth: strokeWidth,
  //       myLocationType: myLocationType,
  //       interval: interval,
  //       showMyLocation: showMyLocation,
  //       showsAccuracyRing: showsAccuracyRing,
  //       showsHeadingIndicator: showsHeadingIndicator,
  //       locationDotBgColor: locationDotBgColor,
  //       locationDotFillColor: locationDotFillColor,
  //       enablePulseAnnimation: enablePulseAnnimation,
  //       image: image,
  //     );
  //     _controller.setMyLocationStyle(_myLocationStyle);
  //   } else {
  //     Scaffold.of(context).showSnackBar(SnackBar(content: Text('权限不足')));
  //   }
  // }

  //单次定位
  void _onceLocation() async {

    final option = LocationClientOptions(
      isOnceLocation: true,
      locatingWithReGeocode: true,
      allowsBackgroundLocationUpdates: true,
    );
    
    if (await Permissions().requestPermission()) {
      Location onceLocation =  await _amapLocation.getLocation(option);
      print(onceLocation);
      int errorCode = onceLocation.errorCode;
      if (errorCode == 0) {
        print('定位成功');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: AMapView(
          onAMapViewCreated: (controller) {
            _controller = controller;
            _controller.setMyLocationStyle(_myLocationStyle);
            _controller.markerClickedEvent.listen((marker){
              Scaffold.of(context).showSnackBar(SnackBar(content: Text(marker.toString())));
            });
            //添加大头针
            // controller.addMarker(MarkerOptions(
            //   icon: 'lib/imgs/location_green.png',
            //   //title: '店铺名店铺名',
            //   //snippet: '送达时间送达时间送达时间送达时间',
            //   position: LatLng(double.parse(_latitude), double.parse(_longitude))
            // ));
          },
          amapOptions: AMapOptions(
            compassEnabled: false,
            zoomControlsEnabled: true,
            camera: CameraPosition(
              //目标位置的屏幕中心点经纬度坐标
              //target: LatLng(39.8994731, 116.4142794),
              zoom: 13,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onceLocation,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

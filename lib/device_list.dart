import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tekno_handbook/detail_device.dart';

class DeviceListScreen extends StatelessWidget {
  final String brand;

  DeviceListScreen({required this.brand});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List $brand Devices'),
        backgroundColor: Color(0xFF00adb5),
      ),
      backgroundColor: Color(0xFFeeeeee),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          child: FutureBuilder(
              future: ListDevice.connectToAPI(brand),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: Text("Loading..."),
                    ),
                  );
                } else {
                  if (constraints.maxWidth < 600) {
                    return DeviceListGenerator(
                      gridCount: 2,
                      apiData: snapshot,
                    );
                  } else if (constraints.maxWidth < 750) {
                    return DeviceListGenerator(
                      gridCount: 3,
                      apiData: snapshot,
                    );
                  } else if (constraints.maxWidth < 900) {
                    return DeviceListGenerator(
                      gridCount: 4,
                      apiData: snapshot,
                    );
                  } else if (constraints.maxWidth < 1100) {
                    return DeviceListGenerator(
                      gridCount: 5,
                      apiData: snapshot,
                    );
                  } else if (constraints.maxWidth < 1300) {
                    return DeviceListGenerator(
                      gridCount: 6,
                      apiData: snapshot,
                    );
                  } else {
                    return DeviceListGenerator(
                      gridCount: 7,
                      apiData: snapshot,
                    );
                  }
                }
              }),
        );
      }),
    );
  }
}

class ListDevice {
  String phoneNameSlug;
  String phoneName;
  String brandSlug;
  String brand;
  String phoneImgUrl;

  ListDevice(
      {required this.phoneNameSlug,
      required this.phoneName,
      required this.brandSlug,
      required this.brand,
      required this.phoneImgUrl});

  static Future<List<ListDevice>> connectToAPI(String brandName) async {
    String apiURL =
        "http://api-mobilespecs.azharimm.tk/brands/$brandName?page=1&limit=10&sort=created_at:desc";
    /*
      Sumber API:
      https://github.com/azharimm/phone-specs-api
    */

    var apiResult = await http.get(Uri.parse(apiURL));
    if (apiResult.statusCode == 200) {
      var jsonObject = jsonDecode(apiResult.body)['data']['phones'];
      List<ListDevice> devices = [];
      for (var i in jsonObject) {
        ListDevice device = ListDevice(
          phoneNameSlug: i['phone_name_slug'],
          phoneName: i['phone_name'],
          brandSlug: i['brand_slug'],
          brand: i['brand'],
          phoneImgUrl: i['phone_img_url'],
        );

        devices.add(device);
      }
      return devices;
    } else {
      throw Exception('Failed to load Devices Data');
    }
  }
}

class DeviceListGenerator extends StatelessWidget {
  final int gridCount;
  final apiData;

  DeviceListGenerator({required this.gridCount, required this.apiData});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: apiData.data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridCount,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (BuildContext context, int index) {
        return SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                margin: EdgeInsets.only(top: 5, bottom: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: Offset(1, 1))
                    ]),
                child: Column(
                  children: [
                    Image.network(
                      apiData.data[index].phoneImgUrl,
                      width: 130,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: Offset(1, 1))
                      ]),
                      child: Text(apiData.data[index].phoneName),
                    ),
                    Container(
                      child: IconButton(
                          icon: Icon(Icons.zoom_in),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return DetailDeviceScreen(
                                deviceNameSlug:
                                    apiData.data[index].phoneNameSlug,
                                deviceName: apiData.data[index].phoneName,
                                deviceBrandSlug: apiData.data[index].brandSlug,
                                deviceBrand: apiData.data[index].brand,
                                devicePhoneImgUrl:
                                    apiData.data[index].phoneImgUrl,
                              );
                            }));
                          }),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

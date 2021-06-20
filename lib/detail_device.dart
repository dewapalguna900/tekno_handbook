import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

class DetailDeviceScreen extends StatelessWidget {
  final String deviceNameSlug;
  final String deviceName;
  final String deviceBrandSlug;
  final String deviceBrand;
  final String devicePhoneImgUrl;

  DetailDeviceScreen({
    required this.deviceNameSlug,
    required this.deviceName,
    required this.deviceBrandSlug,
    required this.deviceBrand,
    required this.devicePhoneImgUrl,
  });

  @override
  Widget build(BuildContext context) {
    var deviceData = getDeviceData(deviceNameSlug, deviceBrandSlug);
    ScrollController _myScrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: Text('$deviceBrand $deviceName'),
        backgroundColor: Color(0xFF00adb5),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              child: Column(
                children: [
                  Container(
                    child: Text(
                      deviceName,
                      style: TextStyle(fontSize: 28),
                    ),
                  ),
                  Container(
                    child: Text(
                      deviceBrand,
                      style: TextStyle(fontSize: 23),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: Image.network(
                      devicePhoneImgUrl,
                    ),
                  ),
                  Stack(children: [
                    Align(
                      alignment: Alignment.center,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Spesifikasi Device',
                            style: TextStyle(fontSize: 21),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: BookmarkButton(),
                    ),
                  ]),
                  FutureBuilder(
                      future: deviceData,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                          return Container(
                            child: Center(
                              child: Text("Loading..."),
                            ),
                          );
                        } else {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Table(
                                        children: [
                                          TableRow(children: [
                                            TableCell(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    snapshot.data[index]
                                                        ['title'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20.0),
                                                  ),
                                                  Text(''),
                                                ],
                                              ),
                                            ),
                                          ])
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          snapshot.data[index]['specs'].length,
                                      itemBuilder: (BuildContext contextSpec,
                                          int indexSpec) {
                                        return Container(
                                          margin: EdgeInsets.only(left: 10.0),
                                          child: Table(
                                            border: TableBorder(
                                                bottom: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black)),
                                            children: [
                                              TableRow(children: [
                                                TableCell(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      5.0),
                                                          child: Text(
                                                            snapshot.data[index]
                                                                        [
                                                                        'specs']
                                                                    [indexSpec]
                                                                ['key'],
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: Text(': ' +
                                                              snapshot
                                                                  .data[index]
                                                                      ['specs'][
                                                                      indexSpec]
                                                                      ['val']
                                                                  .join(', ')),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ])
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                );
                              });
                        }
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<List> getDeviceData(
    String deviceNameSlug, String deviceBrandSlug) async {
  String apiURL =
      "http://api-mobilespecs.azharimm.tk/brands/$deviceBrandSlug/$deviceNameSlug";

  /*
    Sumber API:
    https://github.com/azharimm/phone-specs-api
  */

  var apiResult = await http.get(Uri.parse(apiURL));
  if (apiResult.statusCode == 200) {
    var jsonObject = jsonDecode(apiResult.body)['data']['specifications'];

    return jsonObject;
  } else {
    throw Exception('Failed to load Device Data');
  }
}

class BookmarkButton extends StatefulWidget {
  @override
  _BookmarkButtonState createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
        color: Color(0xFF00adb5),
      ),
      onPressed: () {
        setState(() {
          isBookmarked = !isBookmarked;
        });
      },
      iconSize: 33.0,
    );
  }
}

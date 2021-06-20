import 'package:flutter/material.dart';
import 'package:tekno_handbook/device_list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFeeeeee),
      appBar: AppBar(
        title: Text('Tekno Handbook'),
        backgroundColor: Color(0xFF00adb5),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
                alignment: Alignment.center,
                child: Text(
                  'Top Brand',
                  style: TextStyle(fontSize: 40, color: Color(0xFF00adb5)),
                ),
              ),
              Container(
                child: Column(
                  children: brandLogoList.map((brandLogo) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return DeviceListScreen(brand: brandLogo.brandName);
                        }));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 16.0),
                        child: Image.asset(
                            'images/brand_logo/${brandLogo.logoFileName}',
                            width: 150,
                            height: 150),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BrandLogo {
  String brandName;
  String logoFileName;

  BrandLogo({required this.brandName, required this.logoFileName});
}

var brandLogoList = [
  BrandLogo(brandName: 'apple', logoFileName: 'apple_logo.png'),
  BrandLogo(brandName: 'google', logoFileName: 'google_logo.png'),
  BrandLogo(brandName: 'realme', logoFileName: 'realme_logo.png'),
  BrandLogo(brandName: 'samsung', logoFileName: 'samsung_logo.png'),
  BrandLogo(brandName: 'xiaomi', logoFileName: 'xiaomi_logo.png'),
];

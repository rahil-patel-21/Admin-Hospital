//Flutter Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospitalAdmin/globals/responsive.dart';
import 'package:hospitalAdmin/globals/user_details.dart';
import 'package:hospitalAdmin/screens/payment.dart';
import 'package:hospitalAdmin/screens/splash_screen.dart';
import 'package:hospitalAdmin/services/auth.dart';
import 'package:hospitalAdmin/theme/app_theme.dart';
import 'package:hospitalAdmin/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _feesController = TextEditingController();
  TextEditingController _idController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    Future.delayed(Duration(milliseconds: 100)).whenComplete(() async {
      try {
        Utils.showProgressBar();
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('Admin')
            .doc('membership')
            .get();

        _idController.text = snapshot.data()['id'];
        Get.back();
        setState(() {});
      } catch (error) {
        print(error);
        Get.back();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _feesController.dispose();
    _idController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Admin Section',
            style: TextStyle(
              fontFamily: AppTheme.poppinsBold,
            )),
      ),
      body: Container(
          width: double.infinity,
          child: SingleChildScrollView(
              child: Column(
            children: [
              SizedBox(height: size(15)),
              _textField(controller: _idController, hintText: 'Merchant ID'),
              SizedBox(height: 50),
              RaisedButton(
                onPressed: () async {
                  if (_idController.text.trim() == '') {
                    Utils.showError('Please Enter Valid Merchant ID');
                  } else if (!await Utils.checkInternet()) {
                    Utils.showError('Please Check Your Connection');
                  } else {
                    try {
                      Utils.showProgressBar();
                      await FirebaseFirestore.instance
                          .collection('Admin')
                          .doc('membership')
                          .update({
                        'id': _idController.text.trim(),
                      });
                      Get.back();
                      Utils.showsuccess("Data Updated !");
                    } catch (error) {
                      print(error);
                      Get.back();
                    }
                  }
                },
                color: AppTheme.primaryAccent,
                child: Text('Update Data',
                    style: TextStyle(color: AppTheme.whiteColor)),
              )
            ],
          ))),
    );
  }

  Widget _textField(
      {TextEditingController controller,
      int maxLength,
      TextInputType keyBoardType,
      String hintText,
      int maxLines}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size(15), vertical: size(15)),
      child: TextField(
        controller: controller,
        maxLength: maxLength,
        keyboardType: keyBoardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          counterText: '',
          hintText: hintText,
          labelText: hintText,
          hintStyle: TextStyle(
              fontFamily: AppTheme.poppins, color: AppTheme.primaryColor),
          enabledBorder: new OutlineInputBorder(
            borderSide:
                const BorderSide(color: AppTheme.primaryColor, width: 1.0),
            borderRadius: const BorderRadius.all(
              const Radius.circular(8.0),
            ),
          ),
          focusedBorder: new OutlineInputBorder(
            borderSide:
                const BorderSide(color: AppTheme.primaryColor, width: 1.0),
            borderRadius: const BorderRadius.all(
              const Radius.circular(8.0),
            ),
          ),
          disabledBorder: new OutlineInputBorder(
            borderSide:
                const BorderSide(color: AppTheme.primaryColor, width: 1.0),
            borderRadius: const BorderRadius.all(
              const Radius.circular(8.0),
            ),
          ),
          border: new OutlineInputBorder(
            borderSide:
                const BorderSide(color: AppTheme.primaryColor, width: 1.0),
            borderRadius: const BorderRadius.all(
              const Radius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }
}

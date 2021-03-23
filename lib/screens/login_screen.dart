//Flutter Imports

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hospitalAdmin/constants/resources.dart';
import 'package:hospitalAdmin/globals/responsive.dart';
import 'package:hospitalAdmin/theme/app_theme.dart';
import 'package:hospitalAdmin/utils/utils.dart';
import 'homepage.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: AppTheme.offWhite,
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size(25)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: size(50)),
              Container(
                height: size(60),
                child: Image.asset(logoJPEG),
              ),
              Container(
                alignment: Alignment.center,
                child: Text('Log in as Admin',
                    style: TextStyle(
                        fontFamily: AppTheme.poppinsBold, fontSize: 20)),
              ),
              SizedBox(height: size(20)),
              SvgPicture.asset(logInSVG, height: size(125)),
              SizedBox(height: size(20)),
              _textField(
                  hintText: 'Enter Your Password',
                  maxLength: 10,
                  controller: _passwordController),
              SizedBox(height: size(20)),
              GestureDetector(
                onTap: () async {
                  if (_passwordController.text.trim() == 'xyz@2021') {
                    Get.offAll(HomePage());
                    _passwordController.clear();
                  } else {
                    Utils.showError('Please Enter Valid Password');
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Continue',
                        style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.primaryColor,
                            fontFamily: AppTheme.poppinsBold)),
                    SizedBox(width: size(5)),
                    Icon(Icons.arrow_forward,
                        size: size(15), color: AppTheme.primaryColor)
                  ],
                ),
              )
            ],
          ),
        )));
  }

  Widget _textField(
      {TextEditingController controller, int maxLength, String hintText}) {
    return Padding(
      padding: EdgeInsets.symmetric(),
      child: TextField(
        controller: controller,
        obscureText: true,
        maxLength: maxLength,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          counterText: '',
          hintText: hintText,
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

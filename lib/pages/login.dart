import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/GroceryListPage.dart';
import 'package:flutter_app/pages/ChangePasswordPage.dart';
import 'package:flutter_app/pages/EditProfilePage.dart';
import 'package:flutter_app/pages/HomeScreenforTabletMode.dart';
import 'package:flutter_app/pages/NewUserPage.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app/pages/HomeScreenforTabletModeV2.dart';
import 'package:flutter_app/pages/HomeScreenforPhoneMode.dart';
import 'package:device_info/device_info.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<LoginScreen> {
  TextEditingController emailInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.whiteA700,
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.maxFinite,
                child: Container(
                  width: double.maxFinite,
                  padding: getPadding(
                    left: 20,
                    top: 13,
                    right: 20,
                    bottom: 13,
                  ),
                  decoration: AppDecoration.fillGray100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: getPadding(
                          bottom: 9,
                        ),
                        child: Text(
                          "🍽️ Smart Fridge",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtRobotoBold24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Container(
                width: double.maxFinite,
                child: Container(
                  width: double.maxFinite,
                  margin: getMargin(
                    bottom: 193,
                  ),
                  padding: getPadding(
                    left: 35,
                    top: 27,
                    right: 35,
                    bottom: 27,
                  ),
                  decoration: AppDecoration.fillWhiteA700,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: getPadding(
                          top: 32,
                        ),
                        child: Text(
                          "Email",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtInterRegular18,
                        ),
                      ),
                      CustomTextFormField(
                        focusNode: FocusNode(),
                        controller: emailInputController,
                        margin: getMargin(
                          left: 5,
                          top: 12,
                          right: 20,
                        ),
                        textInputAction: TextInputAction.done,
                      ),
                      Padding(
                        padding: getPadding(
                          left: 5,
                          top: 27,
                        ),
                        child: Text(
                          "Password",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtInterRegular18,
                        ),
                      ),
                      CustomTextFormField(
                        focusNode: FocusNode(),
                        controller: passwordInputController,
                        margin: getMargin(
                          left: 5,
                          top: 12,
                          right: 20,
                        ),
                        textInputAction: TextInputAction.done,
                      ),
                      GestureDetector(
                        onTap: () {
                          loginUser();
                          /*Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Scene()
                          ),
                      );*/
                        },
                        child: Container(
                          width: getHorizontalSize(
                            295,
                          ),
                          margin: getMargin(
                            left: 5,
                            top: 31,
                          ),
                          padding: getPadding(
                            left: 30,
                            top: 12,
                            right: 114,
                            bottom: 12,
                          ),
                          decoration: AppDecoration.txtFillTeal300.copyWith(
                            borderRadius: BorderRadiusStyle.txtRoundedBorder10,
                          ),
                          child: Text(
                            "Login",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtRobotoBold20,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: getPadding(
                            top: 41,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChangePasswordPage()),
                              );
                            },
                            child: Text("Forgot Password?",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtInterRegular16.copyWith(
                                  decoration: TextDecoration.underline,
                                )),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: getPadding(
                            top: 15,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewUserScreen()),
                              );
                            },
                            child: Text(
                              "Create New Account",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtInterRegular16.copyWith(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      displayToastMsg(context, e.message!);
      //
    }
  }

  void loginUser() async {
    try {
      loginWithEmail(
        email: emailInputController.text,
        password: passwordInputController.text,
        context: context,
      );
      final isTabletDevice = await isTablet(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => isTabletDevice ? Scene2() : PhoneScene(),
        ),
      );
    } catch (e) {}
    //print(passwordController.text);
  }

  Future<bool> isTablet(BuildContext context) async {
    double screenWidth = MediaQuery.of(context).size.width;

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.model.contains('iPad');
    } else {
      // Assuming screen width greater than 600dp as a tablet
      return screenWidth > 600;
    }
  }

  //memory leak prevention
  @override
  void dispose() {
    emailInputController.dispose();
    passwordInputController.dispose();
    super.dispose();
  }

  displayToastMsg(BuildContext context, String msg) {
    Fluttertoast.showToast(msg: msg);
  }
}

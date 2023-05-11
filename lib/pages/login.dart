import 'package:flutter/material.dart';
import 'package:flutter_app/pages/NewUserPage.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/style.dart';
class LoginScreen extends StatelessWidget {
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

                      Container(
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
                          color: Color(0xffdbdfd1),
                        ),
                        child: Text(
                          "Login",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: AppStyle.txtRobotoBold20,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: getPadding(
                            top: 41,
                          ),
                          child: Text(
                            "Forgot Password?",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtInterRegular16.copyWith(
                              decoration: TextDecoration.underline,

                            ),
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
                                MaterialPageRoute(builder: (context) => NewUserScreen()),
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
}

import 'package:flutter/material.dart';
import 'package:flutter_app/pages/HomeScreenforTabletMode.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/pages/HomeScreenforTabletModeV2.dart';
import 'package:flutter_app/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
class NewUserScreen extends StatelessWidget {
  TextEditingController emailinputController = TextEditingController();
  TextEditingController nameinputController = TextEditingController();
  TextEditingController passwordinputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.maxFinite,
                child: Container(
                  width: getHorizontalSize(
                    389,
                  ),
                  margin: getMargin(
                    left: 1,
                  ),
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
              Padding(
                padding: getPadding(
                  top: 31,
                ),
                child: Text(
                  "Register",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtInterRegular16,
                ),
              ),
              Container(
                width: double.maxFinite,
                child: Container(
                  width: getHorizontalSize(
                    389,
                  ),
                  margin: getMargin(
                    left: 1,
                    top: 8,
                    bottom: 5,
                  ),
                  padding: getPadding(
                    left: 35,
                    top: 60,
                    right: 35,
                    bottom: 60,
                  ),
                  decoration: AppDecoration.fillWhiteA700,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Email",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtInterRegular18,
                      ),
                      CustomTextFormField(
                        focusNode: FocusNode(),
                        controller: emailinputController,
                        margin: getMargin(
                          left: 5,
                          top: 12,
                          right: 19,
                        ),
                        textInputAction: TextInputAction.done,
                      ),
                      Padding(
                        padding: getPadding(
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
                        controller: passwordinputController,
                        margin: getMargin(
                          left: 5,
                          top: 12,
                          right: 19,
                        ),
                        textInputAction: TextInputAction.done,
                      ),
                      Padding(
                        padding: getPadding(
                          top: 27,
                        ),
                        child: Text(
                          "Name ",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtInterRegular18,
                        ),
                      ),
                      CustomTextFormField(
                        focusNode: FocusNode(),
                        controller: nameinputController,
                        margin: getMargin(
                          left: 5,
                          top: 12,
                          right: 19,
                        ),
                        textInputAction: TextInputAction.done,
                      ),
                      Padding(
                        padding: getPadding(
                          top: 12,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          registerNewUser(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Scene2()
                            ),
                          );
                        },

                        child: Container(
                          width: getHorizontalSize(
                            295,
                          ),
                          margin: getMargin(
                            left: 5,
                            top: 27,
                            bottom: 12,
                          ),
                          padding: getPadding(
                            left: 30,
                            top: 11,
                            right: 70,
                            bottom: 11,
                          ),
                          decoration: AppDecoration.txtFillTeal300.copyWith(
                            borderRadius: BorderRadiusStyle.txtRoundedBorder10,
                          ),
                          child: Text(
                            "Create Account",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtRobotoBold20,
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

  final FirebaseAuth _firebaseAuth= FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async {
    final User? firebaseUser = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailinputController.text,
        password: passwordinputController.text).catchError(
            (errorMsg){displayToastMsg("Error: "+ errorMsg.toString(), context);
        })).user!;

    Map userDataMap = {
      "name": nameinputController.text.trim(),
      "email": emailinputController.text.trim(),
      "password": passwordinputController.text.trim(),
    };
    usersRef.child(firebaseUser!.uid).set(userDataMap);
    displayToastMsg("Congrats account created", context);
  }
  displayToastMsg(String msg, BuildContext context){
    Fluttertoast.showToast(msg: msg);
  }
}


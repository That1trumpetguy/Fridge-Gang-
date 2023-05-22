import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/ChangePasswordPage.dart';
import 'package:flutter_app/pages/EditProfilePage.dart';
import 'package:flutter_app/pages/login.dart';
import 'package:flutter_app/style.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var largeScreen = screenSize.width > 480 ? true : false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
          padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
          child: ListView(
            children: [
              Text(
                "Settings",
                style: TextStyle(
                    fontSize: (largeScreen ? 55 : 30),
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: (largeScreen ? 40 : 20)),
              Row(
                children: [
                  Icon(Icons.person,
                      color: Colors.black, size: (largeScreen ? 40 : 20)),
                  SizedBox(width: 8),
                  Text(
                    "Account",
                    style: TextStyle(
                        fontSize: (largeScreen ? 39 : 29),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(height: 15, thickness: 2),
              SizedBox(
                height: (largeScreen ? 40 : 30),
              ),

              buildAccountOption(
                  context, "Edit Profile", const EditProfilePage()),
              buildAccountOption(
                  context, "Change Password", const ChangePasswordPage()),
              //buildAccountOption(context, "Edit Profile"),
              //buildAccountOption(context, "Edit Profile"),
              //
              const SizedBox(
                height: 90,
              ),
              Row(
                children: [
                  Icon(Icons.volume_up_outlined,
                      color: Colors.black, size: (largeScreen ? 40 : 20)),
                  //
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    "Notifications",
                    //
                    //style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    style: TextStyle(
                        fontSize: (largeScreen ? 39 : 29),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(
                  //
                  height: 30,
                  thickness: 4),
              const SizedBox(
                //
                height: 20,
              ),
              buildNotificationRow("About to expire", true, largeScreen),
              buildNotificationRow("Adding to grocery list", true, largeScreen),
              buildNotificationRow("Account activity", true, largeScreen),
              SizedBox(height: (largeScreen ? 40 : 20)),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },

                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: ColorConstant.teal300,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Text(
                        "Sign Out",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtRobotoBold20.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Row buildNotificationRow(String text, bool isActive, bool largeScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              //height: (largeScreen ? 29 : 19),
              color: Colors.grey[600]),
        ),
        Transform.scale(
            scale: largeScreen ? 0.7 : 0.5,
            child: CupertinoSwitch(
              value: true,
              onChanged: (bool val) {},
            ))
      ],
    );
  }

  GestureDetector buildAccountOption(
      BuildContext context, String title, Widget myWidget) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => myWidget,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

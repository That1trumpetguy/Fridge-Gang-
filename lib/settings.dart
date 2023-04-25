
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
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
            const Text(
              "Settings",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 40,),
            Row(
              children: const [
                Icon(Icons.person, color: Colors.black),
                SizedBox(width: 8,),
                Text(
                  "Account",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(
                height: 15,
                thickness: 2
            ),
            const SizedBox(
              height: 10,
            ),

            buildAccountOption(context, "Edit Profile"),
            buildAccountOption(context, "Change Password"),
            buildAccountOption(context, "Edit Profile"),
            buildAccountOption(context, "Edit Profile"),

            const SizedBox(height: 40,),
            Row(
              children: const [
                Icon(Icons.volume_up_outlined, color: Colors.black),
                SizedBox(width: 8,),
                Text(
                  "Notifications",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

              ],
            ),
            const Divider(
                height: 15,
                thickness: 2
            ),
            const SizedBox(
              height: 10,
            ),
            buildNotificationRow("About to expire", true),
            buildNotificationRow("Adding to grocery list", true),
            buildNotificationRow("Account activity", true),
            const SizedBox(height: 100,),
            Center(
              child: OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffdbdfd1)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                        )
                    )
                  ),
                  onPressed: (){},
                  child: const Text("Sign Out", style: TextStyle(
                    fontSize: 16, letterSpacing: 2.2, color: Colors.black
                  ),)
              ),
            )
          ],

        )
      ),
    );
  }

  Row buildNotificationRow(String text, bool isActive) {
    return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text(text, style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[600]
            ),),
            Transform.scale(
                scale: 0.7,
                child: CupertinoSwitch(value: true, onChanged: (bool val) {},))
          ],
          );
  }

  GestureDetector buildAccountOption(BuildContext context, String title) {
    return GestureDetector(
            onTap: (){
              showDialog(context: context, builder: (BuildContext context){
                return AlertDialog(
                  title: Text(title),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text("Option 1"),
                      Text("Option 2"),
                      Text("Option 3"),
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {

                        },
                        child: const Text("close")),
                  ],
                );
              });

            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text(title, style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[600],
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


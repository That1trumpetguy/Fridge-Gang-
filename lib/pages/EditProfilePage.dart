import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool showPassword = false;
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
          children:  [
            const Text(
              "Edit Profile",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 25,
            ),
            buildTextField("Name", "John Doe", false),
            buildTextField("Email", "JDoe1234@gmail.com", false),
            buildTextField("Password", "*******************", true),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  OutlinedButton(
                    onPressed:  (){},
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 18,
                          letterSpacing: 2.0,
                          color: Colors.black
                        ),
                      ),
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Color(0xffdbdfd1),
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                    ),),
                ElevatedButton(
                    onPressed: (){},
                    child: const Text(
                      "Save",
                      style: TextStyle(
                          fontSize: 18,
                          letterSpacing: 2.0,
                          color: Colors.black
                      ),
                    ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffdbdfd1),
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                  ),
                ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding buildTextField(String labelText, String hintTxt, bool isPasswordField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: TextField(
              obscureText: isPasswordField ? showPassword : false,
              decoration: InputDecoration(
                suffixIcon: isPasswordField ? IconButton(onPressed: (){
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                    icon: const Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                ) : null,
                  contentPadding: EdgeInsets.only(bottom: 5),
                labelText: labelText,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: hintTxt,
                hintStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )
              ),
            ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class  ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {

  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  //todo: create function to authenticate and send user password reset email.
/*
  Future resetPassword() async {
    await FirebaseAuth.instance.
  }
 */

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          const Text('Enter your Email and we will send you a link to reset your password',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25)),
          const SizedBox(height: 15),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xffdbdfd1)),
                    borderRadius: BorderRadius.circular(12)
                ),
                hintText: 'Email',
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
          ),
          const SizedBox(height: 15),
          MaterialButton(
              onPressed: (){},
            child: const Text("Reset Password"),
            color: const Color(0xffdbdfd1),
          ),
        ],
      ),

    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPagetState();
}
  final ShawdowColor = Color.fromRGBO(0, 0, 0, 0.25);
  final SecondColor = Color.fromRGBO(0, 0, 0, 0.50);
  final BgColor = Color(0xFFE6E6E6);
  final MainColor = Color(0xFFF2D1AF);

class _ForgotPasswordPagetState extends State<ForgotPasswordPage> {
  final _ForgotPassword = TextEditingController();

  @override
  void dispose() {
    _ForgotPassword.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
      email: _ForgotPassword.text.trim());
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text("Password reset link sent!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        );
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text(e.message.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 25),
        child: Container(
          width: 350,
          height: 250,
          decoration: BoxDecoration(
             boxShadow: [
              BoxShadow(
                  color: ShawdowColor,
                  offset: Offset(0, 4),
                  blurRadius: 10.0),
              BoxShadow(
                  color: ShawdowColor,
                  offset: Offset(4, 0),
                  blurRadius: 10.0)
            ],
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.white
          ),
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
              Padding( // msg
                padding: const EdgeInsets.all(8.0),
                child: Text("Enter Your Email and we will send you password reset link",
                style: TextStyle(
                  fontSize: 18,
                  color: SecondColor,
                  ),
                ),
              ),
              Padding( // text field
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: (EdgeInsets.symmetric(horizontal: 0)),
                  child: TextField(
                    controller: _ForgotPassword,
                    style: TextStyle(color: SecondColor),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: SecondColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: MainColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Padding( // reset btn
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  child: Container(
                    width: 297,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: MainColor,
                            offset: Offset(0, 4),
                            blurRadius: 10.0),
                        BoxShadow(
                            color: MainColor,
                            offset: Offset(4, 0),
                            blurRadius: 10.0)
                      ],
                      borderRadius: BorderRadius.circular(12.0),
                      color: MainColor,
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(12.0),
                      color: MainColor,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.0),
                        onTap: passwordReset,
                        splashColor: Colors.white,
                        splashFactory: InkSplash.splashFactory,
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Reset',
                                style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
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


import 'package:flutter/material.dart';
import 'package:flutterchatapp/helper/helperfunctions.dart';
import 'package:flutterchatapp/services/auth.dart';
import 'package:flutterchatapp/services/database.dart';
import 'package:flutterchatapp/views/chatrooms.dart';
import 'package:flutterchatapp/widget/widget.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;

  const SignUp({Key key, this.toggleView}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  singUp() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService
          .signUpWithEmailAndPassword(
              emailEditingController.text, passwordEditingController.text)
          .then((result) {
        if (result != null) {
          //print("${result.uid}");

          Map<String, String> userDataMap = {
            "userName": usernameEditingController.text,
            "userEmail": emailEditingController.text
          };

          databaseMethods.addUserInfo(userDataMap);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              usernameEditingController.text);
          HelperFunctions.saveUserEmailSharedPreference(
              emailEditingController.text);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 50,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                                controller: usernameEditingController,
                                validator: (val) {
                                  return val.isEmpty || val.length < 3
                                      ? "Enter Username 3+ characters"
                                      : null;
                                },
                                decoration:
                                    textFieldInputDecoration("username"),
                                style: simpleTextStyle()),
                            TextFormField(
                                controller: emailEditingController,
                                validator: (val) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(val)
                                      ? null
                                      : "Enter correct email";
                                },
                                decoration: textFieldInputDecoration("email"),
                                style: simpleTextStyle()),
                            TextFormField(
                              obscureText: true,
                              controller: passwordEditingController,
                              validator: (val) {
                                return val.length < 6
                                    ? "Enter Password 6+ characters"
                                    : null;
                              },
                              decoration: textFieldInputDecoration("password"),
                              style: simpleTextStyle(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          singUp();
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xff007EF4),
                                    const Color(0xff2A75BC)
                                  ],
                                )),
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "Sign Up",
                              style: biggerTextStyle(),
                              textAlign: TextAlign.center,
                            )),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Sign Up with Google",
                            style:
                                TextStyle(fontSize: 17, color: Colors.black87),
                            textAlign: TextAlign.center,
                          )),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have account? ",
                            style: simpleTextStyle(),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggleView();
                            },
                            child: Text(
                              "Signin now",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

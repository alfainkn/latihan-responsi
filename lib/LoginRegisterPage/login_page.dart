import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latihan_responsi/LoginRegisterPage/register_page.dart';
import 'package:latihan_responsi/common_submit_button.dart';
import 'package:latihan_responsi/helper/hive_database.dart';
import 'package:latihan_responsi/helper/shared_preference.dart';
import 'package:latihan_responsi/main_menu/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void validateAndSave() {
    final FormState? form = _formKey.currentState;
    if(form != null){
      if (form.validate()) {
        ('Form is valid');
      } else {
        ('Form is invalid');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
                  child: Container(
                    // height:300.0,
                    // width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(width: 6, color: Colors.black),
                        borderRadius: BorderRadius.circular(200),
                      color: Colors.white,),

                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: CircleAvatar(
                      radius: 100,
                        backgroundColor: Colors.white,
                        backgroundImage: Image.asset('assets/images/github_logo.png',  fit: BoxFit.cover,).image,
                  ),
                    )),
                ),
            Center(
                child: Stack(
                  children: [
                    // The text border
                    Text(
                      'GitHub',
                      style: TextStyle(
                        fontSize: 70,
                        fontFamily: 'OpenSans',
                        letterSpacing: 5,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 5
                          ..color = Colors.black,
                      ),
                    ),
                    // The text inside
                    const Text(
                      'GitHub',
                      style: TextStyle(
                        fontSize: 70,
                        fontFamily: 'OpenSans',
                        letterSpacing: 5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.white70),
                        labelText: "Username",
                        hintText: "Username",
                        hintStyle: TextStyle(color: Colors.white38),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.grey),
                            borderRadius:
                            BorderRadius.all(Radius.circular(25.0))
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 3, color: Colors.grey),
                            borderRadius:
                            BorderRadius.all(Radius.circular(25.0))
                        ),

                    ),
                    validator: (value) => value!.isEmpty ? 'Username cannot be blank':null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.white70),
                        label: Text("Password"),
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.white38),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.grey),
                            borderRadius:
                            BorderRadius.all(Radius.circular(25.0))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.grey),
                          borderRadius:
                          BorderRadius.all(Radius.circular(25.0))
                      ),
                    ),
                    obscureText: true,
                    validator: (value) => value!.isEmpty ? 'Password cannot be blank' : null,
                  ),
                ),
                _buildLoginButton(),
                _buildRegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CommonSubmitButton(
        labelButton: "LOGIN",
        submitCallback: (value) {
          validateAndSave();
          String currentUsername = _usernameController.value.text;
          String currentPassword = _passwordController.value.text;

          _processLogin(currentUsername, currentPassword);
        },
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CommonSubmitButton(
        labelButton: "REGISTER",
        submitCallback: (value) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const RegisterPage(),
            ),
          );
        },
      ),
    );
  }

  void _processLogin(String username, String password) async {
    final HiveDatabase _hive = HiveDatabase();
    bool found = false;

    found = _hive.checkLogin(username, password);
    if(!found) {
      _showToast("Akun Tidak Ada",
          duration: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
    } else{
      String? history = _hive.getHistory(username);
      String? image = _hive.getImage(username);
      SharedPreference().setLogin(username, password);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Homepage(username:username, password: password, history: "$history", image: "$image",),
        ),
      );
    }
  }

  void _showToast(String msg, {Toast? duration, ToastGravity? gravity}){
    Fluttertoast.showToast(msg: msg, toastLength: duration, gravity: gravity);
  }
}






































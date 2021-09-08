import 'package:admin_umbizz/DialogBox/errorDialog.dart';
import 'package:admin_umbizz/DialogBox/loadingDialog.dart';
import 'package:admin_umbizz/Login/backgroundPainter.dart';
import 'package:admin_umbizz/MainScreens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // String email = "";
  // String password = "";

  returnEmailField(IconData icon, bool isObsecure) {
    return TextField(
      onChanged: (value) {
        _emailController.text = value;
      },
      obscureText: isObsecure,
      style: TextStyle(fontSize: 15.0, color: Colors.white),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),

        hintText: "Email",
        hintStyle: TextStyle(color: Colors.white),
        icon: Icon(
          icon,
          color: Colors.green,
        ),
      ),
    );
  }

  returnPasswordField(IconData icon, bool isObsecure) {
    return TextField(
      onChanged: (value) {
        _passwordController.text = value;
      },
      obscureText: isObsecure,
      style: TextStyle(fontSize: 15.0, color: Colors.white),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),

        hintText: "Password",
        hintStyle: TextStyle(color: Colors.white),
        icon: Icon(
          icon,
          color: Colors.green,
        ),
      ),
    );
  }

  returnLoginButton()
  {
    return ElevatedButton(
      onPressed: ()
      {
        _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty
            ? _loginAdmin()
            : showDialog(
            context: context,
            builder: (con){
              return ErrorAlertDialog(
                message: 'Please provide your credentials for Login',
              );
            });
      },
      child: Text(
        "Login",
        style: TextStyle(
            color: Colors.white,
            letterSpacing: 2.0,
            fontSize: 16.0
        ),
      ),
    );
  }

  void _loginAdmin() async {
    showDialog(
        context: context,
        builder: (_)
        {
          return LoadingAlertDialog();
        });

    // sign in then get the current user
    User currentUser;

    await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
    ).then((aAuth)
    {
      currentUser = aAuth.user;
    }).catchError((error)
    {
      Navigator.pop(context);

      showDialog(
          context: context,
          builder: (context)
          {
            return ErrorAlertDialog(
              message: "Error occured:" + error.toString(),
            );
          });
    });

    if(currentUser != null)
      {
      //homepage
      Route newRoute = MaterialPageRoute(builder: (context) => HomeScreen());
      Navigator.pushReplacement(context, newRoute);
      }
    else{
        //login
      Route newRoute = MaterialPageRoute(builder: (context) => LoginScreen());
      Navigator.pushReplacement(context, newRoute);
    }
  }


  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Stack(
        alignment: Alignment.lerp(
            Alignment.lerp(Alignment.centerRight, Alignment.center, 0.3),
            Alignment.topCenter,
            0.15,
        ),
          children: [
          CustomPaint(
            painter: BackgroundPainter(),
            child: Container(height: _screenHeight,),
          ),
          Center(
            child: Container(
              width: _screenWidth * .5,
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: Image.asset(
                        "images/admin_logo.png", width: 300, height: 300,),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50.0),
                    child: returnEmailField(Icons.person, false),
                  ),
                  SizedBox(height: 20.0,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50.0),
                    child: returnPasswordField(Icons.person, true),
                  ),
                  SizedBox(height: 40.0,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.0),
                        child: returnLoginButton(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        ),
      );
  }
}

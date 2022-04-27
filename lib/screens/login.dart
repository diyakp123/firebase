import 'package:firebase/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase/screens/signup.dart';
import 'package:firebase/screens/home.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget{
   @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}


class _LoginScreenState extends State<LoginScreen>{

 
  final _formKey = GlobalKey<FormState>();

  //editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();


  //firebase
  final _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {

    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value){
        if(value!.isEmpty){
          return ("please enter email");
        }
        //reg expression for email verification
        if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
          return ("please enter a valid email");
        }
        return null;
      },

      onSaved: (value){
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon:Icon(Icons.mail),
        contentPadding: EdgeInsets.all(15),
        hintText: "email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ), 
      ),
    );

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },
      onSaved: (value){
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
       decoration: InputDecoration(
        prefixIcon:Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.all(15),
        hintText: "password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ), 
      )
    );

    final loginButton = Material(
      elevation: 5,
      color: Colors.redAccent,
      borderRadius: BorderRadius.circular(30),
      child : MaterialButton(
        onPressed: ()=>{
          signIn(emailController.text, passwordController.text),
        },
        child: Text(
          "login", 
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white,
            fontSize: 25, fontWeight: FontWeight.bold),
          ),
        
        padding: EdgeInsets.all(20),
        minWidth: MediaQuery.of(context).size.width,
        )
    );

    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.red, because the theme is red, the bg automatically becomes red unless stated otherwise
        
        title: Text("Login Page",style:TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.white,
      body:Center(
        child: SingleChildScrollView(
          child: Container(
            //color: Colors.lime,
            child: Padding(
              padding: const EdgeInsets.all(36),
              child: Form(
                key: _formKey,
                child: Column(

                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children:<Widget> [
                    emailField, SizedBox(height: 15,),
                    passwordField, SizedBox(height: 25),
                    loginButton, SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Text("don't have an account? "),
                        GestureDetector(onTap: ()=>{
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => RegistrationScreen()
                              )
                              )
                        },
                        child: Text("sign up", style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                  ]
                  ),
                  ),
            )
          ),
        ),
      ),
    );
  }
  

  
void signIn(String email, String password) async {
  if(_formKey.currentState!.validate()){
    await _auth
    .signInWithEmailAndPassword(email: email, password: password)
    .then((uid) => {
      Fluttertoast.showToast(msg: "login successful"),
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => homeScreen()))
    }).catchError((e){
      Fluttertoast.showToast(msg: e!.message);
    });
  }
}

}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase/screens/signup.dart';
import 'package:firebase/screens/home.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:firebase/models/user_model.dart';

class RegistrationScreen extends StatefulWidget{
  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
   return  _RegistrationScreenState();
  }
}

class _RegistrationScreenState extends State<RegistrationScreen>{

  final _formKey =  GlobalKey<FormState>();

  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("First Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
      onSaved: (value){
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon:Icon(Icons.person),
        contentPadding: EdgeInsets.all(15),
        hintText: "first name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ), 
      ),
    );

    final secondNameField = TextFormField(
      autofocus: false,
      controller: secondNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("First Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
      onSaved: (value){
        secondNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon:Icon(Icons.person),
        contentPadding: EdgeInsets.all(15),
        hintText: "second name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ), 
      ),
    );

    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
      onSaved: (value){
        emailEditingController.text = value!;
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
      controller: passwordEditingController,
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
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
       decoration: InputDecoration(
        prefixIcon:Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.all(15),
        hintText: "password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ), 
      )
    );

    final confirmpasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: true,
      validator: (value) {
          if (confirmPasswordEditingController.text !=
              passwordEditingController.text) {
            return "Password don't match";
          }
          return null;
        },
      onSaved: (value){
        confirmPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
       decoration: InputDecoration(
        prefixIcon:Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.all(15),
        hintText: "confirm password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ), 
      )
    );

    final signupButton = Material(
      elevation: 5,
      color: Colors.redAccent,
      borderRadius: BorderRadius.circular(30),
      child : MaterialButton(
        onPressed: ()=>{
          signUp(emailEditingController.text, passwordEditingController.text)
        },
        child: Text(
          "Signup", 
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
        backgroundColor: Colors.red,
        leading: IconButton(
          icon:Icon(Icons.arrow_back, color:Colors.white), 
          onPressed: () { 
            Navigator.of(context).pop();
           },
          
          )
        
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
           // color: Colors.blueAccent,
            child: Padding(
              padding: EdgeInsets.all(36),
              child: Form(
                  key : _formKey,
                  child: Column(
        
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      firstNameField,SizedBox(height: 15,),
                      secondNameField,SizedBox(height: 15,),
                      emailField,SizedBox(height: 15,),
                      passwordField,SizedBox(height: 15,),
                      confirmpasswordField, SizedBox(height: 25,),
                      signupButton,
        
        
                    ]),
                ),
              )
          ),
        ),
      ),
    );
  }

 void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth.createUserWithEmailAndPassword(email: email, password: password)
      .then((value) => {
        postDetailsToFirestore()
      }).catchError((e){
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

 postDetailsToFirestore() async{
   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    
    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.secondName = secondNameEditingController.text;

     await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => homeScreen()),
        (route) => false);

 }

}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase/models/user_model.dart';

class homeScreen extends StatefulWidget{
  State<StatefulWidget> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen>{

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }


  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:Text("Home Screen", style: TextStyle(color:Colors.white)),
      ),
        body: Center(
          child:Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 Text(
                  "Welcome back",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                ),
                SizedBox(height: 20),
                Text("${loggedInUser.firstName} ${loggedInUser.secondName}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),                
                ),
                Text("${loggedInUser.email}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  )),
              SizedBox(
                height: 15,
              ),
                ActionChip(label: Text("logout"), onPressed: (){
                  logout(context);
                })
              ],)
          )
        ),
    );
  }

  Future<void> logout(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => LoginScreen())));
  }
}
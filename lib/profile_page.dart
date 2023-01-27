import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final ShawdowColor = Color.fromRGBO(0, 0, 0, 0.25);
  final SecondColor = Color.fromRGBO(0, 0, 0, 0.50);
  final BgColor = Color(0xFFE6E6E6);
  final MainColor = Color(0xFFF2D1AF);
  final Logo = Image(image: AssetImage('assets/cafein_logo.png'),fit: BoxFit.cover,);
  final TestIMG = ImageIcon(AssetImage('assets/ratting.png',),color: Color(0xFFF2D1AF));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").where("uid", isEqualTo: user.uid).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.hasData){
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context,i){
              var data = snapshot.data!.docs[i];
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 104,
                    backgroundImage: NetworkImage(data["image"]),
                  ),
                  SizedBox(height: 10,),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:20,vertical: 2.5),
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: SecondColor,),
                            SizedBox(width: 10),
                            Text(
                              data["username"],
                              style: TextStyle(color: SecondColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:20,vertical: 2.5),
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            Icon(
                              Icons.email,
                              color: SecondColor,),
                            SizedBox(width: 10),
                            Text(
                              data["email"],
                              style: TextStyle(color: SecondColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:20,vertical: 2.5),
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_reaction,
                              color: SecondColor,),
                            SizedBox(width: 10),
                            Text(
                              data["gender"],
                              style: TextStyle(color: SecondColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:20,vertical: 2.5),
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_search,
                              color: SecondColor,),
                            SizedBox(width: 10),
                            Text(
                              data["age"].toString(),
                              style: TextStyle(color: SecondColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        }else{
          return CircularProgressIndicator();
        }
      }),
    );
  }
}

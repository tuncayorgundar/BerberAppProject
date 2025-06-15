import 'dart:math';

import 'package:berber_proje/Admin/booking_admin.dart';
import 'package:berber_proje/services/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class ProfileImageHelper {
  // Tüm profil resimlerinin listesi
  static final List<String> profileImages = [
    'images/profiles/profile1.png',
    'images/profiles/profile2.png',
    'images/profiles/profile3.png',
    'images/profiles/profile4.png',
    'images/profiles/profile5.png',
    'images/profiles/profile6.png',
    'images/profiles/profile7.png',
    'images/profiles/profile8.png',
    'images/profiles/profile9.png',
  ];

  // Rastgele profil resmi seçme metodu
  static String getRandomProfileImage() {
    return profileImages[Random().nextInt(profileImages.length)];
  }
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController usernamecontroller = new TextEditingController();
  TextEditingController userpasswordcontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 40.0, left: 20.0),
              height: MediaQuery.of(context).size.width / 2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color(0xFFB91635),
                Color(0xFF621d3c),
                Color(0xFF311937)
              ])),
              child: Text("Berber\nSayfası",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 30.0),
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.width / 2.5),
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.black,
                            size: 20.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text("Kullanıcı Adı",
                        style: TextStyle(
                            color: Color(0xFFB91635),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500)),
                    TextFormField(
                      controller: usernamecontroller,
                      decoration: InputDecoration(
                          hintText: "Kullanıcı Adı",
                          prefixIcon: Icon(Icons.mail_outline)),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text("Şifre",
                        style: TextStyle(
                            color: Color(0xFFB91635),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500)),
                    TextFormField(
                      controller: userpasswordcontroller,
                      decoration: InputDecoration(
                        hintText: "Şifre",
                        prefixIcon: Icon(Icons.password_outlined),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        loginAdmin();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color(0xFFB91635),
                              Color(0xFF621d3c),
                              Color(0xFF311937)
                            ]),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            "GİRİŞ YAP",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  loginAdmin() async {
    String username = usernamecontroller.text.trim();
    String password = userpasswordcontroller.text.trim();

    // Firestore'dan kullanıcı adına göre admin belgesini çek
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Admin")
        .where("Username", isEqualTo: username)
        .get();

    // Eğer belge bulunamadıysa
    if (querySnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Kullanıcı adınız doğru değil",
          style: TextStyle(fontSize: 20.0),
        ),
      ));
      return;
    }

    // Bulunan belgeyi al
    DocumentSnapshot adminDoc = querySnapshot.docs.first;

    // Şifreyi kontrol et
    if (adminDoc['password'] != password) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Şifreniz doğru değil",
          style: TextStyle(fontSize: 20.0),
        ),
      ));
      return;
    }

    // Eğer her şey doğruysa, rastgele profil resmi seç ve SharedPreferences'a kaydet
    String randomProfileImage = ProfileImageHelper.getRandomProfileImage();
    SharedPreferenceHelper().saveAdminName(username);
    SharedPreferenceHelper().saveAdminPass(password);
    SharedPreferenceHelper().saveAdminImage(randomProfileImage);

    // Admin sayfasına yönlendir
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookingAdmin()),
    );
  }
}

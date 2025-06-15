import 'dart:math';
import 'package:berber_proje/pages/home.dart';
import 'package:berber_proje/pages/login.dart';
import 'package:berber_proje/services/database.dart';
import 'package:berber_proje/services/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
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

class _SignUpState extends State<SignUp> {
  String? name, mail, password, phoneN;

  TextEditingController namecontroller = new TextEditingController();
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();
  TextEditingController phonenumbercontroller = new TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration() async {
    if (password != null && name != null && mail != null) {
      try {
        String randomProfileImage = ProfileImageHelper.getRandomProfileImage();

        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: mail!, password: password!);

        User? user = userCredential.user;
        //String id = randomAlphaNumeric(10);
        await SharedPreferenceHelper()
            .saveUserName(namecontroller.text, user!.uid);
        await SharedPreferenceHelper()
            .saveUserEmail(emailcontroller.text, user.uid);
        await SharedPreferenceHelper()
            .saveUserImage(randomProfileImage, user.uid);
        await SharedPreferenceHelper().saveUserId(user.uid);
        await SharedPreferenceHelper()
            .saveUserPhone(phonenumbercontroller.text, user.uid);
        Map<String, dynamic> userInfoMap = {
          "Name": namecontroller.text,
          "Email": emailcontroller.text,
          "id": user.uid,
          "Image": randomProfileImage,
          "Phone": phonenumbercontroller.text,
        };
        await DatabaseMethods().addUserDetails(userInfoMap, user.uid);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Başarıyla Kayıt Oldunuz",
            style: TextStyle(fontSize: 20.0),
          ),
        ));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Şifre çok zayıf",
              style: TextStyle(fontSize: 20.0),
            ),
          ));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Bu e-posta zaten kullanımda",
              style: TextStyle(fontSize: 20.0),
            ),
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 30.0, left: 10.0),
              height: MediaQuery.of(context).size.width / 1.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color(0xFFB91635),
                Color(0xFF621d3c),
                Color(0xFF311937)
              ])),
              child: Text("Hesabınızı\nOluşturun",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 30.0),
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.width / 2),
              //height: MediaQuery.of(context).size.width,
              //width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Adınız",
                        style: TextStyle(
                            color: Color(0xFFB91635),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500)),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen adınızı girin';
                        }
                        return null;
                      },
                      controller: namecontroller,
                      decoration: InputDecoration(
                          hintText: "Adınız",
                          prefixIcon: Icon(Icons.person_outline)),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text("E-posta",
                        style: TextStyle(
                            color: Color(0xFFB91635),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500)),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen e-posta adresinizi girin';
                        }
                        return null;
                      },
                      controller: emailcontroller,
                      decoration: InputDecoration(
                          hintText: "E-posta",
                          prefixIcon: Icon(Icons.mail_outline)),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text("Telefon Numarası",
                        style: TextStyle(
                            color: Color(0xFFB91635),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500)),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen telefon numaranızı girin';
                        }
                        return null;
                      },
                      controller: phonenumbercontroller,
                      decoration: InputDecoration(
                        hintText: "Telefon Numarası",
                        prefixIcon: Icon(Icons.phone_android),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text("Şifre",
                        style: TextStyle(
                            color: Color(0xFFB91635),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500)),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen şifrenizi girin';
                        }
                        return null;
                      },
                      controller: passwordcontroller,
                      decoration: InputDecoration(
                        hintText: "Şifre",
                        prefixIcon: Icon(Icons.password_outlined),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            mail = emailcontroller.text;
                            name = namecontroller.text;
                            password = passwordcontroller.text;
                            phoneN = phonenumbercontroller.text;
                          });
                        }
                        registration();
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
                            "KAYIT OL",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Zaten bir hesabınız var mı?",
                          style: TextStyle(
                              color: Color(0xFF311937),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LogIn()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Giriş Yap",
                            style: TextStyle(
                                color: Color(0xFF621d3c),
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

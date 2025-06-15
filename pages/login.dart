import 'package:berber_proje/pages/forgot_password.dart';
import 'package:berber_proje/pages/home.dart';
import 'package:berber_proje/pages/signup.dart';
import 'package:berber_proje/services/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LoginState();
}

class _LoginState extends State<LogIn> {
  String? mail, password;

  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  final _formkey = GlobalKey<FormState>();

  userLogin() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: mail!, password: password!);

      // Giriş başarılı ise kullanıcı bilgilerini kaydet
      User? user = userCredential.user;
      if (user != null) {
        // Kullanıcı ID'sini kaydet
        await SharedPreferenceHelper().saveUserId(user.uid);
        print(user.uid);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Bir hata oluştu!",
                style: TextStyle(fontSize: 20.0, color: (Colors.black)))));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Bu e-posta adresine ait kullanıcı bulunamadı",
                style: TextStyle(fontSize: 20.0, color: (Colors.black)))));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Yanlış şifre girdiniz",
                style: TextStyle(fontSize: 20.0, color: (Colors.black)))));
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
              padding: EdgeInsets.only(top: 40.0, left: 20.0),
              height: MediaQuery.of(context).size.width / 2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color(0xFFB91635),
                Color(0xFF621d3c),
                Color(0xFF311937)
              ])),
              child: Text("Merhaba\nGiriş Yap!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 30.0),
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.width / 2.3),
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
                    Text("E-posta",
                        style: TextStyle(
                            color: Color(0xFFB91635),
                            fontSize: 20.0,
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
                      height: 30.0,
                    ),
                    Text("Şifre",
                        style: TextStyle(
                            color: Color(0xFFB91635),
                            fontSize: 20.0,
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
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPassword()));
                          },
                          child: Text("Şifremi Unuttum?",
                              style: TextStyle(
                                  color: Color(0xFF311937),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            mail = emailcontroller.text;
                            password = passwordcontroller.text;
                          });
                          userLogin();
                        }
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
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    //Spacer(),
                    SizedBox(
                      height: 40.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Hesabınız yok mu?",
                          style: TextStyle(
                              color: Color(0xFF311937),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Kayıt Ol",
                            style: TextStyle(
                                color: Color(0xFF621d3c),
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
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
}

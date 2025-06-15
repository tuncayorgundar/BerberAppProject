import 'package:berber_proje/Admin/admin_login.dart';
import 'package:berber_proje/pages/booking.dart';
import 'package:berber_proje/pages/books.dart';
import 'package:berber_proje/pages/profile.dart';
import 'package:berber_proje/services/shared_pref.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? name, image;

  getTheDataFromSharedPref() async {
    final String? userId = await SharedPreferenceHelper().getUserId();
    name = await SharedPreferenceHelper().getUserName(userId!);
    image = await SharedPreferenceHelper().getUserImage(userId);
    setState(() {});
  }

  getTheLoad() async {
    await getTheDataFromSharedPref();
    setState(() {});
  }

  @override
  void initState() {
    getTheLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF2b1615),
        body: Container(
          margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Merhaba,",
                          style: TextStyle(
                              color: Color.fromARGB(197, 255, 255, 255),
                              fontSize: 24.0,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          name ?? "Misafir",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold),
                        )
                      ]),
                  GestureDetector(
                    onTap: () {
                      // Profil sayfasına yönlendir
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                  name: name ?? "Misafir",
                                  image: image ?? "")));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: image != null
                          ? Image.asset(
                              image!,
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white,
                            ), // Null ise bir ikon göster
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Divider(
                color: Colors.white38,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Hizmetler",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Booking(service: 'Klasik Traş')));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        height: 150,
                        decoration: BoxDecoration(
                            color: Color(0xFFe29452),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "images/shaving.png",
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "Klasik Traş",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Booking(service: 'Saç Yıkama')));
                      },
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                            color: Color(0xFFe29452),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "images/hair.png",
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "Saç Yıkama",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Booking(service: 'Saç Kesimi')));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        height: 150,
                        decoration: BoxDecoration(
                            color: Color(0xFFe29452),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "images/cutting.png",
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "Saç Kesimi",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Booking(service: 'Sakal Tıraşı')));
                      },
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                            color: Color(0xFFe29452),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "images/beard.png",
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "Sakal Tıraşı",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminLogin()));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        height: 150,
                        decoration: BoxDecoration(
                            color: Color(0xFFe29452),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "images/admin_icon.png",
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "Berber Sayfası",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => bookings_page()));
                      },
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                            color: Color(0xFFe29452),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "images/books.png",
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "Rezervasyonlar",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

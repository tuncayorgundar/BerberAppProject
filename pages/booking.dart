import 'package:berber_proje/services/database.dart';
import 'package:berber_proje/services/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Booking extends StatefulWidget {
  String service;
  Booking({required this.service});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  String? name, image, email, phone;
  String? selectedAdminName, selectedAdminImage;
  int? selectedAdminIndex;

  Stream? adminsStream;

  getTheDataFromSharedPref() async {
    final String? userId = await SharedPreferenceHelper().getUserId();
    name = await SharedPreferenceHelper().getUserName(userId!);
    image = await SharedPreferenceHelper().getUserImage(userId);
    email = await SharedPreferenceHelper().getUserEmail(userId);
    phone = await SharedPreferenceHelper().getUserPhone(userId);
    setState(() {});
  }

  getTheLoad() async {
    await getTheDataFromSharedPref();
    setState(() {});
  }

  getUsersFromFirestore() async {
    adminsStream = await DatabaseMethods().getAdmins();
    setState(() {});
  }

  @override
  void initState() {
    getTheLoad();
    getUsersFromFirestore();
    super.initState();
  }

  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2024),
        lastDate: DateTime(2025));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<List<String>> getBookedSlots(String adminName, String date) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Booking")
        .where("AdminName", isEqualTo: adminName) // AdminName'e göre filtrele
        .where("Date", isEqualTo: date) // Tarihe göre filtrele
        .get();

    List<String> bookedSlots = [];
    for (var doc in snapshot.docs) {
      bookedSlots
          .add(doc["Time"]); // Zaten alınmış olan randevu saatlerini ekleyin
    }
    return bookedSlots;
  }

  TimeOfDay _selectedTime = TimeOfDay.now();

  List<String> generateTimeSlots(List<String> bookedSlots) {
    List<String> timeSlots = [];
    int startHour = 9; // Sabah 9
    int endHour = 22; // Akşam 10
    for (int hour = startHour; hour < endHour; hour++) {
      String slot1 = "$hour:00";
      String slot2 = "$hour:30";

      // Eğer slot1 zaten alınmışsa, listede gösterme
      if (!bookedSlots.contains(slot1)) {
        timeSlots.add(slot1);
      }
      // Eğer slot2 zaten alınmışsa, listede gösterme
      if (!bookedSlots.contains(slot2)) {
        timeSlots.add(slot2);
      }
    }
    // Son saat slotu (22:00)
    if (!bookedSlots.contains("$endHour:00")) {
      timeSlots.add("$endHour:00"); // 22:00 eklenir
    }
    return timeSlots;
  }

  Future<void> _selectTime(BuildContext context) async {
    if (selectedAdminName == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Lütfen bir berber seçin!",
          style: TextStyle(fontSize: 20.0),
        ),
      ));
      return;
    }

    String date =
        "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}";

    // Firestore'dan berberin seçilen tarih ve saatteki randevularını çek
    List<String> bookedSlots = await getBookedSlots(selectedAdminName!, date);

    // Saat slotlarını oluştur
    List<String> timeSlots = generateTimeSlots(bookedSlots);

    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: timeSlots.length,
            itemBuilder: (context, index) {
              bool isBooked = bookedSlots.contains(timeSlots[index]);
              return ListTile(
                title: Text(
                  timeSlots[index],
                  style: TextStyle(
                    color: isBooked
                        ? Colors.red
                        : Colors.black, // Kırmızı veya siyah renk
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: isBooked
                    ? null // Eğer randevu alınmışsa tıklanamaz
                    : () {
                        setState(() {
                          _selectedTime = TimeOfDay(
                            hour: int.parse(timeSlots[index].split(":")[0]),
                            minute: int.parse(timeSlots[index].split(":")[1]),
                          );
                        });
                        Navigator.pop(context); // Seçimden sonra kapat
                      },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2b1615),
      body: Container(
        margin: EdgeInsets.only(left: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Text(
                "RANDEVU AL",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 70.0,
            ),
            Text(
              "Berberler",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              child: StreamBuilder(
                stream: adminsStream,
                builder: (context, AsyncSnapshot snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot ds = snapshot.data.docs[index];

                            return GestureDetector(
                              onTap: () {
                                // Seçilen admin bilgilerini kaydet
                                setState(() {
                                  selectedAdminName = ds['Username'];
                                  selectedAdminImage = ds['Image'];
                                  selectedAdminIndex = index;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: selectedAdminIndex == index
                                        ? Colors.orange
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundImage: AssetImage(ds['Image']),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      ds['Username'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                      : Container();
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              widget.service,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10.0),
              decoration: BoxDecoration(
                  color: Color(0xFFb4817e),
                  borderRadius: BorderRadius.circular(20)),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Text(
                    "Tarih Seç",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10.0),
              decoration: BoxDecoration(
                  color: Color(0xFFb4817e),
                  borderRadius: BorderRadius.circular(20)),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Text(
                    "Saat Seç",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _selectTime(context);
                        },
                        child: Icon(
                          Icons.alarm,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        "${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: () async {
                if (selectedAdminName == null || selectedAdminImage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "Lütfen bir berber seçin!",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ));
                  return;
                }

                // Aynı berbere, aynı tarih ve saate randevu kontrolü
                QuerySnapshot existingBookings = await FirebaseFirestore
                    .instance
                    .collection(
                        "Booking") // Firestore koleksiyon adınıza göre değişebilir
                    .where("AdminName", isEqualTo: selectedAdminName)
                    .where("Date",
                        isEqualTo:
                            "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}")
                    .where("Time", isEqualTo: _selectedTime.format(context))
                    .where("Service", isEqualTo: widget.service)
                    .get();

                // Eğer zaten bir randevu varsa
                if (existingBookings.docs.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "Seçilen tarih ve saatte zaten bir randevu bulunmaktadır!",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ));
                  return;
                }

                Map<String, dynamic> UserBookingmap = {
                  "Service": widget.service,
                  "Date":
                      "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                  "Time": _selectedTime.format(context),
                  "Username": name,
                  "Image": image,
                  "Email": email,
                  "Phone": phone,
                  "AdminName": selectedAdminName,
                  "AdminImage": selectedAdminImage,
                };

                await DatabaseMethods()
                    .addUserBooking(UserBookingmap)
                    .then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "Randevu başarıyla alındı!",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ));
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                decoration: BoxDecoration(
                    color: Color(0xFFfe8f33),
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: Text(
                    "RANDEVU AL",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

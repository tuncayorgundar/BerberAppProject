import 'package:berber_proje/pages/login.dart';
import 'package:berber_proje/services/database.dart';
import 'package:berber_proje/services/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String name;
  final String image;

  ProfilePage({required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2b1615),
      appBar: AppBar(
        backgroundColor: Color(0xFFe29452),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Profil',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Image.asset(
                image,
                height: 120.0,
                width: 120.0,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40.0),
            Divider(
              color: Colors.white38,
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>?>(
                future: _getLastBooking(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Hata: ${snapshot.error}',
                            style: TextStyle(color: Colors.white)));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Center(
                        child: Text('Son randevunuz bulunamadı.',
                            style: TextStyle(color: Colors.white)));
                  } else {
                    final booking = snapshot.data!;
                    return Column(
                      children: [
                        Text(
                          'Son Randevunuz',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        // Randevu Bilgilerini Kart İçerisinde Göster
                        Card(
                          color: Color(0xFFe29452),
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow('Hizmet', booking['Service']),
                                _buildInfoRow('Tarih', booking['Date']),
                                _buildInfoRow('Saat', booking['Time']),
                                _buildInfoRow(
                                    'Berber Adı', booking['AdminName']),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _logout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFe29452),
              ),
              child: Text(
                'Çıkış Yap',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  // Bilgi satırı oluşturmak için yardımcı fonksiyon
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>?> _getLastBooking() async {
    final String? userId = await SharedPreferenceHelper().getUserId();
    final String? username =
        await SharedPreferenceHelper().getUserName(userId!);

    if (username == null) return null;

    return await DatabaseMethods().getLastBookingForUser(username);
  }

  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LogIn()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Çıkış yapma işlemi sırasında bir hata oluştu: $e'),
        ),
      );
    }
  }
}

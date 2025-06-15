import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future addUserBooking(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Booking")
        .add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getBookings() async {
    return await FirebaseFirestore.instance.collection("Booking").snapshots();
  }

  Future DeleteBooking(String id) async {
    return await FirebaseFirestore.instance
        .collection("Booking")
        .doc(id)
        .delete();
  }

  Future<Stream> getAdmins() async {
    return FirebaseFirestore.instance.collection('Admin').snapshots();
  }

  Future<Stream<QuerySnapshot>> getBookingsForAdmin(
      String? adminUsername) async {
    return FirebaseFirestore.instance
        .collection('Booking')
        .where('AdminName', isEqualTo: adminUsername)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getBookingsForUsers(String? Username) async {
    return FirebaseFirestore.instance
        .collection('Booking')
        .where('Username', isEqualTo: Username)
        .snapshots();
  }

  Future<Map<String, dynamic>?> getLastBookingForUser(String username) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Booking')
        .where('Username', isEqualTo: username)
        .orderBy('Date', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data();
    } else {
      return null;
    }
  }
}

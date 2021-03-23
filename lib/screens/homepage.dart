//Flutter Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospitalAdmin/constants/resources.dart';
import 'package:hospitalAdmin/globals/responsive.dart';
import 'package:hospitalAdmin/globals/user_details.dart';
import 'package:hospitalAdmin/screens/hospital_page.dart';
import 'package:hospitalAdmin/screens/profile_screen.dart';
import 'package:hospitalAdmin/theme/app_theme.dart';
import 'package:hospitalAdmin/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _suggestionsController = TextEditingController();
  List<Widget> _hospitals = [];

  @override
  void dispose() {
    super.dispose();
    _suggestionsController.dispose();
  }

  @override
  void initState() {
    super.initState();
    getHospitals();
  }

  getHospitals() async {
    try {
      Future.delayed(Duration(milliseconds: 100)).whenComplete(() async {
        _hospitals = [];
        Utils.showProgressBar();
        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection('Hospital').get();
        if (querySnapshot != null) {
          if (querySnapshot.docs.length > 0) {
            for (int index = 0;
                index <
                    (querySnapshot.docs.length > 6
                        ? 6
                        : querySnapshot.docs.length);
                index++) {
              _hospitals.add(GestureDetector(
                onTap: () => Get.to(HospitalPage(
                  hospitalID: querySnapshot.docs[index].id,
                  name: querySnapshot.docs[index].data()['name'],
                )),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Row(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey.withOpacity(0.41),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(querySnapshot.docs[index]
                                    .data()['profilePicture'])),
                            borderRadius: BorderRadius.circular(1000)),
                      ),
                      SizedBox(width: 15),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(querySnapshot.docs[index].data()['name'],
                            style: TextStyle(
                                fontFamily: AppTheme.poppinsBold,
                                color: AppTheme.primaryColor)),
                      )
                    ],
                  ),
                ),
              ));
            }
          }
        }
        setState(() {});
        Get.back();
      });
    } catch (error) {
      print(error);
      Get.back();
    }
  }

  PageController _pageController = PageController();
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.offWhite,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () async {
              try {
                dynamic response = await Get.to(ProfilePage());
                if (response) {}
              } catch (error) {
                print(error);
                setState(() {});
              }
            },
            child: Padding(
                padding: EdgeInsets.all(10),
                child: CircleAvatar(
                    child: Icon(Icons.person, color: AppTheme.whiteColor),
                    backgroundColor: AppTheme.primaryColor,
                    radius: 20)),
          ),
          title: Container(
            height: size(35),
            child: Image.asset(logoJPEG),
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          height: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _pageController.jumpToPage(0);
                  }),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_hospital,
                        color: AppTheme.primaryColor,
                        size: 30,
                      ),
                      if (index == 0)
                        Text('Hospitals',
                            style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontFamily: AppTheme.poppinsBold)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _pageController.jumpToPage(1);
                  }),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        color: AppTheme.primaryColor,
                        size: 30,
                      ),
                      if (index == 1)
                        Text('Users',
                            style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.primaryColor,
                                fontFamily: AppTheme.poppinsBold)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _pageController.jumpToPage(2);
                  }),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.feedback,
                        color: AppTheme.primaryColor,
                        size: 30,
                      ),
                      if (index == 2)
                        Text('Feedback',
                            style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.primaryColor,
                                fontFamily: AppTheme.poppinsBold)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _pageController.jumpToPage(3);
                  }),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.group_add,
                        color: AppTheme.primaryColor,
                        size: 30,
                      ),
                      if (index == 3)
                        Text('New\nCustomers',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.primaryColor,
                                fontFamily: AppTheme.poppinsBold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    AppBar().preferredSize.height,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() {
                    this.index = index;
                  }),
                  children: [
                    SingleChildScrollView(
                        child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: Column(
                        children: [
                          if (_hospitals.length > 0) ..._hospitals,
                          SizedBox(height: 5),
                          SizedBox(height: size(50))
                        ],
                      ),
                    )),
                    Users(),
                    FeedbackPage(),
                    NewCustomers(),
                  ],
                ))));
  }
}

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  List<Widget> _customers = [];

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  getUsers() async {
    try {
      Future.delayed(Duration(milliseconds: 100)).whenComplete(() async {
        _customers = [];
        Utils.showProgressBar();
        QuerySnapshot snapshot =
            await FirebaseFirestore.instance.collection('User').get();
        if (snapshot != null) {
          if (snapshot.docs.length > 0) {
            for (int index = 0; index < snapshot.docs.length; index++) {
              _customers.add(Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.docs[index].data()['name'],
                        style: TextStyle(
                            fontFamily: AppTheme.poppinsBold,
                            color: AppTheme.primaryColor),
                      ),
                      Text(
                        'Phone - ' + snapshot.docs[index].id,
                        style: TextStyle(
                            fontFamily: AppTheme.poppins,
                            color: AppTheme.primaryColor),
                      ),
                      Text(
                        'Membership Status - ' +
                            (snapshot.docs[index].data()['status'] == true
                                ? 'Premium'
                                : 'Trial'),
                        style: TextStyle(
                            fontFamily: AppTheme.poppins,
                            color: AppTheme.primaryColor),
                      ),
                      Text(
                        'Expires On - ' +
                            DateFormat('dd MMM yyyy').format(DateTime.parse(
                                snapshot.docs[index]
                                    .data()['expirey']
                                    .toString())),
                        style: TextStyle(
                            fontFamily: AppTheme.poppins,
                            color: AppTheme.primaryColor),
                      ),
                      Text(
                        'Phone - ' + snapshot.docs[index].id,
                        style: TextStyle(
                            fontFamily: AppTheme.poppins,
                            color: AppTheme.primaryColor),
                      ),
                    ],
                  )));
            }
          }
        }
        Get.back();
        setState(() {});
      });
    } catch (error) {
      print(error);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [if (_customers.length > 0) ..._customers],
    ));
  }
}

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  List<Widget> _newCustomers = [];

  @override
  void initState() {
    super.initState();
    getNewUsers();
  }

  getNewUsers() async {
    try {
      Future.delayed(Duration(milliseconds: 100)).whenComplete(() async {
        _newCustomers = [];
        Utils.showProgressBar();
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('Admin')
            .doc('Feedback')
            .collection('List')
            .get();
        if (snapshot != null) {
          if (snapshot.docs.length > 0) {
            for (int index = 0; index < snapshot.docs.length; index++) {
              _newCustomers.add(Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.docs[index].data()['name'],
                        style: TextStyle(
                            fontFamily: AppTheme.poppinsBold,
                            color: AppTheme.primaryColor),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          'Feedback - ' +
                              snapshot.docs[index].data()['feedback'],
                          style: TextStyle(
                              fontFamily: AppTheme.poppins,
                              color: AppTheme.primaryColor),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          'Hospital - ' +
                              snapshot.docs[index].data()['hospital'],
                          style: TextStyle(
                              fontFamily: AppTheme.poppins,
                              color: AppTheme.primaryColor),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          'Address - ' + snapshot.docs[index].data()['address'],
                          style: TextStyle(
                              fontFamily: AppTheme.poppins,
                              color: AppTheme.primaryColor),
                        ),
                      ),
                      Text(
                        'Phone - ' + snapshot.docs[index].data()['number'],
                        style: TextStyle(
                            fontFamily: AppTheme.poppins,
                            color: AppTheme.primaryColor),
                      ),
                    ],
                  )));
            }
          }
        }
        Get.back();
        setState(() {});
      });
    } catch (error) {
      print(error);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        if (_newCustomers.length > 0) ..._newCustomers,
        SizedBox(height: 150)
      ],
    ));
  }
}

class NewCustomers extends StatefulWidget {
  @override
  _NewCustomersState createState() => _NewCustomersState();
}

class _NewCustomersState extends State<NewCustomers> {
  List<Widget> _newCustomers = [];

  @override
  void initState() {
    super.initState();
    getNewUsers();
  }

  getNewUsers() async {
    try {
      Future.delayed(Duration(milliseconds: 100)).whenComplete(() async {
        _newCustomers = [];
        Utils.showProgressBar();
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('Admin')
            .doc('Future Customers')
            .collection('List')
            .get();
        if (snapshot != null) {
          if (snapshot.docs.length > 0) {
            for (int index = 0; index < snapshot.docs.length; index++) {
              _newCustomers.add(Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.docs[index].data()['name'],
                        style: TextStyle(
                            fontFamily: AppTheme.poppinsBold,
                            color: AppTheme.primaryColor),
                      ),
                      Text(
                        'Phone - ' + snapshot.docs[index].data()['number'],
                        style: TextStyle(
                            fontFamily: AppTheme.poppins,
                            color: AppTheme.primaryColor),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          'Hospital - ' +
                              snapshot.docs[index].data()['hospital'],
                          style: TextStyle(
                              fontFamily: AppTheme.poppins,
                              color: AppTheme.primaryColor),
                        ),
                      ),
                    ],
                  )));
            }
          }
        }
        Get.back();
        setState(() {});
      });
    } catch (error) {
      print(error);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [if (_newCustomers.length > 0) ..._newCustomers],
    ));
  }
}

class MyAppointments extends StatefulWidget {
  @override
  _MyAppointmentsState createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointments> {
  List<Widget> _appointments = [];

  @override
  void initState() {
    super.initState();
    getAppointments();
  }

  getAppointments() async {
    try {
      Future.delayed(Duration(milliseconds: 100)).whenComplete(() async {
        Utils.showProgressBar();
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('User')
            .doc(currentUser.phoneNumber)
            .collection('Appointments')
            .get();
        if (querySnapshot != null) {
          if (querySnapshot.docs.length > 0) {
            for (int index = 0; index < querySnapshot.docs.length; index++) {
              _appointments.add(
                DoctorAppointmentCard(
                  ddate: querySnapshot.docs[index].id,
                  date: querySnapshot.docs[index].data()['time'],
                  doctorID: querySnapshot.docs[index].data()['doctorID'],
                  hosptialID: querySnapshot.docs[index].data()['hospitalID'],
                ),
              );
            }
          }
        }
        Get.back();
        setState(() {});
      });
    } catch (error) {
      Get.back();
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [if (_appointments.length > 0) ..._appointments],
    );
  }
}

class DoctorAppointmentCard extends StatefulWidget {
  final String doctorID, hosptialID, date, ddate;
  DoctorAppointmentCard(
      {this.date, this.doctorID, this.hosptialID, this.ddate});
  @override
  _DoctorAppointmentCardState createState() => _DoctorAppointmentCardState();
}

class _DoctorAppointmentCardState extends State<DoctorAppointmentCard> {
  DocumentSnapshot snapshot;

  @override
  void initState() {
    super.initState();
    getDoctorInfo();
  }

  getDoctorInfo() async {
    try {
      Future.delayed(Duration(milliseconds: 100)).whenComplete(() async {
        Utils.showProgressBar();
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('Hospital')
            .doc(widget.hosptialID)
            .collection('Doctors')
            .doc(widget.doctorID)
            .get();
        Get.back();
        dynamic _totalSlots = documentSnapshot.data()['totalSlots'];
        dynamic _slotMinuts = documentSnapshot.data()['slotMinutes'];

        if (_totalSlots > 0) {
          DateTime _openingTime =
              DateTime.parse(documentSnapshot.data()['OpeningTime']);
          DateTime _time = _openingTime;
          List<String> _slots = [];
          for (int index = 0; index < _totalSlots; index++) {
            _slots.add(
              DateFormat('hh:mm a').format(_time),
            );
            _time = DateTime(_time.year, _time.month, _time.day, _time.hour,
                _time.minute + _slotMinuts);
          }
        }
        setState(() {
          snapshot = documentSnapshot;
        });
      });
    } catch (error) {
      Get.back();
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey.withOpacity(0.41),
                      image: snapshot != null
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(snapshot.data()['profile']))
                          : null,
                      borderRadius: BorderRadius.circular(1000)),
                ),
                SizedBox(width: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.68,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot != null ? snapshot.data()['name'] : '',
                        style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 16,
                            fontFamily: AppTheme.poppinsBold),
                      ),
                      Text(
                        '${snapshot != null ? ((snapshot.data()['special1'] ?? '') + ' ' + (snapshot.data()['special2'] ?? '') + ' ' + (snapshot.data()['special3'] ?? '') + ' ' + (snapshot.data()['special4'] ?? '') + ' ' + (snapshot.data()['special5'] ?? '')) : ""}',
                        style: TextStyle(
                            fontSize: 14, fontFamily: AppTheme.poppins),
                      ),
                      Text(
                        '${snapshot != null ? ((snapshot.data()['education1'] ?? '') + ' ' + (snapshot.data()['education2'] ?? '') + ' ' + (snapshot.data()['education3'] ?? '') + ' ' + (snapshot.data()['education4'] ?? '') + ' ' + (snapshot.data()['education5'] ?? '')) : ""}',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontFamily: AppTheme.poppins),
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      '${snapshot != null ? snapshot.data()['years'] : ''} Years',
                      style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppTheme.poppins),
                    ),
                    Text(
                      'Experience',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: AppTheme.poppins),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      widget.date,
                      style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppTheme.poppins),
                    ),
                    Text(
                      'Time',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: AppTheme.poppins),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${snapshot != null ? DateFormat('dd MMM').format(DateTime.parse(widget.ddate)) : ''}',
                      style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppTheme.poppins),
                    ),
                    Text(
                      'Date',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: AppTheme.poppins),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

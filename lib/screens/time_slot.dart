//Flutter Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hospitalAdmin/globals/responsive.dart';
import 'package:hospitalAdmin/globals/user_details.dart';
import 'package:hospitalAdmin/screens/history_page.dart';
import 'package:hospitalAdmin/services/auth.dart';
import 'package:hospitalAdmin/theme/app_theme.dart';
import 'package:hospitalAdmin/utils/utils.dart';

import 'package:intl/intl.dart';
import 'package:get/get.dart';

class SlotPage extends StatefulWidget {
  final String doctorID, hosptialID;
  SlotPage({this.doctorID, this.hosptialID});
  @override
  _SlotPageState createState() => _SlotPageState();
}

class _SlotPageState extends State<SlotPage> {
  List<SlotButton> _tokens = [];
  DocumentSnapshot snapshot;
  String _openingTime = '';
  String _closingTime = '';
  String _lastRefresh = '';

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
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Hospital')
            .doc(widget.hosptialID)
            .collection('Doctors')
            .doc(widget.doctorID)
            .collection('Appointments')
            .get();
        List<String> ids = [];
        if (querySnapshot != null) {
          if (querySnapshot.docs != null) {
            for (int index = 0; index < querySnapshot.docs.length; index++) {
              DateTime date = DateTime.parse(querySnapshot.docs[index].id);
              if (date.day == DateTime.now().day &&
                  date.month == DateTime.now().month &&
                  date.year == DateTime.now().year) {
                ids.add(querySnapshot.docs[index].id);
              }
            }
          }
        }
        Get.back();
        _tokens = [];

        int totalTokens = int.parse(documentSnapshot.data()['tokens']);
        for (int index = 0; index < totalTokens; index++) {
          _tokens.add(SlotButton(
              doctorName: documentSnapshot.data()['name'],
              querySnapshot: querySnapshot,
              idList: ids,
              doctorID: widget.doctorID,
              hospitalID: widget.hosptialID,
              time: (index + 1).toString()));
        }
        _lastRefresh = DateFormat('hh:mm:ss a').format(DateTime.now());
        setState(() {
          snapshot = documentSnapshot;
          _openingTime = DateFormat('hh:mm a')
              .format(DateTime.parse(snapshot.data()['OpeningTime']));
          _closingTime = DateFormat('hh:mm a')
              .format(DateTime.parse(snapshot.data()['ClosingTime']));
        });
      });
    } catch (error) {
      Get.back();
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
            title: Text('Token Management',
                style: TextStyle(
                    fontFamily: AppTheme.poppins,
                    fontWeight: FontWeight.bold))),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(height: 10),
              Card(
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
                                        image: NetworkImage(
                                            snapshot.data()['profile']))
                                    : null,
                                borderRadius: BorderRadius.circular(1000)),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot != null
                                      ? snapshot.data()['name']
                                      : '',
                                  style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontSize: 16,
                                      fontFamily: AppTheme.poppinsBold),
                                ),
                                Text(
                                  '${snapshot != null ? ((snapshot.data()['special1'] ?? '') + ' ' + (snapshot.data()['special2'] ?? '') + ' ' + (snapshot.data()['special3'] ?? '') + ' ' + (snapshot.data()['special4'] ?? '') + ' ' + (snapshot.data()['special5'] ?? '')) : ""}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: AppTheme.poppins),
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
                                'Open',
                                style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppTheme.poppins),
                              ),
                              Text(
                                _openingTime,
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
                                'Close',
                                style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppTheme.poppins),
                              ),
                              Text(
                                _closingTime,
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
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => Get.to(SlotHistpryPage(
                  doctorID: widget.doctorID,
                  hospitalID: widget.hosptialID,
                )),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8)),
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text('Show Appointments History',
                      style: TextStyle(
                          color: AppTheme.whiteColor,
                          fontSize: 14,
                          fontFamily: AppTheme.poppins,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: 10),
              RaisedButton(
                color: AppTheme.primaryColor,
                onPressed: () {
                  getDoctorInfo();
                },
                child: Text('Refresh', style: TextStyle(color: Colors.white)),
              ),
              Text('Last Refreshed on - $_lastRefresh',
                  style: TextStyle(color: AppTheme.primaryColor)),
              SizedBox(height: 10),
              Container(
                child: Text(DateFormat('dd MMM yyyy').format(DateTime.now()),
                    style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontFamily: AppTheme.poppinsBold)),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.red),
                  ),
                  SizedBox(width: 5),
                  Text('Completed',
                      style: TextStyle(
                          fontFamily: AppTheme.poppins,
                          color: AppTheme.primaryColor)),
                  SizedBox(width: 10),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.orange),
                  ),
                  SizedBox(width: 5),
                  Text('Pending',
                      style: TextStyle(
                          fontFamily: AppTheme.poppins,
                          color: AppTheme.primaryColor)),
                  SizedBox(width: 10),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.green),
                  ),
                  SizedBox(width: 5),
                  Text('Available',
                      style: TextStyle(
                          fontFamily: AppTheme.poppins,
                          color: AppTheme.primaryColor)),
                  SizedBox(width: 10)
                ],
              ),
              SizedBox(height: 15),
              Container(
                child: Text('Tokens',
                    style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontFamily: AppTheme.poppins)),
              ),
              SizedBox(height: 10),
              if (_tokens.length > 0) Wrap(children: [..._tokens]),
              SizedBox(height: size(10)),
              SizedBox(height: size(10)),
            ],
          ),
        )));
  }
}

class SlotButton extends StatefulWidget {
  final String time, doctorID, hospitalID, doctorName;
  final List<String> idList;
  final QuerySnapshot querySnapshot;
  SlotButton(
      {this.time,
      this.doctorName,
      this.doctorID,
      this.hospitalID,
      this.idList,
      this.querySnapshot});
  @override
  _SlotButtonState createState() => _SlotButtonState();
}

class _SlotButtonState extends State<SlotButton> {
  String _type = '0';
  String _status = '';
  bool _isAvailable = true;
  String _userNumber = '';
  String _id = '';
  TextEditingController _nameController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  List<String> _upNext = [];

  @override
  void initState() {
    super.initState();
    getSlotStatus();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _numberController.dispose();
  }

  getSlotStatus() async {
    try {
      Future.delayed(Duration(milliseconds: 100)).whenComplete(() async {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('Hospital')
            .doc(widget.hospitalID)
            .collection('Doctors')
            .doc(widget.doctorID)
            .get();
        if (widget.idList != null) {
          List<String> ids = [];
          for (int index = 0; index < widget.idList.length; index++) {
            for (int i = 0; i < widget.querySnapshot.docs.length; i++) {
              if (widget.querySnapshot.docs[i].id == widget.idList[index]) {
                if (widget.querySnapshot.docs[i].data()['token'] ==
                    widget.time) {
                  ids.add(widget.idList[index]);
                } else if (widget.querySnapshot.docs[i].data()['status'] ==
                        "1" &&
                    widget.querySnapshot.docs[i]
                        .data()['number']
                        .toString()
                        .contains('+91') &&
                    int.parse(widget.querySnapshot.docs[i].data()['token']) -
                            int.parse(widget.time) <
                        5 &&
                    int.parse(widget.querySnapshot.docs[i].data()['token']) >
                        int.parse(widget.time)) {
                  _upNext.add(widget.querySnapshot.docs[i].data()['number']);
                }
              }
            }
          }
          print(_upNext);
          if (ids.length > 0) {
            if (ids.length > 1) {
              _id = ids[ids.length - 1];
            } else {
              _id = ids[0];
            }
            if (_id != null) {
              if (_id != '') {
                DocumentSnapshot documentSnapshot = await FirebaseFirestore
                    .instance
                    .collection('Hospital')
                    .doc(widget.hospitalID)
                    .collection('Doctors')
                    .doc(widget.doctorID)
                    .collection('Appointments')
                    .doc(_id)
                    .get();
                if (documentSnapshot != null) {
                  _status = documentSnapshot.data()['status'];
                  _userNumber = documentSnapshot.data()['number'];
                }
              }
            }
          }
        }
        if (snapshot.data() != null) {
          if (snapshot.data()[widget.time] != null) {
            setState(() {
              _isAvailable = (DateTime.now().day !=
                  DateTime.parse(snapshot.data()[widget.time]).day);
              _type = snapshot.data()['S${widget.time}'];
            });
          }
        }
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {},
      child: Container(
        width: size(90),
        height: size(40),
        alignment: Alignment.center,
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: _type == '0'
              ? Colors.green
              : _type == '1'
                  ? Colors.orange
                  : Colors.red,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(widget.time,
            style:
                TextStyle(color: Colors.white, fontFamily: AppTheme.poppins)),
      ),
    );
  }
}

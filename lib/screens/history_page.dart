//Flutter Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospitalAdmin/theme/app_theme.dart';
import 'package:hospitalAdmin/utils/utils.dart';
import 'package:intl/intl.dart';

class SlotHistpryPage extends StatefulWidget {
  final String hospitalID, doctorID;
  SlotHistpryPage({this.doctorID, this.hospitalID});
  @override
  _SlotHistpryPageState createState() => _SlotHistpryPageState();
}

class _SlotHistpryPageState extends State<SlotHistpryPage> {
  List<Widget> _list = [];
  @override
  void initState() {
    super.initState();
    getHistory();
  }

  getHistory() async {
    try {
      Future.delayed(Duration(milliseconds: 100)).whenComplete(() async {
        Utils.showProgressBar();
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('Hospital')
            .doc(widget.hospitalID)
            .collection('Doctors')
            .doc(widget.doctorID)
            .collection("Appointments")
            .get();
        if (snapshot != null) {
          if (snapshot.docs != null) {
            for (int index = snapshot.docs.length - 1; index >= 0; index--) {
              _list.add(Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Text(
                            snapshot.docs[index].data()['name'],
                            style: TextStyle(
                                fontFamily: AppTheme.poppinsBold,
                                color: AppTheme.primaryColor),
                          ),
                        ),
                        Text(
                          snapshot.docs[index].data()['number'],
                          style: TextStyle(
                            fontFamily: AppTheme.poppins,
                          ),
                        ),
                        Text(
                          'Token - ' + snapshot.docs[index].data()['token'],
                          style: TextStyle(
                            fontFamily: AppTheme.poppins,
                          ),
                        ),
                        Text(
                          snapshot.docs[index].data()['status'] == '1'
                              ? 'Appointment Pending'
                              : snapshot.docs[index].data()['status'] == '2'
                                  ? 'Appointment Completed'
                                  : 'Appointment Cancelled',
                          style: TextStyle(
                              fontFamily: AppTheme.poppins,
                              color: snapshot.docs[index].data()['status'] ==
                                      '1'
                                  ? Colors.orange
                                  : snapshot.docs[index].data()['status'] == '2'
                                      ? Colors.green
                                      : Colors.red),
                        ),
                        if (snapshot.docs[index].data()['reason'] != null)
                          Text(
                            'Reason - ' + snapshot.docs[index].data()['reason'],
                            style: TextStyle(
                              fontFamily: AppTheme.poppins,
                            ),
                          ),
                        Text(
                          DateFormat('dd MMM yy')
                              .format(DateTime.parse(snapshot.docs[index].id)),
                          style: TextStyle(
                              fontFamily: AppTheme.poppins, color: Colors.grey),
                        ),
                      ],
                    )),
              ));
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment History'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [if (_list.length > 0) ..._list],
          ),
        ),
      ),
    );
  }
}

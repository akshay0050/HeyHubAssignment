import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hey_hub_assignment/models/hub1json.dart';
import 'package:hey_hub_assignment/models/hub2json.dart';
import 'package:hey_hub_assignment/models/hub3json.dart';
import 'package:hey_hub_assignment/utility_class.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(title: 'HeyHub'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _latController = TextEditingController();
  final _longController = TextEditingController();
  final _accuracyController = TextEditingController();
  String msgText = "";
  bool _isMsgToShow = false;
  List<dynamic> polyPoints;
  Color msgColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.grey[100],
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(child: _buildBody())
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  // UI section start
  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          latitudeInputBox(),
          longitudeInputBox(),
          accuracyInputBox(),
          Visibility(
            visible: _isMsgToShow,
            child: showMessageText(),
          ),
          checkPositionButton()
        ],
      ),
    );
  }

  // latitude input box
  Widget latitudeInputBox() {
    return Container(
      padding:
          EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0, top: 30.0),
      child: TextFormField(
        maxLength: 12,
        keyboardType: TextInputType.phone,
        controller: _latController,
        validator: _validateLatitude,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
          prefixIcon: Icon(Icons.location_on),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.deepPurple),
          ),
          labelText: 'Latitude',
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.black,
            ),
            onPressed: () {
              _latController.clear();
            },
          ),
        ),
      ),
    );
  }

  // longitude input box
  Widget longitudeInputBox() {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: TextFormField(
        maxLength: 12,
        keyboardType: TextInputType.phone,
        controller: _longController,
        validator: _validateLongitude,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
          prefixIcon: Icon(Icons.location_on),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.deepPurple),
          ),
          labelText: 'Longitude',
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.black,
            ),
            onPressed: () {
              _longController.clear();
            },
          ),
        ),
      ),
    );
  }

  // accuracy input box
  Widget accuracyInputBox() {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: TextFormField(
        maxLength: 6,
        keyboardType: TextInputType.phone,
        controller: _accuracyController,
        validator: _validateAccuracy,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
          prefixIcon: Icon(Icons.ac_unit),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.deepPurple),
          ),
          labelText: 'Accuracy',
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.black,
            ),
            onPressed: () {
              _accuracyController.clear();
            },
          ),
        ),
      ),
    );
  }

  // common success or failure UI , by default its hide
  Widget showMessageText() {
    return Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        child: Text(
          this.msgText,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: this.msgColor,
              fontSize: 12.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w800),
        ));
  }

  Widget checkPositionButton() {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: RaisedButton(
        color: Colors.deepPurple,
        padding: EdgeInsets.symmetric(horizontal: 50.0),
        textColor: Colors.white,
        child: Container(
          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: Text('Check Position'),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        onPressed: _onSubmitClick,
      ),
    );
  }

  void _showDialogOptions() {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: MediaQuery.of(context).size.height * 0.50,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Select JSON File',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w800),
              ),
            ),
            Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
            InkWell(
                onTap: () {
                  _onFileSelect("one");
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.insert_drive_file,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 2.0,
                        ),
                        Text('HubOne.json',
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.black)),
                      ]),
                )),
            Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
            InkWell(
                onTap: () {
                  _onFileSelect("two");
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.insert_drive_file,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 2.0,
                        ),
                        Text('HubTwo.json',
                            style: TextStyle(color: Colors.black)),
                      ]),
                )),
            Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
            InkWell(
                onTap: () {
                  _onFileSelect("three");
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.insert_drive_file,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 2.0,
                        ),
                        Text('HubThree.json',
                            style: TextStyle(color: Colors.black)),
                      ]),
                )),
            Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
            InkWell(
                onTap: () {
                  _onFileSelect("upload");
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.file_upload,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 2.0,
                        ),
                        Text('Upload from Device',
                            style: TextStyle(color: Colors.black)),
                      ]),
                )),
            Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
            InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 2.0,
                        ),
                        Text('Cancel', style: TextStyle(color: Colors.black)),
                      ]),
                )),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }

  // UI section ends

  // perform action on click section
  void _onSubmitClick() {
    hideMsgOption();
    if (_formKey.currentState.validate()) _showDialogOptions();
  }

  void _onPositionCheck() {
    double lat = double.parse(this._latController.text);
    double long = double.parse(this._longController.text);
    int accuracy = int.parse(this._accuracyController.text);

    if (polyPoints != null) {
      bool isPositionInsideFence = isInside(lat, long, polyPoints, accuracy);
      showMsg(isPositionInsideFence);
    }
  }

  /// to check whether lat/lng value is inside Geo-fence
  /// params myLat -: Latitude, myLang -: Longitude, accuracy -: Accuracy
  /// func logic is based on Ray Casting algorithm
  bool isInside(double myLat, double myLang, polyPoints, int accuracy) {
    List<String> isInside = [];
    polyPoints.forEach((point) {
      int count = 0;
      while (count < (point.length - 1)) {
        double currentPointLat = point[count]["lat"];
        double currentPointLng = point[count]["lon"];

        double nextPointLat = point[count + 1]["lat"];
        double nextPointLng = point[count + 1]["lon"];

        /// if accuracy is zero then no addition in Lat/Lng value will perform
        if (accuracy > 0) {
          List<double> currentPointLatLngList =
              addMetersInLatLng(currentPointLat, currentPointLng, accuracy);
          if (currentPointLatLngList.length > 1) {
            currentPointLat = currentPointLatLngList[0];
            currentPointLng = currentPointLatLngList[1];
          }

          List<double> nextPointLatLngList =
              addMetersInLatLng(nextPointLat, nextPointLng, accuracy);
          if (nextPointLatLngList.length > 1) {
            nextPointLat = nextPointLatLngList[0];
            nextPointLng = nextPointLatLngList[1];
          }
        }
        /// to check whether lines drawing from entered Lat/Lng values are intersecting Polygon drawn by collection of Lat/Lng values
        bool isIntersect =
            ((currentPointLng > myLang) != (nextPointLng > myLang)) &&
                (myLat <
                    (nextPointLat - currentPointLat) *
                            (myLang - currentPointLng) /
                            (nextPointLng - currentPointLng) +
                        currentPointLat);

        isInside.add(isIntersect.toString());
        count++;
      }
    });
    var trueCount = 0;
    isInside.forEach((f) {
      if (f == 'true') {
        trueCount++;
      }
    });
    // as per Ray Casting algorithm if number of count is odd then that Lat/Lng is inside polygon
    return trueCount.isOdd;
  }


/// provide option to select JSON to perform isInside operation
  void _onFileSelect(type) {
    switch (type) {
      case "one":
        {
          dynamic jsonObj = hubJsonOne;
          this.polyPoints = jsonObj["results"]["geometry"];
          break;
        }
      case "two":
        {
          dynamic jsonObj = hubJsonTwo;
          this.polyPoints = jsonObj["results"]["geometry"];
          break;
        }
      case "three":
        {
          dynamic jsonObj = hubJsonThree;
          this.polyPoints = jsonObj["results"]["geometry"];
          break;
        }
      case "upload":
        {
          _readFileFromStorage();
          break;
        }
    }
    _onPositionCheck();
  }

  // To load data from local files of Mobile device
  void _readFileFromStorage() async {
    try {
      File file = await FilePicker.getFile();
      String fileAsString = await file.readAsString();
      dynamic jsonObj = json.decode(fileAsString);

      if (jsonObj["results"] != null &&
          jsonObj["results"]["geometry"] != null) {
        this.polyPoints = jsonObj["results"]["geometry"];
        _onPositionCheck();
      } else {
        showMsgOption("Unable to load File, Please select proper JSON file");
      }
    } catch (e) {
      showMsgOption("Unable to load File, Please select proper JSON file");
    }
  }

  /// validation section
  String _validateLatitude(String value) {
    if (value.isEmpty) {
      return "Please enter latitude value";
    } else {
      return null;
    }
  }

  String _validateLongitude(String value) {
    if (value.isEmpty) {
      return "Please enter longitude value";
    } else {
      return null;
    }
  }

  String _validateAccuracy(String value) {
    if (value.isEmpty) {
      return "Please enter Accuracy value";
    } else {
      return null;
    }
  }

  /// show/hide error message section

  void showMsg(isWithinFence) {
    setState(() {
      this._isMsgToShow = true;
      if (isWithinFence) {
        this.msgText = "Yehh.. Your position is Within the Geo-FENCE";
        msgColor = Colors.deepPurple;
      } else {
        this.msgText = "Opps.. Your position is Outside the Geo-FENCE";
        msgColor = Colors.red;
      }
    });
  }

  void hideMsgOption() {
    setState(() {
      this._isMsgToShow = false;
    });
  }

  void showMsgOption(String message) {
    setState(() {
      this._isMsgToShow = true;
      this.msgText = message;
      this.msgColor = Colors.red;
    });
  }
}

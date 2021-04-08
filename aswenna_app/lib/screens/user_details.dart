import 'package:aswenna_app/screens/dashboard_farmer.dart';
import 'package:aswenna_app/utilities/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dashboard_customer.dart';

CollectionReference userDetails =
    FirebaseFirestore.instance.collection('users');

class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

//-------------------------------------------- Declare Form Types for Get User Details ----------------------------------
enum FormType { usernames, address, contacts }
//--------------------- Declare gender variables ----------------------------------

//-------------- get current date & time ------------------
var today = new DateTime.now();
var formatter = new DateFormat.yMd().add_jms();
String currentDateTime = formatter.format(today);

class _UserDetailsState extends State<UserDetails> {
  //-------------------------------------------define variables---------------------------------
  //---------------- user details ------------------------
  String firstName;
  String lastName;
  String addressLine1;
  String addressLine2;
  String city;
  String district;
  String province;
  String mobile;
  String nic;
  String gender;
  String userStatus;
  String registeredDate;

  // MyUser myUser = MyUser();
  FormType _formType = FormType.usernames;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();

  //create radio button group for male and female
  int radioButtonGroup = 0;
  var _gender = ['Male', 'Female'];
  var _districts = <String>[
    'Ampara',
    'Anuradhapura',
    'Badulla',
    'Batticaloa',
    'Colombo',
    'Galle',
    'Gampaha',
    'Hambantota',
    'Jaffna',
    'Kalutara',
    'Kandy',
    'Kegalle',
    'Kilinochchi',
    'Kurunegala',
    'Mannar',
    'Matale',
    'Matara',
    'Monaragala',
    'Mullaitivu',
    'Nuwara Eliya',
    'Polonnaruwa',
    'Puttalam',
    'Ratnapura',
    'Trincomalee',
    'Vavuniya'
  ];
  var _provinces = <String>[
    'Central',
    'Eastern',
    'North Central',
    'North Western',
    'Northern',
    'Sabaragamuwa',
    'Southern',
    'Uva',
    'Western',
  ];

  // create user state
  var _userStatus = <String>[
    'I am a Farmer',
    'I am a Customer',
  ];

  //++++++++++++++++++++++++++++++++++++++++++ Build Form State ++++++++++++++++++++++++++++++++++++++++++++++
  //--------------------------------- set form type as register------------------------------------
  void _moveToUserNames() {
    setState(() {
      _formType = FormType.usernames; //change form type to register
    });
  }

//--------------------------------- set form type as login ---------------------------------
  void _moveToAddress() {
    setState(() {
      _formType = FormType.address; //change form type to login
    });
  }

//--------------------------------- set form type as Reset Password ---------------------------------
  void _moveToContacts() {
    setState(() {
      _formType = FormType.contacts; //change form type to login
    });
  }

//--------------------------------------------- Build Profile Picture & User Name Details -----------------------------------------------------
//--------------------------------------------- Build User Image ---------------------------
  Widget _buildUserImage() {
    return Builder(
      builder: (context) => Stack(
        alignment: Alignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF057659), width: 5.0),
                  shape: BoxShape.circle,
                  color: Color(0xFF069370),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/user.jpg'),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width / 2.7,
                left: MediaQuery.of(context).size.width / 2.7),
            child: CircleAvatar(
              backgroundColor: Color(0xFF057659),
              child: IconButton(
                icon: Icon(
                  Icons.camera_alt,
                  color: Color(0xFF09CB9B),
                ),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
    );
  }

//--------------------------------------------- Function Submit User Details-----------------------------------------------------
  void _submitUserData() {
    addUser();
  }

  Future<void> addUser() async {
    Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    userDetails
        .doc(auth.currentUser.uid)
        .set({
          'first_name': this.firstName,
          'last_name': this.lastName,
          'address_01': this.addressLine1,
          'address_02': this.addressLine2,
          'city': this.city,
          'district': this.district,
          'province': this.province,
          'mobile': this.mobile,
          'nic': this.nic,
          'gender': this.gender,
          'user_status': this.userStatus,
          //'Registered Date ': this.registeredDate,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));

    if (this.userStatus == "I am a Farmer") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardFarmer()),
      );
    } else if (this.userStatus == "I am a Customer") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardCustomer()),
      );
    }

    return;
  }

  Widget _buildUserNames() {
    return Column(
      //------------------------------------------ Build First Name Field ------------------------------------------

      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'First Name',
          style: myLabelStyle,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: myBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: _controller,
            validator: (value) =>
                value.isEmpty ? 'First Name cannot be empty' : null,
            onSaved: (value) => this.firstName = value,
            keyboardType: TextInputType.name,
            cursorColor: Colors.white,
            autofocus: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(14.0, 14.0, 0, 0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              hintText: 'Ex: Amila',
              hintStyle: myHintTextStyle,
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            'Enter your common name as your first name',
            style: myLabelDescriptionStyle,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        //------------------------------------------ Build Last Name Field ------------------------------------------

        Text(
          'Last Name',
          style: myLabelStyle,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: myBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            validator: (value) =>
                value.isEmpty ? 'Last Name cannot be empty' : null,
            onSaved: (value) => this.lastName = value,
            keyboardType: TextInputType.name,
            cursorColor: Colors.white,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(14.0, 14.0, 0, 0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              hintText: 'Ex: Thilak',
              hintStyle: myHintTextStyle,
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            'Enter your other common name, if any, as your last name to make it meaningful when read together with your first name',
            style: myLabelDescriptionStyle,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),

        //------------------------------------------ Build Gender Field ------------------------------------------

        Text(
          'Gender',
          style: myLabelStyle,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
            alignment: Alignment.centerLeft,
            decoration: myBoxDecorationStyle,
            height: 60.0,
            child: Theme(
              data: ThemeData.dark(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Spacer(),
                  Radio(
                    value: 1,
                    groupValue: radioButtonGroup,
                    activeColor: Color(0xFF09CB9B),
                    onChanged: (value) {
                      this.gender = 'Male';
                      setState(() {
                        radioButtonGroup = value;
                      });
                    },
                  ),
                  Text(
                    'Male',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  Spacer(),
                  Radio(
                    value: 2,
                    groupValue: radioButtonGroup,
                    activeColor: Color(0xFF09CB9B),
                    onChanged: (value) {
                      this.gender = 'Female';

                      setState(() {
                        radioButtonGroup = value;
                      });
                    },
                  ),
                  Text(
                    'Female',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  Spacer(),
                ],
              ),
            )),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            'Choose your gender',
            style: myLabelDescriptionStyle,
          ),
        ),
      ],
    );
  }

//--------------------------------------------- Build Address Details -----------------------------------------------------
  Widget _buildAddress() {
    return Column(
      //------------------------------------------ Build Address Line 01 Field ------------------------------------------

      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Address',
          style: myLabelStyle,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: myBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: _controller,
            validator: (value) =>
                value.isEmpty ? 'Address cannot be empty' : null,
            onSaved: (value) => this.addressLine1 = value,
            keyboardType: TextInputType.name,
            cursorColor: Colors.white,
            autofocus: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(14.0, 14.0, 0, 0),
              prefixIcon: Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              hintText: 'Street Address',
              hintStyle: myHintTextStyle,
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        //------------------------------------------ Build Address Line 02 Field ------------------------------------------

        Container(
          alignment: Alignment.centerLeft,
          decoration: myBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            onSaved: (value) => this.addressLine2 = value,
            keyboardType: TextInputType.name,
            cursorColor: Colors.white,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              hintText: 'Address Line 2 (Optional)',
              hintStyle: myHintTextStyle,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            'Enter your permanent address',
            style: myLabelDescriptionStyle,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        //------------------------------------------ Build Address City Field ------------------------------------------

        Text(
          'City',
          style: myLabelStyle,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: myBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            validator: (value) => value.isEmpty ? 'City cannot be empty' : null,
            onSaved: (value) => this.city = value,
            keyboardType: TextInputType.name,
            cursorColor: Colors.white,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(14.0, 14.0, 0, 0),
              prefixIcon: Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              hintText: 'Ex: Nugegoda',
              hintStyle: myHintTextStyle,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            'Enter your permanent address',
            style: myLabelDescriptionStyle,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
//--------------------------------------------- Build District Drop Down  -----------------------------------------------------

        Text(
          'District',
          style: myLabelStyle,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: myBoxDecorationStyle,
          height: 60.0,
          child: DropdownButtonFormField(
            hint: Text('Select Your District',
                style: TextStyle(color: Colors.white54)),
            value: this.district,
            icon: Icon(Icons.keyboard_arrow_down),
            iconSize: 24,
            iconEnabledColor: Color(0xFF09CB9B),
            elevation: 16,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(14.0, 14.0, 0, 0),
              prefixIcon: Icon(
                Icons.location_on,
                color: Colors.white,
              ),
            ),
            dropdownColor: Color(0xFF069370),
            onChanged: (String newValue) {
              setState(() {
                this.district = newValue;
              });
            },
            validator: (value) =>
                value == null ? 'Please Select Your District' : null,
            items: _districts.map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Container(
                  width: 200,
                  child: Text(value),
                ),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            'Select your living district',
            style: myLabelDescriptionStyle,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),

        //--------------------------------------------- Build Province Drop Down  -----------------------------------------------------
        Text(
          'Province',
          style: myLabelStyle,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: myBoxDecorationStyle,
          height: 60.0,
          child: DropdownButtonFormField(
            hint: Text('Select Your Province',
                style: TextStyle(color: Colors.white54)),
            value: this.province,
            icon: Icon(Icons.keyboard_arrow_down),
            iconSize: 24,
            iconEnabledColor: Color(0xFF09CB9B),
            elevation: 16,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(14.0, 14.0, 0, 0),
              prefixIcon: Icon(
                Icons.location_on,
                color: Colors.white,
              ),
            ),
            dropdownColor: Color(0xFF069370),
            onChanged: (String newValue) {
              setState(() {
                this.province = newValue;
              });
            },
            validator: (value) =>
                value == null ? 'Please Select Your Province' : null,
            items: _provinces.map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Container(
                  width: 200,
                  child: Text(value),
                ),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            'Select your living province',
            style: myLabelDescriptionStyle,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }

//--------------------------------------------- Build Contacts Fields-----------------------------------------------------
  Widget _buildContacts() {
    return Column(
      //------------------------------------------ Build Mobile Text Field ------------------------------------------

      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mobile',
          style: myLabelStyle,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: myBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            validator: (value) => value.isEmpty
                ? 'Mobile cannot be empty'
                : value.length != 10
                    ? 'Mobile must be 10 digits'
                    : null,
            onSaved: (value) => this.mobile = value,
            keyboardType: TextInputType.phone,
            cursorColor: Colors.white,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(14.0, 14.0, 0, 0),
              prefixIcon: Icon(
                Icons.phone_android,
                color: Colors.white,
              ),
              hintText: 'EX: 0712345678',
              hintStyle: myHintTextStyle,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            'Enter your current working, 10 digit mobile number. this will be used to contact you by Aswenna and you must verify your number',
            style: myLabelDescriptionStyle,
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        //------------------------------------------ Build NIC Text Field ------------------------------------------
        Text(
          'National Identity Card Number',
          style: myLabelStyle,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: myBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            validator: (value) => value.isEmpty
                ? 'NIC cannot be empty'
                : value.length != 10
                    ? 'NIC must be 10 digits'
                    : null,
            onSaved: (value) => this.nic = value,
            keyboardType: TextInputType.text,
            cursorColor: Colors.white,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(14.0, 14.0, 0, 0),
              prefixIcon: Icon(
                Icons.credit_card,
                color: Colors.white,
              ),
              hintText: 'EX: 987654321V',
              hintStyle: myHintTextStyle,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            'Enter your current working, 10 digit mobile number. this will be used to contact you by Aswenna and you must verify your number',
            style: myLabelDescriptionStyle,
          ),
        ),
        SizedBox(
          height: 30.0,
        ),

        //--------------------------------------------- Build User Status Drop Down  -----------------------------------------------------
        Text(
          'User Status',
          style: myLabelStyle,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: myBoxDecorationStyle,
          height: 60.0,
          child: DropdownButtonFormField(
            hint: Text('Select Your Status',
                style: TextStyle(color: Colors.white54)),
            value: this.userStatus,
            icon: Icon(Icons.keyboard_arrow_down),
            iconSize: 24,
            iconEnabledColor: Color(0xFF09CB9B),
            elevation: 16,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(14.0, 14.0, 0, 0),
              prefixIcon: Icon(
                Icons.person_pin,
                color: Colors.white,
              ),
            ),
            dropdownColor: Color(0xFF069370),
            onChanged: (String newValue) {
              setState(() {
                this.userStatus = newValue;
              });
            },
            validator: (value) =>
                value == null ? 'Please Select Your User Status' : null,
            items: _userStatus.map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Container(
                  width: 200,
                  child: Text(value),
                ),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            'If you are a farmer or do you want to sell your produces please select "I am a Farmer" , if you are a customer or do you want to buy produces please  select "I am a Customer"',
            style: myLabelDescriptionStyle,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }

  //--------------------------------------------- Display User Profile pic -----------------------------------------------------
  Widget _displayUserImage() {
    if (_formType == FormType.usernames) {
      return _buildUserImage();
    } else {
      return SizedBox(
        height: 0,
      );
    }
  }

//--------------------------------------------- Display Form Fields -----------------------------------------------------
  Widget _displayFormFields() {
    if (_formType == FormType.usernames) {
      return _buildUserNames();
    } else if (_formType == FormType.address) {
      return _buildAddress();
    } else {
      return _buildContacts();
    }
  }

//--------------------------------------------- Build Next Button for User Details -----------------------------------------------------

  Widget _buildNextBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        //button shadow
        onPressed: () {
          if (_formKey.currentState.validate()) {
            if (_formType == FormType.usernames) {
              _formKey.currentState.save();
              _controller.clear();
              _moveToAddress();
            } else if (_formType == FormType.address) {
              _formKey.currentState.save();
              _controller.clear();
              _moveToContacts();
            } else {
              _formKey.currentState.save();
              _controller.clear();
              _submitUserData();
            }
          }
        },
        padding: EdgeInsets.all(15.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.white,
        child: Text(
          _formType == FormType.usernames
              ? 'Next'
              : _formType == FormType.address
                  ? 'Next'
                  : 'Submit',
          style: TextStyle(
              color: Color(0xFF0E7556),
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans'),
        ),
      ),
    );
  }

  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ Start Build Function ++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        backgroundColor: Color(0xFF069370),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(color: Color(0xFF09CB9B)),
              ),
              Form(
                key: _formKey,
                child: Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Complete Your Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        _displayUserImage(),
                        _displayFormFields(),
                        _buildNextBtn(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//--------------------------------------------- End Build Function -----------------------------------------------------

import 'package:aswenna_app/screens/user_details.dart';
import 'package:aswenna_app/utilities/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dashboard_customer.dart';
import 'dashboard_farmer.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
var userIdGlobal;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

//-------------------------------------------- Declare Form Types for Login and Register ----------------------------------
enum FormType { login, register, resetpass }

class _LoginScreenState extends State<LoginScreen> {
  //--------------------------------------------------------- Variable Declaration -----------------------------------------
  final fb = FacebookLogin();
  bool _rememberMe = false; // set initial remember me as false
  bool _agreement = false; // set initial agreement as false
  FormType _formType =
      FormType.login; // set initial form type as login for log in first
  String formHeading = 'Sign In'; // set initial form heading as sign in

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _tokenController = TextEditingController();

  bool _success; //to check user registration complete of not
  String _userEmail;

//++++++++++++++++++++++++++++++++++++++++++ Build Form State ++++++++++++++++++++++++++++++++++++++++++++++
  //--------------------------------- set form type as register------------------------------------
  void _moveToRegister() {
    setState(() {
      _clear(); // clear text fields
      _formType = FormType.register; //change form type to register
    });
  }

//--------------------------------- set form type as login ---------------------------------
  void _moveToLogin() {
    setState(() {
      _clear(); // clear text fields
      _formType = FormType.login; //change form type to login
    });
  }

//--------------------------------- set form type as Reset Password ---------------------------------
  void _moveToResetPass() {
    setState(() {
      _clear(); // clear text fields
      _formType = FormType.resetpass; //change form type to login
    });
  }

  //------------------------------------------ Build Email Text Field ------------------------------------------

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
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
                ? 'Email cannot be empty'
                : !value.contains('@')
                    ? 'Incorrect Email'
                    : null,
            onSaved: (value) => _emailController.text = value,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Colors.white,
            autofocus: false,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(14.0, 14.0, 0, 0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter Your Email',
              hintStyle: myHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  //------------------------------------------ Build Password Text Field ------------------------------------------

  Widget _buildPasswordField() {
    if (_formType == FormType.login) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password',
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
              controller: _passwordController,
              validator: (value) => value.isEmpty
                  ? 'Password cannot be empty'
                  : value.length < 6
                      ? 'Password Must Contain at least 6 Characters'
                      : null,
              onSaved: (value) => _passwordController.text = value,
              obscureText: true,
              cursorColor: Colors.white,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(14.0, 14.0, 0, 0),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                hintText: 'Enter Your Password',
                hintStyle: myHintTextStyle,
              ),
            ),
          )
        ],
      );
    } else if (_formType == FormType.register) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password',
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
              controller: _passwordController,
              validator: (value) => value.isEmpty
                  ? 'Password cannot be empty'
                  : value.length < 6
                      ? 'Password Must Contain at least 6 Characters'
                      : null,
              onSaved: (value) => _passwordController.text = value,
              obscureText: true,
              cursorColor: Colors.white,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(14.0, 14.0, 0, 0),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                hintText: 'Enter Your Password',
                hintStyle: myHintTextStyle,
              ),
            ),
          )
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      );
    }
  }

//------------------------------------------ Build Re Type Password Text Field ------------------------------------------

  Widget _buildRePasswordField() {
    if (_formType == FormType.register) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.0,
          ),
          Container(
            alignment: Alignment.centerLeft,
            decoration: myBoxDecorationStyle,
            height: 60.0,
            child: TextFormField(
              controller: _confirmPasswordController,
              validator: (value) => value.isEmpty
                  ? 'Confirm Password cannot be empty'
                  : _passwordController.text != _confirmPasswordController.text
                      ? 'Password Not Match'
                      : null,
              obscureText: true,
              cursorColor: Colors.white,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(14.0, 14.0, 0, 0),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                hintText: 'Confirm Your Password',
                hintStyle: myHintTextStyle,
              ),
            ),
          ),
          SizedBox(
            height: 25.0,
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      );
    }
  }

  //------------------------------------------ Build Forgot Password Button ------------------------------------------

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: _moveToResetPass,
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: myLabelStyle,
        ),
      ),
    );
  }

  //------------------------------------------ Build Remember Me Check Box ------------------------------------------

  Widget _buildRememberMeCheckBox() {
    return Container(
      height: 20.0,
      child: Row(
        children: [
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: myLabelStyle,
          )
        ],
      ),
    );
  }

//------------------------------------------ Build Agreement Check Box ------------------------------------------

  Widget _buildAgreementCheckBox() {
    if (_formType == FormType.register) {
      return Container(
        height: 20.0,
        child: Row(
          children: [
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                value: _agreement,
                checkColor: Colors.green,
                activeColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    _agreement = value;
                  });
                },
              ),
            ),
            Text(
              'I Agree to Terms & Conditions',
              style: myLabelStyle,
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  //------------------------------------------ Build Login Button ------------------------------------------

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        //button shadow
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _login();
          }
        },
        padding: EdgeInsets.all(15.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.white,
        child: Text(
          'LOGIN',
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

  //------------------------------------------ Build Register Button ------------------------------------------

  Widget _buildRegisterBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        //button shadow
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            _register();
          }
        },
        padding: EdgeInsets.all(15.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.white,
        child: Text(
          'REGISTER',
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

  //------------------------------------------ Build Password Reset Submit Button ------------------------------------------

  Widget _buildPasswordResetSubmitRtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        //button shadow
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _passwordReset();
          }
        },
        padding: EdgeInsets.all(15.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.white,
        child: Text(
          'Submit',
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

//--------------------------------------------- Build Sign In With Text -----------------------------------------------------

  Widget _buildSignInWithText() {
    return Column(
      children: [
        Text(
          '- OR -',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          'Sign In With',
          style: myLabelStyle,
        )
      ],
    );
  }

//--------------------------------------------- Build Sign Up With Text -----------------------------------------------------

  Widget _buildSignUpWithText() {
    if (_formType == FormType.register) {
      return Column(
        children: [
          Text(
            '- OR -',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'Sign Up With',
            style: myLabelStyle,
          )
        ],
      );
    } else {
      return Column();
    }
  }

//--------------------------------------------- Build Social Button -----------------------------------------------------

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

//--------------------------------------------- Build Social Button Row -----------------------------------------------------

  Widget _buildSocialBtnRow() {
    if (_formType == FormType.resetpass) {
      return Container();
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 30.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSocialBtn(
              () => _signInWithFacebook(),
              //call function for login with facebook btn
              AssetImage('assets/logos/facebook.jpg'),
            ),
            _buildSocialBtn(
              () => _signInWithGoogle(),
              //call function for login with google btn
              AssetImage('assets/logos/google.jpg'),
            ),
          ],
        ),
      );
    }
  }

//--------------------------------------------- Build Sign Up Button -----------------------------------------------------

  Widget _buildSignUpBtn() {
    return GestureDetector(
      onTap: _moveToRegister,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

//--------------------------------------------- Build Sign In Button -----------------------------------------------------

  Widget _buildSignInBtn() {
    return GestureDetector(
      onTap: _moveToLogin,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Already have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //--------------------------------------------- Build Return to Sign in Button -----------------------------------------------------

  Widget _buildReturnToSignInBtn() {
    return GestureDetector(
      onTap: _moveToLogin,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Return to ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

//--------------------------------------- Display Widgets as Form Type Login or Register -----------------------------------------------------------

  //------------------------------------------  Display Login Register & Password reset Buttons as Form Type -------------------------------------------
  Widget _displaySubmitButtons() {
    if (_formType == FormType.login) {
      return _buildLoginBtn(); // return login button for form type as login
    } else if (_formType == FormType.register) {
      return _buildRegisterBtn(); // return register button for form type as register
    } else {
      return _buildPasswordResetSubmitRtn();
    }
  }

  //------------------------------------------  Display Forgot Password Button as Form Type -------------------------------------------

  Widget _displayForgotPasswordButton() {
    if (_formType == FormType.login) {
      return _buildForgotPasswordBtn(); // return forgot password button for form type as login
    } else {
      return _buildRePasswordField();
    }
  }

  //------------------------------------------  Display Remember me & Agreement Checkbox as Form Type -------------------------------------------

  Widget _displayCheckBox() {
    if (_formType == FormType.login) {
      return _buildRememberMeCheckBox(); // return remember me check box for form type as login
    } else {
      return _buildAgreementCheckBox(); // return agreement check box for form type as register
    }
  }

//------------------------------------------  Display Sign In With & Sign Up With Texts as Form Type -------------------------------------------

  Widget _displaySignInWithTexts() {
    if (_formType == FormType.login) {
      return _buildSignInWithText(); // return sign in with text for form type as login
    } else {
      return _buildSignUpWithText(); // return sign up with text for form type as register
    }
  }

  //------------------------------------------  Display Sign In  & Sign Up Button With Texts as Form Type -------------------------------------------

  Widget _displaySignStatusButton() {
    if (_formType == FormType.login) {
      return _buildSignUpBtn(); // return sign in button for form type as login
    } else if (_formType == FormType.register) {
      return _buildSignInBtn(); // return sign up button for form type as register
    } else {
      return _buildReturnToSignInBtn();
    }
  }

  //-++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ User Registration Function +++++++++++++++++++++++++++++++++++++++++
  void _register() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    try {
      final User user = (await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;

      if (user != null) {
        setState(() {
          _success = true;
          _userEmail = user.email;
        });
      } else {
        _success = false;
      }
      _alertMoveToLogin('Successfully registered ' + _userEmail);
    } catch (e) {
      _alertCommon('Registration Failed! Please Try Again');
    }
  }

  //-++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ User Login Function +++++++++++++++++++++++++++++++++++++++++
  void _login() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      //_alertCommon('Login Successful');

      FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        userIdGlobal = _auth.currentUser.uid;
        //  print("----------------------->>>>  $userIdGlobal");
        if (documentSnapshot.exists) {
          print(documentSnapshot.data()['user_status']);
          if (documentSnapshot.data()['user_status'] == "I am a Farmer") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardFarmer(),
              ),
            );
          } else if (documentSnapshot.data()['user_status'] ==
              "I am a Customer") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardCustomer(),
              ),
            );
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserDetails()),
          );
        }
      });
    } catch (e) {
      _alertCommon('Login Failed! Please Try Again');
    }
  }

  //-++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ User Password Reset Function +++++++++++++++++++++++++++++++++++++++++
  void _passwordReset() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      _alertMoveToLogin(
          'A Password Reset Link has been Sent to ${_emailController.text}');
    } catch (e) {
      _alertCommon(
          'Incorrect Email or Your Connection Problem! Please Try Again.');
    }
  }

//+++++++++++++++++++++++++++++++++++++++++++++++++ Sign In With Google Function +++++++++++++++++++++++++++++++++++++++++++
  void _signInWithGoogle() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final GoogleAuthCredential googleAuthCredential =
            GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await _auth.signInWithCredential(googleAuthCredential);
      }

      final user = userCredential.user;
      FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        userIdGlobal = _auth.currentUser.uid;
        if (documentSnapshot.exists) {
          print(documentSnapshot.data()['user_status']);
          if (documentSnapshot.data()['user_status'] == "I am a Farmer") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardFarmer(),
              ),
            );
          } else if (documentSnapshot.data()['user_status'] ==
              "I am a Customer") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardCustomer(),
              ),
            );
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserDetails()),
          );
        }
      });
      //_alertCommon('Login Successful');
    } catch (e) {
      _alertCommon('Failed to sign in with Google! Please Try Again.');
      print(e);
    }
  }

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ Sign In With Facebook Function ++++++++++++++++++++++++++++++++
  void _signInWithFacebook() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    switch (res.status) {
      case FacebookLoginStatus.Success:
        final FacebookAccessToken fbToken = res.accessToken;
        final AuthCredential credential =
            FacebookAuthProvider.credential(fbToken.token);

        final User user = (await _auth.signInWithCredential(credential)).user;
        FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          userIdGlobal = _auth.currentUser.uid;
          if (documentSnapshot.exists) {
            print(documentSnapshot.data()['user_status']);
            if (documentSnapshot.data()['user_status'] == "I am a Farmer") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardFarmer(),
                ),
              );
            } else if (documentSnapshot.data()['user_status'] ==
                "I am a Customer") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardCustomer(),
                ),
              );
            }
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserDetails()),
            );
          }
        });
        //_alertCommon('Login Successful');

        break;
      case FacebookLoginStatus.Cancel:
        _alertCommon('Cancel by User');
        break;
      case FacebookLoginStatus.Error:
        _alertCommon('Facebook Authorization Failed');
        print(res.error.toString());
        break;
    }
  }

//+++++++++++++++++++++++++++++++++++++++++++++++++ Sign Out Function +++++++++++++++++++++++++++++++++++++++++++
  void _signOut() {
    _auth.signOut();
  }

//------------------------------------------------------------ Common Alert Dialog ----------------------------------------
  AlertDialog _alertCommon(String myAlert) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Alert!",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: Text(myAlert),
            backgroundColor: Color(0xFF09CB9B),
            actions: [
              FlatButton(
                  child: Text("Close"),
                  color: Color(0xFF06906E),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _clear();
                  }),
            ],
          );
        });
  }

//------------------------------------------------------------ Move to Login Alert Dialog ----------------------------------------
  AlertDialog _alertMoveToLogin(String myAlert) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Alert!",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: Text(myAlert),
            backgroundColor: Color(0xFF09CB9B),
            actions: [
              FlatButton(
                  child: Text("Close"),
                  color: Color(0xFF06906E),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _moveToLogin();
                    _clear();
                  }),
            ],
          );
        });
  }

  //----------------------------------------------- Clear Controller Values ----------------------------------------
  void _clear() {
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ Start Build Function ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF09CB9B),
                      Color(0xFF07B086),
                      Color(0xFF069370),
                      Color(0xFF057659),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 120.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _formType == FormType.login
                              ? 'Sign In'
                              : _formType == FormType.register
                                  ? 'Sign Up'
                                  : 'Reset Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        _buildEmailField(),
                        // call email text field
                        SizedBox(
                          height: 30.0,
                        ),
                        _buildPasswordField(),
                        // call password text field
                        _displayForgotPasswordButton(),
                        // display forgot password button as form type
                        _displayCheckBox(),
                        // display remember me & agreement checkbox as form type
                        _displaySubmitButtons(),
                        // display login or register button as form type
                        _displaySignInWithTexts(),
                        // display sign in with or sign up with texts as form type
                        _buildSocialBtnRow(),
                        // call sign in with social row
                        _displaySignStatusButton(),
                        //display sign in & sign up buttons as form type
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

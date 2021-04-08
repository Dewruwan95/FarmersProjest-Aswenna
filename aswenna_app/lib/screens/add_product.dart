import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'login_screen.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

CollectionReference users = FirebaseFirestore.instance.collection('users');

class _AddProductState extends State<AddProduct> {
  List<String> categories = ["Vegetable", "Fruit", "Grain"];

  List<DropdownMenuItem<String>> listDropdown = [];
  var selectedTypeForFirebase;
  var selectedItemType;
  var selectedItemName;
  var selectedCardColor;
  var selectedImg;
  var minimumSupply;
  var maximumSupply;
  var pricePerKilo;
  var itemLocation;
  var addressLine1;
  var addressLine2;
  var city;
  var district;
  var province;
  var sellerName;
  var sellerContactNumber;
  var itemDescription = "";
  var image1Url;
  var image2Url;
  var image3Url;
  var image4Url;
  PickedFile _imageFile;

  bool circularIndicatorState = false;

  //-------------------------------------------

  TextEditingController _minimumSupply = TextEditingController();
  TextEditingController _miaximumSupply = TextEditingController();
  TextEditingController _pricePerKilo = TextEditingController();
  TextEditingController _itemLocation = TextEditingController();
  TextEditingController _itemDescription = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedItemType = null;
  }

  //------------------ get product data ------------
  var _data;

  getProductData() {
    var dataStream = FirebaseFirestore.instance
        .collection('products_data')
        .where('type', isEqualTo: selectedTypeForFirebase)
        .snapshots();
    // FirebaseFirestore firestore = FirebaseFirestore.instance;
    // var qn = await firestore.collection('vegetables').get();
    // return qn.docs;
    return dataStream;
  }

  //----------------- load item picture to select item name ------------------
  void loadImageGrid() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(selectedItemType),
          backgroundColor: Color(0xFF069370),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: _data,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            //childAspectRatio: 2,
                          ),
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot proData =
                                snapshot.data.documents[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedItemName = proData['name'];
                                  selectedCardColor = proData['color'];
                                  selectedImg = proData['img'];
                                });

                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 80.0,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  color: Color(
                                    int.parse('${proData['color']}'),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          alignment: Alignment.center,
                                          children: [
                                            //Spacer(),

                                            FadeInImage.assetNetwork(
                                              placeholder:
                                                  'assets/images/placeholder.png',
                                              image: '${proData['img']}',
                                              //fit: BoxFit.cover,
                                              alignment: Alignment.center,
                                              imageScale: 0.09,
                                            ),
                                            Text(
                                              '${proData['name']}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 20, //22
                                                  color: Colors.white),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      );
    }));
  }

//------------------------- Load item type dropdown data -------------------------
  void loadDropdownData() {
    listDropdown = [];
    listDropdown.add(
      DropdownMenuItem(
        child: Text("Vegetable"),
        value: "Vegetable",
      ),
    );
    listDropdown.add(
      DropdownMenuItem(
        child: Text("Fruit"),
        value: "Fruit",
      ),
    );
    listDropdown.add(
      DropdownMenuItem(
        child: Text("Grain"),
        value: "Grain",
      ),
    );
  }

  //----------------------------- minimum supply ---------------------------
  void loadMinimumSupply() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Minimum Supply Amount (Kg)"),
              backgroundColor: Color(0xFF069370),
              centerTitle: true,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Expanded(
                        child: Text(
                          "Enter The Miinimum Supply Amount in Here.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20.0),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 200, 30, 0),
                      child: TextFormField(
                        controller: _minimumSupply,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40.0,
                        ),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueAccent, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueAccent, width: 2.0),
                          ),
                          hintText: "Ex :- 10 Kg",
                          hintStyle: TextStyle(
                            fontSize: 40.0,
                            color: Colors.black26,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 400, 0, 0),
                      alignment: Alignment.center,
                      child: ButtonTheme(
                        height: 50,
                        minWidth: 200,
                        child: RaisedButton(
                          color: Colors.blueAccent,
                          onPressed: () {
                            if (int.parse(_minimumSupply.text) > 0 &&
                                int.parse(_minimumSupply.text) != null) {
                              setState(() {
                                minimumSupply = int.parse(_minimumSupply.text);
                              });
                              Navigator.pop(context);
                            }
                          },
                          padding: EdgeInsets.only(right: 0.0),
                          child: Text(
                            'CONFIRM',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans',
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  //----------------------------- maximum supply ---------------------------
  void loadMaximumSupply() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Maximum Supply Amount (Kg)"),
                backgroundColor: Color(0xFF069370),
                centerTitle: true,
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Expanded(
                          child: Text(
                            "Enter The Maximum Supply Amount in Here.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20.0),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 200, 30, 0),
                        child: TextFormField(
                          controller: _miaximumSupply,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40.0,
                          ),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueAccent, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueAccent, width: 2.0),
                            ),
                            hintText: "Ex :- 250 Kg",
                            hintStyle: TextStyle(
                              fontSize: 40.0,
                              color: Colors.black26,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 400, 0, 0),
                        alignment: Alignment.center,
                        child: ButtonTheme(
                          height: 50,
                          minWidth: 200,
                          child: RaisedButton(
                            color: Colors.blueAccent,
                            onPressed: () {
                              if (int.parse(_miaximumSupply.text) > 0 &&
                                  int.parse(_miaximumSupply.text) != null) {
                                setState(() {
                                  maximumSupply =
                                      int.parse(_miaximumSupply.text);
                                });
                                Navigator.pop(context);
                              }
                            },
                            padding: EdgeInsets.only(right: 0.0),
                            child: Text(
                              'CONFIRM',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans',
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ));
        },
      ),
    );
  }

  //----------------------------- price per kilogram ---------------------------
  void loadPricePerKilo() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Minimum Price Per Kilo(Rupees)"),
                backgroundColor: Color(0xFF069370),
                centerTitle: true,
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Expanded(
                          child: Text(
                            "Enter The Minimum Selling Price Per Kilogram for Your Product",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20.0),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 200, 30, 0),
                        child: TextFormField(
                          controller: _pricePerKilo,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40.0,
                          ),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueAccent, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueAccent, width: 2.0),
                            ),
                            hintText: "Ex :- Rs. 120",
                            hintStyle: TextStyle(
                              fontSize: 40.0,
                              color: Colors.black26,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 400, 0, 0),
                        alignment: Alignment.center,
                        child: ButtonTheme(
                          height: 50,
                          minWidth: 200,
                          child: RaisedButton(
                            color: Colors.blueAccent,
                            onPressed: () {
                              if (int.parse(_pricePerKilo.text) > 0 &&
                                  int.parse(_pricePerKilo.text) != null) {
                                setState(() {
                                  pricePerKilo = int.parse(_pricePerKilo.text);
                                });
                                Navigator.pop(context);
                              }
                            },
                            padding: EdgeInsets.only(right: 0.0),
                            child: Text(
                              'CONFIRM',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans',
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ));
        },
      ),
    );
  }

  //-------------------------- item location ---------------------------
  void loadItemLocation() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Available at",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                backgroundColor: Color(0xFF069370),
                centerTitle: true,
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Expanded(
                          child: Text(
                            "Enter the Location Where Product Can be Collected in Here.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20.0),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 150, 30, 0),
                        child: TextFormField(
                          controller: _itemLocation,
                          maxLines: 6,
                          minLines: 6,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 22.0,
                          ),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueAccent, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueAccent, width: 2.0),
                            ),
                            hintText:
                                "Ex :- No. 12/1, \n        Nisala Niwasa, \n        Rohala Para, \n        Gangodawila, \n        Nugegoda",
                            hintStyle: TextStyle(
                              fontSize: 22.0,
                              color: Colors.black26,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 350, 0, 0),
                        alignment: Alignment.center,
                        child: ButtonTheme(
                          height: 50,
                          minWidth: 330,
                          child: RaisedButton(
                            color: Colors.green,
                            onPressed: () {
                              print(userIdGlobal);
                              users
                                  .doc(userIdGlobal)
                                  .snapshots()
                                  .listen((event) {
                                addressLine1 = event.data()['address_01'];
                                addressLine2 = event.data()['address_02'];
                                city = event.data()['city'];
                                district = event.data()['district'];
                                province = event.data()['province'];
                                sellerName = event.data()['first_name'] +
                                    ' ' +
                                    event.data()['last_name'];
                                sellerContactNumber = event.data()['mobile'];
                                itemLocation = addressLine2 == null
                                    ? "$addressLine1\n$city\n$district\n$province"
                                    : "$addressLine1\n$addressLine2\n$city\n$district\n$province";
                                _itemLocation.text = itemLocation;
                              });

                              // _itemLocation.text =
                              //     _loadUserData().data()[userIdGlobal];
                            },
                            padding: EdgeInsets.only(right: 0.0),
                            child: Text(
                              'Put Home Location',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans',
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 450, 0, 0),
                        alignment: Alignment.center,
                        child: ButtonTheme(
                          height: 50,
                          minWidth: 200,
                          child: RaisedButton(
                            color: Colors.blueAccent,
                            onPressed: () {
                              if (_itemLocation.text != "") {
                                setState(
                                  () {
                                    itemLocation = _itemLocation.text;
                                  },
                                );
                                Navigator.pop(context);
                              }
                            },
                            padding: EdgeInsets.only(right: 0.0),
                            child: Text(
                              'CONFIRM',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans',
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ));
        },
      ),
    );
  }

  //-------------------------- load item description --------------------------
  void loadItemDescription() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(
                "Description",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              backgroundColor: Color(0xFF069370),
              centerTitle: true,
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Expanded(
                            child: Text(
                              "Provide Useful Information About Your Products Here.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20.0),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(30, 100, 30, 0),
                          child: TextFormField(
                            maxLength: 500,
                            controller: _itemDescription,
                            maxLines: 14,
                            minLines: 14,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 22.0,
                            ),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blueAccent, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blueAccent, width: 2.0),
                              ),
                              hintText: "Information Such As Product Quality.",
                              hintStyle: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black26,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 600, 0, 0),
                          alignment: Alignment.center,
                          child: ButtonTheme(
                            height: 50,
                            minWidth: 200,
                            child: RaisedButton(
                              color: Colors.blueAccent,
                              onPressed: () {
                                if (_itemDescription.text != "") {
                                  setState(
                                    () {
                                      itemDescription = _itemDescription.text;
                                    },
                                  );
                                  Navigator.pop(context);
                                }
                              },
                              padding: EdgeInsets.only(right: 0.0),
                              child: Text(
                                'CONFIRM',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'OpenSans',
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  //------------------- load image 01 upload ---------------------------------
  void loadImage1Upload() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(
                "Photos",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              backgroundColor: Color(0xFF069370),
              centerTitle: true,
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Expanded(
                                    child: Text(
                                      "Select Photos Of Your Products Here. ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20.0),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Spacer(),
                            //------------------- camera upload----------------
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 300, 0, 0),
                                  alignment: Alignment.center,
                                  child: ButtonTheme(
                                    height: 100,
                                    minWidth: 100,
                                    child: RaisedButton(
                                      color: Colors.blueAccent,
                                      onPressed: () {
                                        pickImage1FromCamera();
                                      },
                                      padding: EdgeInsets.only(right: 0.0),
                                      child: Icon(
                                        Icons.camera_alt_sharp,
                                        size: 50.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Camera\nUpload",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),

                            Spacer(),
                            //------------------- file upload----------------
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 300, 0, 0),
                                  alignment: Alignment.center,
                                  child: ButtonTheme(
                                    height: 100,
                                    minWidth: 100,
                                    child: RaisedButton(
                                      color: Colors.blueAccent,
                                      onPressed: () {
                                        pickImage1FromFile();
                                      },
                                      padding: EdgeInsets.only(right: 0.0),
                                      child: Icon(
                                        Icons.upload_file,
                                        size: 50.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "File\nUpload",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),

                            Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  //------------------ pick image 01 from camera & upload to firebase --------------------------

  Future pickImage1FromCamera() async {
    final currentDateTime = DateTime.now();
    final ImagePicker picker = ImagePicker();
    final userId = userIdGlobal;
    final imageName = "$userId:$currentDateTime";
    final imagePath = "farmer_product_photos/$imageName";
    final _storage = FirebaseStorage.instance;

    _imageFile = await picker.getImage(source: ImageSource.camera);

    var fileImage = File(_imageFile.path);

    if (_imageFile != null) {
      Navigator.pop(context);
      var snapshot = await _storage.ref().child(imagePath).putFile(fileImage);

      var downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        image1Url = downloadUrl;
      });
    } else {
      print('No path received');
    }
  }

//------------------ pick image 01 from galery & upload to firebase --------------------------

  Future pickImage1FromFile() async {
    final currentDateTime = DateTime.now();
    final ImagePicker picker = ImagePicker();
    final userId = userIdGlobal;
    final imageName = "$userId:$currentDateTime";
    final imagePath = "farmer_product_photos/$imageName";
    final _storage = FirebaseStorage.instance;

    _imageFile = await picker.getImage(source: ImageSource.gallery);

    var fileImage = File(_imageFile.path);

    if (_imageFile != null) {
      Navigator.pop(context);
      var snapshot = await _storage.ref().child(imagePath).putFile(fileImage);

      var downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        image1Url = downloadUrl;
      });
    } else {
      print('No path received');
    }
  }

  //------------------- load image 02 upload ---------------------------------
  void loadImage2Upload() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(
                "Photos",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              backgroundColor: Color(0xFF069370),
              centerTitle: true,
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Expanded(
                                    child: Text(
                                      "Select Photos Of Your Products Here. ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20.0),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Spacer(),
                            //------------------- camera upload----------------
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 300, 0, 0),
                                  alignment: Alignment.center,
                                  child: ButtonTheme(
                                    height: 100,
                                    minWidth: 100,
                                    child: RaisedButton(
                                        color: Colors.blueAccent,
                                        onPressed: () {
                                          pickImage2FromCamera();
                                        },
                                        padding: EdgeInsets.only(right: 0.0),
                                        child: Icon(
                                          Icons.camera_alt_sharp,
                                          size: 50.0,
                                          color: Colors.white,
                                        )),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Camera\nUpload",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),

                            Spacer(),
                            //------------------- file upload----------------
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 300, 0, 0),
                                  alignment: Alignment.center,
                                  child: ButtonTheme(
                                    height: 100,
                                    minWidth: 100,
                                    child: RaisedButton(
                                      color: Colors.blueAccent,
                                      onPressed: () {
                                        pickImage2FromFile();
                                      },
                                      padding: EdgeInsets.only(right: 0.0),
                                      child: Icon(
                                        Icons.upload_file,
                                        size: 50.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "File\nUpload",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),

                            Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  //------------------ pick image 02 from camera & upload to firebase --------------------------

  Future pickImage2FromCamera() async {
    final currentDateTime = DateTime.now();
    final ImagePicker picker = ImagePicker();
    final userId = userIdGlobal;
    final imageName = "$userId:$currentDateTime";
    final imagePath = "farmer_product_photos/$imageName";
    final _storage = FirebaseStorage.instance;

    _imageFile = await picker.getImage(source: ImageSource.camera);

    var fileImage = File(_imageFile.path);

    if (_imageFile != null) {
      Navigator.pop(context);
      var snapshot = await _storage.ref().child(imagePath).putFile(fileImage);

      var downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        image2Url = downloadUrl;
      });
    } else {
      print('No path received');
    }
  }

//------------------ pick image 02 from galery & upload to firebase --------------------------

  Future pickImage2FromFile() async {
    final currentDateTime = DateTime.now();
    final ImagePicker picker = ImagePicker();
    final userId = userIdGlobal;
    final imageName = "$userId:$currentDateTime";
    final imagePath = "farmer_product_photos/$imageName";
    final _storage = FirebaseStorage.instance;

    _imageFile = await picker.getImage(source: ImageSource.gallery);

    var fileImage = File(_imageFile.path);

    if (_imageFile != null) {
      Navigator.pop(context);
      var snapshot = await _storage.ref().child(imagePath).putFile(fileImage);

      var downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        image2Url = downloadUrl;
      });
    } else {
      print('No path received');
    }
  }

  //------------------- load image 03 upload ---------------------------------
  void loadImage3Upload() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(
                "Photos",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              backgroundColor: Color(0xFF069370),
              centerTitle: true,
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Expanded(
                                    child: Text(
                                      "Select Photos Of Your Products Here. ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20.0),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Spacer(),
                            //------------------- camera upload----------------
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 300, 0, 0),
                                  alignment: Alignment.center,
                                  child: ButtonTheme(
                                    height: 100,
                                    minWidth: 100,
                                    child: RaisedButton(
                                      color: Colors.blueAccent,
                                      onPressed: () {
                                        pickImage3FromCamera();
                                      },
                                      padding: EdgeInsets.only(right: 0.0),
                                      child: Icon(
                                        Icons.camera_alt_sharp,
                                        size: 50.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Camera\nUpload",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),

                            Spacer(),
                            //------------------- file upload----------------
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 300, 0, 0),
                                  alignment: Alignment.center,
                                  child: ButtonTheme(
                                    height: 100,
                                    minWidth: 100,
                                    child: RaisedButton(
                                      color: Colors.blueAccent,
                                      onPressed: () {
                                        pickImage3FromFile();
                                      },
                                      padding: EdgeInsets.only(right: 0.0),
                                      child: Icon(
                                        Icons.upload_file,
                                        size: 50.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "File\nUpload",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),

                            Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  //------------------ pick image 03 from camera & upload to firebase --------------------------

  Future pickImage3FromCamera() async {
    final currentDateTime = DateTime.now();
    final ImagePicker picker = ImagePicker();
    final userId = userIdGlobal;
    final imageName = "$userId:$currentDateTime";
    final imagePath = "farmer_product_photos/$imageName";
    final _storage = FirebaseStorage.instance;

    _imageFile = await picker.getImage(source: ImageSource.camera);

    var fileImage = File(_imageFile.path);

    if (_imageFile != null) {
      Navigator.pop(context);
      var snapshot = await _storage.ref().child(imagePath).putFile(fileImage);

      var downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        image3Url = downloadUrl;
      });
    } else {
      print('No path received');
    }
  }

//------------------ pick image 03 from galery & upload to firebase --------------------------

  Future pickImage3FromFile() async {
    final currentDateTime = DateTime.now();
    final ImagePicker picker = ImagePicker();
    final userId = userIdGlobal;
    final imageName = "$userId:$currentDateTime";
    final imagePath = "farmer_product_photos/$imageName";
    final _storage = FirebaseStorage.instance;

    _imageFile = await picker.getImage(source: ImageSource.gallery);

    var fileImage = File(_imageFile.path);

    if (_imageFile != null) {
      Navigator.pop(context);
      var snapshot = await _storage.ref().child(imagePath).putFile(fileImage);

      var downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        image3Url = downloadUrl;
      });
    } else {
      print('No path received');
    }
  }

  //------------------- load image 01 upload ---------------------------------
  void loadImage4Upload() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(
                "Photos",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              backgroundColor: Color(0xFF069370),
              centerTitle: true,
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Expanded(
                                    child: Text(
                                      "Select Photos Of Your Products Here. ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20.0),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Spacer(),
                            //------------------- camera upload----------------
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 300, 0, 0),
                                  alignment: Alignment.center,
                                  child: ButtonTheme(
                                    height: 100,
                                    minWidth: 100,
                                    child: RaisedButton(
                                      color: Colors.blueAccent,
                                      onPressed: () {
                                        pickImage4FromCamera();
                                      },
                                      padding: EdgeInsets.only(right: 0.0),
                                      child: Icon(
                                        Icons.camera_alt_sharp,
                                        size: 50.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Camera\nUpload",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),

                            Spacer(),
                            //------------------- file upload----------------
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 300, 0, 0),
                                  alignment: Alignment.center,
                                  child: ButtonTheme(
                                    height: 100,
                                    minWidth: 100,
                                    child: RaisedButton(
                                      color: Colors.blueAccent,
                                      onPressed: () {
                                        pickImage4FromFile();
                                      },
                                      padding: EdgeInsets.only(right: 0.0),
                                      child: Icon(
                                        Icons.upload_file,
                                        size: 50.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "File\nUpload",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),

                            Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  //------------------ pick image 04 from camera & upload to firebase --------------------------

  Future pickImage4FromCamera() async {
    final currentDateTime = DateTime.now();
    final ImagePicker picker = ImagePicker();
    final userId = userIdGlobal;
    final imageName = "$userId:$currentDateTime";
    final imagePath = "farmer_product_photos/$imageName";
    final _storage = FirebaseStorage.instance;

    _imageFile = await picker.getImage(source: ImageSource.camera);

    var fileImage = File(_imageFile.path);

    if (_imageFile != null) {
      Navigator.pop(context);
      var snapshot = await _storage.ref().child(imagePath).putFile(fileImage);

      var downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        image4Url = downloadUrl;
      });
    } else {
      print('No path received');
    }
  }

//------------------ pick image 04 from galery & upload to firebase --------------------------

  Future pickImage4FromFile() async {
    final currentDateTime = DateTime.now();
    final ImagePicker picker = ImagePicker();
    final userId = userIdGlobal;
    final imageName = "$userId:$currentDateTime";
    final imagePath = "farmer_product_photos/$imageName";
    final _storage = FirebaseStorage.instance;

    _imageFile = await picker.getImage(source: ImageSource.gallery);

    var fileImage = File(_imageFile.path);

    if (_imageFile != null) {
      Navigator.pop(context);
      var snapshot = await _storage.ref().child(imagePath).putFile(fileImage);

      var downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        image4Url = downloadUrl;
      });
    } else {
      print('No path received');
    }
  }

//-------------------------------------------------------
  Future addSaleDataToFirebase() async {
    CollectionReference sales = FirebaseFirestore.instance.collection('sales');
    final userId = userIdGlobal;
    final currentDateTime = DateTime.now();
    final documentId = "$userId:$currentDateTime";
    sales
        .doc(documentId)
        .set({
          'color': selectedCardColor,
          'created_date': currentDateTime,
          'description': itemDescription,
          'farmer_id': userIdGlobal,
          'img': selectedImg,
          'location': itemLocation,
          'max_supply': maximumSupply,
          'min_supply': minimumSupply,
          'photo_url_1': image1Url,
          'photo_url_2': image2Url,
          'photo_url_3': image3Url,
          'photo_url_4': image4Url,
          'price': pricePerKilo,
          'product_name': selectedItemName,
          'seller_name': sellerName,
          'type': selectedTypeForFirebase,
          'seller_contact': sellerContactNumber,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));

    Navigator.of(context).pop();
  }

//------------------------- start build ----------------------------------
  @override
  Widget build(BuildContext context) {
    loadDropdownData();

//-------------------------------------------------------------

    return Scaffold(
      backgroundColor: Color(0xFFB0B3B8),
      appBar: AppBar(
        title: Text(
          'Add New Order',
          textAlign: TextAlign.left,
        ),
        backgroundColor: Color(0xFF069370),
        centerTitle: true,
        // actions: [
        //   Image.network(
        //     '${widget.proData['img']}',
        //     scale: 6.5,
        //   ),
        // ],
      ),
      body: buildAddProductBody(),
    );
  }

//--------------------------  build body of add product ------------------------
  SingleChildScrollView buildAddProductBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20.0,
          ),

          //-------------------------------- Product type ---------------------
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            decoration: BoxDecoration(color: Colors.white),
            child: ListTile(
              tileColor: Colors.white,
              title: Row(
                children: [
                  Text(
                    "Product Category :     ",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  DropdownButton(
                    value: selectedItemType,
                    items: listDropdown,
                    hint: Text("Choose Here"),
                    onChanged: (value) {
                      setState(() {
                        selectedItemType = value;
                        if (selectedItemType == "Vegetable") {
                          selectedTypeForFirebase = "veg";
                        } else if (selectedItemType == "Fruit") {
                          selectedTypeForFirebase = "fru";
                        } else if (selectedItemType == "Grain") {
                          selectedTypeForFirebase = "gra";
                        }
                      });
                      //print("you selected $value");
                    },
                  ),
                ],
              ),
              subtitle: Text("Select The Marketing Product Category Here."),
              trailing: Icon(Icons.arrow_forward_ios_outlined),
              onTap: () {},
            ),
          ),

          SizedBox(
            height: 20.0,
          ),
          //----------------------------- product name ---------------------------

          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            decoration: BoxDecoration(color: Colors.white),
            child: ListTile(
              tileColor: Colors.white,
              title: Text(
                selectedItemName != null
                    ? "Product Name :  $selectedItemName"
                    : "Product Name : ",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text("Select The Name Of The Marketing Product Here."),
              trailing: Icon(Icons.arrow_forward_ios_outlined),
              onTap: () {
                if (selectedItemType == null) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          "Alert!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFC62828),
                          ),
                        ),
                        content: Text(
                          "Please Select a Product Category ",
                          textAlign: TextAlign.left,
                        ),
                        actions: [
                          FlatButton(
                            child: Text("OK"),
                            color: Colors.blueAccent,
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    },
                  );
                } else {
                  _data = getProductData();
                  loadImageGrid();
                }
              },
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          //-----------------------------------------------------------

          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            decoration: BoxDecoration(color: Colors.white),
            child: ListTile(
              tileColor: Colors.white,
              title: Text(
                minimumSupply == null
                    ? "Minimum supply quantity  :  "
                    : "Minimum supply quantity  :  $minimumSupply Kg",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle:
                  Text("Enter The Maximum Amount Can Provided To You Here."),
              trailing: Icon(Icons.arrow_forward_ios_outlined),
              onTap: () {
                loadMinimumSupply();
              },
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          //-----------------------------------------------------------

          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            decoration: BoxDecoration(color: Colors.white),
            child: ListTile(
              tileColor: Colors.white,
              title: Text(
                maximumSupply == null
                    ? "Maximum supply quantity  : "
                    : "Maximum supply quantity :  $maximumSupply Kg",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle:
                  Text("Enter The Minimum Amount Can Provided To You Here."),
              trailing: Icon(Icons.arrow_forward_ios_outlined),
              onTap: () {
                loadMaximumSupply();
              },
            ),
          ),
          SizedBox(
            height: 20.0,
          ),

          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            decoration: BoxDecoration(color: Colors.white),
            child: ListTile(
              tileColor: Colors.white,
              title: Text(
                pricePerKilo == null
                    ? "Minimum Price Per Kilo : "
                    : "Minimum Price Per Kilo :  Rs. $pricePerKilo ",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                  "Enter The Lowest Price You Expect Your Product To Sell For."),
              trailing: Icon(Icons.arrow_forward_ios_outlined),
              onTap: () {
                loadPricePerKilo();
              },
            ),
          ),

          SizedBox(
            height: 20.0,
          ),
          //-----------------------------------------------------------

          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            decoration: BoxDecoration(color: Colors.white),
            child: ListTile(
              tileColor: Colors.white,
              title: Text(
                "Where products are available :",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(itemLocation == null
                  ? "Enter The Place Where Customers Should Come To Get Your Products. (Address)"
                  : "Enter The Place Where Customers Should Come To Get Your Products. (Address) \n \n$itemLocation"),
              trailing: Icon(Icons.arrow_forward_ios_outlined),
              onTap: () {
                loadItemLocation();
              },
            ),
          ),

          SizedBox(
            height: 20.0,
          ),
          //-----------------------------------------------------------
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            decoration: BoxDecoration(color: Colors.white),
            child: ListTile(
              tileColor: Colors.white,
              title: Text(
                "Description :",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(itemDescription == null
                  ? "Provide Useful Information About Your Products Here."
                  : "Provide Useful Information About Your Products Here. \n \n$itemDescription"),
              trailing: Icon(Icons.arrow_forward_ios_outlined),
              onTap: () {
                loadItemDescription();
              },
            ),
          ),

          SizedBox(
            height: 20.0,
          ),
          //-----------------------------------------------------------

          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 50),
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                ListTile(
                  tileColor: Colors.white,
                  title: Text(
                    "Photos :",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text("Post Photos Of Your Products Here."),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //------------------------------------------------------
                    Spacer(),
                    Stack(
                      fit: StackFit.loose,
                      children: [
                        Container(
                          height: 80.0,
                          width: 80.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Color(0xFFFF7643),
                            ),
                          ),
                          child: (image1Url == null || image1Url == "")
                              ? Image.asset(
                                  'assets/images/placeholder_low_opacity.png',
                                  scale: 2.5,
                                )
                              : Image.network(
                                  image1Url,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15.0, 15.0, 0, 0),
                          child: IconButton(
                            alignment: Alignment.center,
                            icon: Icon(
                              Icons.add_a_photo_outlined,
                              color: Color(0xFFFF7643),
                            ),
                            onPressed: () {
                              loadImage1Upload();
                            },
                          ),
                        ),
                      ],
                    ),

                    //------------------------------------------------------
                    Spacer(),
                    Stack(
                      fit: StackFit.loose,
                      children: [
                        Container(
                          // margin: EdgeInsets.only(right: 60),
                          // padding: EdgeInsets.all(8.0),
                          height: 80.0,
                          width: 80.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            //borderRadius: BorderRadius.circular(10.0),

                            border: Border.all(
                              color: Color(0xFFFF7643),
                            ),
                          ),
                          child: (image2Url == null || image2Url == "")
                              ? Image.asset(
                                  'assets/images/placeholder_low_opacity.png',
                                  scale: 2.5,
                                )
                              : Image.network(
                                  image2Url,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15.0, 15.0, 0, 0),
                          child: IconButton(
                            alignment: Alignment.center,
                            icon: Icon(
                              Icons.add_a_photo_outlined,
                              color: Color(0xFFFF7643),
                            ),
                            onPressed: () {
                              loadImage2Upload();
                            },
                          ),
                        ),
                      ],
                    ),
                    //------------------------------------------------------
                    Spacer(),
                    Stack(
                      fit: StackFit.loose,
                      children: [
                        Container(
                          // margin: EdgeInsets.only(right: 60),
                          // padding: EdgeInsets.all(8.0),
                          height: 80.0,
                          width: 80.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            //borderRadius: BorderRadius.circular(10.0),

                            border: Border.all(
                              color: Color(0xFFFF7643),
                            ),
                          ),
                          child: (image3Url == null || image3Url == "")
                              ? Image.asset(
                                  'assets/images/placeholder_low_opacity.png',
                                  scale: 2.5,
                                )
                              : Image.network(
                                  image3Url,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15.0, 15.0, 0, 0),
                          child: IconButton(
                            alignment: Alignment.center,
                            icon: Icon(
                              Icons.add_a_photo_outlined,
                              color: Color(0xFFFF7643),
                            ),
                            onPressed: () {
                              loadImage3Upload();
                            },
                          ),
                        ),
                      ],
                    ),
                    //------------------------------------------------------
                    Spacer(),
                    Stack(
                      fit: StackFit.loose,
                      children: [
                        Container(
                          // margin: EdgeInsets.only(right: 60),
                          // padding: EdgeInsets.all(8.0),
                          height: 80.0,
                          width: 80.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            //borderRadius: BorderRadius.circular(10.0),

                            border: Border.all(
                              color: Color(0xFFFF7643),
                            ),
                          ),
                          child: (image4Url == null || image4Url == "")
                              ? Image.asset(
                                  'assets/images/placeholder_low_opacity.png',
                                  scale: 2.5,
                                )
                              : Image.network(
                                  image4Url,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15.0, 15.0, 0, 0),
                          child: IconButton(
                            alignment: Alignment.center,
                            icon: Icon(
                              Icons.add_a_photo_outlined,
                              color: Color(0xFFFF7643),
                            ),
                            onPressed: () {
                              loadImage4Upload();
                            },
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  alignment: Alignment.center,
                  child: ButtonTheme(
                    height: 50,
                    minWidth: 200,
                    child: RaisedButton(
                      color: Colors.blueAccent,
                      onPressed: () {
                        if (selectedTypeForFirebase == null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  "Alert!",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                content: Text("Please Select Item Type"),
                                actions: [
                                  FlatButton(
                                    child: Text("Close"),
                                    color: Colors.blueAccent,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (selectedItemName == null ||
                            selectedCardColor == null ||
                            selectedImg == null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  "Alert!",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                content: Text("Please Select Item Name"),
                                actions: [
                                  FlatButton(
                                    child: Text("Close"),
                                    color: Colors.blueAccent,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (minimumSupply == null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  "Alert!",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                content: Text("Please Input Minimum Supply"),
                                actions: [
                                  FlatButton(
                                    child: Text("Close"),
                                    color: Colors.blueAccent,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (maximumSupply == null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  "Alert!",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                content: Text("Please Input Maximum Supply"),
                                actions: [
                                  FlatButton(
                                    child: Text("Close"),
                                    color: Colors.blueAccent,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (pricePerKilo == null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  "Alert!",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                content:
                                    Text("Please input Price Per Kilogram"),
                                actions: [
                                  FlatButton(
                                    child: Text("Close"),
                                    color: Colors.blueAccent,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (itemLocation == null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  "Alert!",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                content: Text("Please Input Product Location"),
                                actions: [
                                  FlatButton(
                                    child: Text("Close"),
                                    color: Colors.blueAccent,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          addSaleDataToFirebase();
                        }
                      },
                      padding: EdgeInsets.only(right: 0.0),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}

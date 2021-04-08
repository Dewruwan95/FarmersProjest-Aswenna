import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'edit_product_details.dart';

//---------------------- Detail Page -----------------------
class ProductDetailPageFarmer extends StatefulWidget {
  final DocumentSnapshot proData;

  ProductDetailPageFarmer({this.proData});

  @override
  _ProductDetailPageFarmerState createState() =>
      _ProductDetailPageFarmerState();
}

class _ProductDetailPageFarmerState extends State<ProductDetailPageFarmer> {
  navigateToEditProductDetails(DocumentSnapshot proDatas) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductDetails(
          proData: proDatas,
        ),
      ),
    );
  }

//----------------------------------------------------------------
//----------------------------------------------------
  Future deleteSalesFromFirebase() async {
    CollectionReference sales = FirebaseFirestore.instance.collection('sales');
    final docId = widget.proData.id;
    sales
        .doc(docId)
        .delete()
        .then((value) => print("Sale Deleted"))
        .catchError((error) => print("Failed to delete Sale: $error"));
  }

//----------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF9bd1c4),
      appBar: AppBar(
        title: Text(
          'Details',
          textAlign: TextAlign.left,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined),
            onPressed: () {
              navigateToEditProductDetails(widget.proData);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
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
                        Text("Are You Sure? Do You Want To Delete The Order?"),
                    actions: [
                      FlatButton(
                        child: Text("No"),
                        color: Colors.blueAccent,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text("Yes"),
                        color: Colors.blueAccent,
                        onPressed: () {
                          deleteSalesFromFirebase();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
        backgroundColor: Color(0xFF069370),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProductImages(widget: widget),
            TopRoundedContainer(
              color: Color(0xFF459682),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '${widget.proData['product_name']}',
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //---------------------------------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Minimum Price     : Rs.",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.proData['price']}.00 / Kg",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //-----------------------------------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Minimum Supply  : ",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "${widget.proData['min_supply']} Kg",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //-------------------------------------------------

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Maximum Supply : ",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "${widget.proData['max_supply']} Kg",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //-------------------------------------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Created Date         : ",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "${DateFormat.yMMMd().format(widget.proData['created_date'].toDate())}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ), //-------------------------------------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Seller Name          : ",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "${widget.proData['seller_name']}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //-------------------------------------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Seller Contact       : ",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "${widget.proData['seller_contact']}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  //-------------------------------------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Location                 : ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "${widget.proData['location']}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  //-------------------------------------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Column(
                            children: [
                              Text(
                                "Description            : \n\n${widget.proData['description']}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  //-------------------------------------------------
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final ProductDetailPageFarmer widget;

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    List images = [
      "${widget.widget.proData['photo_url_1']}",
      "${widget.widget.proData['photo_url_2']}",
      "${widget.widget.proData['photo_url_3']}",
      "${widget.widget.proData['photo_url_4']}"
    ];

    GestureDetector buildSmallPreview(int index) {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedImage = index;
          });
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          //padding: EdgeInsets.all(1.0),
          height: 50.0,
          width: 50.0,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                  color: selectedImage == index
                      ? Color(0xFFFF7643)
                      : Colors.black12)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9.0),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/placeholder.png',
              image: images[index],
              fadeInCurve: Curves.bounceIn,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: SizedBox(
            height: 250,
            width: 250,
            child: Row(
              children: [
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: 0),
                  height: 250.0,
                  width: 250.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.black45)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9.0),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/placeholder.png',
                      image: images[selectedImage],
                      fadeInCurve: Curves.bounceIn,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(images.length, (index) => buildSmallPreview(index))
          ],
        )
      ],
    );
  }
}

class TopRoundedContainer extends StatelessWidget {
  const TopRoundedContainer({
    Key key,
    @required this.color,
    @required this.child,
  }) : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.only(top: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: child,
    );
  }
}

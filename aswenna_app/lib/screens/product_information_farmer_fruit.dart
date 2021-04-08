import 'package:aswenna_app/screens/login_screen.dart';
import 'package:aswenna_app/screens/product_details_farmer.dart';
import 'package:aswenna_app/utilities/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_product.dart';

class FarmerProductsFruit extends StatefulWidget {
  @override
  _FarmerProductsFruitState createState() => _FarmerProductsFruitState();
}

class _FarmerProductsFruitState extends State<FarmerProductsFruit> {
  var _dataFruit;
  getDataFruit() {
    var streamFruit = FirebaseFirestore.instance
        .collection('sales')
        .where('type', isEqualTo: "fru")
        .where('farmer_id', isEqualTo: userIdGlobal)
        .orderBy('created_date', descending: true)
        .snapshots();
    return streamFruit;
  }

  navigateToDetail(DocumentSnapshot proData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPageFarmer(
          proData: proData,
        ),
      ),
    );
  }

  @override
  void initState() {
    _dataFruit = getDataFruit();
    // TODO: implement initState
    super.initState();
  }

  Row buildInfoRow(double defaultSize, {String iconSrc, text}) {
    return Row(
      children: <Widget>[
        SizedBox(width: defaultSize), // 10
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return StreamBuilder(
      stream: _dataFruit,
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
                  height: 5.0,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 80.0),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 2,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot proData =
                              snapshot.data.documents[index];

                          var timestamp = proData['created_date'].toDate();
                          var formattedDate =
                              DateFormat.yMMMMd().format(timestamp);
                          return GestureDetector(
                            onTap: () {
                              navigateToDetail(snapshot.data.documents[index]);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 220.0,
                              decoration: BoxDecoration(
                                color: Color(
                                  int.parse('${proData['color']}'),
                                ),
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${proData['product_name']}',
                                            style: TextStyle(
                                              fontSize: 27, //22
                                              color: Colors.white,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          FadeInImage.assetNetwork(
                                            placeholder:
                                                'assets/images/placeholder.png',
                                            image: '${proData['img']}',
                                            fadeInCurve: Curves.bounceIn,
                                            fit: BoxFit.cover,
                                            alignment: Alignment.centerLeft,
                                            imageScale: 2.5,
                                            placeholderScale: 2.5,
                                          ),
                                          buildInfoRow(
                                            defaultSize,
                                            text:
                                                "Minimum Supply : ${proData['min_supply']} Kg",
                                          ),
                                          SizedBox(height: 10),
                                          buildInfoRow(
                                            defaultSize,
                                            text:
                                                "Maximum Supply : ${proData['max_supply']} Kg",
                                          ),
                                          SizedBox(height: 10),
                                          buildInfoRow(
                                            defaultSize,
                                            text:
                                                "Minimum Price Per Kilo : Rs.${proData['price']}",
                                          ),
                                          SizedBox(height: 10),
                                          buildInfoRow(
                                            defaultSize,
                                            text:
                                                "Updated Date : $formattedDate",
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                buildAddProductBtn(context),
              ],
            ),
          );
        }
      },
    );
  }

  Container buildAddProductBtn(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 200),
      child: RawMaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        fillColor: Color(0xFFF2B82A),
        child: Container(
          height: 45.0,
          width: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'ADD NEW ORDER',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                  color: Colors.white,
                  letterSpacing: 1.0,
                  fontFamily: 'OpenSansRegular',
                ),
              ),
            ],
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProduct(),
            ),
          );
        },
        splashColor: Color(0xFFF2B82A),
      ),
    );
  }
}

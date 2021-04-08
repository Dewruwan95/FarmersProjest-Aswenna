import 'package:aswenna_app/screens/product_details_customer.dart';
import 'package:aswenna_app/utilities/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductsAll extends StatefulWidget {
  @override
  _ProductsAllState createState() => _ProductsAllState();
}

class _ProductsAllState extends State<ProductsAll> {
  var _dataAll;

  getDataAll() {
    var streamAll = FirebaseFirestore.instance
        .collection('sales')
        .orderBy('created_date', descending: true)
        .snapshots();
    return streamAll;
  }

  navigateToDetail(DocumentSnapshot proData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPageCustomer(
          proData: proData,
        ),
      ),
    );
  }

  @override
  void initState() {
    _dataAll = getDataAll();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;

    return StreamBuilder(
      stream: _dataAll,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 2,
                      childAspectRatio: 1.65,
                    ),
                    // padding: EdgeInsets.only(top: 10.0),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot proData = snapshot.data.documents[index];
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
                            // Colors.primaries[
                            //     Random().nextInt(Colors.primaries.length)],
                            borderRadius: BorderRadius.circular(18), //18
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Spacer(),
                                      Text(
                                        '${proData['product_name']}',
                                        style: TextStyle(
                                            fontSize: 27, //22
                                            color: Colors.white),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "Rs.${proData['price']}.00 / Kg",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 23),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Spacer(),
                                      // SizedBox(height: 20),
                                      buildInfoRow(
                                        defaultSize,
                                        // iconSrc: "",
                                        text:
                                            "Min Supply : ${proData['min_supply']} Kg",
                                      ),
                                      // SizedBox(height: 5), //5
                                      Spacer(),
                                      buildInfoRow(
                                        defaultSize,

                                        // iconSrc: "",
                                        text:
                                            "Max Supply : ${proData['max_supply']} Kg",
                                      ),
                                      Spacer(),
                                      buildInfoRow(
                                        defaultSize,

                                        // iconSrc: "",
                                        text:
                                            "Listed On : ${DateFormat.yMMMd().format(proData['created_date'].toDate())}",
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 5), //5
                              AspectRatio(
                                aspectRatio: 0.71,
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/images/placeholder.png',
                                  image: '${proData['img']}',
                                  fit: BoxFit.cover,
                                  alignment: Alignment.centerLeft,
                                ),
                                // Image.network(
                                //   '${proData['img']}',
                                //   fit: BoxFit.cover,
                                //   alignment: Alignment.centerLeft,
                                // ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          );
        }
      },
    );
  }
}

//----------------------------------------------------------------------------

Row buildInfoRow(double defaultSize, {String iconSrc, text}) {
  return Row(
    children: <Widget>[
      //Image.asset(iconSrc),
      SizedBox(width: defaultSize), // 10
      Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.0,
        ),
      )
    ],
  );
}

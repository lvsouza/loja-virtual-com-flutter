import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/share/models/product.dart';
import 'package:loja_virtual/share/widgets/cart_button.dart';
import 'package:loja_virtual/share/widgets/product_tile.dart';

class CategoryScreem extends StatelessWidget {
  final DocumentSnapshot snapshot;

  CategoryScreem(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(snapshot.data["title"]),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(icon: Icon(Icons.grid_on)),
              Tab(icon: Icon(Icons.list)),
            ],
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: Firestore.instance
              .collection("products")
              .document(snapshot.documentID)
              .collection("items")
              .getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            else
              return TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  GridView.builder(
                    padding: EdgeInsets.all(4.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      Product data =
                          Product.fromDocument(snapshot.data.documents[index]);
                      data.category = this.snapshot.documentID;

                      return ProductTile("grid", data);
                    },
                  ),
                  ListView.builder(
                    padding: EdgeInsets.all(4.0),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      Product data =
                          Product.fromDocument(snapshot.data.documents[index]);
                      data.category = this.snapshot.documentID;
                      return ProductTile("list", data);
                    },
                  ),
                ],
              );
          },
        ),
        floatingActionButton: CartButton(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:qr_reader/widgets/ScanButton.dart';
import 'package:qr_reader/widgets/custom_navigationbar.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Historial'),
        actions: [
          IconButton(icon: Icon(Icons.delete_forever), onPressed: (){})
        ],
      ),
      body: Center(
        child: Text('Home page'),
      ),
      bottomNavigationBar: CustomNavigationBar(),
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

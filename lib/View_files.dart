import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class view_files extends StatelessWidget {
  const view_files({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: (){},
          child: Text('View'),
        ),
      ),
    );
  }
}

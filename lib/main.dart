import 'package:firebasescantextapp/blocs/camera_bloc.dart';
import 'package:firebasescantextapp/blocs/scan_bloc.dart';
import 'package:firebasescantextapp/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScanApp Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:  MultiBlocProvider(
        providers: [
          BlocProvider<CameraBloc>(
            create: (BuildContext context) => CameraBloc(),
          ),
        ],
        child:  HomePage(),
      )
    );
  }
}


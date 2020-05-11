import 'package:camera/camera.dart';
import 'package:firebasescantextapp/scan_bloc.dart';
import 'package:firebasescantextapp/scan_event.dart';
import 'package:firebasescantextapp/scan_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'camera_preview_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  CameraController _cameraController;



  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: BlocListener<ScanBloc, ScanState>(
        listener: (context, state){
          print('home listener state ' + state.toString());
          if(state is CameraInitFailed){
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Set up failed. Please contact the administrator.'),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
          }
          if(state is CameraInitSuccess) {
            _cameraController = state.cameraController;

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        MultiBlocProvider(
                          providers: [
                            BlocProvider<ScanBloc>(
                              create: (BuildContext context) => ScanBloc(),
                            ),
                          ],
                          child: CameraPreviewPage(
                              cameraController: _cameraController),
                        )
                ));
          }
        },
        child: BlocBuilder<ScanBloc, ScanState>(
          builder: (context, state) {
            print('home child state ' + state.toString());

            if(state is CameraInitInProgress){
              return Center(child: CircularProgressIndicator(),);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Center(child: Text('Please scan car plate.')),
                ),
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: FloatingActionButton(
                    onPressed: () => _initCamera(context),
                    tooltip: 'Scan',
                    child: Icon(Icons.camera_alt),
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }

  _initCamera(BuildContext context) {
    BlocProvider.of<ScanBloc>(context).add(CameraInit());
  }
}
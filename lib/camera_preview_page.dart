import 'package:camera/camera.dart';
import 'package:firebasescantextapp/events/scan_event.dart';
import 'package:firebasescantextapp/states/scan_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/scan_bloc.dart';

class CameraPreviewPage extends StatefulWidget {
  final CameraController cameraController;

  const CameraPreviewPage({
    Key key,
    @required this.cameraController,
  }) : super(key: key);

  @override
  _CameraPreviewPageState createState() => _CameraPreviewPageState();
}

class _CameraPreviewPageState extends State<CameraPreviewPage> {

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    widget.cameraController.dispose();
    super.dispose();
  }

  Future<void> _scan(context) async {
    BlocProvider.of<ScanBloc>(context).add(
        Scan(cameraController: widget.cameraController));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview'),
      ),
      body: BlocListener<ScanBloc, ScanState>(
        listener: (context, state) async {
          print('preview listener state ' + state.toString());
          if (state is ScanSuccess) {
            await _showOutput(state.outputLines);
            BlocProvider.of<ScanBloc>(context).add(OnScanComplete());
          }
          if(state is ScanFailed){
            await _showOutput(['Scan failed.']);
            BlocProvider.of<ScanBloc>(context).add(OnScanComplete());
          }
          if(state is ScanInProgress){
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Scanning...'),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
          }
          if(state is DefaultState){
            Navigator.of(context).pop();
          }
        },
        child: BlocBuilder<ScanBloc, ScanState>(
            builder: (context, state) {
              print('preview child state ' + state.toString());
              return GestureDetector(
                onTap: () => _scan(context),
                child: CameraPreview(widget.cameraController),
              );
            }
        ),
      ),
    );
  }

  Future<void> _showOutput(List<String> outputLines) async {
    var message = '';
    var title = '';
    if(outputLines == null || outputLines.length ==0){
      message = 'no output';
      title = 'Opps';
    }
    else{
      var buffer = new StringBuffer();
      for (var line in outputLines) {
        buffer.write('[Block]\n');
        buffer.write(line.trim().replaceAll(' ', ''));
        buffer.write('\n\n');
      }
      message = buffer.toString();
      title = 'Success';
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Scan output'),
                Text(' '),
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

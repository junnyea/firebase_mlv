import 'package:firebasescantextapp/states/scan_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/scan_bloc.dart';
import 'events/scan_event.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: BlocListener<ScanBloc, ScanState>(
        listener: (context, state) async {
          if(state is ScanInProgress){
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: Colors.blue,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Scanning...'),
                      CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ],
                  ),
                ),
              );
          }
          if(state is ScanSuccess) {
            await _showOutput(state.outputLines);
          }
          if(state is ScanFailed) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Scan failed.'),
                      CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ],
                  ),
                ),
              );
          }
        },
        child: BlocBuilder<ScanBloc, ScanState>(
          builder: (context, state) {
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
                    onPressed: () => _scan(context),
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

  void _scan(BuildContext context) {

    BlocProvider.of<ScanBloc>(context).add(Scan());
  }
}
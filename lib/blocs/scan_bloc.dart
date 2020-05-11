import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebasescantextapp/events/scan_event.dart';
import 'package:firebasescantextapp/states/scan_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {

  @override
  ScanState get initialState => DefaultState();

  @override
  Stream<ScanState> mapEventToState(event) async*{

    if(event is Scan){
      try{

        var cameraController = event.cameraController;

        print(8);

        yield ScanInProgress();

        print(9);

        var tempPath = await getTemporaryDirectory();

        print(10);

        final imagePath = join(tempPath.path, '${DateTime.now()}.png');

        print(11);

        // Attempt to take a picture and log where it's been saved.
        await cameraController.takePicture(imagePath);

        print(12);

        File imageFile = File(imagePath);
        //File imageFile = await FilePicker.getFile();

        print(13);

        final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);

        print(14);

        final TextRecognizer _textRecognizer = FirebaseVision.instance.textRecognizer();

        print(15);

        final VisionText visionText = await _textRecognizer.processImage(visionImage);

        print(16);

        List<String> outputLines = [];

        //String text = visionText.text;
        for (TextBlock block in visionText.blocks) {

          final String text = block.text;
          outputLines.add(text);
          //for (TextLine line in block.lines) {

            //outputLines.add(line.text);
            // Same getters as TextBlock
            //for (TextElement element in line.elements) {
              // Same getters as TextBlock
            //}
          //}
        }

        print(17);

        print(outputLines);
        yield ScanSuccess(outputLines: outputLines);

        print(18);

      }
      catch(error){
        yield ScanFailed();
        print(error);
      }
    }

    if(event is OnScanComplete){
      yield DefaultState();
    }
  }

}
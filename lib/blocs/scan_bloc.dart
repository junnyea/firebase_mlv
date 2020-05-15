import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebasescantextapp/events/scan_event.dart';
import 'package:firebasescantextapp/states/scan_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {

  @override
  ScanState get initialState => DefaultState();

  @override
  Stream<ScanState> mapEventToState(event) async*{

    if(event is Scan){
      try{
        yield ScanInProgress();

        final File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

        final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);

        final TextRecognizer _textRecognizer = FirebaseVision.instance.textRecognizer();

        final VisionText visionText = await _textRecognizer.processImage(visionImage);

        List<String> outputLines = [];

        for (TextBlock block in visionText.blocks) {

          final String text = block.text;
          outputLines.add(text);
        }
        yield ScanSuccess(outputLines: outputLines);
      }
      catch(error){
        yield ScanFailed();
        print(error);
      }
    }
  }
}
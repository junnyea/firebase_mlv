
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebasescantextapp/scan_event.dart';
import 'package:firebasescantextapp/scan_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {

  @override
  ScanState get initialState => DefaultState();

  @override
  Stream<ScanState> mapEventToState(event) async*{

    if(event is CameraInit){
      try{

        print(1);

        yield CameraInitInProgress();


        print(2);

        // Obtain a list of the available cameras on the device.
        final cameras = await availableCameras();

        print(3);

        // Get a specific camera from the list of available cameras.
        final backCamera = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back);

        print(4);

        // To display the current output from the Camera,
        // create a CameraController.
        var controller = CameraController(
          // Get a specific camera from the list of available cameras.
          backCamera,
          // Define the resolution to use.
          ResolutionPreset.max,
        );

        print(5);

        // Next, initialize the controller. This returns a Future.
        await controller.initialize();

        print(6);

        await Future.delayed(const Duration(seconds: 1));
        yield CameraInitSuccess(cameraController: controller);
      }
      catch(error){
        yield CameraInitFailed();
        print(error);
      }
    }

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

          for (TextLine line in block.lines) {

            outputLines.add(line.text);
            // Same getters as TextBlock
            //for (TextElement element in line.elements) {
              // Same getters as TextBlock
            //}
          }
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
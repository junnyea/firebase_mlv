import 'package:camera/camera.dart';
import 'package:firebasescantextapp/events/camera_event.dart';
import 'package:firebasescantextapp/states/camera_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {

  @override
  CameraState get initialState => DefaultState();

  @override
  Stream<CameraState> mapEventToState(event) async*{

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
  }
}
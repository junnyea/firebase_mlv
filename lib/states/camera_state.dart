import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class CameraState extends Equatable{

  const CameraState();

  @override
  List<Object> get props => [];
}

class DefaultState extends CameraState{}

class CameraInitInProgress extends CameraState{}

class CameraInitSuccess extends CameraState{
  final CameraController cameraController;
  const CameraInitSuccess({@required this.cameraController});
}

class CameraInitFailed extends CameraState{}
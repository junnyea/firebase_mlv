import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ScanState extends Equatable{

  const ScanState();

  @override
  List<Object> get props => [];
}

class DefaultState extends ScanState{}

class CameraInitInProgress extends ScanState{}

class CameraInitSuccess extends ScanState{
  final CameraController cameraController;
  const CameraInitSuccess({@required this.cameraController});
}

class CameraInitFailed extends ScanState{}

class ScanInProgress extends ScanState{}

class ScanSuccess extends ScanState{
  final List<String> outputLines;
  const ScanSuccess({@required this.outputLines});
}

class ScanFailed extends ScanState{}

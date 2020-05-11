import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ScanEvent extends Equatable{
  const ScanEvent();

  @override
  List<Object> get props => [];
}

class Scan extends ScanEvent {
  final CameraController cameraController;

  const Scan({@required this.cameraController});
}
class OnScanComplete extends ScanEvent{}
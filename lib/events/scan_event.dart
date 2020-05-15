import 'package:equatable/equatable.dart';

abstract class ScanEvent extends Equatable{
  const ScanEvent();

  @override
  List<Object> get props => [];
}

class Scan extends ScanEvent {}
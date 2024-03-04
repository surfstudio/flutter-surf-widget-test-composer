import 'package:equatable/equatable.dart';

abstract class BlocCounterEvent extends Equatable {}

class Increment extends BlocCounterEvent {
  @override
  List<Object?> get props => [];
}

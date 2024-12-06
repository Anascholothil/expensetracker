
 
 
import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class MainFailures with _$MainFailures{

const factory MainFailures.serverFailer({required String errormsg})= ServerFailure;

}


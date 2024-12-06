// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'innjectable_mdolue.dart' as _i1021;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final firabaseInjectableModule = _$FirabaseInjectableModule();
  await gh.factoryAsync<_i1021.FirebaseServices>(
    () => firabaseInjectableModule.firebaseServices,
    preResolve: true,
  );
  gh.lazySingleton<_i974.FirebaseFirestore>(
      () => firabaseInjectableModule.firebaseFirstore);
  return getIt;
}

class _$FirabaseInjectableModule extends _i1021.FirabaseInjectableModule {}

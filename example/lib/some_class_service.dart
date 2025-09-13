import 'dart:math';

import 'package:cached_repository/cached_repository.dart';
import 'package:logger/logger.dart';

import 'some_class_repository.dart';

class SomeClassService {
  SomeClassService({
    required SomeClassApi someClassApi,
    required SomeClassRepository someClassRepository,
  })  : _someClassApi = someClassApi,
        _someClassRepository = someClassRepository;

  final SomeClassApi _someClassApi;
  final SomeClassRepository _someClassRepository;

  final _logger = Logger();

  Future<void> create(String parameter) async {
    _logger.d('SomeClassService => create');

    await _someClassApi.create(Random().nextInt(100).toString());
    _someClassRepository.invalidate(parameter);
  }

  Future<Resource<List<SomeClass>>> getMyObjects(
    String parameter, {
    bool forceReload = false,
  }) =>
      _someClassRepository.getMyObjects(parameter, forceReload: forceReload);

  Stream<Resource<List<SomeClass>>> getMyObjectsStream(
    String parameter, {
    bool forceReload = false,
  }) =>
      _someClassRepository.getMyObjectsStream(parameter,
          forceReload: forceReload);
}

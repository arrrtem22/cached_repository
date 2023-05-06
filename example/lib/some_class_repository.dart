import 'package:cached_repository/cached_repository.dart';
import 'package:logger/logger.dart';

class SomeClassRepository {
  SomeClassRepository(SomeClassApi someClassApi)
      : _cachedRepo = CachedRepository.persistent(
          'my_objects',
          fetch: (String key, [__]) => someClassApi.getObjects(key),
          decode: (json) => SomeClass.listFromJson(json),
          cacheDuration: const Duration(hours: 12),
        );

  final CachedRepository<String, List<SomeClass>> _cachedRepo;

  final _logger = Logger();

  Stream<Resource<List<SomeClass>>> getMyObjectsStream(
    String parameter, {
    bool forceReload = false,
  }) {
    _logger.d('SomeClassRepository => getMyObjectsStream');
    return _cachedRepo.stream(parameter, forceReload: forceReload);
  }

  Future<Resource<List<SomeClass>>> getMyObjects(
    String parameter, {
    bool forceReload = false,
  }) {
    _logger.d('SomeClassRepository => getMyObjects');
    return _cachedRepo.first(parameter, forceReload: forceReload);
  }

  Future<void> invalidate(String parameter) {
    _logger.d('SomeClassRepository => invalidate');
    return _cachedRepo.invalidate(parameter);
  }

  Future<void> removeObjectFromCache(
    String parameter, {
    /*required*/ String objectId,
  }) async {
    _logger.d('SomeClassRepository => removeObjectFromCache');
    return _cachedRepo.updateValue(parameter, (list) {
      return list.where((it) => it.id != objectId).toList(growable: false);
    });
  }

  Future<void> removeObjectsFromCache(
    String parameter, {
    /*required*/ List<String> objectIds,
  }) async {
    _logger.d('SomeClassRepository => removeObjectsFromCache');
    return _cachedRepo.updateValue(parameter, (list) {
      return list
          ?.where((it) => !objectIds.contains(it.id))
          ?.toList(growable: false);
    });
  }

  Future<void> clear(String parameter) {
    _logger.d('SomeClassRepository => clear');
    return _cachedRepo.clear(parameter);
  }
}

class SomeClass {
  final String id;

  SomeClass(this.id);

  factory SomeClass.fromJson(Map<String, dynamic> json) {
    return SomeClass(
      json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }

  static List<SomeClass> listFromJson(List<dynamic>/*?*/ jsonList) =>
      (jsonList ?? [])
          .map((json) => SomeClass.fromJson(json))
          .toList(growable: false);
}

abstract class SomeClassApi {
  factory SomeClassApi() => _SomeClassFakeApi();

  Future<List<SomeClass>> getObjects(String parameter);

  Future<void> create(String id);
}

class _SomeClassFakeApi implements SomeClassApi {
  final _logger = Logger();

  List<SomeClass> myObjects = [
    SomeClass('1'),
    SomeClass('2'),
    SomeClass('3'),
  ];

  @override
  Future<List<SomeClass>> getObjects(String parameter) async {
    _logger.d('SomeClassFakeApi => getObjects');

    await Future.delayed(const Duration(seconds: 1));
    return myObjects;
  }

  @override
  Future<void> create(String id) async {
    _logger.d('SomeClassFakeApi => create');

    await Future.delayed(const Duration(seconds: 1));
    myObjects = myObjects
      ..add(SomeClass(id))
      ..toList();
  }
}

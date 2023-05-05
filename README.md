# Cached Repository

[![pub package](https://img.shields.io/pub/v/cached_repository.svg?logo=dart&logoColor=00b9fc)](https://pub.dartlang.org/packages/cached_repository)
[![Last Commits](https://img.shields.io/github/last-commit/arrrtem22/cached_repository?logo=git&logoColor=white)](https://github.com/arrrtem22/cached_repository/commits/master)
[![Pull Requests](https://img.shields.io/github/issues-pr/arrrtem22/cached_repository?logo=github&logoColor=white)](https://github.com/arrrtem22/cached_repository/pulls)
[![Code size](https://img.shields.io/github/languages/code-size/arrrtem22/cached_repository?logo=github&logoColor=white)](https://github.com/arrrtem22/cached_repository)
[![License](https://img.shields.io/github/license/arrrtem22/cached_repository?logo=open-source-initiative&logoColor=green)](https://github.com/arrrtem22/cached_repository/blob/master/LICENSE)

Simple, easy to use and extensible cached repository which can store all you need.<br>
Inspired by [NetworkBoundResource](https://github.com/topics/networkboundresource) for Android.

**Show some ❤️ and star the repo to support the project**

### Resources:
- [Pub Package](https://pub.dev/packages/cached_repository)
- [GitHub Repository](https://github.com/arrrtem22/cached_repository)

## Getting Started

Just create a class with `CachedRepository` field and start caching:
```dart
class StringRepository {
  StringRepository(SomeClassApi _someClassApi)
      : _cachedRepo = CachedRepository.persistent(
    'my_objects',
    fetch: (String key, [__]) => _someClassApi.getObjects(),
    decode: (json) => SomeClass.listFromJson(json),
    cacheDuration: const Duration(hours: 12),
  );

  final CachedRepository<String, List<SomeClass>> _cachedRepo;

  static const _key = '';

  Stream<Resource<List<SomeClass>>> officeString({
    bool forceReload = false,
  }) =>
      _cachedRepo.stream(_key, forceReload: forceReload);

  Future<void> invalidate() => _cachedRepo.invalidate(_key);

  Future<void> removeStringFromCache({
    required String stringId,
  }) async {
    return _cachedRepo.updateValue(_key, (list) {
      return list?.where((it) => it.id != stringId).toList(growable: false);
    });
  }

  Future<void> removeCompaniesFromCache({
    required List<String> stringIds,
  }) async {
    return _cachedRepo.updateValue(_key, (list) {
      return list
          ?.where((it) => !stringIds.contains(it.id))
          .toList(growable: false);
    });
  }

  Future<void> clear() => _cachedRepo.clear();
}

abstract class SomeClass {
  String get id;

  static List<SomeClass> listFromJson(List<dynamic> jsonList) => <SomeClass>[];
}

abstract class SomeClassApi {
  Future<List<SomeClass>> getObjects();
}
```

Instead of a SomeClass and SomeClassApi, you can use your own classes.

Feel free to open pull requests.

# Acknowledgments

This package was created by [Artemii Oliinyk](https://github.com/arrrtem22).
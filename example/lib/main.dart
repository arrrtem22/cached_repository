import 'package:example/some_class_repository.dart';
import 'package:example/some_class_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _someParameter = 'key';

  final _logger = Logger();

  /*late final*/
  SomeClassService _service;

  @override
  void initState() {
    final api = SomeClassApi();
    final repository = SomeClassRepository(api);
    _service = SomeClassService(
      someClassApi: api,
      someClassRepository: repository,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('title'),
      ),
      body: Center(
        child: StreamBuilder(
          stream:
              _service.getMyObjectsStream(_someParameter, forceReload: true),
          builder: (context, res) {
            if (res.data?.hasData ?? false) {
              _logger.d(
                  'Value (stream): ${(res.data.data as List<SomeClass>).map((e) => e.toJson()).toList()}');
              return Text(
                  'data: ${res.data.data.map((e) => e.toJson()).toList()}');
            } else if (res.data?.isError ?? false) {
              _logger.d('Error (stream): ${res.data.error}');
            }
            _logger.d('Loading (stream)');
            return const Text('loading');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _service.create(_someParameter),
        tooltip: 'Create',
        child: const Icon(Icons.add),
      ),
    );
  }
}

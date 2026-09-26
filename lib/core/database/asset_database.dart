import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Copie `assets/db/<name>.sqlite` dans le stockage de l'app si elle n'y est
/// pas encore ou si une nouvelle version est livrée (voir le manifeste
/// `<name>_manifest.json` écrit par tool/content_pipeline).
Future<File> installAssetDatabase(String name, SharedPreferences prefs) async {
  final manifest = jsonDecode(
    await rootBundle.loadString('assets/db/${name}_manifest.json'),
  ) as Map<String, dynamic>;
  final version = manifest['content_version'] as int;
  final versionKey = '$name.installed_version';

  final dir = await getApplicationSupportDirectory();
  final file = File(p.join(dir.path, '$name.sqlite'));
  if (!file.existsSync() || prefs.getInt(versionKey) != version) {
    final data = await rootBundle.load('assets/db/$name.sqlite');
    final tmp = File('${file.path}.tmp');
    await tmp.writeAsBytes(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      flush: true,
    );
    await tmp.rename(file.path);
    await prefs.setInt(versionKey, version);
  }
  return file;
}

/// Ouvre une base en lecture seule, dans un isolate d'arrière-plan.
QueryExecutor openReadOnly(File file) =>
    NativeDatabase.createInBackground(file, setup: (db) => db.execute('PRAGMA query_only = ON'));

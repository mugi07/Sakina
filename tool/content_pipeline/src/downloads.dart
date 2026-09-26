import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart' show InputFileStream, ZipDirectory;
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

/// Télécharge les sources brutes une seule fois dans un dossier de cache,
/// puis vérifie leurs sommes SHA-256 contre `sources.lock.json`.
class SourceCache {
  SourceCache({required this.cacheDir, required this.lockFile});

  final Directory cacheDir;
  final File lockFile;
  final Map<String, String> _hashes = {};

  Future<File> fetch(String url, String fileName) async {
    cacheDir.createSync(recursive: true);
    final file = File(p.join(cacheDir.path, fileName));
    if (!file.existsSync() || file.lengthSync() == 0) {
      stdout.writeln('  ↓ $fileName');
      final client = http.Client();
      try {
        final request = http.Request('GET', Uri.parse(url))
          ..headers['User-Agent'] =
              'Mozilla/5.0 (compatible; SakinaContentPipeline/1.0; +https://github.com/mugi07/Sakina)';
        final response = await client.send(request);
        if (response.statusCode != 200) {
          throw HttpException('HTTP ${response.statusCode} pour $url');
        }
        final part = File('${file.path}.part');
        await response.stream.pipe(part.openWrite());
        await part.rename(file.path);
      } finally {
        client.close();
      }
    }
    _hashes[fileName] = (await sha256.bind(file.openRead()).first).toString();
    return file;
  }

  /// Compare les sommes calculées au fichier de verrouillage.
  ///
  /// Une source absente du verrou y est ajoutée. Une source modifiée est une
  /// erreur, sauf avec [update] (après avoir vérifié le changement à la main).
  void verifyLock({required bool update}) {
    final locked = lockFile.existsSync()
        ? Map<String, String>.from(jsonDecode(lockFile.readAsStringSync()) as Map<String, dynamic>)
        : <String, String>{};
    final changed = <String>[];
    for (final MapEntry(key: name, value: hash) in _hashes.entries) {
      final previous = locked[name];
      if (previous == null) {
        stdout.writeln('  + nouvelle source verrouillée : $name');
      } else if (previous != hash) {
        changed.add(name);
      }
    }
    if (changed.isNotEmpty && !update) {
      throw StateError(
        'Sources modifiées depuis le dernier verrouillage : ${changed.join(', ')}.\n'
        'Vérifiez les changements, puis relancez avec --update-lock.',
      );
    }
    final merged = {...locked, ..._hashes};
    final sorted = {for (final k in merged.keys.toList()..sort()) k: merged[k]!};
    lockFile.writeAsStringSync('${const JsonEncoder.withIndent('  ').convert(sorted)}\n');
  }
}

/// Lit une entrée d'une archive zip ligne par ligne, en flux, sans extraire
/// le fichier sur le disque (alternateNamesV2.txt fait plus de 700 Mo).
Stream<String> zipEntryLines(File zip, String entryName) async* {
  final directory = ZipDirectory();
  final input = InputFileStream(zip.path);
  try {
    directory.read(input);
  } finally {
    await input.close();
  }
  final header = directory.fileHeaders.firstWhere(
    (h) => h.filename == entryName,
    orElse: () => throw StateError('$entryName absent de ${zip.path}'),
  );
  if (header.compressionMethod != 8) {
    throw StateError('Compression non gérée (${header.compressionMethod})');
  }

  // En-tête local : 30 octets + nom + champ « extra », puis les données.
  final raf = zip.openSync();
  final int dataStart;
  try {
    raf.setPositionSync(header.localHeaderOffset);
    final local = raf.readSync(30);
    final nameLength = local[26] | (local[27] << 8);
    final extraLength = local[28] | (local[29] << 8);
    dataStart = header.localHeaderOffset + 30 + nameLength + extraLength;
  } finally {
    raf.closeSync();
  }

  yield* zip
      .openRead(dataStart, dataStart + header.compressedSize)
      .transform(ZLibDecoder(raw: true))
      .transform(utf8.decoder)
      .transform(const LineSplitter());
}

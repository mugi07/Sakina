import 'package:share_plus/share_plus.dart';

/// Ouvre la feuille de partage du système avec un texte (verset, hadith…).
Future<void> shareText(String text) => SharePlus.instance.share(ShareParams(text: text));

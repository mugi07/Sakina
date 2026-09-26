import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/content_database.dart';
import '../../../core/providers.dart';
import '../../../core/settings/app_settings.dart';
import '../../../l10n/app_localizations.dart';
import '../application/quran_providers.dart';
import '../domain/page_layout.dart';
import 'widgets/ayah_sheet.dart';
import 'widgets/mushaf_page.dart';
import 'widgets/translation_page.dart';

/// Lecteur du Coran page par page (604 pages du mushaf de Médine).
///
/// Chaque langue a ses propres pages : l'arabe se tourne de droite à gauche
/// comme un mushaf, les traductions de gauche à droite. Changer de langue
/// garde la même page.
class MushafScreen extends ConsumerStatefulWidget {
  const MushafScreen({required this.initialPage, super.key});

  final int initialPage;

  @override
  ConsumerState<MushafScreen> createState() => _MushafScreenState();
}

class _MushafScreenState extends ConsumerState<MushafScreen> {
  late int _page = widget.initialPage.clamp(1, mushafPageCount);
  late QuranLanguage _language = ref.read(settingsProvider).quranLanguage;
  late PageController _controller = PageController(initialPage: _page - 1);
  int? _selectedAyahId;

  @override
  void initState() {
    super.initState();
    _saveLastPage();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveLastPage() => Future.microtask(
    () => ref.read(settingsProvider.notifier).update((s) => s.copyWith(lastReadPage: _page)),
  );

  void _setLanguage(QuranLanguage language) {
    if (language == _language) return;
    final old = _controller;
    setState(() {
      _language = language;
      _controller = PageController(initialPage: _page - 1);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => old.dispose());
    ref.read(settingsProvider.notifier).update((s) => s.copyWith(quranLanguage: language));
  }

  Future<void> _onAyahTap(AyahsOfPageResult row) async {
    setState(() => _selectedAyahId = row.a.id);
    await showAyahSheet(context, row.a);
    if (mounted) setState(() => _selectedAyahId = null);
  }

  Future<void> _goToPage() async {
    final l = AppLocalizations.of(context);
    final input = TextEditingController(text: '$_page');
    final page = await showDialog<int>(
      context: context,
      builder: (context) {
        void submit() {
          final n = int.tryParse(input.text.trim());
          if (n != null && n >= 1 && n <= mushafPageCount) Navigator.of(context).pop(n);
        }

        return AlertDialog(
          title: Text(l.goToPage),
          content: TextField(
            controller: input,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(helperText: '1 – $mushafPageCount'),
            onSubmitted: (_) => submit(),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l.cancel)),
            FilledButton(onPressed: submit, child: Text(l.go)),
          ],
        );
      },
    );
    input.dispose();
    if (page != null && _controller.hasClients) _controller.jumpToPage(page - 1);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isArabicUi = Localizations.localeOf(context).languageCode == 'ar';
    final rows = ref.watch(pageAyahsProvider((page: _page, edition: null))).value;
    final surah = rows == null ? null : ref.watch(surahByIdProvider).value?[rows.first.a.surah];
    final edition = _language.edition;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              surah == null ? '' : (isArabicUi ? 'سورة ${surah.nameAr}' : surah.nameTranslit),
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            Text(l.pageLabel(_page), style: const TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: l.goToPage,
            icon: const Icon(Icons.pin_outlined),
            onPressed: _goToPage,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: SegmentedButton<QuranLanguage>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: QuranLanguage.arabic, label: Text('العربية')),
                ButtonSegment(value: QuranLanguage.french, label: Text('Français')),
                ButtonSegment(value: QuranLanguage.english, label: Text('English')),
              ],
              selected: {_language},
              onSelectionChanged: (s) => _setLanguage(s.first),
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Directionality(
          // L'arabe se feuillette vers la gauche (page suivante à gauche).
          textDirection: edition == null ? TextDirection.rtl : TextDirection.ltr,
          child: PageView.builder(
            key: ValueKey(_language),
            controller: _controller,
            itemCount: mushafPageCount,
            onPageChanged: (i) {
              setState(() => _page = i + 1);
              _saveLastPage();
            },
            itemBuilder: (context, i) => edition == null
                ? MushafPage(page: i + 1, selectedAyahId: _selectedAyahId, onAyahTap: _onAyahTap)
                : TranslationPage(
                    page: i + 1,
                    edition: edition,
                    selectedAyahId: _selectedAyahId,
                    onAyahTap: _onAyahTap,
                  ),
          ),
        ),
      ),
    );
  }
}

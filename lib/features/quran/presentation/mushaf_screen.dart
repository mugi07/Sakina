import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../../../core/database/content_database.dart';
import '../../../core/providers.dart';
import '../../../core/settings/app_settings.dart';
import '../../../l10n/app_localizations.dart';
import '../../khatma/application/khatma_controller.dart';
import '../application/quran_providers.dart';
import '../application/recitation.dart';
import '../domain/page_layout.dart';
import 'widgets/ayah_sheet.dart';
import 'widgets/mushaf_page.dart';
import 'widgets/recitation_bar.dart';
import 'widgets/translation_page.dart';

/// Lecteur du Coran (604 pages du mushaf de Médine) en défilement vertical
/// continu, du début à la fin.
///
/// Chaque langue a ses propres pages (arabe, français, anglais) ; changer de
/// langue garde la même page. La récitation fait défiler jusqu'au verset lu.
class MushafScreen extends ConsumerStatefulWidget {
  const MushafScreen({required this.initialPage, super.key});

  final int initialPage;

  @override
  ConsumerState<MushafScreen> createState() => _MushafScreenState();
}

class _MushafScreenState extends ConsumerState<MushafScreen> {
  late int _page = widget.initialPage.clamp(1, mushafPageCount);
  late QuranLanguage _language = ref.read(settingsProvider).quranLanguage;
  ScrollController _scroll = ScrollController();
  ListController _list = ListController();
  double _viewportHeight = 0;

  /// Page à atteindre dès que la liste est construite (ouverture, langue).
  int? _pendingJump;
  int? _selectedAyahId;

  @override
  void initState() {
    super.initState();
    _pendingJump = _page;
    _scroll.addListener(_onScroll);
    _saveLastPage();
  }

  @override
  void dispose() {
    _scroll.dispose();
    _list.dispose();
    super.dispose();
  }

  void _saveLastPage() => Future.microtask(
    () => ref.read(settingsProvider.notifier).update((s) => s.copyWith(lastReadPage: _page)),
  );

  bool _pageUpdateScheduled = false;

  /// Le défilement est signalé avant la mise en page : la plage visible
  /// n'est à jour qu'après l'image suivante.
  void _onScroll() {
    if (_pageUpdateScheduled) return;
    _pageUpdateScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageUpdateScheduled = false;
      if (mounted) _updateCurrentPage();
    });
  }

  /// Page courante : la première visible, sauf si elle n'occupe plus que le
  /// haut de l'écran (la suivante prend alors le relais).
  void _updateCurrentPage() {
    if (!_list.isAttached || !_scroll.hasClients) return;
    final range = _list.visibleRange;
    if (range == null) return;
    var index = range.$1;
    if (index + 1 < mushafPageCount && range.$2 > index) {
      if (_itemStart(index + 1) - _scroll.offset < _viewportHeight * 0.4) index++;
    }
    final page = index + 1;
    if (page != _page) {
      setState(() => _page = page);
      _saveLastPage();
    }
  }

  /// Position du début d'une page dans la liste (somme des hauteurs des
  /// pages précédentes, mesurées ou estimées).
  double _itemStart(int index) {
    var offset = 0.0;
    for (var i = 0; i < index; i++) {
      offset += _list.extentForIndex(i).$1;
    }
    return offset;
  }

  void _jumpTo(int page) {
    if (!_list.isAttached || !_scroll.hasClients) {
      _pendingJump = page;
      return;
    }
    _list.jumpToItem(index: page - 1, scrollController: _scroll, alignment: 0);
    // Les hauteurs estimées sont corrigées à la mise en page : on recale
    // une fois la page cible mesurée, puis on met le titre à jour.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_list.isAttached || !_scroll.hasClients) return;
      _list.jumpToItem(index: page - 1, scrollController: _scroll, alignment: 0);
      _onScroll();
    });
  }

  void _setLanguage(QuranLanguage language) {
    if (language == _language) return;
    final oldScroll = _scroll;
    final oldList = _list;
    setState(() {
      _language = language;
      _scroll = ScrollController()..addListener(_onScroll);
      _list = ListController();
      _pendingJump = _page;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      oldScroll.dispose();
      oldList.dispose();
    });
    ref.read(settingsProvider.notifier).update((s) => s.copyWith(quranLanguage: language));
  }

  /// Khatma : la page affichée (et celles d'avant) est lue.
  void _markKhatmaRead() {
    final l = AppLocalizations.of(context);
    final finished = ref.read(khatmaProvider.notifier).markReadUpTo(_page);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(finished ? l.khatmaCompleted : l.khatmaMarkedRead(_page))),
    );
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
    if (page != null) _jumpTo(page);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isArabicUi = Localizations.localeOf(context).languageCode == 'ar';
    final rows = ref.watch(pageAyahsProvider((page: _page, edition: null))).value;
    final surah = rows == null ? null : ref.watch(surahByIdProvider).value?[rows.first.a.surah];
    final edition = _language.edition;
    final recitation = ref.watch(recitationProvider);
    final khatma = ref.watch(khatmaProvider);

    // La récitation fait défiler jusqu'à la page du verset lu.
    ref.listen(recitationProvider.select((s) => s.page), (_, page) {
      if (page == null || !_list.isAttached || !_scroll.hasClients) return;
      final range = _list.visibleRange;
      final visible = range != null && page - 1 >= range.$1 && page - 1 <= range.$2;
      if (!visible || page != _page) {
        _list.animateToItem(
          index: page - 1,
          scrollController: _scroll,
          alignment: 0,
          duration: (_) => const Duration(milliseconds: 450),
          curve: (_) => Curves.easeInOut,
        );
      }
    });

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
          if (!recitation.active && rows != null)
            IconButton(
              tooltip: l.listen,
              icon: const Icon(Icons.headphones_outlined),
              onPressed: () => playFromAyah(
                ref,
                context,
                surah: rows.first.a.surah,
                number: rows.first.a.number,
              ),
            ),
          if (khatma != null && !khatma.isCompleted)
            IconButton(
              tooltip: l.khatmaMarkRead,
              icon: Icon(
                _page <= khatma.lastPageRead ? Icons.task_alt : Icons.check_circle_outline,
              ),
              onPressed: _markKhatmaRead,
            ),
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            _viewportHeight = constraints.maxHeight;
            final reference = ref
                .watch(pageAyahsProvider((page: referenceMushafPage, edition: null)))
                .value;
            if (reference == null) return const Center(child: CircularProgressIndicator());
            final fontSize =
                uniformMushafFontSize(reference, constraints.biggest) *
                ref.watch(settingsProvider.select((s) => s.arabicFontScale));

            if (_pendingJump != null) {
              final target = _pendingJump!;
              _pendingJump = null;
              WidgetsBinding.instance.addPostFrameCallback((_) => _jumpTo(target));
            }

            return SuperListView.builder(
              key: ValueKey(_language),
              controller: _scroll,
              listController: _list,
              itemCount: mushafPageCount,
              // Estimation avant mesure : une page arabe ≈ un écran, une page
              // traduite est plus longue.
              extentEstimation: (_, _) => constraints.maxHeight * (edition == null ? 1.0 : 2.2),
              itemBuilder: (context, i) => edition == null
                  ? MushafPageBlock(
                      page: i + 1,
                      fontSize: fontSize,
                      selectedAyahId: _selectedAyahId,
                      playingAyahId: recitation.ayahId,
                      onAyahTap: _onAyahTap,
                    )
                  : TranslationPageBlock(
                      page: i + 1,
                      edition: edition,
                      selectedAyahId: _selectedAyahId,
                      playingAyahId: recitation.ayahId,
                      onAyahTap: _onAyahTap,
                    ),
            );
          },
        ),
      ),
      bottomNavigationBar: recitation.active ? const RecitationBar() : null,
    );
  }
}

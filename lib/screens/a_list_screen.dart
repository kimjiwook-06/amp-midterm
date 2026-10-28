// A-1 TextField 특징 검색 P02/P06; A-2 ActionChip 검색 예시 P06
// A-3 FilledButton 사진 기록 P07; A-4 InkWell 물건 카드 P06
// A-5 FutureBuilder 기록 상태 P01/P09; A-6 NavigationBar 주요 탐색 P04
import 'package:flutter/material.dart';
import '../api.dart';
import '../models.dart';
import '../widgets.dart';
import 'b_detail_screen.dart';
import 'capture_screen.dart';

class FindHome extends StatefulWidget {
  const FindHome({super.key, this.loader = fetchItems});
  final ItemsLoader loader;
  @override
  State<FindHome> createState() => _FindHomeState();
}

class _FindHomeState extends State<FindHome> {
  late Future<List<Item>> future;
  final query = TextEditingController();
  int nav = 0;
  String scenario = 'all', state = 'normal';
  @override
  void initState() {
    super.initState();
    future = widget.loader();
  }

  @override
  void dispose() {
    query.dispose();
    super.dispose();
  }

  void reload() {
    setState(() {
      state = 'normal';
      future = widget.loader();
    });
  }

  void capture() => Navigator.push(
    context,
    MaterialPageRoute<void>(builder: (_) => const CaptureScreen()),
  );
  // STATE: 향후 검색 의도/기록 목록 → 후보 카드. 현재 고정 시나리오만 전환.
  void search([String? value]) {
    if (value != null) query.text = value;
    setState(() {
      nav = 0;
      scenario = query.text.trim().isEmpty
          ? 'all'
          : query.text.contains('음악') || query.text.contains('이어폰')
          ? 'music'
          : query.text.contains('검은')
          ? 'dark'
          : query.text.contains('충전') || query.text.contains('케이블')
          ? 'cable'
          : query.text.contains('열쇠')
          ? 'keys'
          : 'empty';
    });
  }

  void voice() => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: const EdgeInsets.fromLTRB(28, 12, 28, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.graphic_eq, size: 48, color: green),
          const SizedBox(height: 16),
          heading('이렇게 말해 보세요'),
          const SizedBox(height: 12),
          const Text('“검은색이고 음악을 들을 때 쓰는 물건”', textAlign: TextAlign.center),
          const SizedBox(height: 12),
          const Text(
            '음성 입력 미리보기 · 마이크는 사용하지 않아요',
            style: TextStyle(color: muted, fontSize: 12),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              search('검은색이고 음악을 들을 때 쓰는 물건');
            },
            child: const Text('이 문장으로 찾아보기'),
          ),
        ],
      ),
    ),
  );
  void demo() => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heading('데모 장면 선택'),
          const Text('발표용 UI 상태 · 실제 기록은 바뀌지 않아요'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['normal', 'loading', 'error', 'empty']
                .map(
                  (s) => OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() => state = s);
                    },
                    child: Text(
                      {
                        'normal': '정상',
                        'loading': '로딩',
                        'error': '오류',
                        'empty': '빈 기록',
                      }[s]!,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    ),
  );
  @override
  Widget build(BuildContext context) => Scaffold(
    bottomNavigationBar: MediaQuery.sizeOf(context).width < 800
        ? NavigationBar(
            selectedIndex: nav,
            onDestinationSelected: (i) {
              if (i == 2) {
                capture();
              } else {
                setState(() {
                  nav = i;
                  scenario = 'all';
                  query.clear();
                });
              }
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.search_rounded),
                label: '물건 찾기',
              ),
              NavigationDestination(
                icon: Icon(Icons.inventory_2_outlined),
                label: '내 기록',
              ),
              NavigationDestination(
                icon: Icon(Icons.add_a_photo_outlined),
                label: '사진 기록',
              ),
            ],
          )
        : null,
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, box) {
          final wide = box.maxWidth >= 800;
          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: wide ? 40 : 20,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: green,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.location_searching_rounded,
                              color: Color(0xFFE4F0D1),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          heading('어디 뒀지?', size: 23),
                          const Spacer(),
                          if (wide) ...[
                            TextButton(
                              onPressed: () => setState(() => nav = 0),
                              child: const Text('물건 찾기'),
                            ),
                            TextButton(
                              onPressed: () => setState(() => nav = 1),
                              child: const Text('내 기록'),
                            ),
                            const SizedBox(width: 16),
                          ],
                          IconButton(
                            tooltip: '데모 장면 선택',
                            onPressed: demo,
                            icon: const Icon(Icons.tune_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      if (nav == 0) ...[
                        if (wide)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(flex: 11, child: searchPanel(wide)),
                              const SizedBox(width: 40),
                              Expanded(flex: 10, child: photoPanel()),
                            ],
                          )
                        else ...[
                          searchPanel(wide),
                          const SizedBox(height: 24),
                          photoPanel(),
                        ],
                        const SizedBox(height: 32),
                      ] else ...[
                        eyebrow('MY LITTLE ARCHIVE'),
                        const SizedBox(height: 10),
                        heading('물건마다, 기억할 자리'),
                        const SizedBox(height: 10),
                        const Text(
                          '사진으로 남겨 둔 내 방의 작은 기록들',
                          style: TextStyle(color: muted),
                        ),
                        const SizedBox(height: 24),
                      ],
                      Row(
                        children: [
                          Expanded(
                            child: heading(
                              scenario == 'all' ? '최근 기록한 물건' : '이 물건을 찾고 있나요?',
                              size: 21,
                            ),
                          ),
                          if (scenario != 'all')
                            TextButton(
                              onPressed: () => search(''),
                              child: const Text('전체 보기'),
                            )
                          else
                            pill('서랍 1곳'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        scenario == 'all'
                            ? '마지막으로 확인한 위치를 함께 기억해요.'
                            : '특징과 용도를 바탕으로 고른 예시 결과예요.',
                        style: const TextStyle(color: muted, fontSize: 13),
                      ),
                      const SizedBox(height: 18),
                      // A-5 P01 P09: GET errors never silently become fake success.
                      if (state == 'loading')
                        const LoadingView()
                      else if (state == 'error')
                        ErrorView(onRetry: reload)
                      else if (state == 'empty')
                        EmptyView(onAdd: capture)
                      else
                        FutureBuilder<List<Item>>(
                          future: future,
                          builder: (context, s) {
                            if (s.connectionState != ConnectionState.done) {
                              return const LoadingView();
                            }
                            if (s.hasError) return ErrorView(onRetry: reload);
                            final items = s.data ?? [];
                            if (items.isEmpty) return EmptyView(onAdd: capture);
                            final shown = items
                                .where(
                                  (i) =>
                                      scenario == 'all' ||
                                      (scenario == 'music' && i.id == 1) ||
                                      (scenario == 'dark' &&
                                          (i.id == 1 || i.id == 4)) ||
                                      (scenario == 'cable' && i.id == 2) ||
                                      (scenario == 'keys' && i.id == 3),
                                )
                                .toList();
                            if (shown.isEmpty) {
                              return EmptyView(
                                search: true,
                                onAdd: () => search(''),
                              );
                            }
                            return LayoutBuilder(
                              builder: (context, c) => Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: shown
                                    .map(
                                      (i) => SizedBox(
                                        width: c.maxWidth >= 900
                                            ? (c.maxWidth - 48) / 4
                                            : c.maxWidth >= 560
                                            ? (c.maxWidth - 16) / 2
                                            : c.maxWidth,
                                        child: itemCard(i),
                                      ),
                                    )
                                    .toList(),
                              ),
                            );
                          },
                        ),
                      const SizedBox(height: 28),
                      const Divider(color: line),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: [
                          const Text(
                            '어디 뒀지? · 나의 작은 기억 보관소',
                            style: TextStyle(color: muted, fontSize: 11),
                          ),
                          TextButton(
                            onPressed: () => showDialog<void>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('프로토타입 안내'),
                                content: const Text(
                                  '수업용 UI 데모입니다. 사진·AI·음성·저장은 예시입니다.\n검색 예시: 음악 / 검은색 / 충전 / 열쇠.\n그 외 문장은 빈 결과를 보여 줍니다.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('확인'),
                                  ),
                                ],
                              ),
                            ),
                            child: const Text(
                              'UI 데모 · 이용 안내',
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
  Widget searchPanel(bool wide) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      eyebrow('A PLACE FOR EVERYTHING'),
      const SizedBox(height: 14),
      heading('분명 여기 뒀는데,\n어디였더라?', size: wide ? 43 : 32),
      const SizedBox(height: 16),
      const Text(
        '이름이 생각나지 않아도 괜찮아요.\n색깔이나 쓰임새로 물건을 찾아보세요.',
        style: TextStyle(color: muted, fontSize: 15, height: 1.8),
      ),
      const SizedBox(height: 24),
      TextField(
        controller: query,
        onSubmitted: (_) => search(),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: '어떤 물건을 찾고 있나요?',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: IconButton(
            tooltip: '말로 찾기 미리보기',
            onPressed: voice,
            icon: const Icon(Icons.mic_none_rounded),
          ),
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: search,
          icon: const Icon(Icons.search),
          label: const Text('물건 찾아보기'),
        ),
      ),
      const SizedBox(height: 14),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: ['음악 들을 때 쓰는 것', '검은색 물건', '충전하는 것']
            .map(
              (s) => ActionChip(
                label: Text(s, style: const TextStyle(fontSize: 12)),
                onPressed: () => search(s),
                backgroundColor: Colors.white,
                side: const BorderSide(color: line),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            )
            .toList(),
      ),
    ],
  );
  Widget photoPanel() => Surface(
    padding: const EdgeInsets.all(14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ScenePhoto(),
        Padding(
          padding: const EdgeInsets.fromLTRB(6, 18, 6, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  pill('PHOTO MEMORY'),
                  const Spacer(),
                  const Text(
                    '예시 사진',
                    style: TextStyle(fontSize: 11, color: muted),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              heading('오늘의 정리, 한 장이면 충분해요.', size: 18),
              const SizedBox(height: 6),
              const Text(
                '사진 속 물건을 정리하고, 확인한 뒤 기록해요.',
                style: TextStyle(fontSize: 12, color: muted),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: capture,
                  icon: const Icon(Icons.add_a_photo_outlined, size: 18),
                  label: const Text('사진으로 새 기록'),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
  Widget itemCard(Item i) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (_) => ItemDetail(item: i)),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: line),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F2EA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(itemIcon(i.icon), size: 30, color: green),
                ),
                const Spacer(),
                const Icon(Icons.north_east_rounded, size: 18, color: muted),
              ],
            ),
            const SizedBox(height: 18),
            heading(i.name, size: 17),
            const SizedBox(height: 6),
            Text(
              '${i.color} · ${i.use}',
              style: const TextStyle(color: muted, fontSize: 12),
            ),
            const SizedBox(height: 16),
            const Divider(color: line),
            const SizedBox(height: 8),
            Text(
              i.location,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            const Text(
              '10월 28일 09:41 기록',
              style: TextStyle(fontSize: 10, color: muted),
            ),
          ],
        ),
      ),
    ),
  );
}

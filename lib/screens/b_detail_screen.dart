// B-1 Text 물건 이름 P02; B-2 ScenePhoto 사진 위치 P06
// B-3 TabBar 위치/물품 정보 P04; B-4 Text 마지막 기록 P01; B-5 FilledButton 찾았어요 P03
import 'package:flutter/material.dart';
import '../models.dart';
import '../widgets.dart';
import 'c_result_sheet.dart';

class ItemDetail extends StatelessWidget {
  const ItemDetail({super.key, required this.item});
  final Item item;
  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(title: const Text('물건의 자리'), centerTitle: true),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1060),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  eyebrow('FOUND IN YOUR MEMORY'),
                  const SizedBox(height: 12),
                  heading('여기 두었어요.', size: 34),
                  const SizedBox(height: 8),
                  Text(
                    '${item.name} · 마지막으로 기록한 위치예요.',
                    style: const TextStyle(color: muted),
                  ),
                  const SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, c) {
                      final info = Surface(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  itemIcon(item.icon),
                                  color: green,
                                  size: 28,
                                ),
                                const SizedBox(width: 12),
                                Expanded(child: heading(item.name)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const TabBar(
                              tabs: [
                                Tab(text: '위치'),
                                Tab(text: '물품 정보'),
                              ],
                            ),
                            SizedBox(
                              height: 230,
                              child: TabBarView(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 22),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        pill('내 방 → 책상 → 첫 번째 서랍'),
                                        const SizedBox(height: 18),
                                        heading(item.location, size: 20),
                                        const SizedBox(height: 12),
                                        const Text(
                                          '마지막 기록  2026.10.28 09:41',
                                          style: TextStyle(
                                            color: muted,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          '물건을 옮겼다면 지금 위치와 다를 수 있어요.',
                                          style: TextStyle(
                                            color: muted,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 22),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('이름   ${item.name}'),
                                        const SizedBox(height: 14),
                                        Text('색깔   ${item.color}'),
                                        const SizedBox(height: 14),
                                        Text('용도   ${item.use}'),
                                        const SizedBox(height: 18),
                                        pill('사진에서 확인한 예시 정보'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed: () => showFoundSheet(context, item),
                                icon: const Icon(Icons.check_circle_outline),
                                label: const Text('찾았어요!'),
                              ),
                            ),
                          ],
                        ),
                      );
                      if (c.maxWidth >= 760) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 6, child: ScenePhoto(item: item)),
                            const SizedBox(width: 28),
                            Expanded(flex: 5, child: info),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          ScenePhoto(item: item),
                          const SizedBox(height: 24),
                          info,
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '사진의 표시 영역은 예시 위치입니다. 실제 AI 분석은 실행하지 않습니다.',
                    style: TextStyle(fontSize: 11, color: muted),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

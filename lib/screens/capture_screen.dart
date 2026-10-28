// D-1 Wrap 진행 단계 P01; D-2 ScenePhoto 예시 사진 P06
// D-3 CheckboxListTile 검토 목록 P05; D-4 AlertDialog 정보 수정 P03
// D-5 FilledButton 확인/모의 완료 P01; D-6 TextField 장소 P02
import 'package:flutter/material.dart';
import '../widgets.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});
  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  int step = 0;
  bool busy = false;
  final names = ['무선 이어폰', '충전 케이블', '열쇠', '다이어리'];
  final selected = [true, true, true, true];
  bool corrected = false;
  final place = TextEditingController(text: '내 방 · 책상 첫 번째 서랍');
  @override
  void dispose() {
    place.dispose();
    super.dispose();
  }

  // STATE: 향후 인식 후보/검토 상태 → 확인 목록. 로컬 UI 표시만 변경.
  Future<void> analyze() async {
    setState(() => busy = true);
    await Future<void>.delayed(const Duration(milliseconds: 1600));
    if (mounted) {
      setState(() {
        busy = false;
        step = 1;
      });
    }
  }

  Future<void> edit(int i) async {
    final controller = TextEditingController(text: names[i]);
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('물건 이름 확인'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('사진을 보고 정확한 이름으로 바꿔 주세요.'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(labelText: '물건 이름'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: const Text('수정 적용'),
          ),
        ],
      ),
    );
    if (value != null && mounted) {
      setState(() {
        names[i] = value;
        if (i == 3) corrected = true;
      });
    }
    // Dialog exit animation can still read the controller; dispose after it finishes.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('사진으로 기록'), centerTitle: true),
    body: SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    pill('01 사진 선택', color: step == 0 ? green : muted),
                    pill('02 물건 확인', color: step == 1 ? green : muted),
                    pill('03 기록 완료', color: step == 2 ? green : muted),
                  ],
                ),
                const SizedBox(height: 28),
                if (step == 2) ...[
                  const SizedBox(height: 30),
                  Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.task_alt_rounded,
                          size: 76,
                          color: green,
                        ),
                        const SizedBox(height: 24),
                        heading('물건의 자리를 기억했어요.', size: 28),
                        const SizedBox(height: 12),
                        Text(
                          '${selected.where((s) => s).length}개 물건 · ${place.text}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 18),
                        pill('저장 완료 미리보기'),
                        const SizedBox(height: 12),
                        const Text(
                          'UI 데모이므로 실제 저장되지 않아요.\n홈에는 처음 제공된 예시 기록이 표시돼요.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: muted),
                        ),
                        const SizedBox(height: 30),
                        FilledButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('홈으로 돌아가기'),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  heading(
                    step == 0 ? '한 장에 담아 두세요.' : 'AI가 찾은 물건, 확인해 주세요.',
                    size: 28,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    step == 0
                        ? '자주 잊어버리는 물건이 있는 곳을 기록해요.'
                        : '잘못된 이름은 수정하고, 기록할 물건만 선택해요.',
                    style: const TextStyle(color: muted),
                  ),
                  const SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, c) {
                      final panel = Surface(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (step == 0) ...[
                              eyebrow('PHOTO PREVIEW'),
                              const SizedBox(height: 14),
                              heading('책상 서랍 예시', size: 22),
                              const SizedBox(height: 12),
                              const Text(
                                '시연용 사진이 준비되어 있어요.\n카메라나 개인 사진에 접근하지 않아요.',
                                style: TextStyle(color: muted, height: 1.8),
                              ),
                              const SizedBox(height: 24),
                              TextField(
                                controller: place,
                                maxLength: 50,
                                decoration: const InputDecoration(
                                  labelText: '어디에 있는 곳인가요?',
                                  prefixIcon: Icon(Icons.location_on_outlined),
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (busy) ...[
                                const LinearProgressIndicator(),
                                const SizedBox(height: 12),
                                const Text('물건의 종류와 위치를 정리하고 있어요…'),
                                const SizedBox(height: 12),
                              ] else
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    onPressed: analyze,
                                    icon: const Icon(
                                      Icons.auto_awesome_outlined,
                                    ),
                                    label: const Text('이 사진으로 분석하기'),
                                  ),
                                ),
                              const SizedBox(height: 12),
                              const Text(
                                '예시 분석 · 외부 AI로 사진을 전송하지 않아요',
                                style: TextStyle(color: muted, fontSize: 11),
                              ),
                            ] else ...[
                              Row(
                                children: [
                                  heading('확인할 물건', size: 21),
                                  const Spacer(),
                                  pill(
                                    '${selected.where((s) => s).length}개 선택',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'AI 분석은 틀릴 수 있어요.',
                                style: TextStyle(color: muted, fontSize: 12),
                              ),
                              const SizedBox(height: 12),
                              ...List.generate(
                                4,
                                (i) => Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.zero,
                                            value: selected[i],
                                            onChanged: (v) => setState(
                                              () => selected[i] = v!,
                                            ),
                                            title: Text(
                                              names[i],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            subtitle: Text(
                                              i == 3 && !corrected
                                                  ? '이름 확인 필요 · 노트일 수도 있어요'
                                                  : [
                                                      '검은색 · 왼쪽 칸',
                                                      '흰색 · 오른쪽 가운데',
                                                      '은색 · 오른쪽 아래',
                                                      '남색 · 오른쪽 위',
                                                    ][i],
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: i == 3 && !corrected
                                                    ? const Color(0xFF94601A)
                                                    : muted,
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          tooltip: '${names[i]} 이름 수정',
                                          onPressed: () => edit(i),
                                          icon: const Icon(
                                            Icons.edit_outlined,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(color: line, height: 1),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: selected.any((v) => v)
                                      ? () {
                                          if (place.text.trim().isEmpty) {
                                            place.text = '내 방 · 책상 첫 번째 서랍';
                                          }
                                          setState(() => step = 2);
                                        }
                                      : null,
                                  child: Text(
                                    '${selected.where((s) => s).length}개 확인하고 기록하기',
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => setState(() => step = 0),
                                child: const Text('사진 선택으로 돌아가기'),
                              ),
                            ],
                          ],
                        ),
                      );
                      if (c.maxWidth >= 740) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(child: ScenePhoto()),
                            const SizedBox(width: 24),
                            Expanded(child: panel),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          const ScenePhoto(),
                          const SizedBox(height: 24),
                          panel,
                        ],
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

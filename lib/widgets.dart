import 'package:flutter/material.dart';
import 'models.dart';

const green = Color(0xFF275C48),
    muted = Color(0xFF6A786E),
    line = Color(0xFFE1E6DE);
Widget heading(String text, {double size = 24}) => Text(
  text,
  style: TextStyle(
    fontSize: size,
    fontWeight: FontWeight.w700,
    letterSpacing: -.8,
    height: 1.4,
    color: const Color(0xFF283B32),
  ),
);
Widget eyebrow(String text) => Text(
  text,
  style: const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 2,
    color: green,
  ),
);
Widget pill(String text, {Color color = green}) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
  decoration: BoxDecoration(
    color: color.withValues(alpha: .08),
    borderRadius: BorderRadius.circular(30),
  ),
  child: Text(
    text,
    style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600),
  ),
);
IconData itemIcon(String key) => switch (key) {
  'earbuds' => Icons.headphones_rounded,
  'cable' => Icons.cable_rounded,
  'keys' => Icons.key_rounded,
  _ => Icons.menu_book_rounded,
};

class Surface extends StatelessWidget {
  const Surface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.color = Colors.white,
  });
  final Widget child;
  final EdgeInsets padding;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: line),
    ),
    child: Material(color: color, child: child),
  );
}

class ScenePhoto extends StatelessWidget {
  const ScenePhoto({super.key, this.item});
  final Item? item;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: AspectRatio(
      aspectRatio: 1.5,
      child: LayoutBuilder(
        builder: (context, c) => Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/drawer.png',
              fit: BoxFit.cover,
              semanticLabel: '책상 서랍 속 이어폰, 케이블, 열쇠, 노트의 예시 사진',
            ),
            if (item != null)
              Positioned(
                left: (item!.x - .13) * c.maxWidth,
                top: (item!.y - .16) * c.maxHeight,
                width: c.maxWidth * .26,
                height: c.maxHeight * .32,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFECFFBA),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    color: const Color(0xFFECFFBA),
                    child: Text(
                      item!.name,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: green,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              left: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .94),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '내 방 / 책상 첫 번째 서랍',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.all(48),
    child: Center(
      child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('기억해 둔 물건을 불러오는 중이에요…'),
        ],
      ),
    ),
  );
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: Surface(
      child: Column(
        children: [
          const Icon(Icons.cloud_off_rounded, size: 38, color: muted),
          const SizedBox(height: 14),
          heading('기록을 불러오지 못했어요', size: 20),
          const Text(
            '연결을 확인한 뒤 다시 시도해 주세요.\n기존 기록은 변경되지 않아요.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('다시 시도'),
          ),
        ],
      ),
    ),
  );
}

class EmptyView extends StatelessWidget {
  const EmptyView({super.key, required this.onAdd, this.search = false});
  final VoidCallback onAdd;
  final bool search;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: Surface(
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded, size: 40, color: muted),
          const SizedBox(height: 16),
          heading(search ? '딱 맞는 물건이 아직 없어요' : '첫 번째 기억을 남겨 볼까요?', size: 20),
          Text(search ? '다른 색깔이나 용도로 표현해 보세요.' : '사진 한 장으로 물건의 자리를 기록해요.'),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: onAdd,
            child: Text(search ? '전체 물건 보기' : '사진으로 기록하기'),
          ),
        ],
      ),
    ),
  );
}

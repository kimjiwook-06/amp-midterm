import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eodi_dwotji/models.dart';
import 'package:eodi_dwotji/screens/a_list_screen.dart';
import 'package:eodi_dwotji/screens/capture_screen.dart';
import 'package:eodi_dwotji/widgets.dart';

const sample = Item(
  id: 1,
  name: '무선 이어폰',
  color: '검은색',
  location: '첫 번째 서랍 · 왼쪽 칸',
  use: '음악 듣기',
  icon: 'earbuds',
  x: .34,
  y: .5,
);
Widget app(Widget child) => MaterialApp(home: child);
void main() {
  testWidgets('mobile review prevents confirming zero items', (t) async {
    t.view.physicalSize = const Size(360, 800);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(app(const CaptureScreen()));
    await t.pumpAndSettle();
    await t.ensureVisible(find.text('이 사진으로 분석하기'));
    await t.tap(find.text('이 사진으로 분석하기'));
    await t.pump(const Duration(seconds: 2));
    await t.pumpAndSettle();
    for (var i = 0; i < 4; i++) {
      final tile = find.byType(CheckboxListTile).at(i);
      await t.ensureVisible(tile);
      await t.tap(tile);
      await t.pump();
    }
    await t.ensureVisible(find.text('0개 확인하고 기록하기'));
    final button = t.widget<FilledButton>(
      find.widgetWithText(FilledButton, '0개 확인하고 기록하기'),
    );
    expect(button.onPressed, isNull);
    expect(t.takeException(), isNull);
  });
  testWidgets('GET loading, failure, retry, then success', (t) async {
    final pending = Completer<List<Item>>();
    int calls = 0;
    await t.pumpWidget(
      app(
        FindHome(
          loader: () {
            calls++;
            return calls == 1 ? pending.future : Future.value([sample]);
          },
        ),
      ),
    );
    expect(find.byType(LoadingView), findsOneWidget);
    pending.completeError(Exception('offline'));
    await t.pumpAndSettle();
    expect(find.byType(ErrorView), findsOneWidget);
    await t.ensureVisible(find.text('다시 시도'));
    await t.tap(find.text('다시 시도'));
    await t.pumpAndSettle();
    expect(calls, 2);
    expect(find.text('무선 이어폰'), findsOneWidget);
  });
  testWidgets('empty GET shows actionable empty state', (t) async {
    await t.pumpWidget(app(FindHome(loader: () async => [])));
    await t.pumpAndSettle();
    expect(find.byType(EmptyView), findsOneWidget);
  });
  testWidgets('push detail, tab, modal, pop to home', (t) async {
    await t.pumpWidget(app(FindHome(loader: () async => [sample])));
    await t.pumpAndSettle();
    await t.ensureVisible(find.text('무선 이어폰'));
    await t.tap(find.text('무선 이어폰'));
    await t.pumpAndSettle();
    expect(find.text('여기 두었어요.'), findsOneWidget);
    await t.ensureVisible(find.text('물품 정보'));
    await t.tap(find.text('물품 정보'));
    await t.pumpAndSettle();
    expect(find.text('용도   음악 듣기'), findsOneWidget);
    await t.ensureVisible(find.text('찾았어요!'));
    await t.tap(find.text('찾았어요!'));
    await t.pumpAndSettle();
    expect(find.text('찾아서 다행이에요!'), findsOneWidget);
    await t.tap(find.text('다른 물건 찾기'));
    await t.pumpAndSettle();
    expect(find.byType(FindHome), findsOneWidget);
  });
  testWidgets('search example and unknown query recovery', (t) async {
    await t.pumpWidget(app(FindHome(loader: () async => [sample])));
    await t.pumpAndSettle();
    await t.enterText(find.byType(TextField), '우산');
    await t.tap(find.text('물건 찾아보기'));
    await t.pumpAndSettle();
    expect(find.byType(EmptyView), findsOneWidget);
    await t.ensureVisible(find.text('전체 물건 보기'));
    await t.tap(find.text('전체 물건 보기'));
    await t.pumpAndSettle();
    expect(find.text('무선 이어폰'), findsOneWidget);
  });
  testWidgets('review, edit, deselect, simulated save', (t) async {
    await t.pumpWidget(app(const CaptureScreen()));
    await t.pumpAndSettle();
    await t.ensureVisible(find.text('이 사진으로 분석하기'));
    await t.tap(find.text('이 사진으로 분석하기'));
    await t.pump();
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    await t.pump(const Duration(seconds: 2));
    await t.pumpAndSettle();
    await t.ensureVisible(find.byTooltip('다이어리 이름 수정'));
    await t.tap(find.byTooltip('다이어리 이름 수정'));
    await t.pumpAndSettle();
    await t.enterText(find.byType(TextField), '작은 노트');
    await t.tap(find.text('수정 적용'));
    await t.pumpAndSettle();
    expect(find.text('작은 노트'), findsOneWidget);
    await t.ensureVisible(find.text('4개 확인하고 기록하기'));
    await t.tap(find.text('4개 확인하고 기록하기'));
    await t.pumpAndSettle();
    expect(find.text('물건의 자리를 기억했어요.'), findsOneWidget);
  });
  for (final width in [360.0, 600.0, 800.0, 1440.0]) {
    testWidgets('adaptive layout $width without overflow', (t) async {
      t.view.physicalSize = Size(width, 900);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      await t.pumpWidget(app(FindHome(loader: () async => [sample])));
      await t.pumpAndSettle();
      expect(t.takeException(), isNull);
      expect(
        find.byType(NavigationBar),
        width < 800 ? findsOneWidget : findsNothing,
      );
    });
  }
}

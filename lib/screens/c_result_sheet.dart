// C-1 Icon 완료 피드백 P01; C-2 Text 찾은 물건 P02
// C-3 Text 시연 안내 P01; C-4 FilledButton 돌아가기 P03
import 'package:flutter/material.dart';
import '../models.dart';
import '../widgets.dart';

void showFoundSheet(BuildContext context, Item item) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 28, 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF1DD),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: green, size: 40),
              ),
              const SizedBox(height: 24),
              heading('찾아서 다행이에요!', size: 28),
              const SizedBox(height: 12),
              Text(
                '${item.name}, 다시 제자리에 두면\n다음에도 쉽게 찾을 수 있어요.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: muted, height: 1.8),
              ),
              const SizedBox(height: 20),
              pill('시연 완료 · 기록은 변경되지 않아요'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () =>
                      Navigator.popUntil(context, (route) => route.isFirst),
                  child: const Text('다른 물건 찾기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );

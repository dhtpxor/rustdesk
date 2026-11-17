import 'package:flutter/material.dart';

import '../../common.dart';
import '../../consts.dart';
import '../../models/model.dart';

class _Shortcut {
  final String label;
  final String key;
  final bool ctrl;
  final bool alt;
  final bool shift;
  final bool command;

  const _Shortcut(this.label, this.key,
      {this.ctrl = false,
      this.alt = false,
      this.shift = false,
      this.command = false});
}

const _shortcuts = <_Shortcut>[
  _Shortcut('저장', 'VK_S', ctrl: true),
  _Shortcut('복사', 'VK_C', ctrl: true),
  _Shortcut('붙여넣기', 'VK_V', ctrl: true),
  _Shortcut('실행 취소', 'VK_Z', ctrl: true),
  _Shortcut('창 전환', 'VK_TAB', alt: true),
  _Shortcut('바탕화면', 'VK_D', command: true),
  _Shortcut('한/영', 'VK_HANGUL'),
  _Shortcut('시작', 'Meta'),
  _Shortcut('Esc', 'VK_ESCAPE'),
  _Shortcut('Enter', 'VK_ENTER'),
  _Shortcut('Ctrl+Alt+Del', 'CTRL_ALT_DEL'),
];

void sendMyShortcut(FFI ffi, String key,
    {bool ctrl = false,
    bool alt = false,
    bool shift = false,
    bool command = false}) {
  final input = ffi.inputModel;
  final old = [input.ctrl, input.alt, input.shift, input.command];
  input.ctrl = ctrl;
  input.alt = alt;
  input.shift = shift;
  input.command = command;
  input.inputKey(key);
  input.ctrl = old[0];
  input.alt = old[1];
  input.shift = old[2];
  input.command = old[3];
}

class MyShortcutBar extends StatelessWidget {
  final FFI ffi;

  const MyShortcutBar({Key? key, required this.ffi}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMac = ffi.ffiModel.pi.platform == kPeerPlatformMacOS;
    return Container(
      color: MyTheme.accent.withOpacity(0.92),
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        children: _shortcuts
            .where((s) => !(isMac && s.key == 'CTRL_ALT_DEL'))
            .map((s) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white70),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      minimumSize: const Size(0, 32),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => sendMyShortcut(ffi, s.key,
                        ctrl: s.ctrl && !isMac,
                        alt: s.alt,
                        shift: s.shift,
                        command: s.command || (s.ctrl && isMac)),
                    child: Text(s.label, style: const TextStyle(fontSize: 13)),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

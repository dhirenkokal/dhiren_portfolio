import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

class TerminalOverlay extends StatefulWidget {
  final Widget child;
  const TerminalOverlay({super.key, required this.child});

  @override
  State<TerminalOverlay> createState() => _TerminalOverlayState();
}

class _TerminalOverlayState extends State<TerminalOverlay> {
  bool _isOpen = false;
  final TextEditingController _inputCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final FocusNode _inputFocus = FocusNode();
  final List<_TerminalLine> _lines = [];

  static const _welcomeLines = [
    '╔══════════════════════════════════════════════╗',
    '║     DHIREN KOKAL — INTERACTIVE TERMINAL      ║',
    '╚══════════════════════════════════════════════╝',
    '',
    'Type a command and press Enter.',
    'Available: whoami  skills  experience  contact  hire  projects  clear  exit',
    '',
  ];

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
    for (final line in _welcomeLines) {
      _lines.add(_TerminalLine(text: line, type: _LineType.output));
    }
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backquote) {
      setState(() => _isOpen = !_isOpen);
      if (_isOpen) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _inputFocus.requestFocus();
        });
      }
      return true;
    }
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape &&
        _isOpen) {
      setState(() => _isOpen = false);
      return true;
    }
    return false;
  }

  void _executeCommand(String input) {
    final cmd = input.trim().toLowerCase();
    _lines.add(_TerminalLine(text: '> $input', type: _LineType.input));
    _inputCtrl.clear();

    if (cmd.isEmpty) return;

    switch (cmd) {
      case 'whoami':
        _addOutput([
          'Dhiren Kokal',
          'Mobile Application Engineer',
          'MCA Graduate — University of Mumbai',
          'Specializing in Flutter, Android (Kotlin), Clean Architecture',
        ]);
      case 'skills':
        _addOutput([
          'Languages  : Dart, Kotlin, Java, C/C++, JavaScript, ArkTS',
          'Frameworks : Flutter, Jetpack Compose, Spring Boot',
          'Tools      : Firebase, Apollo GraphQL, Room, Hilt, Retrofit',
          'Arch       : Clean Architecture, MVVM, BLoC, MVI',
          'DevOps     : Git, Shorebird, Firebase App Distribution',
          'AI Tools   : Claude Code, GPT-4, Cursor, Kiro AI',
        ]);
      case 'experience':
        _addOutput([
          'Binaryveda          Oct 2024 – Present',
          '  Mobile Application Engineer',
          '  Flutter IoT Platform (747K+ lines), Android SDK, ArkTS',
          '',
          'Vigo Infotech       Mar 2024 – Oct 2024',
          '  Junior Android Developer',
          '  CRM module, Matrimony app, MVVM, Kotlin',
          '',
          'Vigo Infotech       Feb 2024 – Mar 2024',
          '  Software Developer Intern',
        ]);
      case 'contact':
        _addOutput([
          'Email  : dhirenkokal@gmail.com',
          'Phone  : +91 9172185008',
          'GitHub : github.com/dhirenkokal',
        ]);
      case 'hire':
        _addOutput([
          '🚀 Smart choice!',
          '',
          'I am open to exciting opportunities.',
          'Send a message to: dhirenkokal@gmail.com',
          'Or navigate to: /contact',
          '',
          'Looking for someone who ships clean, scalable',
          'Flutter apps at 747K lines and counting.',
        ]);
      case 'projects':
        _addOutput([
          'Flutter IoT Platform   : Smart home, 747K+ lines, Clean Arch',
          'Messaging (Flutter)    : Firebase Firestore, real-time, Flutter',
          'Messaging (Android)    : Java, Firebase, pagination',
          'Weather Forecasting    : Java/Android, REST API, JSON animations',
        ]);
      case 'clear':
        setState(() {
          _lines.clear();
          for (final line in _welcomeLines) {
            _lines.add(_TerminalLine(text: line, type: _LineType.output));
          }
        });
        return;
      case 'exit':
        setState(() => _isOpen = false);
        return;
      case 'help':
        _addOutput([
          'Commands:',
          '  whoami      — Who is Dhiren?',
          '  skills      — Technical skill set',
          '  experience  — Work history',
          '  contact     — Get in touch',
          '  hire        — Open to work details',
          '  projects    — Notable projects',
          '  clear       — Clear terminal',
          '  exit        — Close terminal',
        ]);
      default:
        _addOutput([
          'Command not found: $cmd',
          'Try: whoami, skills, experience, contact, hire, projects, help',
        ]);
    }

    setState(() {});
    _scrollToBottom();
  }

  void _addOutput(List<String> lines) {
    for (final line in lines) {
      _lines.add(_TerminalLine(text: line, type: _LineType.output));
    }
    _lines.add(_TerminalLine(text: '', type: _LineType.output));
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    _inputFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: _buildTerminalWindow(),
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 200.ms),
          ),
      ],
    );
  }

  Widget _buildTerminalWindow() {
    return Container(
      width: 680,
      height: 460,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.terminalBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent.withOpacity(0.4), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.2),
            blurRadius: 40,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Title bar
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.cardBorder,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // Traffic lights
                _dot(const Color(0xFFFF5F57)),
                const SizedBox(width: 8),
                _dot(const Color(0xFFFFBD2E)),
                const SizedBox(width: 8),
                _dot(const Color(0xFF28CA41)),
                const Spacer(),
                Text(
                  'dhiren@portfolio ~ terminal',
                  style: AppTextStyles.code.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => setState(() => _isOpen = false),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Icon(
                      Icons.close,
                      color: AppColors.textMuted,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Output
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                controller: _scrollCtrl,
                itemCount: _lines.length,
                itemBuilder: (context, i) {
                  final line = _lines[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      line.text,
                      style: line.type == _LineType.input
                          ? AppTextStyles.terminalPrompt
                          : AppTextStyles.code,
                    ),
                  );
                },
              ),
            ),
          ),
          // Input
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Text('> ', style: AppTextStyles.terminalPrompt),
                Expanded(
                  child: TextField(
                    controller: _inputCtrl,
                    focusNode: _inputFocus,
                    style: AppTextStyles.terminalInput,
                    cursorColor: AppColors.accent,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onSubmitted: _executeCommand,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .slideY(begin: 0.05, end: 0, duration: 200.ms, curve: Curves.easeOut)
        .fadeIn(duration: 200.ms);
  }

  Widget _dot(Color color) => Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

class _TerminalLine {
  final String text;
  final _LineType type;
  _TerminalLine({required this.text, required this.type});
}

enum _LineType { input, output }

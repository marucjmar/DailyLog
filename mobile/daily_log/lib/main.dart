import 'dart:io';
import 'dart:math';

import 'package:daily_log/repositories/session.dart';
import 'package:daily_log/stores/session.dart';
import 'package:daily_log/views/login.dart';
import 'package:daily_log/views/timeline.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  await SessionRepository.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.amber),
      ),
      home: AnimatedBuilder(
        animation: SessionRepository.instance,
        builder: (context, child) {
          return SessionRepository.instance.isLoggedIn
              ? const MyHomePage()
              : const LoginPage();
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  DateTime _selectedDate = DateTime.now();
  final Map<DateTime, int> _activityByDay = {
    DateTime(2026, 7, 10): 1,
    DateTime(2026, 7, 11): 4,
    DateTime(2026, 7, 12): 8,
    DateTime(2026, 7, 13): 2,
    DateTime(2026, 7, 15): 10,
  };

  List<Widget> get _pages => [
    TimelinePage(
      selectedDate: _selectedDate,
      onDateChanged: (date) {
        setState(() {
          _selectedDate = date;
        });
      },
      loadActivityCounts: (start, end) async {
        final random = Random();

        return await Future.delayed(const Duration(milliseconds: 1250), () {
          final Map<DateTime, int> result = {};

          for (
            DateTime date = start;
            !date.isAfter(end);
            date = date.add(const Duration(days: 1))
          ) {
            result[date] = random.nextInt(11); // 0-10
          }

          return result;
        });
      },
    ),
    const Center(child: Text('Historia')),
  ];

  Future<void> _openAddEntryBottomSheet() async {
    final textController = TextEditingController();
    final focusNode = FocusNode();

    String? attachmentName;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Future.delayed(const Duration(milliseconds: 100), () {
              if (mounted) {
                focusNode.requestFocus();
              }
            });

            Future<void> addAttachment() async {
              FilePickerResult? result = await FilePicker.pickFiles();

              File? file;

              if (result != null) {
                file = File(result.files.single.path!);
              } else {
                // User canceled the picker
              }

              if (file == null) return;

              // Tutaj później możesz otworzyć file picker.
              // Na razie przykładowy załącznik:
              setModalState(() {
                attachmentName = file!.path;
              });
            }

            void removeAttachment() {
              setModalState(() {
                attachmentName = null;
              });
            }

            Future<void> submit() async {
              final text = textController.text.trim();

              if (text.isEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Wpisz treść')));
                return;
              }

              debugPrint('Treść: $text');
              debugPrint('Załącznik: $attachmentName');

              // Tutaj wywołaj repository/API:
              //
              // await DailyLogRepository.instance.createEntry(
              //   text: text,
              //   attachment: attachment,
              // );

              if (bottomSheetContext.mounted) {
                Navigator.of(bottomSheetContext).pop();
              }

              if (mounted) {
                showToast(this.context, 'Wpis został dodany');
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 8,
                bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Nowy wpis',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: textController,
                      autofocus: false,
                      focusNode: focusNode,
                      minLines: 1,
                      maxLines: 1,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Treść',
                        hintText: 'Napisz, co wydarzyło się dzisiaj...',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    if (attachmentName != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.attach_file),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                attachmentName!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              onPressed: removeAttachment,
                              tooltip: 'Usuń załącznik',
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        IconButton.filledTonal(
                          onPressed: addAttachment,
                          tooltip: 'Dodaj załącznik',
                          icon: const Icon(Icons.attach_file),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: submit,
                            icon: const Icon(Icons.send),
                            label: const Text('Wyślij'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    // textController.dispose();
  }

  void showToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);

    final entry = OverlayEntry(
      builder: (context) => Positioned(
        left: 20,
        right: 20,
        bottom: 100,
        child: SafeArea(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inverseSurface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(blurRadius: 12, color: Colors.black26),
                ],
              ),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 2), entry.remove);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: _openAddEntryBottomSheet,
        child: const Icon(Icons.add),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 65,
          child: Row(
            children: [
              Expanded(
                child: IconButton(
                  icon: Icon(
                    Icons.timeline,
                    color: _selectedIndex == 0
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() => _selectedIndex = 0);
                  },
                ),
              ),

              const SizedBox(width: 48),

              Expanded(
                child: IconButton(
                  icon: Icon(
                    Icons.history,
                    color: _selectedIndex == 1
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() => _selectedIndex = 1);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

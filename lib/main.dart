import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized().ensureSemantics();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Field Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xffe87542),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xfffffbf5),
        textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Georgia',
          bodyColor: const Color(0xff263238),
          displayColor: const Color(0xff263238),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _started = false;

  void _startExploring() {
    setState(() => _started = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 760;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 72 : 24,
                vertical: isWide ? 40 : 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Header(isWide: isWide),
                      SizedBox(height: isWide ? 104 : 72),
                      _Hero(
                        isWide: isWide,
                        started: _started,
                        onStart: _startExploring,
                      ),
                      const SizedBox(height: 88),
                      _FeatureRow(isWide: isWide),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'FIELD / NOTES',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.4),
        ),
        if (isWide)
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.arrow_outward, size: 18),
            label: const Text('About the project'),
          ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.isWide,
    required this.started,
    required this.onStart,
  });

  final bool isWide;
  final bool started;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: isWide ? Axis.horizontal : Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: isWide ? 6 : 0,
          child: Text(
            'A quieter way\nto think clearly.',
            style: TextStyle(
              fontSize: isWide ? 72 : 52,
              height: .98,
              fontWeight: FontWeight.w700,
              letterSpacing: -1.5,
            ),
          ),
        ),
        SizedBox(width: isWide ? 80 : 0, height: isWide ? 0 : 28),
        Expanded(
          flex: isWide ? 4 : 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Field Notes is a small space for collecting the ideas, questions, and observations worth returning to.',
                style: TextStyle(fontSize: 19, height: 1.45),
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: onStart,
                icon: Icon(started ? Icons.check : Icons.arrow_forward),
                label: Text(started ? 'You are ready' : 'Start exploring'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xffe87542),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final features = [
      ('01', 'Collect', 'Keep the fragments that spark something.'),
      ('02', 'Notice', 'Give your attention room to wander.'),
      ('03', 'Return', 'Find the thread when you need it again.'),
    ];
    return Flex(
      direction: isWide ? Axis.horizontal : Axis.vertical,
      children: [
        for (final feature in features)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: isWide ? 28 : 0,
                bottom: isWide ? 0 : 24,
              ),
              child: _Feature(
                number: feature.$1,
                title: feature.$2,
                body: feature.$3,
              ),
            ),
          ),
      ],
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature({
    required this.number,
    required this.title,
    required this.body,
  });

  final String number;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 18),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xffd7d0c6))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(number, style: const TextStyle(color: Color(0xffe87542))),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              fontSize: 16,
              height: 1.4,
              color: Color(0xff687177),
            ),
          ),
        ],
      ),
    );
  }
}

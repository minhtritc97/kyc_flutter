import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kyc_flutter/kyc_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KYC Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  KycResult? _result;

  Future<void> _startKyc() async {
    final KycResult result = await KYCFlutter.instance.startKyc(
      context,
      config: const DetectionConfig(
        // Look-straight far + near always run first; add liveness steps here.
        steps: [KYCStep.blink, KYCStep.smile],
        smileThreshold: 0.5,
        // Override any on-screen text (defaults are English):
        // strings: KycStrings(blink: 'Please blink your eyes'),
      ),
    );
    setState(() => _result = result);
  }

  @override
  Widget build(BuildContext context) {
    final KycResult? result = _result;
    return Scaffold(
      appBar: AppBar(title: const Text('KYC Flutter Demo')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              onPressed: _startKyc,
              icon: const Icon(Icons.face_retouching_natural),
              label: const Text('Start KYC'),
            ),
            const SizedBox(height: 24),
            if (result != null) ...[
              Text('Status: ${result.status.name}'),
              Text('Images captured: ${result.images.length}'),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    for (final CapturedImage img in result.images)
                      Column(
                        children: [
                          Expanded(
                            child: Image.file(File(img.imgPath),
                                fit: BoxFit.cover),
                          ),
                          Text(
                            img.step?.name ?? img.type.name,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

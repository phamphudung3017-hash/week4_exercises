import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IsolateScreen extends StatefulWidget {
  const IsolateScreen({super.key});

  @override
  State<IsolateScreen> createState() => _IsolateScreenState();
}

class _IsolateScreenState extends State<IsolateScreen> {
  final TextEditingController _numController = TextEditingController(text: '2000');
  String _result = '';
  bool _loading = false;
  ReceivePort? _port;
  Isolate? _isolate;

  // compute-based factorial (no progress)
  Future<String> _computeFactorial(String nStr) async {
    final n = int.tryParse(nStr) ?? 0;
    if (n <= 0) return 'Invalid number';
    setState(() {
      _loading = true;
      _result = '';
    });

    // We will run heavy task in compute (Isolate) to avoid UI freeze.
    final BigInt result = await compute(_factorialCompute, n);
    setState(() {
      _loading = false;
      // The result is massive; show digits count and a short preview.
      final digits = result.toString().length;
      final s = result.toString();
      final preview = s.length > 200 ? '${s.substring(0, 100)}\n...\n${s.substring(s.length - 100)}' : s;
      _result = 'Factorial of $n computed.\nDigits: $digits\n\nPreview:\n$preview';
    });
    return 'done';
  }

  static BigInt _factorialCompute(int n) {
    BigInt r = BigInt.one;
    for (int i = 2; i <= n; i++) {
      r *= BigInt.from(i);
    }
    return r;
  }

  // Example of using manual Isolate + progress via ports (simple heartbeat)
  Future<void> _startIsolateWithProgress(String nStr) async {
    final n = int.tryParse(nStr) ?? 0;
    if (n <= 0) {
      setState(() => _result = 'Invalid number');
      return;
    }
    _port = ReceivePort();
    setState(() {
      _loading = true;
      _result = 'Starting isolate...';
    });
    _isolate = await Isolate.spawn(_isolateFactorialEntry, [_port!.sendPort, n]);
    StreamSubscription? sub;
    sub = _port!.listen((message) {
      if (message is Map) {
        if (message['type'] == 'progress') {
          setState(() {
            _result = 'Progress: ${message['value']}%';
          });
        } else if (message['type'] == 'done') {
          final digits = (message['digits'] as int);
          setState(() {
            _loading = false;
            _result = 'Completed in isolate. Digits: $digits\nPreview omitted for huge size.';
          });
          sub?.cancel();
          _port?.close();
        }
      }
    });
  }

  static void _isolateFactorialEntry(List<dynamic> args) {
    final SendPort send = args[0] as SendPort;
    final int n = args[1] as int;
    BigInt r = BigInt.one;
    final int step = (n / 100).ceil();
    for (int i = 1; i <= n; i++) {
      r *= BigInt.from(i);
      if (i % step == 0) {
        final pct = ((i / n) * 100).toInt();
        send.send({'type': 'progress', 'value': pct});
      }
    }
    send.send({'type': 'done', 'digits': r.toString().length});
  }

  @override
  void dispose() {
    _numController.dispose();
    _port?.close();
    _isolate?.kill(priority: Isolate.immediate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const Text('Compute factorial using isolate (heavy task).', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _numController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Compute factorial of (e.g., 2000 or 30000)'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(
                onPressed: _loading ? null : () => _computeFactorial(_numController.text),
                child: const Text('Compute (compute())'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _loading ? null : () => _startIsolateWithProgress(_numController.text),
                child: const Text('Compute + progress (Isolate)'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_loading) const CircularProgressIndicator(),
          const SizedBox(height: 12),
          SelectableText(_result),
          const SizedBox(height: 12),
          const Text('Note: For huge n (like 30000) it can take long and produce enormous output.'),
        ],
      ),
    );
  }
}

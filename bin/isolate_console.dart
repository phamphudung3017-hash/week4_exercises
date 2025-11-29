import 'dart:async';
import 'dart:isolate';
import 'dart:math';

// Worker entry
void worker(SendPort send) {
  final rand = Random();
  final ReceivePort port = ReceivePort();
  send.send(port.sendPort); // send our sendPort to main
  int sum = 0;
  Timer.periodic(Duration(seconds: 1), (t) {
    final val = rand.nextInt(20) + 1;
    sum += val;
    send.send({'type': 'value', 'value': val, 'sum': sum});
    if (sum > 100) {
      send.send({'type': 'stop', 'sum': sum});
      t.cancel();
      Isolate.exit();
    }
  });
  port.listen((message) {
    if (message == 'stop') {
      Isolate.exit();
    }
  });
}

Future<void> main() async {
  final receive = ReceivePort();
  final isolate = await Isolate.spawn(worker, receive.sendPort);

  SendPort? workerPort;
  final sub = receive.listen((message) {
    if (message is SendPort) {
      workerPort = message;
      print('Worker ready.');
    } else if (message is Map) {
      if (message['type'] == 'value') {
        print('Worker sent value ${message['value']}, sum=${message['sum']}');
      } else if (message['type'] == 'stop') {
        print('Worker requested stop. Final sum=${message['sum']}');
      }
    }
  });

  // main will wait until isolate exits
  await Future.delayed(Duration(seconds: 20));
  sub.cancel();
  receive.close();
  print('Main finished (if worker already exited, fine).');
}

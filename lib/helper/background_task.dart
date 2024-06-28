import 'dart:isolate';



import '../data/home/repositories/hom_repositry.dart';
import 'database_helper.dart';




Future<void> refreshRepositories(DatabaseHelper databaseHelper) async {
  final ReceivePort receivePort = ReceivePort();
  await Isolate.spawn(_refreshRepositoriesIsolate, receivePort.sendPort);

  final SendPort sendPort = await receivePort.first;
  final response = ReceivePort();
  sendPort.send([response.sendPort, databaseHelper]);

  await for (final message in response) {
    if (message == 'done') {
      break;
    }
  }
}

void _refreshRepositoriesIsolate(SendPort sendPort) async {
  final port = ReceivePort();
  sendPort.send(port.sendPort);

  await for (final message in port) {
    final SendPort replyTo = message[0];
    final DatabaseHelper databaseHelper = message[1];

    try {
      var repositories = await fetchRepositoriesHome();
      await databaseHelper.insertRepositories(repositories);
    } catch (e) {
      // Handle error if needed
    }

    replyTo.send('done');
  }
}

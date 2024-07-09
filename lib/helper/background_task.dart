import 'dart:isolate';



import '../data/home/repositories/hom_repositry.dart';
import 'database_helper.dart';




Future<void> refreshRepositories(DatabaseHelper databaseHelper) async {
  // Create a ReceivePort to receive messages from the isolate.
  final ReceivePort receivePort = ReceivePort();
  // Spawn a new isolate and pass the sendPort of receivePort to it.
  await Isolate.spawn(_refreshRepositoriesIsolate, receivePort.sendPort);
// Wait for the isolate to send back its sendPort.
  final SendPort sendPort = await receivePort.first;
  // Create another ReceivePort to receive responses from the isolate.
  final response = ReceivePort();
  // Send a message to the isolate with the response sendPort and the database helper.
  sendPort.send([response.sendPort, databaseHelper]);
  // Wait for a message from the isolate indicating the task is done.
  await for (final message in response) {
    if (message == 'done') {
      break;
    }
  }
}

void _refreshRepositoriesIsolate(SendPort sendPort) async {
  // Create a ReceivePort to receive messages from the main thread.
  final port = ReceivePort();
  // Send the isolate's sendPort back to the main thread.
  sendPort.send(port.sendPort);
  // Listen for messages from the main thread.
  await for (final message in port) {
    final SendPort replyTo = message[0];
    final DatabaseHelper databaseHelper = message[1];

    try {
      var repositories = await fetchRepositoriesHome();
      await databaseHelper.insertRepositories(repositories);
    } catch (e) {
      // Handle error if needed
    }
    // Notify the main thread that the task is done.
    replyTo.send('done');
  }
}

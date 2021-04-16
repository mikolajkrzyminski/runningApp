import 'dart:io';

import 'dart:typed_data';

// TODO: change to stable version it's only for test
Future<void> serverConnectionTestData() async {

  HttpClient client = HttpClient();

  HttpClientRequest request = await client.get('178.183.128.112', 7080, '/api/test/all-tests');

  HttpClientResponse response = await request.close();
  
  Socket socket = await response.detachSocket();


  WebSocket ws = WebSocket.fromUpgradedSocket(
    socket,
    serverSide: false,
  );

  print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

  socket.listen(

    // handle data from the server
        (Uint8List data) {
      final serverResponse = String.fromCharCodes(data);
      print('Server: $serverResponse');
    },

    // handle errors
    onError: (error) {
      print(error);
      socket.destroy();
    },

    // handle server ending connection
    onDone: () {
      print('Server left.');
      socket.destroy();
    },
  );
}
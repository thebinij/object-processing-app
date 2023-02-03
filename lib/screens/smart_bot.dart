import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class SmartBot extends StatefulWidget {
  const SmartBot({super.key});
  @override
  State<SmartBot> createState() => _SmartBotState();
}

class _SmartBotState extends State<SmartBot> {
  final TextEditingController _controller = TextEditingController();

  final _channel =
      IOWebSocketChannel.connect(Uri.parse('ws://10.0.2.2:5001/echo'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Bot'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                autocorrect: false,
                decoration: const InputDecoration(labelText: "Send a message."),
                controller: _controller,
              ),
            ),
            const SizedBox(height: 24),
            StreamBuilder(
                stream: _channel.stream,
                builder: (context, snapshot) {
                  return Text(snapshot.hasData ? '${snapshot.data}' : '');
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Send message',
        onPressed: () {
          if (_controller.text.isNotEmpty) {
            _channel.sink.add(_controller.text);
          }
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.send),
      ),
    );
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}

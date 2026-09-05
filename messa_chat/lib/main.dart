import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(const messaChat());
}

class messaChat extends StatelessWidget {
    const messaChat({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
      title: 'messaChat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF293145),
        primaryColor: Colors.cyanAccent,
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
    const ChatScreen({super.key});

    @override
    State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
    final TextEditingController _controller = TextEditingController();
    final DatabaseRefernce _dbRef = FirebaseDataabse.instance.ref("messages");
    final List<Map<String, String>> _messages = [];

    @override
    void initState() {
        super.initState();
        _dbRef.onChildAdded.listen((event) {
            final data = Map<String, dynamic>.from(event.snapshot.value as Map);
            setState(() {
                _messages.add({
                    "sender": data["sender"] ?? "ano"
                    "text": data["text"] ?? "",
            });
        });
    });
}

void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    _dbRef.push().set({
        "sender": "trznhien",
        "text": _controller.text.trim(),
        "timestamp": DateTime.now().milisecondsSinceEpoch,
    });

    _controller.clear();
}

@override
Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("messa-chat😌", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
            backgroundColor: const Color(0xFF1E293B),
            elevation: 0,
        ),
        body: Column(
            children: [
                Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                            final msg = _messages[index];
                            return Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF334155),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                                    ),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text(
                                                msg["sender"]!,
                                                style: const TextStyle(fontSize: 10, color: Colors.cyanAccent, fontWeight: FontWeight.bold),

                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                                msg["text"]!
                                                style: const TextStyle(fontSize: 15, color: Colors.white),
                                            ),
                                        ],
                                    ),
                                ),
                            ),
                        },
                    ),
                ),

                Container(
                    padding: const EdgeInsets.all(8),
                    color: const Color(0xFF1E293B),
                    child: Row(
                        children: [
                            Expanded(
                                child: TextField(
                                    controller: _controller,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                        hintText: "Nhập tin nhắn...",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                    ),
                                ),
                            ),
                            IconButton(
                                icon: const Icon(Icons.send, color: Colors.cyanAccent),
                                onPressed: _sendMessage,
                            ),
                        ],
                    ),
                ),
            ],
        ),
    ),
}
}
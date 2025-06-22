import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final Gemini gemini = Gemini.instance;
  final ScrollController _controller = ScrollController();

  List<ChatMessage> messages = [
    ChatMessage(
      user: ChatUser(id: "1", firstName: "Cactile"),
      createdAt: DateTime.now(),
      text: "Hello! I'm Cactile. How can I help you today?",
    )
  ];

  final ChatUser currentUser = ChatUser(
    id: "0",
    firstName: "You",
  );

  final ChatUser botUser = ChatUser(
    id: "1",
    firstName: "Cactile",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Cactile AI'),
        centerTitle: true,
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal.shade50,
              Colors.white,
            ],
          ),
        ),
        child: DashChat(
          currentUser: currentUser,
          onSend: _sendMessage,
          messages: messages,
          messageListOptions: MessageListOptions(
            scrollController: _controller,
          ),
          inputOptions: InputOptions(
            inputDecoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromARGB(255, 245, 244, 244),
              hintText: 'Type your message...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            sendButtonBuilder: (onSend) => IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => onSend(),
              color: Colors.teal[700],
            ),
          ),
          messageOptions: MessageOptions(
            currentUserContainerColor: Colors.teal[400]!,
            containerColor: Colors.grey[200]!,
            textColor: Colors.black,
            currentUserTextColor: const Color.fromARGB(255, 10, 10, 10),
            messageDecorationBuilder: (message, _, __) => BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _sendMessage(ChatMessage message) {
    setState(() {
      messages.insert(0, message);
    });

    gemini.streamGenerateContent(message.text).listen((response) {
      String text = response.content?.parts
              ?.whereType<TextPart>()
              .map((e) => e.text)
              .join(' ') ??
          '';

      setState(() {
        messages.insert(
          0,
          ChatMessage(
            user: botUser,
            createdAt: DateTime.now(),
            text: text,
          ),
        );
      });
    });
  }
}

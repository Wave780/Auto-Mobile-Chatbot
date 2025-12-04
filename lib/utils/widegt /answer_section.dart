// // import 'package:auto_mobile_chatbot/service/chat_service.dart';
// // import 'package:auto_mobile_chatbot/theme/theme.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_markdown/flutter_markdown.dart';
// //
// // class AnswerSection extends StatefulWidget {
// //   const AnswerSection({super.key});
// //
// //   @override
// //   State<AnswerSection> createState() => _AnswerSectionState();
// // }
// //
// // class _AnswerSectionState extends State<AnswerSection> {
// //   String fullResponse = '';
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         // Text(
// //         //   'Thinking',
// //         //   style: TextStyle(
// //         //     fontSize: 18,
// //         //     fontWeight: FontWeight.bold,
// //         //   ),
// //         // ),
// //         // SizedBox(height: 8),
// //         StreamBuilder(
// //             stream: ChatService().chatStream,
// //             builder: (context, snapshot) {
// //               if (snapshot.connectionState == ConnectionState.waiting) {
// //                 return const Center(
// //                   child: CircularProgressIndicator(),
// //                 );
// //               }
// //               fullResponse += """
// // ### Context:
// //       ${snapshot.data?['context'] ?? ''}
// //
// //     ### Answer:
// //     ${snapshot.data?['answer'] ?? ''}
// //     """;
// //               //fullResponse += snapshot.data?['answer'] ?? '';
// //               return Markdown(
// //                 data: fullResponse,
// //                 shrinkWrap: true,
// //                 styleSheet:
// //                     MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
// //                         codeblockDecoration: BoxDecoration(
// //                           color: AppColors.surfaceDark,
// //                           borderRadius: BorderRadius.circular(10),
// //                         ),
// //                         code: TextStyle(fontSize: 18)),
// //               );
// //             }),
// //       ],
// //     );
// //   }
// // }
// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
//
// import '../../service/chat_service.dart';
// import '../../theme/theme.dart';
//
// class AnswerSection extends StatefulWidget {
//   @override
//   State<AnswerSection> createState() => _AnswerSectionState();
// }
//
// class _AnswerSectionState extends State<AnswerSection>
//     with TickerProviderStateMixin {
//   final List<Map<String, dynamic>> messages = [];
//   final _scrollController = ScrollController();
//   bool isTyping = false;
//   late StreamSubscription chatSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//
//     chatSubscription = ChatService().chatStream.listen((data) {
//       setState(() {
//         final contextText = data["context"] ?? "";
//         final answerText = data["answer"] ?? "";
//
//         messages.add({
//           "text": """
//
// ### Answer:
// $answerText
//
// ### Context:
// $contextText
// """,
//           "isUser": false,
//         });
//
//         isTyping = false;
//       });
//
//       _scrollToBottom();
//     });
//
//     ChatService().onTyping.listen((_) {
//       setState(() => isTyping = true);
//       _scrollToBottom();
//     });
//   }
//
//   void _scrollToBottom() {
//     Future.delayed(Duration(milliseconds: 50), () {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     chatSubscription.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         AnimatedSize(
//           duration: Duration(milliseconds: 300),
//           child: ListView.builder(
//             controller: _scrollController,
//             itemCount: messages.length + (isTyping ? 1 : 0),
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemBuilder: (context, i) {
//               if (i == messages.length && isTyping) {
//                 return _typingBubble();
//               }
//
//               return _messageBubble(
//                 messages[i]["text"],
//                 messages[i]["isUser"],
//               );
//             },
//           ),
//         ),
//         SizedBox(height: 20),
//         _inputField()
//       ],
//     );
//   }
//
//   Widget _messageBubble(String text, bool isUser) {
//     return AnimatedSlide(
//       offset: Offset(0, 0.2),
//       duration: Duration(milliseconds: 300),
//       child: AnimatedOpacity(
//         opacity: 1,
//         duration: Duration(milliseconds: 300),
//         child: Align(
//           alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//           child: Container(
//             margin: EdgeInsets.symmetric(vertical: 8),
//             padding: EdgeInsets.all(14),
//             constraints: BoxConstraints(maxWidth: 600),
//             decoration: BoxDecoration(
//               color: isUser ? AppColors.primaryLight : Colors.white,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: MarkdownBody(
//               data: text,
//               styleSheet: MarkdownStyleSheet(
//                 p: TextStyle(
//                   color: isUser ? Colors.white : Colors.black87,
//                   fontSize: 16,
//                 ),
//                 codeblockDecoration: BoxDecoration(
//                   color: Colors.black12,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _typingBubble() {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Container(
//         padding: EdgeInsets.all(14),
//         margin: EdgeInsets.symmetric(vertical: 8),
//         decoration: BoxDecoration(
//           //color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: const [
//             Text("● ● ●", style: TextStyle(fontSize: 18, color: Colors.grey)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _inputField() {
//     final controller = TextEditingController();
//
//     return Row(
//       children: [
//         Expanded(
//           child: TextField(
//             controller: controller,
//             decoration: InputDecoration(
//               hintText: "Ask another question...",
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             onSubmitted: (value) {
//               ChatService().chat(
//                 value.trim(),
//               );
//             },
//           ),
//         ),
//         SizedBox(width: 10),
//         IconButton(
//           icon: Icon(Icons.send, color: AppColors.primaryLight),
//           onPressed: () {
//             ChatService().chat(
//               controller.text.trim(),
//             );
//             controller.clear();
//           },
//         )
//       ],
//     );
//   }
// }

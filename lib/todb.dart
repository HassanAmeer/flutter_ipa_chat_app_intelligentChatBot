// ignore_for_file: unused_local_variable, unused_import, unused_field

import "dart:developer";
import "dart:io";
import "dart:math";

import "package:chatapp/model/ChatModel.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:intl/intl.dart";
import "package:langchain/langchain.dart";
import "dart:convert";

import "package:langchain_openai/langchain_openai.dart";
import "package:provider/provider.dart";

import "getkey.dart";
// import "package:langchain_pinecone/langchain_pinecone.dart";

// const String openAiKey = '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';
// const String openAiKey = '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'; // free api
// String openAiKey = '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';
// const String openAiKey = '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';
// const String openAiKey = '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'; // undefined key
// const String openAiKey = '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';
// const String openAiKey = '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';
// const String openAiKey =
//     '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'; //free api key
const String pineconeKey = '2e13ee6b-e229-4546-a5e7-995b4bb809dd';

// Modify the ChatMessage.system method to use user history for LangChain.
extension ChatMessageSystem on ChatMessage {
  static ChatMessage systemForLangChain(String userHistory) {
    return ChatMessage.system("$userHistory ");
  }
}

///////////////////////////////////////////////////////////////////////////////
class GptApi {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('messages');
  getResponse(model, hitory, context) async {
    // List<Map<String, String>> messages = [];
    //////////
    // final openaiApiKeyp = Platform.environment[openAiKey]!;
    // final pineconeApiKeyp = Platform.environment[pineconeKey]!;
    // final embeddingsp = OpenAIEmbeddings(apiKey: openaiApiKeyp);
    // final vectorStorep = Pinecone(
    //     apiKey: pineconeApiKeyp,
    //     indexName: 'chat-index1',
    //     embeddings: embeddingsp);
    // final chunkSize = 1000;
    // final chunks = chunkText(hitory, chunkSize);
    // await addChunksToVectorStore(vectorStorep, chunks);

    // final res = await vectorStorep.similaritySearch(
    //   query: model,
    //   config: const PineconeSimilaritySearch(
    //     k: 2,
    //     scoreThreshold: 0.4,
    //     filter: {'history': 'person'},
    //   ),
    // );
    // print("👉 cone :$res ");

    //////////
    final getKey = Provider.of<GetKey>(context, listen: false);

    try {
      final pj = OpenAI(apiKey: getKey.apiKey);
      final messages = [
        ChatMessage.system(
            "first read this user history: context for answer related Question only if need from user chat history other wise own can answer but not say thats you can see chat history: ${hitory.toString()}"),
        ChatMessage.humanText(model)
      ];

      final sos = await pj.predictMessages(messages);
      final data =
          sos.contentAsString.replaceAll(RegExp(r'^\s*', multiLine: true), '');
      // final res =  http.post(
      //   Uri.parse('https://api.openai.com/v1/chat/completions'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Authorization': 'Bearer $openAiKey',
      //   },
      //   body: jsonEncode({
      //     "model": "gpt-3.5-turbo",
      //     "messages": [
      //       {"role": "user", "content": "$model"},
      //       // {
      //       //   "role": "system",
      //       //   "content": "my name is Hassan Ameer. my lisence number is 1010"
      //       // }
      //     ],
      //   }),
      // );
      int data1 = data.indexOf(':');
      String data2 = '';
      if (data1 != -1) {
        data2 = data.substring(data1 + 1).trim();
      } else {
        data2 = data;
      }
      // const text = 'when asked';
      // final messag = [ChatMessage.humanText(text)];

      // final res1 = await pj.invoke(PromptValue.string(text));
      // final res2 = await pj.invoke(PromptValue.chat(messag));
      // const template = ['array of data'];
      // const humanTemplate = '{text}';
      // final chat = ChatOpenAI(apiKey: '');

      // final chain = chat.pipe(model);
// Alternative syntax:
// final chain = chatPrompt | chatModel | CommaSeparatedListOutputParser();

      // if (res.statusCode == 200) {
      //   String content =
      //       jsonDecode(res.body)['choices'][0]['message']['content'];
      //   log("$content");
      //   _database.push().set({
      //     'mode': 2,
      //     'text': content,
      //     'sender': "chatGPT",
      //     // 'sender': _user?.email,
      //     'timestamp': ServerValue.timestamp,
      //   });
      //   // return ChatModel(message: content, mode: 2);
      // }
      // log("${res.body}");
      // ChatModel(message: "Failed to process your request", mode: -1);

      // final resd = await chain.invoke(chain as PromptValue);
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
          DateTime now = DateTime.now();
          String formattedDate = DateFormat('dd/MM/yyyy').format(now);
          databaseReference.child('chats').child(user.uid).push().set({
            'mode': 2,
            'text': data2.trim().isEmpty || data2.trim().length <= 1
                ? "Ok How can assist you"
                : data2,
            'sender': "chatGPT",
            // 'sender': _user?.email,
            'timestamp': ServerValue.timestamp,
            'date': formattedDate,
            // 'date': '25/12/2023',
          });
        }
      } catch (e) {
        debugPrint('$e');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Api Key Limit: $e'),
          // content: Text('$e'),
          duration: const Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {},
          ),
        ),
      );
    }
  }
}
///////////////

// List<String> chunkText(String text, int chunkSize) {
//   final chunks = <String>[];
//   for (int i = 0; i < text.length; i += chunkSize) {
//     chunks.add(text.substring(i, min(i + chunkSize, text.length)));
//   }
//   return chunks;
// }

// Future<void> addChunksToVectorStore(
//     Pinecone vectorStore, List<String> chunks) async {
//   for (int i = 0; i < chunks.length; i++) {
//     final chunk = chunks[i];
//     final documentId =
//         (i + 1).toString(); // You may want to use a more meaningful ID
//     await vectorStore.addDocuments(
//       documents: [
//         Document(
//           id: documentId,
//           pageContent: chunk,
//           metadata: {'chunk': i.toString()},
//         ),
//       ],
//     );
//   }
// }

// import "dart:developer";

// import "package:chatapp/model/ChatModel.dart";
// import "package:http/http.dart" as http;
// import "dart:convert";

// const String openAiKey = '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';
// // const String openAiKey = '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';

// class GptApi {
//   Future<ChatModel> getresponse(
//       List<ChatModel> model, List<ChatModel> previousUserChat) async {
//     List<Map<String, String>> messages = [];

//     /*  // adding data from history
//     for(int i = 0; i<previousUserChat.length; i++){
//       messages.add({
//         "role": previousUserChat[i].mode == 2 ? "assistant" : "user",
//         "content": previousUserChat[i].message
//       });
//     }

//     // adding current session chat history
//     for(int i = 0; i<model.length; i++){
//       messages.add({
//         "role": model[i].mode == 2 ? "assistant" : "user",
//         "content": model[i].message
//       });
//     }

//     // removing all the dublicates
//     List<Map<String, String>> uniqueMessages = [];
//     Set<String> uniqueContentSet = Set();

//     uniqueMessages.add({
//       "role" : "system",
//       "content" : "remember the following user details. my name is abdulrehman. my lisence number is 1010"
//     });

//     for (var message in messages) {
//       var content = message['content'];
//       if (!uniqueContentSet.contains(content)) {
//         uniqueContentSet.add(content!);
//         uniqueMessages.add(message);
//       }
//     }

//     log(uniqueMessages.toString());
// */

//     final res = await http.post(
//       Uri.parse('https://api.openai.com/v1/chat/completions'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $openAiKey',
//       },
//       body: jsonEncode({
//         "model": "gpt-3.5-turbo",
//         "messages": [
//           {"role": "user", "content": model.last.message},
//           {
//             "role": "system",
//             "content": "my name is Hassan Ameer. my lisence number is 1010"
//           }
//         ],
//       }),
//     );

//     if (res.statusCode == 200) {
//       String content = jsonDecode(res.body)['choices'][0]['message']['content'];
//       log("$content");
//       return ChatModel(message: content, mode: 2);
//     }
//     log("${res.body}");
//     return ChatModel(message: "Failed to process your request", mode: -1);
//   }
// }

// class ChatClass {
//   String openAiKey =
//       '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'; //// paid api
// // const String openAiKey = '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'; //// free api old

//   // langchain: ^0.3.0
//   // langchain_openai: ^0.3.0

//   getResponse(userinput, pdftext, context) async {
//     try {
//       final ai =
//           OpenAI(apiKey: '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');
//       final messages = [
//         ChatMessage.system("answer according to this: ${pdftext.toString()}"),
//         ChatMessage.humanText(userinput)
//       ];
//       final answer = await ai.predictMessages(messages);
//       debugPrint('🎉 Response: $answer');
//       // answer // its chat gpt response
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//   }
// }

/////////////////////////
 // const _apiKey =
                          //     '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';

                          // final result1 = await http.post(
                          //   Uri.parse(
                          //       'https://api.openai.com/v1/chat/completions'),
                          //   headers: {
                          //     'Content-Type': 'application/json',
                          //     'Authorization': 'Bearer $_apiKey',
                          //   },
                          //   body: jsonEncode({
                          //     "model": "gpt-3.5-turbo",
                          //     "messages": [
                          //       {"role": "user", "content": "$prompt"},
                          //       // {
                          //       //   "role": "system",
                          //       //   "content": "my name is Hassan Ameer. my lisence number is 1010"
                          //       // }
                          //     ],
                          //   }),
                          // );

                          // final resultDecode = jsonDecode(result1.body);
                          // debugPrint("👉" + resultDecode.toString());
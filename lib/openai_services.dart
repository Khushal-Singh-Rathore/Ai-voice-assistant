import 'dart:convert';

import 'package:chat_gpt/secreat.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OpenAIServices {
  List<Map<dynamic, dynamic>> messages = [];
  Future<String> isArtPromptAPI(String prompt) async {
    try {
      final res = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $key3'
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": [
              {
                'role': 'user',
                'content':
                    'Is the given statement ask to generate a AI image , picture , or something like that , $prompt , just answer with yes or no.'
              }
            ]
          }));
      print(res.body);
      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        switch (content) {
          case 'Yes':
          case 'yes':
          case 'Yes.':
          case 'yes.':
            final res = await dallEAPI(prompt);
            return res;
          default:
            final res = await chatGptAPI(prompt);
            return res;
        }
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> chatGptAPI(String prompt) async {
    // messages.add({'role': 'user', 'content': prompt});
    try {
      // print(' ---------------------> $prompt');
      final res = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $key3'
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": [
              {'role': 'user', 'content': prompt}
            ]
          }));
      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();
        // messages.add({'role': 'assistant', 'content': content});
        return content;
      }
      return 'Internal error occured';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> dallEAPI(String prompt) async {
    try {
      final res = await http.post(
          Uri.parse('https://api.openai.com/v1/images/generations'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $key3'
          },
          body: jsonEncode({
            'prompt': prompt,
            'n': 1,
          }));

      if (res.statusCode == 200) {
        String content = jsonDecode(res.body)['data'][0]['url'];
        content = content.trim();
        return content;
      }
      return 'An internal error occured';
    } catch (e) {
      return e.toString();
    }
  }
}

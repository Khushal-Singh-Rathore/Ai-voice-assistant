import 'package:animate_do/animate_do.dart';
import 'package:chat_gpt/colors.dart';
import 'package:chat_gpt/featuresList.dart';
import 'package:chat_gpt/openai_services.dart';
import 'package:chat_gpt/practice.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
// import 'package:flutter_tts/flutter_tts.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => homeScreenState();
}

class homeScreenState extends State<homeScreen> {
  final speechToText = SpeechToText();
  // final flutterTts = FlutterTts();
  String lastWords = '';
  String words = '';
  int start = 200;
  int delay = 200;
  String? generatedContent;
  String? generatedImageUrl;
  OpenAIServices openAIServices = OpenAIServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechToText();
    // initTextToSpeech();
  }

  // Future<void> initTextToSpeech() async {}
  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
      words = lastWords;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    speechToText.stop();
    // flutterTts.stop();
  }

  // Future<void> systemSpeak(String content) async {
  //   await flutterTts.speak(content);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(child: const Text('Eva')),
        leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: ListView(children: [
        Column(children: [
          //  virtual assistant image
          ZoomIn(
            child: Stack(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 4),
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue[100],
                    ),
                  ),
                ),
                Container(
                  height: 123,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/virtualAssistant.png'))),
                )
              ],
            ),
          ),
          FadeInRight(
            child: Visibility(
              visible: generatedImageUrl == null,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30)
                    .copyWith(top: 30),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blueGrey,
                    ),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
                child: Text(
                    generatedContent == null
                        ? 'Good Morning, what task can I do for you?'
                        : generatedContent!,
                    // textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: 'Cera Pro',
                        fontSize: generatedContent == null ? 25 : 18,
                        color: fontColor,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          ),
          if (generatedImageUrl != null)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(generatedImageUrl!)),
            ),

          Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: Column(
                children: [
                  SlideInLeft(
                    child: Container(
                      padding: const EdgeInsets.only(left: 25, top: 10),
                      alignment: Alignment.topLeft,
                      child: Text('Here are a few features',
                          style: TextStyle(
                              fontFamily: 'Cera Pro',
                              color: fontColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start),
                    child: featuresList(
                        color: s1boxColor,
                        heading: 'ChatGPT',
                        description:
                            'A smarter way to stay organized and informed with ChatGPT'),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + delay),
                    child: featuresList(
                        color: s2boxColor,
                        heading: 'Dall-E',
                        description:
                            'Get inspired and stay creative wiht your personal assistant powered by Dall-E'),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + delay * 2),
                    child: featuresList(
                        color: s3boxColor,
                        heading: 'Smart Voice Assistant',
                        description:
                            'Get the best of both worlds wiht a voice assistant powered by Dall-E and ChatGPT'),
                  ),
                ],
              )),
        ]),
      ]),
      floatingActionButton: ZoomIn(
        delay: Duration(milliseconds: start + delay * 3),
        child: FloatingActionButton(
          onPressed: () async {
            if (await speechToText.hasPermission &&
                speechToText.isNotListening) {
              await startListening();
            } else if (speechToText.isListening) {
              final speech = await openAIServices.isArtPromptAPI(lastWords);
              if (speech.contains('https')) {
                generatedImageUrl = speech;
                generatedContent = null;
                setState(() {});
              } else {
                generatedContent = speech;
                generatedImageUrl = null;
                setState(() {});
                // await systemSpeak(speech);
              }
              print(speech);
              await stopListening();
            } else {
              initSpeechToText();
            }
          },
          elevation: 30,
          backgroundColor: s1boxColor,
          child: Icon(
            speechToText.isNotListening ? Icons.mic : Icons.stop,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

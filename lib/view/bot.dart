import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  // ignore: library_private_types_in_public_api
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final DialogFlowtter dialogFlowtter = DialogFlowtter();

  final TextEditingController _controller = TextEditingController();
  FlutterTts flutterTts = FlutterTts();

  List<Map<String, dynamic>> messages = [];
  String place = '';

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        await Geolocator.openLocationSettings();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    print('Location: ${placemarks.first.locality}');
    setState({
      place = placemarks.first.locality as String,
    } as VoidCallback);
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  playText(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.6);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ''),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index]['message'] as Message;
                final isUserMessage = messages[index]['isUserMessage'] as bool;

                return ListTile(
                  title: Text(
                    message.text?.text?.join(', ') ?? '',
                    style: TextStyle(
                        color: isUserMessage ? Colors.blue : Colors.white),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            color: Colors.blue,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    sendMessage(_controller.text);
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // void sendMessage(String text) async {
  //   print('sendMessage is initialize');
  //   if (text.isEmpty) return;

  //   setState(() {
  //     addMessage(
  //       Message(text: DialogText(text: [text])),
  //       true,
  //     );
  //   });

  //   try {
  //     DetectIntentResponse response = await dialogFlowtter.detectIntent(
  //       queryInput: QueryInput(text: TextInput(text: text)),
  //     );

  //     String? textResponse = response.text;

  //     print('getMessage is initialize');

  //     print(response);

  //     print('getMessage is ended');

  //     if (response.message == null) {
  //       print('Error: ${response.queryResult?.diagnosticInfo?.toString()}');
  //       return;
  //     }

  //     setState(() {
  //       addMessage(Message(
  //           text: DialogText(text: [textResponse ?? 'No response found'])));
  //     });
  //   } catch (error) {
  //     print('Error during request: $error');
  //   }
  // }

  // void sendMessage(String text) async {
  //   print('sendMessage is initialize');
  //   if (text.isEmpty) return;

  //   setState(() {
  //     addMessage(
  //       Message(text: DialogText(text: [text])),
  //       true, // Set isUserMessage to true for user messages
  //     );
  //   });

  //   try {
  //     DetectIntentResponse response = await dialogFlowtter.detectIntent(
  //       queryInput: QueryInput(text: TextInput(text: text)),
  //     );

  //     String? textResponse = response.text;

  //     print('getMessage is initialize');
  //     print(response.text);
  //     print('getMessage is ended');

  //     if (response.message == null) {
  //       print('Error: ${response.queryResult?.diagnosticInfo?.toString()}');
  //       return;
  //     }

  //     setState(() {
  //       addMessage(
  //         Message(
  //             text: DialogText(text: [textResponse ?? 'No response found'])),
  //         false, // Set isUserMessage to false for bot messages
  //       );
  //     });
  //   } catch (error) {
  //     print('Error during request: $error');
  //   }
  // }

  // void addMessage(Message message, [bool? isUserMessage]) {
  //   messages.add({
  //     'message': message,
  //     'isUserMessage': isUserMessage ?? false,
  //   });

  //   // Access the text content from the nested structures
  //   String? textContent = message.text?.text?.first;

  //   if (textContent != null) {
  //     if (textContent == 'getLocation') {
  //       playText('Your located at $place');
  //       print('Your located at $place');
  //     } else {
  //       playText(textContent);

  //       print('Text Content: $textContent');
  //     }
  //   } else {
  //     print('No text available');
  //   }
  // }

  void addMessage(Message message, {bool isUserMessage = true}) {
    messages.add({
      'message': message,
      'isUserMessage': isUserMessage,
    });

    // Access the text content from the nested structures
    String? textContent = message.text?.text?.first;

    if (textContent != null && !isUserMessage) {
      if (textContent == 'getLocation') {
        playText('Your located at $place');
        print('Your located at $place');
      } else {
        playText(textContent);
        print('Text Content: $textContent');
      }
    } else {
      print('No text available');
    }
  }

  void sendMessage(String text) async {
    print('sendMessage is initialize');
    if (text.isEmpty) return;

    setState(() {
      addMessage(
        Message(text: DialogText(text: [text])),
        isUserMessage: true, // Set isUserMessage to true for user messages
      );
    });

    try {
      DetectIntentResponse response = await dialogFlowtter.detectIntent(
        queryInput: QueryInput(text: TextInput(text: text)),
      );

      String? textResponse = response.text;

      print('getMessage is initialize');
      print(response.text);
      print('getMessage is ended');

      if (response.message == null) {
        print('Error: ${response.queryResult?.diagnosticInfo?.toString()}');
        return;
      }

      setState(() {
        addMessage(
          Message(
              text: DialogText(text: [textResponse ?? 'No response found'])),
          isUserMessage: false, // Set isUserMessage to false for bot messages
        );
      });
    } catch (error) {
      print('Error during request: $error');
    }
  }
}

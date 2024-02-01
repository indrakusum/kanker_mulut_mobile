import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hama Caisim Prediction',
      theme: ThemeData(
        primaryColor: Colors.blue,
        hintColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.blue,
        ),
      ),
      home: const PredictView(),
    );
  }
}

class PredictView extends StatefulWidget {
  const PredictView({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<PredictView> {
  File? _file;
  String? prediction = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        title: const Text('prediksi kanker mulut'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.lightGreen, Colors.green],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildImagePreview(),
                const SizedBox(height: 16),
                _buildPredictionText(),
                const SizedBox(height: 16),
                _buildButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return _file == null
        ? Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.photo,
                size: 50,
                color: Colors.grey,
              ),
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              _file!,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
          );
  }

  Widget _buildPredictionText() {
    String formattedPrediction = _formatPrediction(prediction);

    return Text(
      formattedPrediction,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.black,
      ),
    );
  }

  String _formatPrediction(String? jsonPrediction) {
    if (jsonPrediction == null) {
      return "No prediction available";
    }

    try {
      Map<String, dynamic> predictionMap = jsonDecode(jsonPrediction);
      String result = predictionMap["label"];
      return "Prediction: $result";
    } catch (e) {
      return "";
    }
  }

  Widget _buildButtons() {
    return Column(
      children: <Widget>[
        ElevatedButton.icon(
          onPressed: () => uploadImage(),
          icon: const Icon(FontAwesomeIcons.upload),
          label: const Text("Upload Image"),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () async {
            await predict();
            print("Prediction Result: $prediction");
          },
          icon: const Icon(FontAwesomeIcons.wandMagic),
          label: const Text("Predict"),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.white,
          ),
        ),
      ],
    );
  }

  Future<void> uploadImage() async {
    final myfile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (myfile == null) return;

    setState(() {
      _file = File(myfile.path);
      prediction = "";
    });
  }

  Future<void> predict() async {
    if (_file == null) return;

    var uri =   
        Uri.parse("https://9034-103-166-147-253.ngrok-free.app//predict_mobile");

    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile(
      'file',
      http.ByteStream(Stream.castFrom(_file!.openRead())),
      _file!.lengthSync(),
      filename: _file!.path.split("/").last,
      contentType: MediaType('image', 'jpeg'),
    );

    request.files.add(multipartFile);

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        setState(() {
          prediction = responseBody;
        });
      } else {
        print("Image upload failed.");
      }
    } catch (e) {
      print("Error uploading image: $e");
    }
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:http_parser/http_parser.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Siap Jalan',
//       theme: ThemeData(),
//       home: const Test1(),
//     );
//   }
// }

// class Test1 extends StatefulWidget {
//   const Test1({Key? key}) : super(key: key);

//   @override
//   _TestState createState() => _TestState();
// }

// class _TestState extends State<Test1> {
//   File? _file;
//   String? prediction = "";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Siap Jalan'),
//       ),
//       body: SingleChildScrollView(
//         controller: ScrollController(),
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(25.0),
//             child: Align(
//               alignment: Alignment.bottomCenter,
//               child: Column(
//                 children: <Widget>[
//                   _file == null
//                       ? const Text("Foto Tidak Ditemukan")
//                       : Image.file(_file!),
//                   const SizedBox(height: 16),
//                   Text(prediction ?? ""), // Menampilkan hasil prediksi di sini
//                   const SizedBox(height: 16),
//                   _buildButtons(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildButtons() {
//     return Column(
//       children: <Widget>[
//         ElevatedButton(
//           onPressed: () => uploadImage(),
//           child: const Text("Unggah"),
//         ),
//         const SizedBox(height: 16),
//         ElevatedButton(
//           onPressed: () async {
//             await predict(); // Panggil fungsi predict
//             // Setelah prediksi selesai, Anda dapat mengakses nilai 'prediction' di sini
//             print(" Hasil Prediksi: $prediction");
//           },
//           child: const Text("Mulai Prediksi"), // Tombol "Predict"
//         ),
//       ],
//     );
//   }

//   Future<void> uploadImage() async {
//     final myfile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (myfile == null) return;

//     setState(() {
//       _file = File(myfile.path);
//       prediction = ""; // Reset hasil prediksi saat mengunggah gambar baru
//     });
//   }

//   Future<void> predict() async {
//     if (_file == null) return;

//     var uri = Uri.parse("http://10.0.2.2:5000/predict"); // URL endpoint Flask

//     var request = http.MultipartRequest("POST", uri);
//     var multipartFile = http.MultipartFile(
//       'file',
//       http.ByteStream(Stream.castFrom(_file!.openRead())),
//       _file!.lengthSync(),
//       filename: _file!.path.split("/").last,
//       contentType: MediaType('image', 'jpeg'),
//     );

//     request.files.add(multipartFile);

//     try {
//       var response = await request.send();
//       if (response.statusCode == 200) {
//         var responseBody = await response.stream.bytesToString();
//         setState(() {
//           prediction = responseBody; // Menyimpan hasil prediksi
//         });
//       } else {
//         print("Gagal Unggah Gambar.");
//       }
//     } catch (e) {
//       print("Error Unggah Gambar: $e");
//     }
//   }
// }
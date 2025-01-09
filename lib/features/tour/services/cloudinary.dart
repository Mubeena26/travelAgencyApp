// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:path/path.dart';

// Future<String> uploadImageToCloudinary(File imageFile) async {
//   final cloudName = 'dbgvn6kup';
//   final apiKey = '351541992828455';
//   final apiSecret = 'SZZPcZ5-iV2hqaoNalu1lcDyFTk';

//   final uri =
//       Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

//   final request = http.MultipartRequest('POST', uri)
//     ..fields['upload_preset'] = 'your_preset_here' // Replace with your preset
//     ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

//   final response = await request.send();

//   if (response.statusCode == 200) {
//     final responseData = await response.stream.toBytes();
//     final responseString = String.fromCharCodes(responseData);
//     final jsonResponse = jsonDecode(responseString);
//     return jsonResponse['secure_url']; // Returns the image URL
//   } else {
//     throw Exception('Failed to upload image');
//   }
// }
// File? _selectedImage;
//   String? _imageUrl;
  

//   Future<void> _pickImage( ImageSource source) async {
//     final ImagePicker _picker = ImagePicker();
    
    
// final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//       if (pickedFile != null) {
//         setState(() {
//           _selectedImage = File(pickedFile.path);
//         });
//       } else {
//         print('No image selected.');
//       }
//     } 

  

//   Future<void>_uploadImage()async{
//     final url=
//     Uri.parse('https://api.cloudinary.com/v1_1/dbgvn6kup/upload');
//     // my_upload_preset
//  final request = http.MultipartRequest('POST', url)
//  ..fields['upload_preset']='my_upload_preset'
//  ..files.add(await http.MultipartFile.fromPath('file', _selectedImage!.path));
//  final response = await request.send();
//  if (response.statusCode==200){
//  final responseData = await response.stream.toBytes();
//      final responseString = String.fromCharCodes(responseData);
//   final jsonMap = jsonDecode(responseString);
//   setState((){
//     final url = jsonMap['url'];
//     _imageUrl =url;
//   });
//  }
//   }
// }
// // @dart=2.9
//
// import 'dart:async';
// import 'dart:html';
// import 'package:admin_umbizz/MainScreens/home.dart';
// import 'package:admin_umbizz/Service/blog_database.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image_picker_web/image_picker_web.dart';
// import 'package:random_string/random_string.dart';
// import 'package:universal_html/html.dart' as html;
// import 'package:firebase/firebase.dart' as fb;
//
//
// class CreateBlog extends StatefulWidget {
//   @override
//   _CreateBlogState createState() => _CreateBlogState();
// }
//
// class _CreateBlogState extends State<CreateBlog> {
//   String authorName, title, desc;
//   FirebaseAuth auth;
//
//   html.File image;
//   final picker = ImagePicker();
//   var downloadUrl;
//   //File selectedImage;
//
//   var selectedImage;
//   bool _isLoading = false;
//   CrudMethods crudMethods = new CrudMethods();
//   firebase_storage.Reference ref;
//
//   Uri imageUri;
//
//
//   Future getImage() async {
//
//     final image = await picker.getImage(source: ImageSource.gallery);
//     File file = File(image.path);
//
//     setState(() {
//       selectedImage = file;
//     });
//
//     var image = await ImagePickerWeb.getImage(outputType: ImageType.widget);
//
//     if (image != null) {
//       setState(() {
//         selectedImage = image;
//       });
//     }
//   }
//
//   Future<String> getFile() {
//     final completer = new Completer<String>();
//     final InputElement input = document.createElement('input');
//     input
//       ..type = 'file'
//       ..accept = 'image/*';
//     input.onChange.listen((e) async {
//       final List<File> files = input.files;
//       final reader = new FileReader();
//       reader.readAsDataUrl(files[0]);
//       reader.onError.listen((error) => completer.completeError(error));
//       await reader.onLoad.first;
//       completer.complete(reader.result as String);
//     });
//     input.click();
//     return completer.future;
//   }
//
//   // uploadBlog() async {
//   //
//   //
//   //   if (selected != null) {
//   //     setState(() {
//   //       _isLoading = true;
//   //     });
//   //
//   //
//   //
//   //     /// uploading image to firebase storage
//   //     ref = firebase_storage.FirebaseStorage.instance
//   //         .ref()
//   //         .child("blogImages")
//   //         .child("${randomAlphaNumeric(9)}.jpg");
//   //
//   //     fb.StorageReference storageRef = fb.storage().ref('images/$selected');
//   //     fb.UploadTaskSnapshot uploadTaskSnapshot = await storageRef.put(selected).future;
//   //
//   //     imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
//   //
//   //
//   //
//   //     // await ref.putFile(selectedImage).whenComplete(() async{
//   //     //   await ref.getDownloadURL().then((value){
//   //     //
//   //     //     downloadUrl = value;
//   //     //   });
//   //     // });
//   //
//   //     print("this is url $imageUri");
//   //
//   //     Map<String, String> blogMap = {
//   //       "imgUrl": imageUri.toString(),
//   //       "authorName": authorName,
//   //       "title": title,
//   //       "desc": desc
//   //     };
//   //     crudMethods.addData(blogMap).then((result) {
//   //       Navigator.pop(context);
//   //     });
//   //   } else {}
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: BackButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => HomeScreen()),
//               );
//             }
//         ),
//         flexibleSpace: Container(
//           decoration: new BoxDecoration(
//             gradient: new LinearGradient(
//               colors: [
//                 Colors.deepPurple[300],
//                 Colors.blue,
//
//                 // Colors.lightBlueAccent,
//                 // Colors.blueAccent,
//
//                 // Colors.blueGrey,
//                 // Colors.grey,
//               ],
//               begin: const FractionalOffset(0.0, 0.0),
//               end: const FractionalOffset(1.0, 0.0),
//               stops: [0.0, 1.0],
//             ),
//           ),
//         ),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               "Business Tips Manager",
//               style: TextStyle(fontSize: 22),
//             )
//           ],
//         ),
//         //backgroundColor: Colors.transparent,
//         elevation: 0.0,
//         actions: <Widget>[
//           GestureDetector(
//             onTap: () {
//               //uploadBlog();
//             },
//             child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16),
//                 child: Icon(Icons.file_upload)),
//           )
//         ],
//       ),
//       body: _isLoading
//           ? Container(
//         alignment: Alignment.center,
//         child: CircularProgressIndicator(),
//       )
//           : Container(
//         child: Column(
//           children: <Widget>[
//             SizedBox(
//               height: 10,
//             ),
//             GestureDetector(
//                 onTap: () {
//                   getFile();
//                 },
//                 child: selectedImage != null
//                     ? Container(
//                   margin: EdgeInsets.symmetric(horizontal: 16),
//                   height: 170,
//                   width: MediaQuery.of(context).size.width,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(6),
//                         child: Image.file(
//                         selectedImage,
//                         fit: BoxFit.cover,
//                     ),
//                   ),
//                 )
//                     : Container(
//                   margin: EdgeInsets.symmetric(horizontal: 16),
//                   height: 170,
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(6)),
//                   width: MediaQuery.of(context).size.width,
//                   child: Icon(
//                     Icons.add_a_photo,
//                     color: Colors.black45,
//                   ),
//                 )),
//             SizedBox(
//               height: 8,
//             ),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 children: <Widget>[
//                   TextField(
//                     decoration: InputDecoration(hintText: "Author Name"),
//                     onChanged: (val) {
//                       authorName = val;
//                     },
//                   ),
//                   TextField(
//                     decoration: InputDecoration(hintText: "Title"),
//                     onChanged: (val) {
//                       title = val;
//                     },
//                   ),
//                   TextField(
//                     decoration: InputDecoration(hintText: "Description"),
//                     onChanged: (val) {
//                       desc = val;
//                     },
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
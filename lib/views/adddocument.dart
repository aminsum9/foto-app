// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../config/url.dart' as host;
// import '../../styles/colors.dart' as colors;
// // import '../../helper/handle_url.dart' as handle_url;

// class AddProduct extends StatefulWidget {
//   const AddProduct({super.key});
//   @override
//   AddWarehouseState createState() => AddWarehouseState();
// }

// class AddWarehouseState extends State<AddProduct> {
//   TextEditingController controllerName = TextEditingController(text: "");
//   TextEditingController controllerPrice = TextEditingController(text: "");
//   TextEditingController controllerDiscount = TextEditingController(text: "");
//   TextEditingController controllerStock = TextEditingController(text: "");
//   TextEditingController controllerDesc = TextEditingController(text: "");
//   //
//   String? imageName = "";
//   File imageProduct = File("");

//   Future<File> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     final imagePath = pickedFile != null ? pickedFile.path : "";

//     setState(() {
//       imageName = imagePath;
//       imageProduct = File(imagePath);
//     });
//     return File(imagePath);
//   }

//   Future<String> getDataStorage(String key) async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(key).toString();
//   }

//   void addDataProduct() async {
//     var token = await getDataStorage('token');
//     var partnerId = await getDataStorage('partner_id');

//     var url = Uri.parse("${host.baseUrl}product/add");

//     var image = imageProduct;

//     var request = http.MultipartRequest("POST", url);

//     request.headers["Authorization"] = 'Bearer $token';

//     request.fields['product_name'] = controllerName.text;
//     request.fields['product_price'] = controllerPrice.text.toString();
//     request.fields['product_discount'] = controllerDiscount.text.toString();
//     request.fields['product_qty'] = controllerStock.text.toString();
//     request.fields['product_desc'] = controllerDesc.text;
//     request.fields['partner_id'] = partnerId;

//     if (image.path != "" && image.path != null) {
//       request.files.add(await http.MultipartFile.fromPath(
//         'product_image',
//         image.path,
//       ));
//     }

//     final response = await request.send();

//     final respBody = await response.stream.bytesToString();

//     if (response.statusCode == 200) {
//       final decodedMap = await json.decode(respBody);

//       if (decodedMap['success']) {
//         //kadang error karena ditambah pengondisian respnse success
//         showDialog<void>(
//           context: context,
//           barrierDismissible: false, // user must tap button!
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text('Berhasil menambah produk baru.'),
//               // content: Text(jsonDecode(response.toString())['message']),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () => Navigator.pushNamed(context, '/home'),
//                   child:
//                       const Text("OK", style: TextStyle(color: Colors.green)),
//                 ),
//               ],
//             );
//           },
//         );
//       } else if (decodedMap['message'] != null) {
//         showDialog<void>(
//           context: context,
//           barrierDismissible: false, // user must tap button!
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text('Gagal menambah produk'),
//               content: Text(decodedMap['message']),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child:
//                       const Text("OK", style: TextStyle(color: Colors.green)),
//                 )
//               ],
//             );
//           },
//         );
//       }
//     } else {
//       showDialog<void>(
//         context: context,
//         barrierDismissible: false, // user must tap button!
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Gagal melakukan transaksi!'),
//             content: const Text("Terjadi kesalahan pada server."),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text("OK", style: TextStyle(color: Colors.green)),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Tambah Produk",
//             style: TextStyle(color: colors.secondaryColor)),
//         backgroundColor: Colors.white,
//         shadowColor: Colors.transparent,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: colors.secondaryColor),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Container(
//           padding: const EdgeInsets.all(20.0),
//           child: ListView(children: [
//             Column(
//               children: [
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     imageName != ""
//                         ? (SizedBox(
//                             width: 100,
//                             height: 100,
//                             child: ClipRRect(
//                                 // borderRadius: BorderRadius.circular(100.0),
//                                 child: Image.file(
//                               imageProduct,
//                               fit: BoxFit.fill,
//                             ))))
//                         : (const ClipRRect(
//                             // borderRadius: BorderRadius.circular(100.0),
//                             child: SizedBox(
//                               width: 100.0,
//                               height: 100.0,
//                               child: Icon(Icons.widgets,
//                                   color: Colors.blueGrey, size: 100.0),
//                             ),
//                           )),
//                     imageName == ""
//                         ? (TextButton(
//                             onPressed: () async {
//                               _pickImage();
//                             },
//                             child: const Text("Pilih gambar")))
//                         : (TextButton(
//                             onPressed: () async {
//                               setState(() {
//                                 imageName = "";
//                                 imageProduct = File("");
//                               });
//                             },
//                             child: const Text("Hapus gambar")))
//                   ],
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.all(10.0),
//                 ),
//                 TextField(
//                   controller: controllerName,
//                   decoration: InputDecoration(
//                       hintText: "masukkan nama produk",
//                       labelText: "Nama",
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20.0))),
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.all(10.0),
//                 ),
//                 TextField(
//                   controller: controllerPrice,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                       hintText: "masukkan harga produk",
//                       labelText: "Harga",
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20.0))),
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.all(10.0),
//                 ),
//                 TextField(
//                   controller: controllerDiscount,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                       hintText: "masukkan diskon produk",
//                       labelText: "Diskon",
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20.0))),
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.all(10.0),
//                 ),
//                 TextField(
//                   controller: controllerStock,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                       hintText: "masukkan qty produk",
//                       labelText: "Qty",
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20.0))),
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.all(10.0),
//                 ),
//                 TextField(
//                   controller: controllerDesc,
//                   decoration: InputDecoration(
//                       hintText: "masukkan deskripsi produk",
//                       labelText: "Deskripsi produk",
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20.0))),
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.all(20.0),
//                 ),
//               ],
//             ),
//           ])),
//       bottomNavigationBar: Container(
//         margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
//         child: TextButton(
//           onPressed: () {
//             addDataProduct();
//           },
//           style: TextButton.styleFrom(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               backgroundColor: colors.secondaryColor,
//               padding: const EdgeInsets.all(15)),
//           child: const Text("TAMBAH PRODUK",
//               style: TextStyle(color: Colors.white)),
//         ),
//       ),
//     );
//   }
// }
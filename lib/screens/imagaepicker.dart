import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? image;
  final _picker = ImagePicker();
  bool showSpinner = false;
  Future getImage() async {
    final imagepick =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (imagepick != null) {
      image = File(imagepick.path);
      setState(() {});
    } else {
      print("Image Not Found");
    }
  }

  Future uploadImage() async {
    setState(() {
      showSpinner = true;
    });
    var stream = http.ByteStream(image!.openRead());
    var lenght = await image!.length();
    var uri = Uri.parse("https://fakestoreapi.com/products");
    var request = http.MultipartRequest('POST', uri);
    var mutiPort = http.MultipartFile('image', stream, lenght);
    request.files.add(mutiPort);
    var response = await request.send();
    if (response.statusCode == 200) {
      setState(() {
        showSpinner = false;
      });
      print("Uploaded Successfully");
    } else {
      setState(() {
        showSpinner = false;
      });
      print("Uploaded Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
          appBar: AppBar(title: const Text("Upload Image")),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    print("tap");
                    getImage();
                  },
                  child: Center(
                    child: Container(
                        child: image == null
                            ? const Center(child: Text("Image Pick"))
                            : Container(
                                decoration: const BoxDecoration(),
                                height: 200,
                                width: 200,
                                child: Image.file(File(image!.path).absolute))),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                InkWell(
                  onTap: (() {
                    uploadImage();
                    print("upload");
                  }),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10)),
                    height: 50,
                    child: const Center(child: Text("Upload Image")),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

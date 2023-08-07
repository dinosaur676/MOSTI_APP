import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_hour/manager/address_manager.dart';

import '../utils/next_screen.dart';
import 'home.dart';

class ImageLoadingPage extends StatefulWidget {
  const ImageLoadingPage({Key? key}) : super(key: key);

  @override
  State<ImageLoadingPage> createState() => _ImageLoadingPageState();
}

class _ImageLoadingPageState extends State<ImageLoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
    );
  }

  test() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    // final response = await GetIt.I<AddressManager>().setMainCode(pickedFile);
    //
    // if (response) {
    //   print("test");
    // }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    test();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/screens/pdf_compresser.dart';
import '../screens/image_processer.dart';
import '../utils/colors.dart';

List<Widget> homeScreenItems = [
  const ImageProcesser(
    title: 'Object Processing App',
  ),
  const PDFcompressor()
];

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController; // for tabs animation
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.wrap_text,
              color: (_page == 0) ? primaryColor : secondaryColor,
            ),
            label: 'Image to Text',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.compress_outlined,
                color: (_page == 1) ? primaryColor : secondaryColor,
              ),
              label: 'PDF Compressor',
              backgroundColor: primaryColor),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}

import 'package:keeper/Screens/nav_pages/Login_page.dart';
import 'package:keeper/Screens/nav_pages/registration_page.dart';
import 'package:keeper/widgets/App_Large_Text.dart';
import 'package:keeper/widgets/App_text.dart';
import 'package:keeper/widgets/responsive_button.dart';
import 'package:flutter/material.dart';

class SliderPage extends StatefulWidget {
  static const id = 'scroller_screen';

  @override
  State<SliderPage> createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  List images = ['image-3.jpg', 'image-2.jpg', 'image-1.jpg'];
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: images.length,
          itemBuilder: (_, index) {
            return Container(
              width: double.maxFinite,
              height: double.maxFinite,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/' + images[index]),
                    fit: BoxFit.cover),
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 70, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppLargeText(
                          text: 'Book Keeping',
                          color: Colors.black,
                        ),
                        AppText(
                          text: 'A Necessity!',
                          color: Colors.black,
                          size: 20,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 250,
                          child: AppText(
                            text: 'Manage your important files at a go!',
                            color: Colors.black,
                            size: 14,
                          ),
                        ),
                        SizedBox(
                          height: 300,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    });
                                Navigator.pushNamed(context, LoginPage.id);
                              },
                              child: ResponsiveButton(
                                text: 'Log in',
                                width: 120,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                );
                                Navigator.pushNamed(
                                    context, Registration_Page.id);
                              },
                              child: ResponsiveButton(
                                text: 'Register',
                                width: 120,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: List.generate(
                        3,
                        (indexDots) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 2),
                            width: 8,
                            height: index == indexDots ? 25 : 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: index == indexDots
                                  ? Colors.blue
                                  : Colors.blue.withOpacity(0.3),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

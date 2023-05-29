import 'package:keeper/Screens/nav_pages/bar_item_page.dart';
import 'package:flutter/material.dart';

class CookBookTile extends StatelessWidget {
  const CookBookTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
      child: Container(
        padding: EdgeInsets.all(12),
        width: 200,
        //color: Colors.grey,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black54,
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset('images/cashbook.jpg'),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: const [
                Text('MANAGE YOUR FINANCES'),
              ],
            ),
            RaisedButton(
              textColor: Colors.black,
              child: const Text(
                'See All Your Records',
              ),
              color: Colors.orange.shade400,
              onPressed: () {
                Navigator.pushNamed(context, BarItemPage.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

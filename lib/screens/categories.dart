import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/text_widget.dart';

import '../widgets/categories_widget.dart';

class CategoriesScreen extends StatelessWidget {
   CategoriesScreen({Key? key}) : super(key: key);

  List<Color> gridColors = [
    const Color(0xff53B175),
    const Color(0xffF8A44C),
    const Color(0xffF7A593),
    const Color(0xffD3B0E0),
    const Color(0xffFDE598),
    const Color(0xffB7DFF5),
  ];

List<Map<String, dynamic>> catInfo = [
    {
      'imgPath': 'assets/images/cat/fruits.png',
      'catText': 'Trái cây',
    },
    {
      'imgPath': 'assets/images/cat/veg.png',
      'catText': 'Rau củ',
    },
    {
      'imgPath': 'assets/images/cat/Spinach.png',
      'catText': 'Thảo mộc',
    },
    {
      'imgPath': 'assets/images/cat/nuts.png',
      'catText': 'Quả hạch',
    },
    {
      'imgPath': 'assets/images/cat/spices.png',
      'catText': 'Gia vị',
    },
     {
      'imgPath': 'assets/images/cat/grains.png',
      'catText': 'Các loại hạt',
    },
  ];
  @override
  Widget build(BuildContext context) {

    final utils = Utils(context);
    Color color = utils.color;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: TextWidget(
            text: 'Danh mục',
            color: color,
            textSize: 22,
            isTitle: true,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 240 / 250,
            crossAxisSpacing: 10, // Vertical spacing
            mainAxisSpacing: 10, // Horizontal spacing 
            children: List.generate(6, (index) {
              return CategoriesWidget(
                catText: catInfo[index]['catText'],
                imgPath: catInfo[index]['imgPath'],
                passedColor: gridColors[index],
              );
            }),
          ),
        ));
  }
}
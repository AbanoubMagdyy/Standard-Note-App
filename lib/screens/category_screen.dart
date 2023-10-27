import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:standard_fivver_note_app/components/components.dart';
import 'package:standard_fivver_note_app/screens/view_category_screen.dart';
import 'package:standard_fivver_note_app/style/colors.dart';
import '../models/category_model.dart';
import '../shared/add_note_bloc/cubit.dart';
import '../shared/add_note_bloc/states.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AddNoteCubit, AddNotesStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AddNoteCubit.get(context);
        final List<CategoryModel> categories = [
          CategoryModel(
            image: 'assets/images/harry_potter.webp',
            name: 'Harry Potter',
            numberOfItem: cubit.harryPotter.length,
          ),
          CategoryModel(
            image: 'assets/images/characters/albus_dumbledore.jpg',
            name: 'Albus Dumbledore',
            numberOfItem: cubit.albusDumbledore.length,
          ),
          CategoryModel(
            image: 'assets/images/characters/ginny_weasley.jfif',
            name: 'Ginny Weasley',
            numberOfItem: cubit.ginnyWeasley.length,

          ),
          CategoryModel(
            image: 'assets/images/characters/hermione_granger.jpg',
            name: 'Hermione Granger',
            numberOfItem: cubit.hermioneGranger.length,

          ),
          CategoryModel(
            image: 'assets/images/characters/lord_voldemort.jpg',
            name: 'Lord Voldemort',
            numberOfItem: cubit.lordVoldemort.length,
          ),
          CategoryModel(
            image: 'assets/images/characters/neville_longbottom.jpg',
            name: 'Neville Longbottom',
            numberOfItem: cubit.nevilleLongbottom.length,
          ),
          CategoryModel(
            image: 'assets/images/characters/ron_weasley.jpg', name: 'Ron Weasley',
            numberOfItem: cubit.ronWeasley.length,

          ),
          CategoryModel(
            image: 'assets/images/characters/rubeus_hagrid.jpg',
            name: 'Rubeus Hagrid',
            numberOfItem: cubit.rubeusHagrid.length,

          ),
          CategoryModel(
            image: 'assets/images/characters/severus_snape.jpg',
            name: 'Severus Snape',
            numberOfItem: cubit.severusSnape.length,

          ),
          CategoryModel(
            image: 'assets/images/characters/sirius_black.jfif',
            name: 'Sirius Black',
            numberOfItem: cubit.siriusBlack.length,

          ),
        ];
        return  Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            itemCount: categories.length,
            itemBuilder: (context, index) =>categoryItem(categories[index],context),
            staggeredTileBuilder: (index) =>const StaggeredTile.count(
                1, 1)
          ),
        );
      },
    );
  }




   Widget categoryItem(CategoryModel model,context)=>InkWell(
     onTap: (){
       navigateTo(context,  ViewCategoryScreen(model: model,));
     },
     child: LayoutBuilder(
         builder: (BuildContext context, BoxConstraints constraints) {
           final screenSize = MediaQuery.of(context).size;
           final double fontSize = screenSize.width * 0.025;
           double radius = constraints.maxWidth / 5;
           return Container(
             color: defColor.withOpacity(0.6),
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 /// image
                 CircleAvatar(
                   radius: radius,
                   backgroundImage: AssetImage(model.image,),
                 ),
                 /// name
                   Padding(
                     padding: const EdgeInsets.symmetric(vertical:15),
                     child: Text(model.name.toUpperCase(),style:  TextStyle(
                         fontSize: fontSize,
                         fontWeight: FontWeight.bold,
                         color: secondColor
                     ),
                     ),
                   ),
                 /// number
                 Text('${model.numberOfItem} item',style: const TextStyle(
                     fontSize: 20,
                     fontWeight: FontWeight.bold,
                     color: secondColor
                 ),
                 ),
               ],
             ),
           );
         }
     ),
   );
}


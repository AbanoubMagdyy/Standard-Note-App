import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:standard_fivver_note_app/screens/background_image.dart';
import 'package:standard_fivver_note_app/shared/add_note_bloc/cubit.dart';
import 'package:standard_fivver_note_app/shared/add_note_bloc/states.dart';
import '../components/components.dart';
import '../models/category_model.dart';
import '../style/colors.dart';

class ViewCategoryScreen extends StatelessWidget {
 final  CategoryModel model;
 final double requiredHeight = 400;


 const ViewCategoryScreen({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddNoteCubit, AddNotesStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AddNoteCubit.get(context);
          late List list;
          switch (model.name) {
            case 'Harry Potter':
              list = cubit.harryPotter;
              break;
            case 'Hermione Granger':
              list = cubit.hermioneGranger;
              break;
            case 'Ron Weasley':
              list = cubit.ronWeasley;
              break;
            case 'Albus Dumbledore':
              list = cubit.albusDumbledore;
              break;
            case 'Lord Voldemort':
              list = cubit.lordVoldemort;
              break;
            case 'Severus Snape':
              list = cubit.severusSnape;
              break;
            case 'Sirius Black':
              list = cubit.siriusBlack;
              break;
            case 'Rubeus Hagrid':
              list = cubit.rubeusHagrid;
              break;
            case 'Ginny Weasley':
              list = cubit.ginnyWeasley;
              break;
            case 'Neville Longbottom':
              list = cubit.nevilleLongbottom;
              break;
          }

          return Scaffold(
            floatingActionButton:FloatingActionButton(
              onPressed: (){
                showModalBottomSheet(
                  context: context,
                  backgroundColor: defColor,
                  builder: (context) {
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsetsDirectional.all(10),
                          padding: const EdgeInsetsDirectional.all(15),
                          decoration: BoxDecoration(
                            color: secondColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('Add note to ${model.name.split(' ')[0]} category'.toUpperCase(),style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              if(cubit.notes[index]['category'] != model.name) {
                                return categoryItem(cubit.notes[index],context);
                              }else{
                                return Container();
                              }
                            },
                            itemCount: cubit.notes.length,
                            physics: const BouncingScrollPhysics(),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            child: const Icon(Icons.add),
            ) ,
            body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          final double availableHeight = constraints.maxHeight;
          final screenSize = MediaQuery.of(context).size;
          final double fontSize = screenSize.width * 0.03;
          return  BackgroundImage(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    /// APPBAR
                    if(requiredHeight <= availableHeight)
                      defAppBar(context: context, screenName: '${model.name} Category',textSize: fontSize),
                    if(list.isNotEmpty)
                      Expanded(
                        child: StaggeredGridView.countBuilder(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return optionNoteItem(context, list[index], index,cubit.notes[index]['id']);
                          },
                          staggeredTileBuilder: (index) {
                            return index == 0
                                ? const StaggeredTile.count(1, 1.0) //For Text
                                : const StaggeredTile.count(1, 1.2); // others item
                          },
                        ),
                      ),
                    if(list.isEmpty)
                      ifNotesEmpty(),
                  ],
                ),
              ),
            ),
          );
            }
            ),
          );
        },
    );
  }

 Widget categoryItem(listModel,context) => InkWell(
   onTap: (){
     AddNoteCubit.get(context).updateCategory(category: model.name, id: listModel['id']).then((value) {
       toast(msg: 'Add note to ${model.name} category success', isError: false);
     });
     Navigator.pop(context);
   },
   child: Container(
     margin: const EdgeInsetsDirectional.all(10),
     padding: const EdgeInsetsDirectional.all(15),
     decoration: BoxDecoration(
       color: secondColor,
       borderRadius: BorderRadius.circular(20),
     ),
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children:
       [
         if(listModel['title'] !='')
         Text(listModel['title'].toUpperCase(),style: const TextStyle(
             fontSize: 25,
             fontWeight: FontWeight.bold
         ),
         ),
         if(listModel['note'] !='')
           Text(listModel['note'].toUpperCase(),
             maxLines: 2,
             overflow: TextOverflow.ellipsis,
             style: const TextStyle(
             fontSize: 20,
             fontWeight: FontWeight.bold
         ),
         ),
       ],
     ),
   ),
 );


}

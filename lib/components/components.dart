import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import '../models/category_model.dart';
import '../models/note_model.dart';
import '../screens/note_screen.dart';
import '../shared/add_note_bloc/cubit.dart';
import '../style/colors.dart';
import 'constants.dart';

Widget defTextField({
  required TextEditingController controller,
  required IconData icon,
  IconData? leftIcon,
  required String text,
  void Function()? onTap,
  void Function()? leftIconOnPressed,
  double fontSize = 25,
  bool hideInput = false,
  TextInputType keyboard = TextInputType.text,
  bool hideKeyboard = false,
}) =>
    TextFormField(
      readOnly: hideKeyboard,
      obscureText: hideInput,
      keyboardType: keyboard,
      style: TextStyle(
        fontSize: fontSize,
        wordSpacing: 5,
        fontWeight: FontWeight.bold,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter some information';
        }
        return null;
      },
      onTap: onTap,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: defColor,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: defColor,
          ),
        ),
        prefixIcon: Icon(
          icon,
          color: defColor,
        ),
        suffixIcon: IconButton(
          onPressed: () {},
          icon: Icon(leftIcon),
        ),
        hintText: text.toUpperCase(),
        hintStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

Widget defTextButton({
  required String text,
  required void Function()? onTap,
}) =>
    Container(
      height: 60,
      width: 210,
      margin: const EdgeInsetsDirectional.symmetric(vertical: 15),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(30),
      ),
      child: MaterialButton(
        onPressed: onTap,
        color: defColor,
        child: Text(
          text,
          style: const TextStyle(
            color: secondColor,
            fontSize: 18,
          ),
        ),
      ),
    );

void navigateAndFinish(context, Widget screen) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
      (route) => false,
    );

void navigateTo(context, Widget screen) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );

Widget defIconButton({
  void Function()? onTap,
  required IconData icon,
  double margin = 7,
  double height = 45,
  Color iconColor = secondColor,
}) =>
    Container(
      height: height,
      margin: EdgeInsetsDirectional.only(start: margin),
      decoration: BoxDecoration(
        color: defColor,
        borderRadius: BorderRadiusDirectional.circular(20),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );

Widget defAppBar(
        {required context, required String screenName, double textSize = 24}) =>
    Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          defIconButton(
            icon: Icons.arrow_back_ios,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            screenName.toUpperCase(),
            style: TextStyle(
              fontSize: textSize,
              wordSpacing: 5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

Widget noteItem({required Map model, index, context}) => LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      final double availableWidth = constraints.maxWidth;
      const double minWidthForDate = 200;
      const double requiredWidthForTitle = 100;
      return Container(
        color: defColor.withOpacity(0.6),
        padding: const EdgeInsetsDirectional.all(15),
        child: Builder(builder: (context) {
          String images = model['image_paths'];
          final paths = images.split(',');
          final files = paths.map((path) => File(path.trim())).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// title
              if (model['title'].toString().isNotEmpty && requiredWidthForTitle <= availableWidth)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    '${model['title']}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 27,
                        height: 1.15,
                        color: secondColor),
                  ),
                ),

              /// note
              Expanded(
                flex: 2,
                child: Text(
                  '${model['note']}',
                  style: const TextStyle(
                    fontSize: 20,
                    height: 1.15,
                    color: secondColor,
                  ),
                ),
              ),
              /// image
              if (model['image_paths'] != 'null')
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5,top: 5),
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      separatorBuilder: (context, index) =>
                      const SizedBox(width: 5),
                      scrollDirection: Axis.horizontal,
                      itemCount: files.length,
                      itemBuilder: (context, index) {
                        final file = files[index];
                        return Image.file(file);
                      },
                    ),
                  ),
                ),

              /// DATE
              if(minWidthForDate <= availableWidth)
                Row(
                  children: [
                    Text(
                      '${model['date']}',
                      style: const TextStyle(
                        color: secondColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${model['time']}',
                      style: const TextStyle(
                        color: secondColor,
                      ),
                    ),
                  ],
                )
            ],
          );
        },
        ),
      );
    }
);

Widget optionNoteItem(context, Map model, index, id) => FocusedMenuHolder(
      animateMenuItems: false,
      duration: const Duration(milliseconds: 0),
      menuWidth: MediaQuery.of(context).size.width * 0.65,
      menuItems: <FocusedMenuItem>[
        /// open
        FocusedMenuItem(
            title: const Text(
              'open',
              style: TextStyle(fontSize: 25, height: 1.15, color: defColor),
            ),
            onPressed: () {
              Note note = Note(
                id: model['id'],
                title: model['title'],
                note: model['note'],
                date: model['date'],
                time: model['time'],
                images: model['image_paths'],
                category: model['category'],
              );
              navigateTo(
                context,
                NoteScreen(note),
              );
            },
            trailingIcon: const Icon(Icons.open_in_new_rounded)),

        /// add or change to category
        FocusedMenuItem(
          title: model['category'] == 'null'
              ? const Text(
                  'Add to category',
                  style: TextStyle(fontSize: 20, height: 1.15, color: defColor),
                )
              : const Text(
                  'Change category',
                  style: TextStyle(fontSize: 20, height: 1.15, color: defColor),
                ),
          onPressed: () {
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
                      child: model['category'] == 'null'
                          ? Text(
                              'Add to category'.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )
                          : Text(
                              'Change to category'.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) => categoryItem(
                            model: categories[index], context: context, id: id),
                        itemCount: categories.length,
                        physics: const BouncingScrollPhysics(),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          trailingIcon: model['category'] == 'null'
              ? const Icon(
                  Icons.add,
                )
              : const Icon(
                  Icons.change_circle_outlined,
                ),
          backgroundColor: Colors.red.withOpacity(0.5),
        ),

        /// remove from category
        if (model['category'] != 'null')
          FocusedMenuItem(
            title: Text(
              'Remove from ${model['category'].split(' ')[0]}\'s category',
              style: const TextStyle(
                  fontSize: 20, height: 1.15, color: defColor),
            ),
            onPressed: () {
              AddNoteCubit.get(context)
                  .updateCategory(id: model['id'], category: 'null');
            },
            trailingIcon: const Icon(
              Icons.remove,
            ),
            backgroundColor: Colors.red.withOpacity(0.8),
          ),

        /// delete
        FocusedMenuItem(
          title: const Text(
            'delete',
            style: TextStyle(fontSize: 25, height: 1.15, color: defColor),
          ),
          onPressed: () {
            AddNoteCubit.get(context).deleteDB(id: model['id']);
          },
          trailingIcon: const Icon(
            Icons.delete_outline,
          ),
          backgroundColor: Colors.red,
        ),
      ],
      onPressed: () {},
      child: InkWell(
        onTap: () {
          Note note = Note(
            id: model['id'],
            title: model['title'],
            note: model['note'],
            date: model['date'],
            time: model['time'],
            images: model['image_paths'],
            category: model['category'],
          );
          navigateTo(
            context,
            NoteScreen(note),
          );
        },
        child: noteItem(model: model, context: context),
      ),
    );

Widget ifNotesEmpty() =>
    Expanded(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              'assets/gif/write_note.gif',
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );

Widget categoryItem(
        {required CategoryModel model, required context, required int id}) =>
    LayoutBuilder(
builder: (BuildContext context, BoxConstraints constraints) {
  final double availableWidth = constraints.maxWidth;
  const double requiredWidth = 340;

  double radius = constraints.maxWidth / 10;

  return  InkWell(
    onTap: () {
      AddNoteCubit.get(context)
          .updateCategory(category: model.name, id: id)
          .then((value) {
            toast(msg: 'Add note to ${model.name} category success', isError: false);
      },
      );
      Navigator.pop(context);
    },
    child: Container(
      margin: const EdgeInsetsDirectional.all(10),
      padding: const EdgeInsetsDirectional.all(15),
      decoration: BoxDecoration(
        color: secondColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundImage: AssetImage(
              model.image,
            ),
          ),
          const Spacer(),
          if(requiredWidth <= availableWidth)
          Text(
            model.name.toUpperCase(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}
);

Future<bool?> toast({
  required String msg,
  required bool isError,
}) =>
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: isError ? Colors.red : Colors.black,
        textColor: Colors.white,
        fontSize: 18);

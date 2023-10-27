import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:standard_fivver_note_app/shared/add_note_bloc/cubit.dart';
import 'package:standard_fivver_note_app/shared/add_note_bloc/states.dart';
import 'package:standard_fivver_note_app/style/colors.dart';
import '../components/components.dart';
import 'background_image.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddNoteCubit, AddNotesStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AddNoteCubit.get(context);

        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.grey,
            title: AnimatedSearchBar(
              label: "Tap To Search Something Here",
              labelStyle: const TextStyle(fontSize: 17),
              searchStyle: const TextStyle(color: defColor),
              cursorColor: secondColor,
              textInputAction: TextInputAction.done,
              searchDecoration: const InputDecoration(
                hintText: "Search",
                fillColor: defColor,
                focusColor: defColor,
                hintStyle: TextStyle(color: defColor),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                if (value != '') {
                  cubit.searchNotes(value);
                } else {
                  cubit.removeSearch();
                }
              },
              onFieldSubmitted: (value) {
                if (value != '') {
                  cubit.searchNotes(value);
                } else {
                  cubit.removeSearch();
                }
              },
            ),
          ),
          body: BackgroundImage(
            child: Column(
              children: [
                if (cubit.search.isNotEmpty)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: StaggeredGridView.countBuilder(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              itemCount: cubit.search.length,
                              itemBuilder: (context, index) {
                                return optionNoteItem(
                                    context, cubit.search[index], index,cubit.notes[index]['id']);
                              },
                              staggeredTileBuilder: (index) {
                                return index == 0
                                    ? const StaggeredTile.count(
                                        1, 1.0) //For Text
                                    : const StaggeredTile.count(
                                        1, 1.2); // others item
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (cubit.search.isEmpty)
                  ifNotesEmpty()
              ],
            ),
          ),
        );
      },
    );
  }
}

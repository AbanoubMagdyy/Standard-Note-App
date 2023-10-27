import 'dart:io';
import 'package:standard_fivver_note_app/shared/add_note_bloc/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class AddNoteCubit extends Cubit<AddNotesStates> {
  AddNoteCubit() : super(InitState());

  static AddNoteCubit get(context) => BlocProvider.of(context);

  Database? dataBase;
  List<Map> notes = [];

  Future createDB() {
    return openDatabase(
      'notes.db',
      version: 1,
      onCreate: (database, version) {
        database.execute(
            'CREATE TABLE notes(id INTEGER PRIMARY KEY , title TEXT, date TEXT, time TEXT, note TEXT, image_paths TEXT,category TEXT)');
      },
      onOpen: (database) {
        getDateFromDB(database);
      },
    ).then((value) {
      dataBase = value;
      emit(CreateDBState());
    });
  }




  /// categories
  List<Map> harryPotter = [];
  List<Map> hermioneGranger = [];
  List<Map> ronWeasley = [];
  List<Map> albusDumbledore = [];
  List<Map> lordVoldemort = [];
  List<Map> severusSnape = [];
  List<Map> siriusBlack = [];
  List<Map> rubeusHagrid = [];
  List<Map> ginnyWeasley = [];
  List<Map> nevilleLongbottom  = [];




  Future<void> insertNoteToDB({
    required String title,
    required String time,
    required String date,
    required String note,
  }) async {
    if (imageFiles.isNotEmpty) {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final path = directory.path;
        final imagePaths = <String>[];
        for (final imageFile in imageFiles) {
          final file =
              File('$path/.${DateTime.now().millisecondsSinceEpoch}.jpg');
          await file.writeAsBytes(await imageFile.readAsBytes());
          imagePaths.add(file.path);
        }
        await dataBase?.transaction(
          (txn) {
            txn
                .rawInsert(
                    'INSERT INTO notes(title,time,date,note,image_paths,category) VALUES ("$title","$time","$date","$note","${imagePaths.join(',')}","null")')
                .then(
              (value) {
                emit(InsertDBWithImagesState());
                getDateFromDB(dataBase);
              },
            );
            return Future(() => null);
          },
        );
      }
    }

    if (imageFiles.isEmpty) {
      await dataBase?.transaction(
        (txn) {
          txn
              .rawInsert(
                  'INSERT INTO notes(title,time,date,note,image_paths,category) VALUES ("$title","$time","$date","$note","null","null") ')
              .then(
            (value) {
              emit(InsertDBWithoutImagesState());
              getDateFromDB(dataBase);
              removeImages();
            },
          );
          return Future(() => null);
        },
      );
    }
  }


  Future<void> insertCategory({
    required String title,
    required String time,
    required String date,
    required String note,
    required category,}) async{
    await dataBase?.transaction(
    (txn) {
    txn
        .rawInsert(
        'INSERT INTO notes(title,time,date,note,image_paths,category) VALUES ("$title","$time","$date","$note","null","$category")')
        .then(
    (value) {
    emit(InsertDBWithImagesState());
    getDateFromDB(dataBase);
    },
    );
    return Future(() => null);
    },
    );
  }

   getDateFromDB(database) async {
    notes = [];
     harryPotter = [];
     hermioneGranger = [];
     ronWeasley = [];
     albusDumbledore = [];
     lordVoldemort = [];
     severusSnape = [];
     siriusBlack = [];
     rubeusHagrid = [];
     ginnyWeasley = [];
     nevilleLongbottom  = [];
    return await database.rawQuery('SELECT * FROM notes').then((value) {
      value.forEach((element) {
        switch (element['category']) {
          case 'Harry Potter':
            harryPotter.add(element);
            notes.add(element);
            break;
          case 'Hermione Granger':
            hermioneGranger.add(element);
            notes.add(element);
            break;
          case 'Ron Weasley':
            ronWeasley.add(element);
            notes.add(element);
            break;
          case 'Albus Dumbledore':
            albusDumbledore.add(element);
            notes.add(element);
            break;
          case 'Lord Voldemort':
            lordVoldemort.add(element);
            notes.add(element);
            break;
          case 'Severus Snape':
            severusSnape.add(element);
            notes.add(element);
            break;
          case 'Sirius Black':
            siriusBlack.add(element);
            notes.add(element);
            break;
          case 'Rubeus Hagrid':
            rubeusHagrid.add(element);
            notes.add(element);
            break;
          case 'Ginny Weasley':
            ginnyWeasley.add(element);
            notes.add(element);
            break;
          case 'Neville Longbottom':
            nevilleLongbottom.add(element);
            notes.add(element);
            break;
          default:
            notes.add(element);
        }
      });
      emit(GetDBState());
    });
  }

  Future<void> updateNote({
    required String title,
    required int id,
    required String time,
    required String date,
    required String note,
   // required String category,
  }) async {
    if (imageFiles.isNotEmpty) {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final path = directory.path;
        final imagePaths = <String>[];
        for (final imageFile in imageFiles) {
          final file =
              File('$path/.${DateTime.now().millisecondsSinceEpoch}.jpg');
          await file.writeAsBytes(await imageFile.readAsBytes());
          imagePaths.add(file.path);
        }
        dataBase?.rawUpdate(
            'UPDATE notes SET note = ? ,title = ?, date = ?, time = ?, image_paths = ? WHERE id = ? ',
            [note, title, date, time, imagePaths.join(','), id]).then(
          (value) async {
            emit(SuccessUpdateNoteWithImage());
            await getDateFromDB(dataBase);
          },
        );
      }
    }
    if (imageFiles.isEmpty) {
      dataBase?.rawUpdate(
          'UPDATE notes SET note = ? ,title = ?, date = ?, time = ?, image_paths = ?  WHERE id = ? ',
          [note, title, date, time, 'null',id]).then(
        (value) async {
          emit(SuccessUpdateNoteWithoutImage());
          await getDateFromDB(dataBase);
        },
      );
    }
  }


  Future<void> updateCategory({
    required String category,
    required int id
}) async {
    dataBase?.rawUpdate(
        'UPDATE notes SET category = ?  WHERE id = ? ',
        [category, id]).then(
          (value) async {
        emit(SuccessUpdateCategory());
        await getDateFromDB(dataBase);
      },
    );
  }

  void deleteDB({required int id}) {
    dataBase?.rawDelete('DELETE FROM notes WHERE id =?', [id]).then((value) {
      getDateFromDB(dataBase);
      emit(DeleteDBState());
    });
  }

  List<File> imageFiles = [];

  Future<void> selectImages() async {

    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(
      maxWidth: 800,
      maxHeight: 800,
    );
    imageFiles.addAll(
        pickedFiles.map((pickedFile) => File(pickedFile.path)).toList());
    emit(SuccessPutImages());
  }

  removeImages() {
    imageFiles = [];
    emit(Remove());
  }

  removeImage(file) {
    imageFiles.remove(file);
    emit(Remove());
  }


    List<Map<String, dynamic>> search = [];

  Future<List<Map>> searchNotes(String query) async {
    search = await dataBase!.rawQuery('''
      SELECT * FROM notes WHERE title LIKE '%$query%' OR note LIKE '%$query%'
    ''');
    emit(Search());
    return notes;
  }


  removeSearch(){
    search = [];
    emit(RemoveSearch());
  }



}

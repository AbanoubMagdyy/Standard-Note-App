import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../models/category_model.dart';
import 'components.dart';

String login = 'createAccountDoneaq';

final List<CategoryModel> categories = [
  CategoryModel(
      image: 'assets/images/harry_potter.webp', name: 'Harry Potter'),
  CategoryModel(
      image: 'assets/images/characters/albus_dumbledore.jpg',
      name: 'Albus Dumbledore'),
  CategoryModel(
      image: 'assets/images/characters/ginny_weasley.jfif',
      name: 'Ginny Weasley'),
  CategoryModel(
      image: 'assets/images/characters/hermione_granger.jpg',
      name: 'Hermione Granger'),
  CategoryModel(
      image: 'assets/images/characters/lord_voldemort.jpg',
      name: 'Lord Voldemort'),
  CategoryModel(
      image: 'assets/images/characters/neville_longbottom.jpg',
      name: 'Neville Longbottom'),
  CategoryModel(
      image: 'assets/images/characters/ron_weasley.jpg', name: 'Ron Weasley'),
  CategoryModel(
      image: 'assets/images/characters/rubeus_hagrid.jpg',
      name: 'Rubeus Hagrid'),
  CategoryModel(
      image: 'assets/images/characters/severus_snape.jpg',
      name: 'Severus Snape'),
  CategoryModel(
      image: 'assets/images/characters/sirius_black.jfif',
      name: 'Sirius Black'),
];


bool isConnect = false;
Future<void> checkInternetConnectivity() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    isConnect = true;
  } else {
    // Wait for a brief moment to allow the package to update its status
    await Future.delayed(const Duration(seconds: 2));
    connectivityResult = await Connectivity().checkConnectivity();
    isConnect =
        connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi;
    toast(
      msg: 'Please check the Internet',
      isError: false,);
  }
}


Future<bool> checkTheCode(String code,String name) async {
  bool isTheCodeAvailable = false;

  // Create a DocumentReference to the document with the name.
  DocumentReference documentReference = FirebaseFirestore.instance.collection('Account creation codes').doc(code);

  // Call the get() method on the DocumentReference to retrieve the document.
  DocumentSnapshot documentSnapshot = await documentReference.get();

  //  Check if the hasData property of the DocumentSnapshot is true.
  if(documentSnapshot.exists){
    await documentSnapshot.reference.get().then((value) {
      if(value.get('Has the code been used')){
        isTheCodeAvailable = false;
      }else{
        try{
          documentSnapshot.reference.update({
            'Has the code been used' : true,
            'Name' : name,
          }
          );
          isTheCodeAvailable = true;
        } catch(error) {
          if (kDebugMode) {
            print(error.toString());
          }
        }
      }
    },
    );

  }
  return isTheCodeAvailable;
}
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
//import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
//import 'package:firebase_core/firebase_core.dart';

Future<String> saveImage(
    String urlImage, String urlName, String urlImageFirebase) async {
  print('saveImage: urlImage: $urlImage');

/*   Firebase.initializeApp();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instanceFor(
          bucket: 'pvalarmes-3f7ee.appspot.com'); */

/* FirebaseApp secondaryApp = Firebase.app('SecondaryApp');
firebase_storage.FirebaseStorage storage =
  firebase_storage.FirebaseStorage.instanceFor(app: secondaryApp); */

  /*  firebase_storage.Reference ref = storage.refFromURL(urlImageFirebase);

  await ref.delete().then(
        (res) => print('saveImage:: Image $urlImageFirebase DELETED'),
      ); */

  Uri uriImage = Uri.parse(urlImage);

  var response = await http.get(uriImage);

  Directory documentDirectory = await getApplicationDocumentsDirectory();

  File file = new File(join(documentDirectory.path, '$urlName.png'));

  file.writeAsBytesSync(response.bodyBytes);

  var path = file.path;
  print('::saveImage:: file.path: $path');
  return file.path;

// This is a sync operation on a real
// app you'd probably prefer to use writeAsByte and handle its Future
}

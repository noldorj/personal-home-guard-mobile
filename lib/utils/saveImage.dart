import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

Future<String> saveImage(String urlImage, String urlName) async {
  print('saveImage: urlImage: $urlImage');

  Uri uriImage = Uri.parse(urlImage);

  var response = await http.get(uriImage);

  Directory documentDirectory = await getApplicationDocumentsDirectory();

  File file = new File(join(documentDirectory.path, '$urlName.png'));

  file.writeAsBytesSync(response.bodyBytes);

  print('saveImage...');
  var path = file.path;
  print('::saveImage:: file.path: $path');
  return file.path;

// This is a sync operation on a real
// app you'd probably prefer to use writeAsByte and handle its Future
}

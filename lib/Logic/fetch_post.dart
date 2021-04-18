import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';



void postTest() async {
  // Body me list hai sirf
  print("步驟1");
  final response = await http.get('https://jsonplaceholder.typicode.com/posts/1'); // Body se banega string
  print("步驟2");
  print(response.body);

}



class FetchDecode {


  List <String>  diseaseNameList;
  List <String>  speciesList;


  //  = http.get('124');


  String diseaseName;
  String speciesName;
  String boolBamboo;
  String boolHealth;


   
}


void sendImage(String loc) async{
    
  File imageFile =new File(loc);
  List <int> imageBytes = imageFile.readAsBytesSync();
  String encImage = base64.encode(imageBytes);
  

  // Map <String, String>  jString=  {
  //   'file': encImage,
  //   'size': '224',  
  // };
  print("test");
  
  var temp = await http.post('http://140.123.94.141:8000/api/test/', body: encImage);


  print("123456圖片資訊");

  print("789"+ temp.body);

}
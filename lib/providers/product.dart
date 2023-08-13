import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool newvalue){
    isFavorite =newvalue;
    notifyListeners();
  }
  Future<void> toggleFavoriteStatus(String token,String userId) async{
    final oldStatus = isFavorite;
    isFavorite = !isFavorite; //inverting favorite to unfavorite or vice versa
    notifyListeners();
    final url = Uri.parse('https://flutter-update-60452-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token');
    try{
      final response=await http.put(
        url,
        body: json.encode(
             isFavorite,
        ),
      );
      if(response.statusCode>=400){
        //Rollback
        _setFavValue(oldStatus);
      }
    }catch(error){
      _setFavValue(oldStatus);
    }
    }

}

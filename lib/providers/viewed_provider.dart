import 'package:flutter/material.dart';
import 'package:grocery_app/models/Viewed_model.dart';

class ViewedProductProvider with ChangeNotifier {
  Map<String, ViewedProductModel> _viewedProdlistItems = {};

  Map<String, ViewedProductModel> get getViewedProdlistItems {
    return _viewedProdlistItems;
  }

  void addProductsToHistory({required String productId}) {
    _viewedProdlistItems.putIfAbsent(
        productId,
        () => ViewedProductModel(
            id: DateTime.now().toString(), productId: productId));

    notifyListeners();
  }

  void clearHistory() {
    _viewedProdlistItems.clear();
    notifyListeners();
  }
}

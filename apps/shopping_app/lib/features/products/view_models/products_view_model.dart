import 'package:ease_annotation/ease_annotation.dart';
import 'package:ease_state_helper/ease_state_helper.dart';
import 'package:flutter/widgets.dart';

import '../../../core/logging/logger.dart';
import '../../../core/services/api_service.dart';
import '../models/products_state.dart';

part 'products_view_model.ease.dart';

@ease()
class ProductsViewModel extends StateNotifier<ProductsState> {
  final ApiService _apiService;

  ProductsViewModel({ApiService? apiService})
    : _apiService = apiService ?? ApiService(),
      super(const ProductsState());

  Future<void> loadProducts() async {
    logger.info('PRODUCTS', 'Loading products...');
    state = state.copyWith(status: ProductsStatus.loading);

    try {
      final products = await _apiService.getProducts();
      state = state.copyWith(
        products: products,
        status: ProductsStatus.success,
      );
      logger.info('PRODUCTS', 'Loaded ${products.length} products successfully');
    } catch (e) {
      logger.error('PRODUCTS', 'Failed to load products', e);
      state = state.copyWith(
        status: ProductsStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void selectCategory(String? category) {
    logger.userAction('select_category', {'category': category ?? 'all'});
    state = state.copyWith(selectedCategory: category);
    logger.debug('PRODUCTS', 'Filtered to category: ${category ?? 'all'}, showing ${state.filteredProducts.length} products');
  }
}

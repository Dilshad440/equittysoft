import 'package:equitysoft/response/product_response.dart';
import 'package:equitysoft/state/base/base_ui_state.dart';

class ProductState extends BaseUiState<List<ProductResponse>> {
  ProductState.loading() : super.loading();

  ProductState.completed(List<ProductResponse> data)
      : super.completed(data: data);

  ProductState.error(dynamic error) : super.error(error);
}

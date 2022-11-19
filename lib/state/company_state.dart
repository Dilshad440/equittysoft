import 'package:equitysoft/response/company_response.dart';
import 'package:equitysoft/state/base/base_ui_state.dart';

class CompanyState extends BaseUiState<List<CompanyRes>> {
  CompanyState.loading() : super.loading();

  CompanyState.completed(List<CompanyRes> data) : super.completed(data: data);

  CompanyState.error(dynamic error) : super.error(error);
}

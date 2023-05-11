

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:klio_staff/mvc/model/profit_loss_report_model.dart';
import 'package:klio_staff/mvc/model/sale_report_list_model.dart';
import 'package:klio_staff/mvc/model/stock_report_list_model.dart';
import 'package:klio_staff/service/local/shared_pref.dart';

import '../../constant/value.dart';
import '../../service/api/api_client.dart';
import '../../utils/utils.dart';
import '../model/waste_report_list_model.dart';
import 'error_controller.dart';

class ReportManagementController extends GetxController with ErrorController{
  Rx<SaleReportListModel> saleRepData = SaleReportListModel(data: []).obs;
  Rx<StockReportListModel> stockRepData = StockReportListModel(data: []).obs;
  Rx<ProfitLossReportModel> profitLossData =ProfitLossReportModel().obs;
  Rx<WasteReportListModel> wasteRepData = WasteReportListModel(data: []).obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    reportDataLoading();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  Future<void> reportDataLoading()async{
    token = (await SharedPref().getValue('token'))!;
    getSaleReportDataList();
    getStockReportDataList();
    getProfitLossReportList();
    getWasteReportDataList();
  }

  @override
  Future<void> onClose()async{}

  Future<void> getSaleReportDataList({dynamic id = ''})async{
    String endPoint = 'report/sale';
    var response = await ApiClient()
        .get(endPoint, header: Utils.apiHeader)
        .catchError(handleApiError);
    saleRepData.value = saleReportListModelFromJson(response);
    update();
    debugPrint("checkSaleReportData${saleRepData.value.data![0].id}");
  }

  Future<void> getStockReportDataList({dynamic id = ''})async{
    String endPoint = 'report/stock';
    var response = await ApiClient()
        .get(endPoint, header: Utils.apiHeader)
        .catchError(handleApiError);
    stockRepData.value = stockReportListModelFromJson(response);
    update();
    debugPrint("checkSaleReportData${stockRepData.value.data![0].id}");
  }

  Future<void> getProfitLossReportList({dynamic id = ''})async{
    String endPoint = 'report/profit-loss';
    var response = await ApiClient()
        .get(endPoint, header: Utils.apiHeader)
        .catchError(handleApiError);
    profitLossData.value = profitLossReportModelFromJson(response);
    update();
  }

  Future<void> getWasteReportDataList({dynamic id = ''})async{
    String endPoint = 'report/waste';
    var response = await ApiClient()
        .get(endPoint, header: Utils.apiHeader)
        .catchError(handleApiError);
    wasteRepData.value = wasteReportListModelFromJson(response);
    update();
    debugPrint("checkSaleReportData${wasteRepData.value.data![0].id}");
  }


}
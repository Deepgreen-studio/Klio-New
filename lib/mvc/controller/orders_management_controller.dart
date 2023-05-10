import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:klio_staff/mvc/controller/error_controller.dart';
import 'package:klio_staff/service/api/api_client.dart';
import 'package:klio_staff/service/local/shared_pref.dart';
import 'package:klio_staff/utils/utils.dart';

import '../../constant/value.dart';
import '../model/orders.dart';

class OrdersManagementController extends GetxController with ErrorController{
  ///Api data fetch varriable
  Rx<Orders> ordersData = Orders(data: []).obs;



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    ordersDataLoading();
  }
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  Future<void> ordersDataLoading()async{
    token=(await SharedPref().getValue('token'))!;
    debugPrint('checkToken\n$token');
    getOrdersData();
  }

  Future<void> getOrdersData({dynamic id =''})async{
    String endPoint = 'pos/order';
    var response = await ApiClient()
    .get(endPoint, header: Utils.apiHeader)
    .catchError(handleApiError);
    ordersData.value= ordersFromJson(response);
    print("Check order data ${response}");
    update();
  }


}
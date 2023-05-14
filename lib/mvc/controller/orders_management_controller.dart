import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:klio_staff/mvc/controller/error_controller.dart';
import 'package:klio_staff/mvc/model/all_orders_model.dart';
import 'package:klio_staff/service/api/api_client.dart';
import 'package:klio_staff/service/local/shared_pref.dart';
import 'package:klio_staff/utils/utils.dart';

import '../../constant/value.dart';
import '../model/orders.dart';

class OrdersManagementController extends GetxController with ErrorController{
  ///Api data fetch varriable
  Rx<AllOrdersModel> allOrdersData = AllOrdersModel(
    data:[],
    links: Links(first: '', last: '', prev: null, next: ''),
    meta: Meta(
      currentPage: 0,
      from: 0,
      lastPage: 0,
      links: [],
      path: '',
      perPage: 0,
      to: 0,
      total: 0,
    ),
  ).obs;
  Rx<AllOrdersModel> allSuccessData = AllOrdersModel(
    data:[],
    links: Links(first: '', last: '', prev: null, next: ''),
    meta: Meta(
      currentPage: 0,
      from: 0,
      lastPage: 0,
      links: [],
      path: '',
      perPage: 0,
      to: 0,
      total: 0,
    ),
  ).obs;



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
    getSuccessData();
  }

  Future<void>  getSuccessData({int pageKey = 1})async {
    String endPoint = 'orders/order?page=${pageKey}&status=success';
    var response = await ApiClient()
        .get(endPoint, header: Utils.apiHeader)
        .catchError(handleApiError);
    var temp = allOrdersModelFromJson(response);
    List<Datum> datums = [];
    for (Datum it in temp.data!) {
      datums.add(it);
    }
    allSuccessData.value.data?.addAll(datums);
    print("Check order data ${response}");
    update();

  }


  Future<void> getOrdersData({int pageKey = 1})async {
    String endPoint = 'orders/order?page=$pageKey';
    var response = await ApiClient()
        .get(endPoint, header: Utils.apiHeader)
        .catchError(handleApiError);
    var temp = allOrdersModelFromJson(response);
    List<Datum> datums = [];
    for (Datum it in temp.data!) {
      datums.add(it);
    }
    allOrdersData.value.data?.addAll(datums);
    print("Check order data ${response}");
    update();
  }

}
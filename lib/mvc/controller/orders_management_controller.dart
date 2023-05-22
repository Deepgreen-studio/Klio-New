import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:klio_staff/mvc/controller/error_controller.dart';
import 'package:klio_staff/mvc/model/all_orders_model.dart';
import 'package:klio_staff/service/api/api_client.dart';
import 'package:klio_staff/service/local/shared_pref.dart';
import 'package:klio_staff/utils/utils.dart';

import '../../constant/value.dart';
import '../model/orders.dart';

class OrdersManagementController extends GetxController with ErrorController {
  ///Api data fetch varriable
  int allOrderPageNumber = 1;
  int successOrderPageNumber = 1;
  int processingOrderPageNumber = 1;
  int pendingOrderPageNumber = 1;
  int cancelOrderPageNumber = 1;

  bool isLoadingAllOrder = false;
  bool isLoadingSuccessOrder = false;
  bool isLoadingProcessingOrder = false;
  bool isLoadingPendingOrder = false;
  bool isLoadingCancelOrder = false;

  bool haveMoreAllOrder = true;
  bool haveMoreSuccessOrder = true;
  bool haveMoreProcessingOrder = true;
  bool haveMorePendingOrder = true;
  bool haveMoreCancelOrder = true;

  static AllOrdersModel dummy = AllOrdersModel(
    data: [],
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
  );

  Rx<AllOrdersModel> allOrdersData = AllOrdersModel(
    data: [],
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
    data: [],
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
  Rx<AllOrdersModel> allProcessingData = AllOrdersModel(
    data: [],
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
  Rx<AllOrdersModel> allPendingData = AllOrdersModel(
    data: [],
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
  Rx<AllOrdersModel> allCancelData = AllOrdersModel(
    data: [],
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

  Future<void> ordersDataLoading() async {
    token = (await SharedPref().getValue('token'))!;
    debugPrint('checkToken\n$token');
    getOrdersData();
  }

  Future<void> getOrdersData() async {
    if (!haveMoreAllOrder) {
      return;
    }
    isLoadingAllOrder = true;
    String endPoint = 'orders/order?page=$allOrderPageNumber';
    var response = await ApiClient()
        .get(endPoint, header: Utils.apiHeader)
        .catchError(handleApiError);
    var temp = allOrdersModelFromJson(response);
    List<Datum> datums = [];
    for (Datum it in temp.data!) {
      datums.add(it);
    }

    allOrdersData.value.data?.addAll(datums);
    allOrdersData.value.meta = temp.meta;
    allOrderPageNumber++;
    if (allOrdersData.value.meta!.total <= (allCancelData.value.meta!.to ?? 0)) {
      haveMoreAllOrder = false;
    }

    isLoadingAllOrder = false;
    update(['allOrders']);
  }

  Future<void> getSuccessData() async {
    if (!haveMoreSuccessOrder) {
      return;
    }
    isLoadingSuccessOrder = true;
    String endPoint =
        'orders/order?page=$successOrderPageNumber&status=success';
    var response = await ApiClient()
        .get(endPoint, header: Utils.apiHeader)
        .catchError(handleApiError);
    var temp = allOrdersModelFromJson(response);
    List<Datum> datums = [];
    for (Datum it in temp.data!) {
      datums.add(it);
    }
    allSuccessData.value.data?.addAll(datums);
    allSuccessData.value.meta = temp.meta;
    if (allSuccessData.value.meta!.total <= (allCancelData.value.meta!.to ?? 0)) {
      haveMoreSuccessOrder = false;
    }
    successOrderPageNumber++;
    isLoadingSuccessOrder = false;

    update(["allSuccessOrders"]);
  }

  Future<void> getProcessingData() async {
    if (!haveMoreProcessingOrder) {
      return;
    }
    isLoadingProcessingOrder = true;
    String endPoint =
        'orders/order?page=$processingOrderPageNumber&status=processing';
    var response = await ApiClient()
        .get(endPoint, header: Utils.apiHeader)
        .catchError(handleApiError);
    var temp = allOrdersModelFromJson(response);
    List<Datum> datums = [];
    for (Datum it in temp.data!) {
      datums.add(it);
    }
    allProcessingData.value.data?.addAll(datums);
    allProcessingData.value.meta = temp.meta;
    if (allProcessingData.value.meta!.total <=
        (allCancelData.value.meta!.to ?? 0)) {
      haveMoreProcessingOrder = false;
    }
    processingOrderPageNumber++;
    isLoadingProcessingOrder = false;

    update(["allProcessingOrders"]);
  }

  Future<void> getPendingData() async {
    if (!haveMorePendingOrder) {
      return;
    }
    isLoadingPendingOrder = true;
    String endPoint =
        'orders/order?page=$pendingOrderPageNumber&status=pending';
    var response = await ApiClient()
        .get(endPoint, header: Utils.apiHeader)
        .catchError(handleApiError);

    /*if (json.decode(response)["data"]) {
      haveMorePendingOrder = false;
      isLoadingPendingOrder = false;
      update(["allPendingOrders"]);

      return;
    }*/

    var temp = allOrdersModelFromJson(response);
    List<Datum> datums = [];
    for (Datum it in temp.data!) {
      datums.add(it);
    }

    allPendingData.value.data?.addAll(datums);

    allPendingData.value.meta = temp.meta;

    if (allPendingData.value.meta!.total <= (allCancelData.value.meta!.to ?? 0)) {
      haveMorePendingOrder = false;
    }
    print(haveMorePendingOrder);
    pendingOrderPageNumber++;
    isLoadingPendingOrder = false;

    update(["allPendingOrders"]);
  }

  Future<void> getCancelData() async {
    if (!haveMoreCancelOrder) {
      return;
    }
    isLoadingCancelOrder = true;
    String endPoint = 'orders/order?page=$cancelOrderPageNumber&status=cancel';
    var response = await ApiClient()
        .get(endPoint, header: Utils.apiHeader)
        .catchError(handleApiError);
    var temp = allOrdersModelFromJson(response);
    List<Datum> datums = [];
    for (Datum it in temp.data!) {
      datums.add(it);
    }
    allCancelData.value.data?.addAll(datums);
    allCancelData.value.meta = temp.meta;

    if (allCancelData.value.meta!.total <= (allCancelData.value.meta!.to ?? 0)) {
      haveMoreCancelOrder = false;
    }
    cancelOrderPageNumber++;
    isLoadingCancelOrder = false;

    update(["allCancelOrders"]);
  }
}

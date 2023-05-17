

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:klio_staff/constant/value.dart';
import 'package:klio_staff/mvc/controller/error_controller.dart';
import 'package:klio_staff/mvc/model/expense_category_model.dart';
import 'package:klio_staff/mvc/model/expense_category_model.dart' as ExpCategory;
import 'package:klio_staff/mvc/model/expense_list_model.dart';
import 'package:klio_staff/mvc/model/expense_list_model.dart' as Expense;
import 'package:klio_staff/mvc/model/purchase_list_model.dart';
import 'package:klio_staff/mvc/model/purchase_list_model.dart' as Purchase;
import 'package:klio_staff/mvc/model/single_expense_data.dart';
import 'package:klio_staff/mvc/model/single_purchase_data.dart';
import 'package:klio_staff/service/api/api_client.dart';
import 'package:klio_staff/service/local/shared_pref.dart';
import 'package:klio_staff/utils/utils.dart';


class PurchaseManagementController extends GetxController with ErrorController{
  Rx<PurchaseListModel> purchaseData = PurchaseListModel(data: []).obs;
  Rx<ExpenseDataList> expenseData = ExpenseDataList(data: []).obs;
  Rx<ExpenseCategoryModel> expenseCategoryData = ExpenseCategoryModel(data: []).obs;

  Rx<SinglePurchaseData> singlePurchaseData = SinglePurchaseData().obs;
  Rx<SingleExpenseData> singleExpenseData = SingleExpenseData().obs;

  ///Api data fetch varriable
  int purchasePageNumber = 1;
  int expencePageNumber = 1;
  int expenceCategoryPageNumber = 1;

  bool isLoadingPurchase = false;
  bool isLoadingExpence = false;
  bool isLoadingExpenceCategory = false;

  bool haveMorePurchase = true;
  bool haveMoreExpence = true;
  bool haveMoreExpenceCategory = true;

  ///Purchase Management
  Rx<TextEditingController> expenseCategoryNameCtlr = TextEditingController().obs;
  Rx<String> dateCtlr = ''.obs;
  Rx<TextEditingController> unitPriceCtlr = TextEditingController().obs;
  Rx<TextEditingController> quantityCtlr = TextEditingController().obs;

  Rx<TextEditingController> shippingChargeCtlr =  TextEditingController(text:'0').obs;
  Rx<TextEditingController> discountCtlr =  TextEditingController(text:'0').obs;
  Rx<TextEditingController> paidCtlr =  TextEditingController(text:'0').obs;
  Rx<int> totalAmount =  0.obs;
  Rx<int> grandTotal =  0.obs;
  Rx<int> due = 0.obs;
  Rx<double> unitP= 0.0.obs;
  Rx<double> quantityA= 0.0.obs;

  var total = 0.0.obs;
  var isBank =false.obs;

  Rx<String> itemDatetext= 'Choose Date'.obs;


///add Expense
  final uploadExpenceFormKey = GlobalKey<FormState>();
  List<int> uploadExpenceResPersonList = [];
  List<int> uploadExpenceCatList = [];
  TextEditingController expenceAmountCtlr = TextEditingController();
  TextEditingController expenceNoteCtlr = TextEditingController();


  ///update Expense
  final updateExpenceFormKey = GlobalKey<FormState>();
  List<int> updateExpenceResPersonList = [];
  List<int> updateExpenceCatList = [];
  TextEditingController updateExpenceAmountCtlr = TextEditingController();
  TextEditingController updateExpenceNoteCtlr = TextEditingController();




  @override
  Future<void> onInit() async {
    super.onInit();
    purchaseDataLoading();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<void> purchaseDataLoading()async{
    token = (await SharedPref().getValue('token'))!;
    getPurchaseDataList();
    getExpenseDataList();
    getExpenseCategoryList();
  }

  Future<void> getChooseDate(BuildContext context)async{
    DateTime? pickDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
    );
    if(pickDate== null) return;
    dateCtlr.value= DateFormat('yyyy-MM-dd').format(pickDate);
    update();
  }


  Future<void> getPurchaseDataList({dynamic id = ''})async{
    if(!haveMorePurchase){
      return;
    }
    isLoadingPurchase =true;
    String endPoint = 'finance/purchase?page=$purchasePageNumber';
    var response = await ApiClient()
        .get(endPoint, header: Utils.apiHeader)
        .catchError(handleApiError);
    var temp = purchaseListModelFromJson(response);
    List<Purchase.Datum> datums= [];
    for (Purchase.Datum it in temp.data) {
      datums.add(it);
    }
    purchaseData.value.data.addAll(datums);
    purchasePageNumber++;
    var res = json.decode(response);
    int to = res['meta']['to'];
    int total = res['meta']['total'];
    if (total <= to) {
      haveMorePurchase = false;
    }
    isLoadingPurchase = false;
    update(['purchaseId']);

  }

  Future<void> getSinglePurchaseData({dynamic id = ''})async{
    String endPoint = 'finance/purchase/$id';
    var response = await ApiClient()
        .get(endPoint, header: Utils.apiHeader)
        .catchError(handleApiError);
    singlePurchaseData.value = singlePurchaseDataFromJson(response);
    update();
    print('checkResponseDetails${singlePurchaseData.value.data!.id}');
  }

  Future<void> deletePurchaseItem({dynamic id=''})async{
    Utils.showLoading();
    String endPoint = 'finance/purchase/$id';
    var response = await ApiClient()
        .delete(endPoint, header: Utils.apiHeader)
        .catchError(handleApiError);
    if(response==null) return;
    purchaseDataLoading();
    Utils.hidePopup();
    Get.back();
    Utils.showSnackBar("Deleted Expense");
  }


  Future<void> getExpenseDataList({dynamic id = ''})async{
    if(!haveMoreExpence){
      return;
    }
    isLoadingExpence =true;
    String endPoint = 'finance/expense?page=$expencePageNumber';
    var response = await ApiClient()
        .get(endPoint, header: Utils.apiHeader)
        .catchError(handleApiError);
    var temp = expenseDataListFromJson(response);
    List<Expense.Datum> datums= [];
    for (Expense.Datum it in temp.data) {
      datums.add(it);
    }
    expenseData.value.data.addAll(datums);
    expencePageNumber++;
    var res = json.decode(response);
    int to = res['meta']['to'];
    int total = res['meta']['total'];
    if (total <= to) {
      haveMoreExpence = false;
    }
    isLoadingExpence = false;
    update(['expenseId']);

  }

  Future<void> addExpence(
    int personId,
    int categoryId,
    double amount,
    String date,
    {String note = ''})async{
    String endPoint = 'finance/expense';
    var body = jsonEncode({
      "person": personId,
      "category": categoryId,
      "amount": amount,
      "date": date,
      "note": note
    });
    var response = await ApiClient()
    .post(endPoint, body, header: Utils.apiHeader)
    .catchError(handleApiError);
    if (response == null) return;
    purchaseDataLoading();
    Utils.hidePopup();
    Get.back();
    Utils.showSnackBar("Successfully Added");
  }

  void updateExpence(
      int personId,
      int categoryId,
      double amount,
      String date,
      String note,
      {String id =''})async{
    Utils.showLoading();
    var body = jsonEncode({
      "person": personId,
      "category": categoryId,
      "amount": amount,
      "date": date,
      "note": note,
    });
    var response =await ApiClient()
    .put('finance/expense/$id', body, header: Utils.apiHeader)
    .catchError(handleApiError);
    print(response);
    if(response==null) return ;
      purchaseDataLoading();
      Get.back();
      Get.back();
      Utils.showSnackBar("successfully");

  }

  Future<void> getSingleExpenseData({dynamic id = ''})async{
    String endPoint = 'finance/expense/$id';
    var response = await ApiClient()
        .get(endPoint, header: Utils.apiHeader)
        .catchError(handleApiError);
    singleExpenseData.value = singleExpenseDataFromJson(response);
    update();
    print('checkResponseDetails${singleExpenseData.value.data!.id}');
  }

  Future<void> deleteExpense({dynamic id=''})async{
    Utils.showLoading();
    String endPoint = 'finance/expense/$id';
    var response = await ApiClient()
        .delete(endPoint, header: Utils.apiHeader)
        .catchError(handleApiError);
    if(response==null) return;
    purchaseDataLoading();
    Utils.hidePopup();
    Get.back();
    Utils.showSnackBar("Deleted Expense");
  }

  Future<void> getExpenseCategoryList({dynamic id = ''})async{
    if (!haveMoreExpenceCategory) {
      return;
    }
    isLoadingExpenceCategory=true;
    String endPoint = 'finance/expense-category?page=$expenceCategoryPageNumber';
    var response = await ApiClient()
        .get(endPoint, header: Utils.apiHeader)
        .catchError(handleApiError);
    var temp= expenseCategoryModelFromJson(response);
    List<ExpCategory.Datum> datums= [];
    for (ExpCategory.Datum it in temp.data) {
      datums.add(it);
    }
    expenseCategoryData.value.data.addAll(datums);
    expenceCategoryPageNumber++;
    var res = json.decode(response);
    int to = res['meta']['to'];
    int total = res['meta']['total'];
    if (total <= to) {
      haveMoreExpenceCategory = false;
    }
    isLoadingExpenceCategory = false;
    update(['expCategoryId']);

  }


  Future<void> addNewExpenseCategory(String name)async{
    Utils.showLoading();
    String endPoint = 'finance/expense-category';
    var body = jsonEncode({
      "name": name,
    });
    var response = await ApiClient()
    .post(endPoint, body, header: Utils.apiHeader )
        .catchError(handleApiError);
    if (response == null) return;
    purchaseDataLoading();
    Utils.hidePopup();
    Get.back();
    Utils.showSnackBar("Successfully Added");
  }

  Future<void> deleteExpenseCategory({dynamic id=''})async{
    Utils.showLoading();
    String endPoint = 'finance/expense-category/$id';
    var response = await ApiClient()
    .delete(endPoint, header: Utils.apiHeader)
    .catchError(handleApiError);
    if(response==null) return;
    purchaseDataLoading();
    Utils.hidePopup();
    Get.back();
    Utils.showSnackBar("Deleted Category");
  }

}
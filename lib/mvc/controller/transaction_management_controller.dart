import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:klio_staff/constant/value.dart';
import 'package:klio_staff/mvc/controller/error_controller.dart';
import 'package:klio_staff/mvc/model/bank_list_data_model.dart';
import 'package:klio_staff/mvc/model/transaction_list_data_model.dart';
import 'package:klio_staff/service/api/api_client.dart';
import 'package:klio_staff/service/local/shared_pref.dart';
import 'package:klio_staff/utils/utils.dart';
import 'package:http/http.dart' as http;
import '../../service/api/api_exception.dart';

class TransactionsController extends GetxController with ErrorController{
  Rx<BankListModel> bankListData = BankListModel(data: []).obs;
  Rx<TransactionListModel> transactionListData = TransactionListModel(data: []).obs;
  File? signatureStoreImage;


  ///upload bank data
  final uploadBankKey = GlobalKey<FormState>();
  TextEditingController nameCtlr = TextEditingController();
  TextEditingController accNameCtlr = TextEditingController();
  TextEditingController accNumCtlr = TextEditingController();
  TextEditingController branchCtlr = TextEditingController();
  TextEditingController balanceCtlr = TextEditingController();

  // Validator
  String? Function(String?)? textValidator = (String? value) {
    if (value!.isEmpty) {
      return 'This filed is required';
    } else {
      return null;
    }
  };

  @override
  Future<void> onInit() async {
    super.onInit();
    transactionsDataLoading();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<void> transactionsDataLoading()async{
    token = (await SharedPref().getValue('token'))!;
    bankListDataList();
    transactionDataList();
  }

  Future<File> getImage() async {
    File ?imageFile;
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File signatureStoreImage = File(pickedFile.path);
      imageFile=signatureStoreImage;
      update();
    } else {
      print('No image selected.');
    }
    return imageFile!;
  }

  Future<void> bankListDataList({dynamic id = ''})async{
    String endPoint = id == '' ? 'finance/bank' : 'finance/bank/$id';
    var response = await ApiClient()
        .get(endPoint, header: Utils.apiHeader)
        .catchError(handleApiError);
   // debugPrint("checkBankList$response");
    bankListData.value = bankListModelFromJson(response);
    update();
    debugPrint("checkBankList${bankListData.value.data[0].name}");
  }

  void addNewBank(
      String name,
      String accountName,
      String accountNumber,
      String branchName,
      String balance,
      File? signatureImg
      )async{
    Utils.showLoading();
    var uri = Uri.parse(baseUrl + 'finance/bank');
    try {
      http.MultipartRequest request = http.MultipartRequest('POST', uri);
      request.headers.addAll(Utils.apiHeader);
      if (signatureImg != null) {
        http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('signature_image', signatureImg.path);
        request.files.add(multipartFile);
      }
      Map<String, String> _fields = Map();
      _fields.addAll(<String, String>{
          "name" : name,
          "account_name" :accountName,
          "account_number" : accountNumber,
          "branch_name" : branchName,
          "balance" : balance,
      });
      request.fields.addAll(_fields);
      http.StreamedResponse response = await request.send();
      var res = await http.Response.fromStream(response);
      Utils.hidePopup();
      Get.back();
      _processResponse(res);
      transactionsDataLoading();
    } on SocketException {
      throw ProcessDataException("No internet connection", uri.toString());
    } on TimeoutException {
      throw ProcessDataException("Not responding in time", uri.toString());
    }
  }

  Future<void> deleteBank({id =''}) async{
    Utils.showLoading();
    String endPoint = 'finance/bank/$id';
    var response = await ApiClient()
        .delete(endPoint, header: Utils.apiHeader)
        .catchError(handleApiError);
    transactionsDataLoading();
    Utils.hidePopup();
  }

  Future<void> transactionDataList({dynamic id = ''}) async{
    String endPoint = id == '' ? 'finance/bank-transaction' : 'finance/bank-transaction/$id';
    var response = await ApiClient()
        .get(endPoint, header: Utils.apiHeader)
        .catchError(handleApiError);
   // debugPrint("checkTransactionList${response}");
    transactionListData.value = transactionListModelFromJson(response);
    update();
    debugPrint("checkTransactionList${transactionListData.value.data[0].id}");
  }

  dynamic _processResponse(http.Response response) {
    var jsonResponse = utf8.decode(response.bodyBytes);
    print('check body response${response.body}');
    var jsonDecode=json.decode(response.body);
    Utils.showSnackBar(jsonDecode['message']);
    print(response.statusCode);
    print(response.request!.url);
    switch (response.statusCode) {
      case 200:
        return jsonResponse;
      case 201:
        return jsonResponse;
      case 422:
        return jsonResponse;
      case 400:
        throw BadRequestException(
            jsonResponse, response.request!.url.toString());
      case 500:
        throw BadRequestException(
            jsonResponse, response.request!.url.toString());
      default:
        throw ProcessDataException(
            "Error occurred with code ${response.statusCode}",
            response.request!.url.toString());
    }
  }

}
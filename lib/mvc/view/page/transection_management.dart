import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:klio_staff/constant/color.dart';
import 'package:klio_staff/constant/value.dart';
import 'package:klio_staff/mvc/controller/transaction_management_controller.dart';
import 'package:klio_staff/mvc/view/dialog/custom_dialog.dart';
import 'package:klio_staff/mvc/view/widget/custom_widget.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:klio_staff/mvc/model/bank_list_data_model.dart' as Bank;
import 'package:klio_staff/mvc/model/transaction_list_data_model.dart' as Transaction;


class TransactionManagement extends StatefulWidget {
  const TransactionManagement({Key? key}) : super(key: key);

  @override
  State<TransactionManagement> createState() => _TransactionManagementState();
}

class _TransactionManagementState extends State<TransactionManagement>with SingleTickerProviderStateMixin {
  TransactionsController _transactionsController = Get.put(TransactionsController());
  int _currentSelection = 0;
  late TabController controller;
  late ScrollController scrollController;

  @override
  void initState() {
    // TODO: implement initState
    controller = TabController(vsync: this, length: 2);
    controller.addListener((){
      _currentSelection = controller.index;
      _transactionsController.update(['changeCustomTabBar']);
    });
    scrollController= ScrollController();

    scrollController.addListener(() {
      if(scrollController.position.pixels>=
      scrollController.position.maxScrollExtent * 0.95){
        if(_currentSelection==0 && !_transactionsController.isLoadingBank){
          _transactionsController.bankListDataList();
        }else if(_currentSelection==1 && !_transactionsController.isLoadingTransition){
          _transactionsController.transactionDataList();
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              itemTitleHeader(),
              customTapbarHeader(controller),
              Expanded(
                          child: TabBarView(controller: controller, children: [
                            bankListDataTable(context),
                            bankTransactionsDataTable(context),
                          ]),
              )
            ],
          ),
        )
    );
  }
  itemTitleHeader() {
    return Builder(builder: (context) {
      if (_currentSelection == 0) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  'Bank',
                  style: TextStyle(fontSize: fontBig, color: primaryText),
                ),
              ),
              Container(
                child: OutlinedButton.icon(
                  icon: Icon(
                    Icons.add,
                    color: primaryText,
                  ),
                  label: Text(
                    "Add New Bank",
                    style: TextStyle(
                      color: primaryText,
                    ),
                  ),
                  onPressed: () {
                      showCustomDialog(context, 'Add New Bank',
                          newBankForm(), 100, 300);
                  },
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(width: 1.0, color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }
      else{
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  'Bank Transactions',
                  style: TextStyle(fontSize: fontBig, color: primaryText),
                ),
              ),
              Container(
                child: OutlinedButton.icon(
                  icon: Icon(
                    Icons.add,
                    color: primaryText,
                  ),
                  label: Text(
                    "Add New Transaction",
                    style: TextStyle(
                      color: primaryText,
                    ),
                  ),
                  onPressed: () => print("it's pressed"),
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(width: 1.0, color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }
    }
    );
  }

  Widget customTapbarHeader(TabController controller) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          GetBuilder<TransactionsController>(
            id: 'changeCustomTabBar',
            builder: (context) {
              return Expanded(
                flex: 1,
                child: MaterialSegmentedControl(
                  children: {
                    0: Text(
                      'Bank List',
                      style: TextStyle(
                          color: _currentSelection == 0 ? white : textSecondary),
                    ),
                    1: Text(
                      'Bank Transactions',
                      style: TextStyle(
                          color: _currentSelection == 1 ? white : textSecondary),
                    ),
                  },
                  selectionIndex: _currentSelection,
                  borderColor: Colors.grey,
                  selectedColor: primaryColor,
                  unselectedColor: Colors.white,
                  borderRadius: 32.0,
                  disabledChildren: [
                    6,
                  ],
                  onSegmentChosen: (index) {
                    if(index==0 && _transactionsController.bankListData.value.data.isEmpty){
                      _transactionsController.bankListDataList();
                    } else if(index ==1 && _transactionsController.transactionListData.value.data.isEmpty){
                      _transactionsController.transactionDataList();
                    }
                    print(index);
                    setState(() {
                      _currentSelection = index;
                      controller.index = _currentSelection;
                    });
                  },
                ),
              );
            }
          ),
          Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      elevation: 0.0,
                      child: SizedBox(
                          width: 250,
                          height: 30,
                          child: TextField(
                              style: const TextStyle(
                                fontSize: fontSmall,
                                color: Colors.blueAccent,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white10,
                                contentPadding:
                                const EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 0.0),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  size: 18,
                                ),
                                hintText: "Search Item",
                                hintStyle: TextStyle(
                                    fontSize: fontVerySmall,
                                    color: textSecondary),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.transparent)),
                                disabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.transparent)),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.transparent)),
                                errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.transparent)),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.transparent)),
                                focusedErrorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.transparent)),
                              ))),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text(
                            "Show :",
                            style: TextStyle(color: textSecondary),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 30,
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(25.0),
                                border: Border.all(color: Colors.black12)),
                            child: DropdownButton<int>(
                              hint: Text(
                                '1',
                                style: TextStyle(color: textSecondary),
                              ),
                              dropdownColor: white,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              iconSize: 15,
                              underline: const SizedBox(),
                              items: <int>[1, 2, 3, 4].map((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(value.toString()),
                                );
                              }).toList(),
                              onChanged: (int? newVal) {},
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Entries",
                            style: TextStyle(color: textSecondary),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget bankListDataTable(BuildContext context) {
    return Card(
      color: secondaryBackground,
      child: SingleChildScrollView(
        controller: scrollController,
        child: GetBuilder<TransactionsController>(
          id: 'bankId',
          builder: (controller) {
            if (!controller.haveMoreBank && controller.bankListData.value.data.last.id != 0) {
              controller.bankListData.value.data.add(Bank.Datum(id:0));
            }
            return DataTable(
                dataRowHeight: 70,
                columns: [
                  // column to set the name
                  DataColumn(label: Text('SL NO',style: TextStyle(color:textSecondary),),),
                  DataColumn(label: Text('Bank Name',style: TextStyle(color:textSecondary),),),
                  DataColumn(label: Text('AC Name',style: TextStyle(color:textSecondary),),),
                  DataColumn(label: Text('AC Number',style: TextStyle(color:textSecondary),),),
                  DataColumn(label: Text('Branch Name',style: TextStyle(color:textSecondary),),),
                  DataColumn(label: Text('Balance',style: TextStyle(color:textSecondary),),),
                  DataColumn(label: Text('Action',style: TextStyle(color:textSecondary),),),
                ],

                rows: controller.bankListData.value.data
                    .map(
                      (item) {
                        if(item.id== 0 && !controller.haveMoreBank){
                          return  DataRow(cells: [
                            const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                            const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                            const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                            DataCell(Text('No Data',style: TextStyle(color: primaryText))),
                            const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                            const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                            const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                          ]);
                        }else if(item== controller.bankListData.value.data.last && !controller.isLoadingBank && controller.haveMoreBank){
                          return const DataRow(cells: [
                            DataCell(CircularProgressIndicator(color: Colors.transparent)),
                            DataCell(CircularProgressIndicator(color: Colors.transparent)),
                            DataCell(CircularProgressIndicator(color: Colors.transparent)),
                            DataCell(CircularProgressIndicator()),
                            DataCell(CircularProgressIndicator(color: Colors.transparent)),
                            DataCell(CircularProgressIndicator(color: Colors.transparent)),
                            DataCell(CircularProgressIndicator(color: Colors.transparent)),
                          ]);
                        }
                        return DataRow(
                    cells: [
                      DataCell(
                        Text('${item.id ?? ""}',style: TextStyle(color: primaryText),),
                      ),
                      DataCell(
                        Text('${item.name ?? ""}',style: TextStyle(color: primaryText),),
                      ),
                      DataCell(
                        Text('${item.accountName ?? ""}',style: TextStyle(color: primaryText),),
                      ),
                      DataCell(
                        Text('${item.accountNumber ?? ""}',style: TextStyle(color: primaryText),),
                      ),
                      DataCell(
                        Text('${item.branchName ?? ""}',style: TextStyle(color: primaryText),),
                      ),
                      DataCell(
                        Text('${item.balance ?? ""}',style: TextStyle(color: primaryText),),
                      ),
                      DataCell(
                        Row(
                          // mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: const Color(0xffFEF4E1),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: Image.asset(
                                "assets/edit-alt.png",
                                height: 15,
                                width: 15,
                                color: const Color(0xffED7402),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: const Color(0xffFFE7E6),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: GestureDetector(
                                onTap: (){
                                  showWarningDialog('Are you sure to delete this ?',
                                      onAccept:(){
                                    _transactionsController.deleteBank(id: item.id);
                                    Get.back();
                                  });
                                },
                                child: Image.asset(
                                  "assets/delete.png",
                                  height: 15,
                                  width: 15,
                                  color: const Color(0xffED0206),
                                ),
                              ),
                            ),
                          ],
                        ),)
                    ],
                  );
                    },
                ).toList());
          }
        ),
      ),
    );
  }

  Widget bankTransactionsDataTable(BuildContext context) {
    return Card(
      color: secondaryBackground,
      child: SingleChildScrollView(
        controller: scrollController,
        child: GetBuilder<TransactionsController>(
            id: 'transId',
          builder: (controller) {
            if (!controller.haveMoreTransition && controller.transactionListData.value.data.last.id != 0) {
              controller.transactionListData.value.data.add(Transaction.Datum(id:0));
            }
            return DataTable(
                columnSpacing: 50,
                columns: [
                  // column to set the name
                  DataColumn(label: Text('SL NO',style: TextStyle(color:textSecondary),),),
                  DataColumn(label: Text('Bank',style: TextStyle(color:textSecondary),),),
                  DataColumn(label: Text('Date',style: TextStyle(color:textSecondary),),),
                  DataColumn(label: Text('Withdraw/ID',style: TextStyle(color:textSecondary),),),
                  DataColumn(label: Text('Amount',style: TextStyle(color:textSecondary),),),
                  DataColumn(label: Text('Action',style: TextStyle(color:textSecondary),),),
                ],

                rows: controller.transactionListData.value.data
                    .map(
                      (item) {
                        if(item.id== 0 && !controller.haveMoreTransition){
                          return  DataRow(cells: [
                            const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                            const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                            const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                            DataCell(Text('No Data',style: TextStyle(color: primaryText))),
                            const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                            const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                          ]);
                        }else if(item== controller.transactionListData.value.data.last && !controller.isLoadingTransition && controller.haveMoreTransition){
                          return const DataRow(cells: [
                            DataCell(CircularProgressIndicator(color: Colors.transparent)),
                            DataCell(CircularProgressIndicator(color: Colors.transparent)),
                            DataCell(CircularProgressIndicator(color: Colors.transparent)),
                            DataCell(CircularProgressIndicator()),
                            DataCell(CircularProgressIndicator(color: Colors.transparent)),
                            DataCell(CircularProgressIndicator(color: Colors.transparent)),
                          ]);
                        }

                        return DataRow(
                          cells: [
                            DataCell(
                              Text('${item.id ?? ""}',
                                style: TextStyle(color: primaryText),),
                            ),
                            DataCell(
                              Text(item.bank?.name ?? "",
                                style: TextStyle(color: primaryText),),
                            ),
                            DataCell(
                              Text(item.date ?? "",
                                style: TextStyle(color: primaryText),),
                            ),
                            DataCell(
                              Text(item.withdrawDepositeId ?? "",
                                style: TextStyle(color: primaryText),),
                            ),
                            DataCell(
                              Text(item.amount ?? "",
                                style: TextStyle(color: primaryText),),
                            ),
                            DataCell(
                              Row(
                                // mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffFEF4E1),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    child: Image.asset(
                                      "assets/edit-alt.png",
                                      height: 15,
                                      width: 15,
                                      color: const Color(0xffED7402),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffFFE7E6),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    child: Image.asset(
                                      "assets/delete.png",
                                      height: 15,
                                      width: 15,
                                      color: const Color(0xffED0206),
                                    ),
                                  ),
                                ],
                              ),)
                          ],
                        );
                      },
                )
                    .toList());
          }
        ),
      ),
    );
  }



  Widget newBankForm() {
    return Container(
      padding: const EdgeInsets.all(25.0),
      child: Form(
        key: _transactionsController.uploadBankKey,
        child: ListView(
          children: [
            textRow('Bank Name', 'Account Name'),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                  height:52,
                  child: TextFormField(
                        controller: _transactionsController.nameCtlr,
                        validator: _transactionsController.textValidator,
                        decoration: InputDecoration(
                          fillColor: secondaryBackground,
                          hintText: 'Enter Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          hintStyle:
                          TextStyle(fontSize: fontVerySmall, color: textSecondary),

                        ),
                      keyboardType: TextInputType.text,
                  ),
                  ),
                ),
                const SizedBox(width: 10),
                  Expanded(
                  child: SizedBox(
                  height:52,
                  child: TextFormField(
                    controller: _transactionsController.accNameCtlr,
                    validator: _transactionsController.textValidator,
                    decoration: InputDecoration(
                      fillColor: secondaryBackground,
                      hintText: 'Enter Account Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      hintStyle:
                      TextStyle(fontSize: fontVerySmall, color: textSecondary),

                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                )
              ],
            ),
            const SizedBox(height:10),
            textRow('Account Number', 'Branch Name'),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height:52,
                    child: TextFormField(
                      controller: _transactionsController.accNumCtlr,
                      validator: _transactionsController.textValidator,
                      decoration: InputDecoration(
                        fillColor: secondaryBackground,
                        hintText: 'Enter Account Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        hintStyle:
                        TextStyle(fontSize: fontVerySmall, color: textSecondary),

                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height:52,
                    child: TextFormField(
                      controller: _transactionsController.branchCtlr,
                      validator: _transactionsController.textValidator,
                      decoration: InputDecoration(
                        fillColor: secondaryBackground,
                        hintText: 'Enter Branch Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        hintStyle:
                        TextStyle(fontSize: fontVerySmall, color: textSecondary),

                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height:10),
            textRow('Balance', 'Signature'),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height:52,
                    child: TextFormField(
                      controller: _transactionsController.balanceCtlr,
                      validator: _transactionsController.textValidator,
                      decoration: InputDecoration(
                        fillColor: secondaryBackground,
                        hintText: 'Enter Balance',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        hintStyle:
                        TextStyle(fontSize: fontVerySmall, color: textSecondary),

                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                    flex: 1,
                    child: SizedBox(
                        height: 52,
                        child: MaterialButton(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                          color: primaryBackground,
                          onPressed: () async {
                            _transactionsController.signatureStoreImage=
                            await  _transactionsController.getImage();
                          },
                          child: GetBuilder<TransactionsController>(
                              builder: (context) {
                                return Text(
                                  _transactionsController.signatureStoreImage ==null
                                      ? 'No file chosen'
                                      : basename(_transactionsController.signatureStoreImage!.path
                                      .split(Platform.pathSeparator.tr)
                                      .last),
                                  style: TextStyle(
                                      color: textSecondary, fontSize: fontSmall),
                                );
                              }),
                        )
                      // child: normalButton('No file chosen', primaryColor, primaryColor),
                    )),
              ],
            ),
            const SizedBox(height:20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                normalButton('Submit', primaryColor, white, onPressed: (){
                  if(_transactionsController.uploadBankKey.currentState!.validate()){
                    _transactionsController.addNewBank(
                        _transactionsController.nameCtlr.text,
                        _transactionsController.accNameCtlr.text,
                        _transactionsController.accNumCtlr.text,
                        _transactionsController.branchCtlr.text,
                        _transactionsController.balanceCtlr.text,
                      _transactionsController.signatureStoreImage!
                    );
                    _transactionsController.nameCtlr.clear();
                    _transactionsController.accNameCtlr.clear();
                    _transactionsController.accNumCtlr.clear();
                    _transactionsController.branchCtlr.clear();
                    _transactionsController.balanceCtlr.clear();
                    _transactionsController.signatureStoreImage;
                  }
                }),
              ],
            )
          ],
        ),
      )
    );
  }



}

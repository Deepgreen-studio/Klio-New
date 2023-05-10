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

class TransactionManagement extends StatefulWidget {
  const TransactionManagement({Key? key}) : super(key: key);

  @override
  State<TransactionManagement> createState() => _TransactionManagementState();
}

class _TransactionManagementState extends State<TransactionManagement>with SingleTickerProviderStateMixin {
  TransactionsController _transactionsController=Get.put(TransactionsController());
  int _currentSelection = 0;
  late TabController controller;
  @override
  void initState() {
    // TODO: implement initState
    controller = TabController(vsync: this, length: 2);
    super.initState();
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
                    side: BorderSide(width: 1.0, color: primaryColor),
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
          padding: EdgeInsets.all(15.0),
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
                    side: BorderSide(width: 1.0, color: primaryColor),
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

  Widget bankListDataTable(BuildContext context) {
    return Card(
      color: secondaryBackground,
      child: SingleChildScrollView(
        child: GetBuilder<TransactionsController>(
          builder: (controller) {
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

                rows: controller.bankListData.value.data.reversed
                    .map(
                      (item) => DataRow(
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
                                color: Color(0xffFEF4E1),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: Image.asset(
                                "assets/edit-alt.png",
                                height: 15,
                                width: 15,
                                color: Color(0xffED7402),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: Color(0xffFFE7E6),
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
                                  color: Color(0xffED0206),
                                ),
                              ),
                            ),
                          ],
                        ),)
                    ],
                  ),
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
        child: GetBuilder<TransactionsController>(
          builder: (controller) {
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

                rows: controller.transactionListData.value.data.reversed
                    .map(
                      (item) => DataRow(
                    cells: [
                      DataCell(
                        Text('${item.id ?? ""}',style: TextStyle(color: primaryText),),
                      ),
                      DataCell(
                        Text('${item.bank.name?? ""}',style: TextStyle(color: primaryText),),
                      ),
                      DataCell(
                        Text('${item.date ?? ""}',style: TextStyle(color: primaryText),),
                      ),
                      DataCell(
                        Text('${item.withdrawDepositeId ?? ""}',style: TextStyle(color: primaryText),),
                      ),
                      DataCell(
                        Text('${item.amount ?? ""}',style: TextStyle(color: primaryText),),
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
                                color: Color(0xffFEF4E1),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: Image.asset(
                                "assets/edit-alt.png",
                                height: 15,
                                width: 15,
                                color: Color(0xffED7402),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: Color(0xffFFE7E6),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: Image.asset(
                                "assets/delete.png",
                                height: 15,
                                width: 15,
                                color: Color(0xffED0206),
                              ),
                            ),
                          ],
                        ),)
                    ],
                  ),
                )
                    .toList());
          }
        ),
      ),
    );
  }


  Widget customTapbarHeader(TabController controller) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Expanded(
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
                print(index);
                setState(() {
                  _currentSelection = index;
                  controller.index = _currentSelection;
                });
              },
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(left: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      elevation: 0.0,
                      child: SizedBox(
                          width: 250,
                          height: 30,
                          child: TextField(
                              style: TextStyle(
                                fontSize: fontSmall,
                                color: Colors.blueAccent,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white10,
                                contentPadding:
                                EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 0.0),
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 18,
                                ),
                                hintText: "Search Item",
                                hintStyle: TextStyle(
                                    fontSize: fontVerySmall,
                                    color: textSecondary),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.transparent)),
                                disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.transparent)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.transparent)),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.transparent)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.transparent)),
                                focusedErrorBorder: OutlineInputBorder(
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
                          SizedBox(
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
                              icon: Icon(Icons.keyboard_arrow_down),
                              iconSize: 15,
                              underline: SizedBox(),
                              items: <int>[1, 2, 3, 4].map((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(value.toString()),
                                );
                              }).toList(),
                              onChanged: (int? newVal) {},
                            ),
                          ),
                          SizedBox(
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

  Widget newBankForm() {
    return Container(
      padding: EdgeInsets.all(25.0),
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
                SizedBox(width: 10),
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
            SizedBox(height:10),
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
                SizedBox(width: 10),
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
            SizedBox(height:10),
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
                SizedBox(width: 10),
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
            SizedBox(height:20),
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

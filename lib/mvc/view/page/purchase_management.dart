import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:klio_staff/constant/color.dart';
import 'package:klio_staff/constant/value.dart';
import 'package:klio_staff/mvc/controller/purchase_management_controller.dart';
import 'package:klio_staff/mvc/model/purchase_list_model.dart';
import 'package:klio_staff/mvc/model/expense_list_model.dart' as Expense;
import 'package:klio_staff/mvc/model/expense_category_model.dart' as ExpCategory;

import 'package:klio_staff/mvc/view/dialog/custom_dialog.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../widget/custom_widget.dart';

class PurchaseManagement extends StatefulWidget {
  const PurchaseManagement({Key? key}) : super(key: key);

  @override
  State<PurchaseManagement> createState() => _PurchaseManagementState();
}

class _PurchaseManagementState extends State<PurchaseManagement>
    with SingleTickerProviderStateMixin {
  PurchaseManagementController purchaseCtrl =
      Get.put(PurchaseManagementController());
  int _currentSelection = 0;
  late TabController controller;
  late ScrollController scrollController;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    controller = TabController(vsync: this, length: 3);

    controller.addListener((){
      _currentSelection = controller.index;
      purchaseCtrl.update(['changeCustomTabBar']);
    });

    scrollController= ScrollController();

    scrollController.addListener(() {
      if(scrollController.position.pixels >=
      scrollController.position.maxScrollExtent *0.95){
        if(_currentSelection==0 && !purchaseCtrl.isLoadingPurchase){
          purchaseCtrl.getPurchaseDataList();
        }else if(_currentSelection==1 && !purchaseCtrl.isLoadingExpence){
          purchaseCtrl.getExpenseDataList();
        } else if(_currentSelection==2 && !purchaseCtrl.isLoadingExpenceCategory){
          purchaseCtrl.getExpenseCategoryList();
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
              purchaseDataTable(),
              expenseDataTable(),
              expenseCategoryDataTable(),
            ]),
          )
        ],
      ),
    ));
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
                  'Purchase List',
                  style: TextStyle(fontSize: fontBig, color: primaryText),
                ),
              ),const SizedBox(height:48)
            ],
          ),
        );
      } else if (_currentSelection == 1) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  'Expense List',
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
                    "Add New Expense",
                    style: TextStyle(
                      color: primaryText,
                    ),
                  ),
                  onPressed: () {
                    showCustomDialog(
                        context, "Add New Expence", addNewExpence(), 100, 300);
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
      } else if (_currentSelection == 2) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  'Expense Category List',
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
                    "Add Expense Category",
                    style: TextStyle(
                      color: primaryText,
                    ),
                  ),
                  onPressed: () {
                    showCustomDialog(context, "Add New Expense Category",
                        addNewExpenseCategory(), 100, 400);
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
      return Container();
    });
  }

  Widget customTapbarHeader(TabController controller) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          GetBuilder<PurchaseManagementController>(
              id: 'changeCustomTabBar',
              builder: (context) {
                return Expanded(
                flex: 1,
                child: MaterialSegmentedControl(
                  children: {
                    0: Text(
                      'Purchase List',
                      style: TextStyle(
                          color: _currentSelection == 0 ? white : black),
                    ),
                    1: Text(
                      'Expense',
                      style: TextStyle(
                          color: _currentSelection == 1 ? white : black),
                    ),
                    2: Text(
                      'Expense Category',
                      style: TextStyle(
                          color: _currentSelection == 2 ? white : black),
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

                    if(index==0 && purchaseCtrl.purchaseData.value.data.isEmpty){
                      purchaseCtrl.getPurchaseDataList();
                    } else if(index ==1 && purchaseCtrl.expenseData.value.data.isEmpty){
                      purchaseCtrl.getExpenseDataList();
                    }else if(index==2 && purchaseCtrl.expenseCategoryData.value.data.isEmpty){
                      purchaseCtrl.getExpenseCategoryList();
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
          Container(
            margin: const EdgeInsets.only(left: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Card(
                  elevation: 0.0,
                  child: SizedBox(
                      width: 300,
                      height: 40,
                      child: TextField(
                          onChanged: (text)async{},
                          controller: textController,
                          style: const TextStyle(
                            fontSize: fontSmall,
                            color: black,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white10,
                            contentPadding:
                             const EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 0.0),
                            prefixIcon:  const Icon(
                              Icons.search,
                              size: 20,
                            ),
                            suffixIcon: IconButton(
                                onPressed: (){
                                  textController.text='';
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: textSecondary,
                                )),
                            hintText: "Search Item",
                            hintStyle: const TextStyle(
                                fontSize: fontSmall,
                                color: black),
                            border:  const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Colors.transparent)),
                            disabledBorder:  const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Colors.transparent)),
                            enabledBorder:  const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Colors.transparent)),
                            errorBorder:  const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Colors.transparent)),
                            focusedBorder:  const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Colors.transparent)),
                            focusedErrorBorder:  const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Colors.transparent)),
                          ))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget purchaseDataTable() {
    return Card(
      color: secondaryBackground,
      child: SingleChildScrollView(
        controller: scrollController,
        child: GetBuilder<PurchaseManagementController>(
            id: 'purchaseId',
            builder: (controller) {
              if(controller.purchaseData.value.data.isEmpty){
                return  Center(child: Container(
                    height:40,
                    width: 40,
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.3),
                    child: CircularProgressIndicator()));
              }
              if (!controller.haveMorePurchase && controller.purchaseData.value.data.last.id != 0) {
                controller.purchaseData.value.data.add(Datum(id:0));
              }
          return DataTable(
              dataRowHeight: 70,
              columns: [
                // column to set the name
                DataColumn(
                  label: Text(
                    'SL NO',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Reference No',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Date',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Supplier',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Grand Total',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Due Amount',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Action',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
              ],
              rows: controller.purchaseData.value.data
                  .map(
                    (item) {
                      if(item.id== 0 && !controller.haveMorePurchase){
                        return DataRow(cells: [
                          const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                          const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                          const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                          DataCell(Text('No Data', style: TextStyle(color: primaryText))),
                          const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                          const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                          const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                        ]);
                      }else if(item== controller.purchaseData.value.data.last && !controller.isLoadingPurchase && controller.haveMorePurchase){
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
                          Text(
                            '${item.id ?? ""}',
                            style: TextStyle(color: primaryText),
                          ),
                        ),
                        DataCell(
                          Text(
                            '${item.referenceNo ?? ""}',
                            style: TextStyle(color: primaryText),
                          ),
                        ),
                        DataCell(
                          Text(
                            '${item.date ?? ""}',
                            style: TextStyle(color: primaryText),
                          ),
                        ),
                        DataCell(
                          Text(
                            '${item.supplier?.name ?? ""}',
                            style: TextStyle(color: primaryText),
                          ),
                        ),
                        DataCell(
                          Text(
                            '${item.totalAmount ?? ""}',
                            style: TextStyle(color: primaryText),
                          ),
                        ),
                        DataCell(
                          Text(
                            '${item.paidAmount ?? ""}',
                            style: TextStyle(color: primaryText),
                          ),
                        ),
                        DataCell(
                          Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: const Color(0xffE1FDE8),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                purchaseCtrl
                                    .getSinglePurchaseData(id: item.id)
                                    .then((value) {
                                  showCustomDialog(context, "Purchase Details",
                                      viewPurchaseData(), 120, 400);
                                });
                              },
                              child: Image.asset(
                                "assets/hide.png",
                                height: 15,
                                width: 15,
                                color: const Color(0xff00A600),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                   },
                  )
                  .toList());
        }),
      ),
    );
  }

  Widget expenseDataTable() {
    return Card(
      color: secondaryBackground,
      child: SingleChildScrollView(
        controller: scrollController,
        child: GetBuilder<PurchaseManagementController>(
            id: 'expenceId',
            builder: (controller) {
              if (!controller.haveMoreExpence && controller.expenseData.value.data.last.id != 0) {
                controller.expenseData.value.data.add(Expense.Datum(id:0));
              }
          return DataTable(
              // dataRowHeight: 70,
              columnSpacing: 50,
              columns: [
                // column to set the name
                DataColumn(
                  label: Text(
                    'SL NO',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Category',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Responsible person',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Amount',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Date',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Note',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Status',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Action',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
              ],
              rows: controller.expenseData.value.data
                  .map(
                    (item) {
                      if(item.id== 0 && !controller.haveMoreExpence){
                        return  DataRow(cells: [
                          const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                          const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                          const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                          const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                          DataCell(Text('No Data',style: TextStyle(color: primaryText))),
                          const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                          const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                          const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                        ]);
                      }else if(item== controller.expenseData.value.data.last && !controller.isLoadingExpence && controller.haveMoreExpence){
                        return const DataRow(cells: [
                          DataCell(CircularProgressIndicator(color: Colors.transparent)),
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
                            Text(
                              '${item.id ?? ""}',
                              style: TextStyle(color: primaryText),
                            ),
                          ),
                          DataCell(
                            Text(
                              item.category?.name ?? "",
                              style: TextStyle(color: primaryText),
                            ),
                          ),
                          DataCell(
                            Text(
                              item.person?.name ?? "",
                              style: TextStyle(color: primaryText),
                            ),
                          ),
                          DataCell(
                            Text(
                              item.amount ?? "",
                              style: TextStyle(color: primaryText),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${item.date ?? ""}',
                              style: TextStyle(color: primaryText),
                            ),
                          ),
                          DataCell(
                            Text(
                              item.note ?? "",
                              style: TextStyle(color: primaryText),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${item.status ?? ""}',
                              style: TextStyle(color: primaryText),
                            ),
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
                                    color: const Color(0xffE1FDE8),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      purchaseCtrl
                                          .getSingleExpenseData(id: item.id)
                                          .then((value) {
                                        showCustomDialog(
                                            context,
                                            "Show Expense Details",
                                            viewExpenseDetails(),
                                            100,
                                            400);
                                      });
                                    },
                                    child: Image.asset(
                                      "assets/hide.png",
                                      height: 15,
                                      width: 15,
                                      color: const Color(0xff00A600),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffFEF4E1),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      purchaseCtrl
                                          .getSingleExpenseData(id: item.id)
                                          .then((value) {
                                        purchaseCtrl.updateExpenceResPersonList
                                            .add(purchaseCtrl.singleExpenseData
                                            .value.data!.person.id);
                                        purchaseCtrl.updateExpenceCatList.add(
                                            purchaseCtrl.singleExpenseData.value
                                                .data!.category.id);
                                        purchaseCtrl
                                            .updateExpenceAmountCtlr.text =
                                            purchaseCtrl.singleExpenseData.value
                                                .data!.amount;
                                        purchaseCtrl.updateExpenceNoteCtlr
                                            .text =
                                            purchaseCtrl.singleExpenseData.value
                                                .data!.note;
                                        purchaseCtrl.dateCtlr.value =
                                            purchaseCtrl
                                                .singleExpenseData.value.data!
                                                .date
                                                .toString();

                                        showCustomDialog(
                                            context,
                                            "Update Expence",
                                            updateExpenceForm(item.id),
                                            100,
                                            300);
                                      });
                                    },
                                    child: Image.asset(
                                      "assets/edit-alt.png",
                                      height: 15,
                                      width: 15,
                                      color: const Color(0xffED7402),
                                    ),
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
                                    onTap: () {
                                      showWarningDialog(
                                          "Do you want to delete this item?",
                                          onAccept: () {
                                            purchaseCtrl.deleteExpense(
                                                id: item.id);
                                            Get.back();
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
                            ),
                          )
                        ],
                      );
                    },
                  )
                  .toList());
        }),
      ),
    );
  }

  Widget expenseCategoryDataTable() {
    return Card(
      color: secondaryBackground,
      child: SingleChildScrollView(
        controller: scrollController,
        child: GetBuilder<PurchaseManagementController>(
            id:'expCategoryId',
            builder: (controller) {
              if (!controller.haveMoreExpenceCategory && controller.expenseCategoryData.value.data.last.id != 0) {
                controller.expenseCategoryData.value.data.add(ExpCategory.Datum(id:0));
              }
          return DataTable(
              dataRowHeight: 70,
              columnSpacing: 50,
              columns: [
                // column to set the name
                DataColumn(
                  label: Text(
                    'SL NO',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Name',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Status',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Action',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
              ],
              rows: controller.expenseCategoryData.value.data
                  .map(
                    (item) {
                      if(item.id== 0 && !controller.haveMoreExpenceCategory){
                        return  DataRow(cells: [
                          const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                          const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                          DataCell(Text('No Data',style: TextStyle(color: primaryText))),
                          const DataCell(CircularProgressIndicator(color: Colors.transparent)),
                        ]);
                      }else if(item== controller.expenseCategoryData.value.data.last && !controller.isLoadingExpenceCategory && controller.haveMoreExpenceCategory){
                        return const DataRow(cells: [
                          DataCell(CircularProgressIndicator(color: Colors.transparent)),
                          DataCell(CircularProgressIndicator(color: Colors.transparent)),
                          DataCell(CircularProgressIndicator()),
                          DataCell(CircularProgressIndicator(color: Colors.transparent)),
                        ]);
                      }
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              '${item.id ?? ""}',
                              style: TextStyle(color: primaryText),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${item.name ?? ""}',
                              style: TextStyle(color: primaryText),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${item.status ?? ""}',
                              style: TextStyle(color: primaryText),
                            ),
                          ),
                          DataCell(
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: const Color(0xffFFE7E6),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  showWarningDialog(
                                      "Do you want to delete this item?",
                                      onAccept: () {
                                        purchaseCtrl.deleteExpenseCategory(
                                            id: item.id).then((value) {
                                              if(Navigator.of(context).canPop()){
                                                Navigator.of(context).pop();
                                              }
                                        });
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
                          )
                        ],
                      );
                    },
                  )
                  .toList());
        }),
      ),
    );
  }


  Widget viewPurchaseData() {
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: ListView(
        children: [
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Reference No:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        purchaseCtrl.singlePurchaseData.value.data!.referenceNo,
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Supplier Name:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        purchaseCtrl
                            .singlePurchaseData.value.data!.supplier.name
                            .toString(),
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Date:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        purchaseCtrl.singlePurchaseData.value.data!.date
                            .toString(),
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Payment Type:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        purchaseCtrl.singlePurchaseData.value.data!.paymentType,
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Total Total:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        purchaseCtrl.singlePurchaseData.value.data!.totalAmount,
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Shipping Charge:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        purchaseCtrl
                            .singlePurchaseData.value.data!.shippingCharge,
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Discount Amount:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        purchaseCtrl
                            .singlePurchaseData.value.data!.discountAmount,
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Grand Total:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        purchaseCtrl.singlePurchaseData.value.data!.paidAmount,
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Paid Amount:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        purchaseCtrl.singlePurchaseData.value.data!.paidAmount,
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Due Amount:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        "${double.parse(purchaseCtrl.singlePurchaseData.value.data!.totalAmount) - double.parse(purchaseCtrl.singlePurchaseData.value.data!.paidAmount)}",
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Details:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        purchaseCtrl.singlePurchaseData.value.data!.details ??
                            "",
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget addNewExpence() {
    return Container(
        height: Size.infinite.height,
        width: Size.infinite.width,
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Form(
          key: purchaseCtrl.uploadExpenceFormKey,
          child: ListView(children: [
            textRow("Responsible Person", "Category"),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Expanded(
                  flex: 1,
                  child: GetBuilder<PurchaseManagementController>(
                    builder: (controller) {
                      return MultiSelectDropDown(
                        backgroundColor: secondaryBackground,
                        optionsBackgroundColor: secondaryBackground,
                        selectedOptionTextColor: primaryText,
                        selectedOptionBackgroundColor: primaryColor,
                        optionTextStyle:
                            TextStyle(color: primaryText, fontSize: 16),
                        onOptionSelected: (List<ValueItem> selectedOptions) {
                          purchaseCtrl.uploadExpenceResPersonList =
                              selectedOptions
                                  .map((ValueItem e) => int.parse(e.value!))
                                  .toList();
                          print(purchaseCtrl.uploadExpenceResPersonList);
                        },
                        options: controller.expenseData.value.data.map((e) {
                          return ValueItem(
                            label: e.person?.name??"",
                            value: e.person?.id.toString(),
                          );
                        }).toList(),
                        hint: 'Select Person',
                        hintColor: primaryText,
                        selectionType: SelectionType.single,
                        chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                        dropdownHeight: 300,
                        selectedOptionIcon: const Icon(Icons.check_circle),
                        inputDecoration: BoxDecoration(
                          color: secondaryBackground,
                          borderRadius: const BorderRadius.all(Radius.circular(6)),
                          border: Border.all(
                            color: primaryBackground,
                          ),
                        ),
                      );
                    },
                  )),
              const SizedBox(width: 10),
              Expanded(
                  flex: 1,
                  child: GetBuilder<PurchaseManagementController>(
                    builder: (controller) {
                      return MultiSelectDropDown(
                        backgroundColor: secondaryBackground,
                        optionsBackgroundColor: secondaryBackground,
                        selectedOptionTextColor: primaryText,
                        selectedOptionBackgroundColor: primaryColor,
                        optionTextStyle:
                            TextStyle(color: primaryText, fontSize: 16),
                        onOptionSelected: (List<ValueItem> selectedOptions) {
                          purchaseCtrl.uploadExpenceCatList = selectedOptions
                              .map((ValueItem e) => int.parse(e.value!))
                              .toList();
                          print(purchaseCtrl.uploadExpenceCatList);
                        },
                        options:
                            controller.expenseCategoryData.value.data.map((e) {
                          return ValueItem(
                            label: e.name.toString(),
                            value: e.id.toString(),
                          );
                        }).toList(),
                        hint: 'Select Category',
                        hintColor: primaryText,
                        selectionType: SelectionType.single,
                        chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                        dropdownHeight: 300,
                        selectedOptionIcon: const Icon(Icons.check_circle),
                        inputDecoration: BoxDecoration(
                          color: secondaryBackground,
                          borderRadius: const BorderRadius.all(Radius.circular(6)),
                          border: Border.all(
                            color: primaryBackground,
                          ),
                        ),
                      );
                    },
                  )),
            ]),
            const SizedBox(height: 10),
            textRow("Amount", "Date"),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 52,
                    child: TextFormField(
                        controller: purchaseCtrl.expenceAmountCtlr,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            fontSize: fontVerySmall, color: primaryText),
                        decoration: InputDecoration(
                            fillColor: secondaryBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            hintStyle: TextStyle(
                                fontSize: fontVerySmall, color: primaryText),
                            hintText: "Enter Amount")),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 52,
                    child: GetBuilder<PurchaseManagementController>(
                      builder: (controller) => GestureDetector(
                        onTap: () {
                          controller.getChooseDate(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: secondaryBackground,
                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                            border: Border.all(
                              color: textSecondary,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(controller.dateCtlr.value),
                              const Icon(Icons.calendar_month)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            textRow("Note", ""),
            SizedBox(
              child: TextFormField(
                  controller: purchaseCtrl.expenceNoteCtlr,
                  keyboardType: TextInputType.text,
                  maxLines: 3,
                  style: TextStyle(fontSize: fontVerySmall, color: primaryText),
                  decoration: InputDecoration(
                      fillColor: secondaryBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      hintStyle: TextStyle(
                          fontSize: fontVerySmall, color: primaryText),
                      hintText: "Enter...")),
            ),
            const SizedBox(height: 30),
            Container(
              height: 40,
              width: 50,
              child: normalButton(
                "Submit",
                primaryColor,
                white,
                onPressed: () async {
                  if (purchaseCtrl.uploadExpenceFormKey.currentState!
                      .validate()) {
                    purchaseCtrl.addExpence(
                        purchaseCtrl.uploadExpenceResPersonList.first,
                        purchaseCtrl.uploadExpenceCatList.first,
                        double.parse(purchaseCtrl.expenceAmountCtlr.text),
                        purchaseCtrl.dateCtlr.value,
                        note: purchaseCtrl.expenceNoteCtlr.text);
                  }
                  purchaseCtrl.expenceAmountCtlr.clear();
                  purchaseCtrl.dateCtlr.close();
                  purchaseCtrl.expenceNoteCtlr.clear();
                },
              ),
            ),
            const SizedBox(height: 30),
          ]),
        ));
  }

  Widget updateExpenceForm(dynamic itemId) {
    return Container(
        height: Size.infinite.height,
        width: Size.infinite.width,
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Form(
          key: purchaseCtrl.updateExpenceFormKey,
          child: ListView(children: [
            textRow("Responsible Person", "Category"),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Expanded(
                  flex: 1,
                  child: GetBuilder<PurchaseManagementController>(
                    builder: (controller) {
                      return MultiSelectDropDown(
                        backgroundColor: secondaryBackground,
                        optionsBackgroundColor: secondaryBackground,
                        selectedOptionTextColor: primaryText,
                        selectedOptionBackgroundColor: primaryColor,
                        optionTextStyle:
                            TextStyle(color: primaryText, fontSize: 16),
                        onOptionSelected: (List<ValueItem> selectedOptions) {
                          purchaseCtrl.updateExpenceResPersonList =
                              selectedOptions
                                  .map((ValueItem e) => int.parse(e.value!))
                                  .toList();
                          print(purchaseCtrl.updateExpenceResPersonList);
                        },
                        options: controller.expenseData.value.data.map((e) {
                          return ValueItem(
                            label: e.person?.name??"",
                            value: e.person?.id.toString(),
                          );
                        }).toList(),
                        selectedOptions:
                            controller.expenseData.value.data.map((e) {
                          return ValueItem(
                            label: purchaseCtrl.expenseData.value.data
                                .firstWhere((element) => element.id == itemId)
                                .person
                                !.name,
                            value: purchaseCtrl.expenseData.value.data
                                .firstWhere((element) => element.id == itemId)
                                .person
                                !.id
                                .toString(),
                          );
                        }).toList(),
                        hint: purchaseCtrl.expenseData.value.data
                            .firstWhere((element) => element.id == itemId)
                            .person
                            !.name,
                        hintColor: primaryText,
                        selectionType: SelectionType.single,
                        chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                        dropdownHeight: 300,
                        selectedOptionIcon: const Icon(Icons.check_circle),
                        inputDecoration: BoxDecoration(
                          color: secondaryBackground,
                          borderRadius: const BorderRadius.all(Radius.circular(6)),
                          border: Border.all(
                            color: primaryBackground,
                          ),
                        ),
                      );
                    },
                  )),
              const SizedBox(width: 10),
              Expanded(
                  flex: 1,
                  child: GetBuilder<PurchaseManagementController>(
                    builder: (controller) {
                      return MultiSelectDropDown(
                        backgroundColor: secondaryBackground,
                        optionsBackgroundColor: secondaryBackground,
                        selectedOptionTextColor: primaryText,
                        selectedOptionBackgroundColor: primaryColor,
                        optionTextStyle:
                            TextStyle(color: primaryText, fontSize: 16),
                        onOptionSelected: (List<ValueItem> selectedOptions) {
                          purchaseCtrl.updateExpenceCatList = selectedOptions
                              .map((ValueItem e) => int.parse(e.value!))
                              .toList();
                          print(purchaseCtrl.updateExpenceCatList);
                        },
                        selectedOptions:
                            controller.expenseCategoryData.value.data.map((e) {
                          return ValueItem(
                            label: purchaseCtrl.expenseCategoryData.value.data
                                .firstWhere((element) => element.id == itemId,
                                    orElse: () {
                              return purchaseCtrl
                                  .expenseCategoryData.value.data.first;
                            }).name.toString(),
                            value: purchaseCtrl.expenseCategoryData.value.data
                                .firstWhere((element) => element.id == itemId,
                                    orElse: () {
                                  return purchaseCtrl
                                      .expenseCategoryData.value.data.first;
                                })
                                .id
                                .toString(),
                          );
                        }).toList(),
                        options:
                            controller.expenseCategoryData.value.data.map((e) {
                          return ValueItem(
                            label: e.name.toString(),
                            value: e.id.toString(),
                          );
                        }).toList(),
                        hint: purchaseCtrl.expenseCategoryData.value.data
                            .firstWhere((element) => element.id == itemId,
                                orElse: () {
                          return purchaseCtrl
                              .expenseCategoryData.value.data.first;
                        }).name.toString(),
                        hintColor: primaryText,
                        selectionType: SelectionType.single,
                        chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                        dropdownHeight: 300,
                        selectedOptionIcon: const Icon(Icons.check_circle),
                        inputDecoration: BoxDecoration(
                          color: secondaryBackground,
                          borderRadius: const BorderRadius.all(Radius.circular(6)),
                          border: Border.all(
                            color: primaryBackground,
                          ),
                        ),
                      );
                    },
                  )),
            ]),
            const SizedBox(height: 10),
            textRow("Amount", "Date"),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 52,
                    child: TextFormField(
                        controller: purchaseCtrl.updateExpenceAmountCtlr,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            fontSize: fontVerySmall, color: primaryText),
                        decoration: InputDecoration(
                            fillColor: secondaryBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            hintStyle: TextStyle(
                                fontSize: fontVerySmall, color: primaryText),
                            hintText: "Enter Amount")),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 52,
                    child: GetBuilder<PurchaseManagementController>(
                      builder: (controller) => GestureDetector(
                        onTap: () {
                          controller.getChooseDate(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: textSecondary,
                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                            border: Border.all(
                              color: textSecondary,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(controller.dateCtlr.value),
                              const Icon(Icons.calendar_month)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            textRow("Note", ""),
            SizedBox(
              child: TextFormField(
                  controller: purchaseCtrl.updateExpenceNoteCtlr,
                  keyboardType: TextInputType.text,
                  maxLines: 3,
                  style: TextStyle(fontSize: fontVerySmall, color: primaryText),
                  decoration: InputDecoration(
                      fillColor: secondaryBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      hintStyle: TextStyle(
                          fontSize: fontVerySmall, color: primaryText),
                      hintText: "Enter...")),
            ),
            const SizedBox(height: 30),
            Container(
              height: 40,
              width: 50,
              child: normalButton(
                "Submit",
                primaryColor,
                white,
                onPressed: () async {
                  purchaseCtrl.updateExpence(
                    purchaseCtrl.updateExpenceResPersonList.first,
                    purchaseCtrl.updateExpenceCatList.first,
                    double.parse(purchaseCtrl.updateExpenceAmountCtlr.text),
                    purchaseCtrl.dateCtlr.value.toString(),
                    purchaseCtrl.updateExpenceNoteCtlr.text,
                    id: itemId.toString(),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
          ]),
        ));
  }

  Widget addNewExpenseCategory() {
    return Container(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: ListView(children: [
          textRow('Name', ''),
          normalTextField(
             purchaseCtrl.expenseCategoryNameCtlr.value,
          ),
          const SizedBox(height: 10),
          Container(
            height: 40,
            width: 50,
            child: normalButton(
              'Submit',
              primaryColor,
              white,
              onPressed: () async {
                purchaseCtrl.addNewExpenseCategory(
                  purchaseCtrl.expenseCategoryNameCtlr.value.text,
                );
                purchaseCtrl.expenseCategoryNameCtlr.value.clear();
              },
            ),
          ),
        ]));
  }

  Widget viewExpenseDetails() {
    return Container(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: ListView(children: [
          SizedBox(
            height: 60,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'ID:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        purchaseCtrl.singleExpenseData.value.data!.id
                            .toString(),
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Person Id:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        purchaseCtrl.singleExpenseData.value.data!.person.id
                            .toString(),
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Person Name:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        purchaseCtrl.singleExpenseData.value.data!.person.name
                            .toString(),
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Category Id:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        purchaseCtrl.singleExpenseData.value.data!.category.id
                            .toString(),
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Category Name:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        purchaseCtrl.singleExpenseData.value.data!.category.name
                            .toString(),
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Date:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        purchaseCtrl.singleExpenseData.value.data!.date
                            .toString(),
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Amount:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        purchaseCtrl.singleExpenseData.value.data!.amount
                            .toString(),
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Note:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        purchaseCtrl.singleExpenseData.value.data!.note
                            .toString(),
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Status:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        purchaseCtrl.singleExpenseData.value.data!.status
                            .toString(),
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
        ]));
  }
}

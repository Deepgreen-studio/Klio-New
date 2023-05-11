import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:klio_staff/mvc/controller/report_management_controller.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import '../../../constant/color.dart';
import '../../../constant/value.dart';
class Reports extends StatefulWidget {
  const Reports({Key? key}) : super(key: key);

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> with SingleTickerProviderStateMixin {

  ReportManagementController _reportController = Get.put(ReportManagementController());

  int _currentSelection = 0 ;
  late TabController controller;
  int dropdownvalue = 1;

  @override
  void initState() {
    // TODO: implement initState
    controller = TabController(length: 4, vsync: this);
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
              Expanded(child: TabBarView(
                  controller: controller,
                  children:[
                    saleReportDataTable(),
                    stockReportDataTable(),
                    profitLossReportDataTable(),
                    wasteReportDataTable(),
                  ]))
            ],
          )
      ),
    );
  }

  itemTitleHeader() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Text(
              'Reports',
              style: TextStyle(fontSize: fontBig, color: primaryText),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 25),
            child: OutlinedButton.icon(
              icon: Icon(
                Icons.add,
                color: primaryText,
              ),
              label: Text(
                "Add New Reports",
                style: TextStyle(
                  color: primaryText,
                ),
              ),
              onPressed: () {
                // showCustomDialog(context, "Add New Ingredient",
                //     addIngrediant(1), 30, 400);
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

  customTapbarHeader(TabController controller) {
    return Padding(
        padding: EdgeInsets.all(15.0),
        child:Row(
          children: [
            Expanded(
                flex: 1,
                child: MaterialSegmentedControl(
                    children: {
                      0: Text(
                        'Sale Report',
                        style: TextStyle(
                            color: _currentSelection == 0 ? white : Colors.black),
                      ),
                      1: Text(
                        'Stock Report',
                        style: TextStyle(
                            color: _currentSelection == 1 ? white : Colors.black),
                      ),
                      2: Text(
                        'Profit Loss Report',
                        style: TextStyle(
                            color: _currentSelection == 2 ? white : Colors.black),
                      ),
                      3: Text(
                        'Waste Report',
                        style: TextStyle(
                            color: _currentSelection == 3 ? white : Colors.black),
                      ),
                    },
                    selectionIndex: _currentSelection,
                    borderColor: Colors.grey,
                    selectedColor: primaryColor,
                    unselectedColor: Colors.white,
                    borderRadius: 32.0,
                    onSegmentChosen: (index)
                    {
                      print(index);
                      setState(() {
                        _currentSelection=index;
                        controller.index = _currentSelection;
                      });
                    }
                )
            ),
            Expanded(
                flex: 1,
                child:Container(
                    margin: EdgeInsets.only(left:100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          elevation: 0.0,
                          child: SizedBox(
                              width:250,
                              height:30,
                              child: TextField(
                                  style: TextStyle(
                                    fontSize: fontSmall,
                                    color: primaryColor,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white10,
                                    contentPadding: EdgeInsets.fromLTRB(10, 3, 10, 0),
                                    prefixIcon: Icon(
                                      Icons.search, size:18,
                                    ),
                                    hintText: "Search Item",
                                    hintStyle: TextStyle(
                                        fontSize: fontVerySmall, color: black
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width:1, color: Colors.transparent)),
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
                                    width:10,
                                  ),
                                  Container(
                                    height:30,
                                    padding: const EdgeInsets.only(left:15, right: 15),
                                    decoration: BoxDecoration(
                                        color: white,
                                        borderRadius: BorderRadius.circular(25.0),
                                        border: Border.all(color: Colors.black12)
                                    ),
                                    child: DropdownButton<int>(
                                      hint: Text(
                                        '1',
                                        style: TextStyle(color: black),
                                      ),
                                      dropdownColor: white,
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      iconSize: 15,
                                      underline: SizedBox(),
                                      value: dropdownvalue,
                                      items: <int>[1, 2, 3, 4].map((int value) {
                                        return DropdownMenuItem<int>(
                                          value: value,
                                          child: Text(value.toString()),
                                        );
                                      }).toList(),
                                      onChanged: (int? newVal) {
                                        setState(() {
                                          dropdownvalue = newVal!;
                                        });
                                      },
                                    ),
                                  ),

                                  SizedBox(width:10),
                                  Text("Entries",
                                    style: TextStyle(color: textSecondary),
                                  )
                                ]
                            )
                        )
                      ],
                    )
                )
            )
          ],
        )
    );
  }

  saleReportDataTable() {
    return Card(
      color: secondaryBackground,
      child: SingleChildScrollView(
        child: GetBuilder<ReportManagementController>(builder: (controller) {
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
                    'Invoice',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Customer Name',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Type',
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
                    'Date',
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
              rows: controller.saleRepData.value.data!
                  .map(
                    (item) => DataRow(
                  cells: [
                    DataCell(
                      Text(
                        '${item.id ?? ""}',
                        style: TextStyle(color: primaryText),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${item.invoice ?? ""}',
                        style: TextStyle(color: primaryText),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${item.customerName?? ""}',
                        style: TextStyle(color: primaryText),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${item.type ?? ""}',
                        style: TextStyle(color: primaryText),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${item.grandTotal ?? ""}',
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
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Color(0xffE1FDE8),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: GestureDetector(
                          onTap: () {},
                          child: Image.asset(
                            "assets/hide.png",
                            height: 15,
                            width: 15,
                            color: Color(0xff00A600),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
                  .toList());
        }),
      ),
    );
  }

  stockReportDataTable() {
    return Card(
      color: secondaryBackground,
      child: SingleChildScrollView(
        child: GetBuilder<ReportManagementController>(builder: (controller) {
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
                    'Quantity Amount',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Ingredient Name',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Ingredient Code',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Alert Quantity',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Category Name',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Unit name',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
              ],
              rows: controller.stockRepData.value.data!
                  .map(
                    (item) => DataRow(
                  cells: [
                    DataCell(
                      Text(
                        '${item.id ?? ""}',
                        style: TextStyle(color: primaryText),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${item.qtyAmount ?? ""}',
                        style: TextStyle(color: primaryText),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${item.ingredient.name?? ""}',
                        style: TextStyle(color: primaryText),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${item.ingredient.code?? ""}',
                        style: TextStyle(color: primaryText),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${item.ingredient.alertQty?? ""}',
                        style: TextStyle(color: primaryText),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${item.ingredient.category.name ?? ""}',
                        style: TextStyle(color: primaryText),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${item.ingredient.unit?.name ?? ""}',
                        style: TextStyle(color: primaryText),
                      ),
                    ),
                  ],
                ),
              )
                  .toList());
        }),
      ),
    );
  }

  profitLossReportDataTable() {
    return Card(
      color: secondaryBackground,
      child: SingleChildScrollView(
        child: GetBuilder<ReportManagementController>(builder: (controller)=>
            DataTable(
              columns: [
                DataColumn(label: Text('Loss Item', style: TextStyle(color: textSecondary))),
                DataColumn(label: Text('Amount', style: TextStyle(color: textSecondary))),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text("Total Purchase Shipping Charge: ")),
                  DataCell(Text(controller.profitLossData.value.grossProfit.toString())),
                ]),
              DataRow(cells: [
                DataCell(Text("Total Purchase Discount: ")),
                DataCell(Text(controller.profitLossData.value.totalPurchaseDiscount.toString())),
              ]),
              DataRow(cells: [
                DataCell(Text("Total Purchase: ")),
                DataCell(Text(controller.profitLossData.value.totalPurchase.toString())),
              ]),
              DataRow(cells: [
                DataCell(Text("Total Sell Discount: ")),
                DataCell(Text(controller.profitLossData.value.totalSellDiscount.toString())),
              ]),
              DataRow(cells: [
                DataCell(Text("Total Customer Reward: ")),
                DataCell(Text(controller.profitLossData.value.totalCustomerReward.toString())),
              ]),
              DataRow(cells: [
                DataCell(Text("Total Expense: ")),
                DataCell(Text(controller.profitLossData.value.totalExpense.toString())),
              ]),
              DataRow(cells: [
                DataCell(Text("Total Waste: ")),
                DataCell(Text(controller.profitLossData.value.totalWaste.toString())),
              ]),
              DataRow(cells: [
                DataCell(Text("Total Sell Shipping Charge: ")),
                DataCell(Text(controller.profitLossData.value.totalSellShippingCharge.toString())),
              ]),
              DataRow(cells: [
                DataCell(Text("Total Sell Service Charge: ")),
                DataCell(Text(controller.profitLossData.value.totalSellServiceCharge.toString())),
              ]),
              DataRow(cells: [
                DataCell(Text("Total Sales: ")),
                DataCell(Text(controller.profitLossData.value.totalSales.toString())),
              ]),
              DataRow(cells: [
                DataCell(Text("Total Sell Vat: ")),
                DataCell(Text(controller.profitLossData.value.totalSellVat.toString())),
              ]),
              DataRow(cells: [
                DataCell(Text("Gross Profit: ")),
                DataCell(Text(controller.profitLossData.value.grossProfit.toString())),
              ]),
              DataRow(cells: [
                DataCell(Text("Net Profit: ")),
                DataCell(Text(controller.profitLossData.value.netProfit.toString())),
              ]),
            ],
          ),
        ),
      )
    );
  }

  wasteReportDataTable() {
    return Card(
      color: secondaryBackground,
      child: SingleChildScrollView(
        child: GetBuilder<ReportManagementController>(builder: (controller) {
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
                    'Name',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Ref No',
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
                    'Added By',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Total Loss',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
              ],
              rows: controller.wasteRepData.value.data!
                  .map(
                    (item) => DataRow(
                  cells: [
                    DataCell(
                      Text(
                        '${item.id ?? ""}',
                        style: TextStyle(color: primaryText),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${item.personName ?? ""}',
                        style: TextStyle(color: primaryText),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${item.referenceNo?? ""}',
                        style: TextStyle(color: primaryText),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${item.date?? ""}',
                        style: TextStyle(color: primaryText),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 300,
                        child: Text(
                          '${item.note?? ""}',
                          style: TextStyle(color: primaryText),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${item.addedBy?? ""}',
                        style: TextStyle(color: primaryText),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${item.totalLoss?? ""}',
                        style: TextStyle(color: primaryText),
                      ),
                    ),
                  ],
                ),
              )
                  .toList());
        }),
      ),
    );
  }

}

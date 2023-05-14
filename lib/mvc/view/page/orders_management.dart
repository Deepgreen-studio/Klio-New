import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

import '../../../constant/color.dart';
import '../../../constant/value.dart';
import '../../controller/orders_management_controller.dart';
import '../../model/all_orders_model.dart';
import '../dialog/custom_dialog.dart';

class OrdersManagement extends StatefulWidget {
  const OrdersManagement({Key? key}) : super(key: key);

  @override
  State<OrdersManagement> createState() => _OrdersManagementState();
}

class _OrdersManagementState extends State<OrdersManagement>
    with SingleTickerProviderStateMixin {
  OrdersManagementController _ordersManagementController =
      Get.put(OrdersManagementController());

  int _currentSelection = 0;
  late TabController controller;
  int dropdownvalue = 1;

  late ScrollController scrollController;
  bool isLoading = false;
  bool hasMore = true;
  int page = 1;

  @override
  void initState() {
    // TODO: implement initState
    controller = TabController(vsync: this, length: 5);

    scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent * 0.95 &&
          !isLoading) {
        page++;
        if (hasMore) {
          if(_currentSelection==0){
            _ordersManagementController.getOrdersData(pageKey: page);
          }
          else if(_currentSelection==1){
            _ordersManagementController.getSuccessData(pageKey: page);
          }
          else{

          }
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
                    allOrder(context),
                    successOrder(context),
                    processingOrder(context),
                    pendingOrders(context),
                    cancelOrder(context),
                  ]),
                )
              ],
            )));
  }

  itemTitleHeader() {
    if (_currentSelection == 0) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                'Order List',
                style: TextStyle(fontSize: fontBig, color: primaryText),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 25),
              child: Row(
                children: [
                  OutlinedButton.icon(
                    icon: Icon(
                      Icons.add,
                      color: primaryText,
                    ),
                    label: Text(
                      "Add New Orders",
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
                ],
              ),
            )
          ],
        ),
      );
    } else if (_currentSelection == 1) {
      return Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  'Order List',
                  style: TextStyle(fontSize: fontBig, color: primaryText),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 25),
                child: Row(
                  children: [
                    OutlinedButton.icon(
                      icon: Icon(
                        Icons.add,
                        color: primaryText,
                      ),
                      label: Text(
                        "Add Success Orders",
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
                  ],
                ),
              )
            ],
          ));
    } else if (_currentSelection == 2) {
      return Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  'Order List',
                  style: TextStyle(fontSize: fontBig, color: primaryText),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 25),
                child: Row(
                  children: [
                    OutlinedButton.icon(
                      icon: Icon(
                        Icons.add,
                        color: primaryText,
                      ),
                      label: Text(
                        "Add Processing Orders",
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
                  ],
                ),
              )
            ],
          ));
    } else if (_currentSelection == 3) {
      return Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  'Order List',
                  style: TextStyle(fontSize: fontBig, color: primaryText),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 25),
                child: Row(
                  children: [
                    OutlinedButton.icon(
                      icon: Icon(
                        Icons.add,
                        color: primaryText,
                      ),
                      label: Text(
                        "Add Pending Orders",
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
                  ],
                ),
              )
            ],
          ));
    } else if (_currentSelection == 4) {
      return Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  'Order List',
                  style: TextStyle(fontSize: fontBig, color: primaryText),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 25),
                child: Row(
                  children: [
                    OutlinedButton.icon(
                      icon: Icon(
                        Icons.add,
                        color: primaryText,
                      ),
                      label: Text(
                        "Add Cancel Orders",
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
                  ],
                ),
              )
            ],
          ));
    }
    return Container();
  }

  customTapbarHeader(TabController controller) {
    return Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: MaterialSegmentedControl(
                children: {
                  0: Text(
                    'All Orders',
                    style: TextStyle(
                        color: _currentSelection == 0 ? white : Colors.black),
                  ),
                  1: Text(
                    'Success Orders',
                    style: TextStyle(
                        color: _currentSelection == 1 ? white : Colors.black),
                  ),
                  2: Text(
                    'Processing Orders',
                    style: TextStyle(
                        color: _currentSelection == 2 ? white : Colors.black),
                  ),
                  3: Text(
                    'Pending Order',
                    style: TextStyle(
                        color: _currentSelection == 3 ? white : Colors.black),
                  ),
                  4: Text(
                    'Cancel Orders',
                    style: TextStyle(
                        color: _currentSelection == 4 ? white : Colors.black),
                  ),
                },
                selectionIndex: _currentSelection,
                borderColor: Colors.grey,
                selectedColor: primaryColor,
                unselectedColor: Colors.white,
                borderRadius: 32.0,
                // disabledChildren: [
                //   6,
                // ],
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
                                  color: primaryColor,
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
                                      fontSize: fontVerySmall, color: black),
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
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(25.0),
                                  border: Border.all(color: Colors.black12)),
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
        ));
  }

  Widget allOrder(BuildContext context) {
    return Card(
        color: secondaryBackground,
        child: SingleChildScrollView(
            controller: scrollController,
            child:
                GetBuilder<OrdersManagementController>(builder: (controller) {
              return dataTable(controller, controller.allOrdersData.value.data!, controller.allOrdersData.value);
            })));
  }



  successOrder(BuildContext context) {
    return Card(
        color: secondaryBackground,
        child: SingleChildScrollView(
          controller: scrollController,
            child:
            GetBuilder<OrdersManagementController>(builder: (controller) {
          return dataTable(controller, controller.allSuccessData.value.data!, controller.allSuccessData.value);
        })));
  }

  Widget processingOrder(BuildContext context) {
    return Card(
      color: secondaryBackground,
    );
  }

  Widget pendingOrders(BuildContext context) {
    return Card(
      color: secondaryBackground,
    );
  }

  Widget cancelOrder(BuildContext context) {
    return Card(
      color: secondaryBackground,
    );
  }

  DataTable dataTable(OrdersManagementController controller, List<Datum> data, AllOrdersModel model ) {
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
              'Order Type',
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
              'Grand Total',
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
        rows: data.map(
              (item) {
            if (model.data?.last == item) {
              return DataRow(cells: [
                DataCell(CircularProgressIndicator(
                    color: Colors.transparent)),
                DataCell(CircularProgressIndicator(
                    color: Colors.transparent)),
                DataCell(CircularProgressIndicator(
                    color: Colors.transparent)),
                DataCell(CircularProgressIndicator()),
                DataCell(CircularProgressIndicator(
                    color: Colors.transparent)),
                DataCell(CircularProgressIndicator(
                    color: Colors.transparent)),
                DataCell(CircularProgressIndicator(
                    color: Colors.transparent)),
              ]);
            }
           else if(!hasMore){
              return DataRow(
                cells: [
                  DataCell(CircularProgressIndicator(
                      color: Colors.transparent)),
                  DataCell(CircularProgressIndicator(
                      color: Colors.transparent)),
                  DataCell(CircularProgressIndicator(
                      color: Colors.transparent)),
                  DataCell(Text('No Data')),
                  DataCell(CircularProgressIndicator(
                      color: Colors.transparent)),
                  DataCell(CircularProgressIndicator(
                      color: Colors.transparent)),
                  DataCell(CircularProgressIndicator(
                      color: Colors.transparent)),
                ]
              );
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
                    '${item.invoice ?? ""}',
                    style: TextStyle(color: primaryText),
                  ),
                ),
                DataCell(
                  Text(
                    '${item.customerName ?? ""}',
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
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                        color: item.status == "success"
                            ? green
                            : item.status == "processing"
                            ? primaryColor
                            : red,
                        borderRadius:
                        BorderRadius.all(Radius.circular(5))),
                    child: Text(
                      '${item.status ?? ""}',
                      style: TextStyle(color: white),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    '${item.grandTotal ?? ""}',
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
                    child: Image.asset(
                      "assets/hide.png",
                      height: 15,
                      width: 15,
                      color: Color(0xff00A600),
                    ),
                  ),
                )
              ],
            );
          },
        ).toList());
  }
}

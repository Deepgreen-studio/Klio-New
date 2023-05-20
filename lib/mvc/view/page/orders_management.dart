import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import '../../../constant/color.dart';
import '../../../constant/value.dart';
import '../../controller/orders_management_controller.dart';
import '../../model/all_orders_model.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    controller = TabController(vsync: this, length: 5);

    scrollController = ScrollController();

    controller.addListener(() {
      _currentSelection = controller.index;
      _ordersManagementController.update(['changeTabBar']);

      if (_currentSelection == 1 &&
          _ordersManagementController.allSuccessData.value.data!.isEmpty) {
        _ordersManagementController.getSuccessData();
      } else if (_currentSelection == 2 &&
          _ordersManagementController.allProcessingData.value.data!.isEmpty) {
        _ordersManagementController.getProcessingData();
      } else if (_currentSelection == 3 &&
          _ordersManagementController.allPendingData.value.data!.isEmpty) {
        _ordersManagementController.getPendingData();
      } else if (_currentSelection == 4 &&
          _ordersManagementController.allCancelData.value.data!.isEmpty) {
        _ordersManagementController.getCancelData();
      }
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent * 0.95) {
        if (_currentSelection == 0 &&
            !_ordersManagementController.isLoadingAllOrder) {
          _ordersManagementController.getOrdersData();
        } else if (_currentSelection == 1 &&
            !_ordersManagementController.isLoadingSuccessOrder) {
          _ordersManagementController.getSuccessData();
        } else if (_currentSelection == 2 &&
            !_ordersManagementController.isLoadingProcessingOrder) {
          _ordersManagementController.getProcessingData();
        } else if (_currentSelection == 3 &&
            !_ordersManagementController.isLoadingPendingOrder) {
          _ordersManagementController.getPendingData();
        } else if (_currentSelection == 4 &&
            !_ordersManagementController.isLoadingCancelOrder) {
          _ordersManagementController.getCancelData();
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
                customTapBarHeader(controller),
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
                margin: const EdgeInsets.only(right: 25),
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
                        side: const BorderSide(width: 1.0, color: primaryColor),
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

  customTapBarHeader(TabController controller) {
    return Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(
          children: [
            GetBuilder<OrdersManagementController>(
                id: "changeTabBar",
                builder: (context) {
                  return Expanded(
                    flex: 1,
                    child: MaterialSegmentedControl(
                      children: {
                        0: Text(
                          'All Orders',
                          style: TextStyle(
                              color: _currentSelection == 0
                                  ? white
                                  : Colors.black),
                        ),
                        1: Text(
                          'Success Orders',
                          style: TextStyle(
                              color: _currentSelection == 1
                                  ? white
                                  : Colors.black),
                        ),
                        2: Text(
                          'Processing Orders',
                          style: TextStyle(
                              color: _currentSelection == 2
                                  ? white
                                  : Colors.black),
                        ),
                        3: Text(
                          'Pending Order',
                          style: TextStyle(
                              color: _currentSelection == 3
                                  ? white
                                  : Colors.black),
                        ),
                        4: Text(
                          'Cancel Orders',
                          style: TextStyle(
                              color: _currentSelection == 4
                                  ? white
                                  : Colors.black),
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
                      onSegmentTapped: (index) {
                        if (index == 0 &&
                            _ordersManagementController
                                .allOrdersData.value.data!.isEmpty) {
                          _ordersManagementController.getOrdersData();
                        } else if (index == 1 &&
                            _ordersManagementController
                                .allSuccessData.value.data!.isEmpty) {
                          _ordersManagementController.getSuccessData();
                        } else if (index == 2 &&
                            _ordersManagementController
                                .allProcessingData.value.data!.isEmpty) {
                          _ordersManagementController.getProcessingData();
                        } else if (index == 3 &&
                            _ordersManagementController
                                .allPendingData.value.data!.isEmpty) {
                          _ordersManagementController.getPendingData();
                        } else if (index == 4 &&
                            _ordersManagementController
                                .allCancelData.value.data!.isEmpty) {
                          _ordersManagementController.getCancelData();
                        }
                        print("${index}indexxxxxxxxxxxxxxxxxxxxxxxxxxx");
                        setState(() {
                          _currentSelection = index;
                          controller.index = _currentSelection;
                        });
                      },
                    ),
                  );
                }),
            Container(
              margin: EdgeInsets.only(left: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                   Card(
                    elevation: 0.0,
                    child: SizedBox(
                        width: 300,
                        height: 40,
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
                                size: 20,
                              ),
                              hintText: "Search Item",
                              hintStyle: TextStyle(
                                  fontSize: fontSmall, color: black),
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
                ],
              ),
            ),
          ],
        ));
  }

  Widget allOrder(BuildContext context) {
    return Card(
      color: secondaryBackground,
      child: SingleChildScrollView(
        controller: scrollController,
        child: GetBuilder<OrdersManagementController>(
          id: "allOrders",
          builder: (controller) {
            return dataTable(
              controller,
              controller.allOrdersData.value.data ?? [],
              controller.allOrdersData.value.data!.isNotEmpty
                  ? controller.allOrdersData.value.data!.last
                  : Datum(),
              controller.haveMoreAllOrder,
              controller.isLoadingAllOrder,
            );
          },
        ),
      ),
    );
  }

  successOrder(BuildContext context) {
    return Card(
      color: secondaryBackground,
      child: SingleChildScrollView(
        controller: scrollController,
        child: GetBuilder<OrdersManagementController>(
          id: "allSuccessOrders",
          builder: (controller) {
            return dataTable(
              controller,
              controller.allSuccessData.value.data ?? [],
              controller.allSuccessData.value.data!.isNotEmpty
                  ? controller.allSuccessData.value.data!.last
                  : Datum(),
              controller.haveMoreSuccessOrder,
              controller.isLoadingSuccessOrder,
            );
          },
        ),
      ),
    );
  }

  Widget processingOrder(BuildContext context) {
    return Card(
      color: secondaryBackground,
      child: SingleChildScrollView(
        controller: scrollController,
        child: GetBuilder<OrdersManagementController>(
          id: "allProcessingOrders",
          builder: (controller) {
            return dataTable(
              controller,
              controller.allProcessingData.value.data ?? [],
              controller.allProcessingData.value.data!.isNotEmpty
                  ? controller.allProcessingData.value.data!.last
                  : Datum(),
              controller.haveMoreProcessingOrder,
              controller.isLoadingProcessingOrder,
            );
          },
        ),
      ),
    );
  }

  Widget pendingOrders(BuildContext context) {
    return Card(
      color: secondaryBackground,
      child: SingleChildScrollView(
        controller: scrollController,
        child: GetBuilder<OrdersManagementController>(
          id: "allPendingOrders",
          builder: (controller) {
            print("*********************************************");
            print(controller.allPendingData.value.data!.length);
            return dataTable(
              controller,
              controller.allPendingData.value.data ?? [],
              controller.allPendingData.value.data!.isNotEmpty
                  ? controller.allPendingData.value.data!.last
                  : Datum(),
              controller.haveMorePendingOrder,
              controller.isLoadingPendingOrder,
            );
          },
        ),
      ),
    );
  }

  Widget cancelOrder(BuildContext context) {
    return Card(
      color: secondaryBackground,
      child: SingleChildScrollView(
        controller: scrollController,
        child: GetBuilder<OrdersManagementController>(
          id: "allCancelOrders",
          builder: (controller) {
            return dataTable(
                controller,
                controller.allCancelData.value.data ?? [],
                controller.allCancelData.value.data!.isNotEmpty
                    ? controller.allCancelData.value.data!.last
                    : Datum(),
                controller.haveMoreCancelOrder,
                controller.isLoadingCancelOrder);
          },
        ),
      ),
    );
  }

  DataTable dataTable(OrdersManagementController controller, List<Datum> data,
      Datum lastItem, bool haveMoreData, bool isLoading) {
    if (!haveMoreData && data.last.id != 0) {
      data.add(Datum(id: 0));
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
            if (item.id == 0 && !haveMoreData) {
              return const DataRow(cells: [
                DataCell(CircularProgressIndicator(color: Colors.transparent)),
                DataCell(CircularProgressIndicator(color: Colors.transparent)),
                DataCell(CircularProgressIndicator(color: Colors.transparent)),
                DataCell(Text('No Data')),
                DataCell(CircularProgressIndicator(color: Colors.transparent)),
                DataCell(CircularProgressIndicator(color: Colors.transparent)),
                DataCell(CircularProgressIndicator(color: Colors.transparent)),
              ]);
            } else if (item == lastItem && !isLoading && haveMoreData) {
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
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                        color: item.status == "success"
                            ? green
                            : item.status == "processing"
                                ? primaryColor
                                : red,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
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

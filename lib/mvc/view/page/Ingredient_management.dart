
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:klio_staff/constant/color.dart';
import 'package:klio_staff/constant/value.dart';
import 'package:klio_staff/mvc/controller/Ingredient_management_controller.dart';
import 'package:klio_staff/mvc/model/ingredient_category_model.dart';
import 'package:klio_staff/mvc/model/ingredient_unit_model.dart';
import 'package:klio_staff/mvc/view/widget/custom_widget.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:klio_staff/mvc/view/dialog/custom_dialog.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class IngredientManagement extends StatefulWidget {
  const IngredientManagement({Key? key}) : super(key: key);

  @override
  State<IngredientManagement> createState() => _IngredientManagementState();
}

class _IngredientManagementState extends State<IngredientManagement>
    with SingleTickerProviderStateMixin {
  IngredientController _ingredientController = Get.put(IngredientController());

  int _currentSelection = 0;
  late TabController controller;


  @override
  void initState() {
    // TODO: implement initState
    controller = TabController(vsync: this, length: 4);
    super.initState();
  }

  int dropdownvalue = 1;

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
                  ingedietnDataTable(),
                  ingredientCategoryDataTable(),
                  ingredientUintDataTable(),
                  ingredientSupplierDataTable(),
                ]),
              )
            ],
          ),
        ));
  }

  Widget ingedietnDataTable() {
    return Card(
      color: secondaryBackground,
      child: SingleChildScrollView(
        child: GetBuilder<IngredientController>(builder: (controller) {
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
                    'Code',
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
                    'Category',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Purchase Price',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Alert Qty',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Unit',
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
              rows: controller.ingredientData.value.data!.reversed
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
                        '${item.code ?? ""}',
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
                        '${item.categoryName ?? ""}',
                        style: TextStyle(color: primaryText),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${item.purchasePrice ?? ""}',
                        style: TextStyle(color: primaryText),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${item.alertQty ?? ""}',
                        style: TextStyle(color: primaryText),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${item.unitName ?? ""}',
                        style: TextStyle(color: primaryText),
                      ),
                    ),
                    DataCell(
                      Row(
                        // mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Container(
                          //   height: 35,
                          //   width: 35,
                          //   decoration: BoxDecoration(
                          //     color: Color(0xffE1FDE8),
                          //     borderRadius: BorderRadius.circular(25.0),
                          //   ),
                          //   child: Image.asset(
                          //     "assets/hide.png",
                          //     height: 15,
                          //     width: 15,
                          //     color: Color(0xff00A600),
                          //   ),
                          // ),
                          // SizedBox(
                          //   width: 10,
                          // ),
                          Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Color(0xffFEF4E1),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _ingredientController
                                    .getSingleIngredientData(id: item.id)
                                    .then((value) {
                                  showCustomDialogResponsive(
                                    context,
                                    "Update Ingredient",
                                    updateIngrediant(item.id),
                                    300,
                                    400,
                                  );
                                  _ingredientController
                                      .updateIngrediantNameCtlr.text =
                                      _ingredientController
                                          .singleIngredientData
                                          .value
                                          .data!
                                          .name;
                                  _ingredientController
                                      .updateIngredientPriceCtlr.text =
                                      _ingredientController
                                          .singleIngredientData
                                          .value
                                          .data!
                                          .purchasePrice;
                                  _ingredientController
                                      .updateIngredintCodeCtlr.text =
                                      _ingredientController
                                          .singleIngredientData
                                          .value
                                          .data!
                                          .code;
                                  _ingredientController
                                      .updateIngredintUnitCtlr.text =
                                      _ingredientController
                                          .singleIngredientData
                                          .value
                                          .data!
                                          .unitName;
                                  _ingredientController
                                      .updateIngredintAlertQtyCtlr
                                      .text =
                                      _ingredientController
                                          .singleIngredientData
                                          .value
                                          .data!
                                          .alertQty;
                                });
                              },
                              child: Image.asset(
                                "assets/edit-alt.png",
                                height: 15,
                                width: 15,
                                color: Color(0xffED7402),
                              ),
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
                              onTap: () {
                                showWarningDialog(
                                    "Do you want to delete this item?",
                                    onAccept: () async {
                                      _ingredientController
                                          .deleteIngredientDataList(id: item.id);
                                      Get.back();
                                    }
                                );
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

  Widget ingredientCategoryDataTable() {
    return Card(
      color: secondaryBackground,
      child: SingleChildScrollView(
        child: GetBuilder<IngredientController>(builder: (controller) {
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
              rows: controller.ingredientCategoryData.value.data.reversed
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
                          color: Color(0xffFFE7E6),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            showWarningDialog(
                                "Do you want to delete this item?",
                                onAccept: () async {
                                  _ingredientController
                                      .deleteIngredientCategory(id: item.id);
                                  Get.back();
                                }
                            );
                          },
                          child: Image.asset(
                            "assets/delete.png",
                            height: 15,
                            width: 15,
                            color: Color(0xffED0206),
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

  Widget ingredientUintDataTable() {
    return Card(
      color: secondaryBackground,
      child: SingleChildScrollView(
        child: GetBuilder<IngredientController>(builder: (controller) {
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
                    'Description',
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
              rows: controller.ingredientUnitData.value.data.reversed
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
                        '${item.name ?? ""}',
                        style: TextStyle(color: primaryText),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${item.description ?? ""}',
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
                              color: Color(0xffFFE7E6),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                showWarningDialog(
                                    "Do you want to delete this item?",
                                    onAccept: () async {
                                      _ingredientController.deleteIngredientUnit(
                                          id: item.id);
                                      Get.back();
                                    }
                                );
                              },
                              child: Image.asset(
                                "assets/delete.png",
                                height: 15,
                                width: 15,
                                color: Color(0xffED0206),
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

  Widget ingredientSupplierDataTable() {
    return Card(
      color: secondaryBackground,
      child: SingleChildScrollView(
        child: GetBuilder<IngredientController>(builder: (controller) {
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
                    'Email',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Phone',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Reference',
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
              rows: controller.ingredientSupplierData.value.data.reversed
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
                        '${item.name ?? ""}',
                        style: TextStyle(color: primaryText),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${item.email ?? ""}',
                        style: TextStyle(color: primaryText),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${item.phone ?? ""}',
                        style: TextStyle(color: primaryText),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${item.reference ?? ""}',
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
                              color: Color(0xffE1FDE8),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: GestureDetector(
                              onTap:(){
                                _ingredientController.getSupplierSingleDetails(id: item.id)
                                    .then((value) {
                                  showCustomDialog(context, "Supplier Details",
                                      viewSupplierDetails(), 100, 400);
                                });
                              },
                              child: Image.asset(
                                "assets/hide.png",
                                height: 15,
                                width: 15,
                                color: Color(0xff00A600),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Color(0xffFEF4E1),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _ingredientController.getSupplierSingleDetails(id: item.id)
                                .then((value) {
                                  _ingredientController.updateSupplierNameCtlr.text =
                                      _ingredientController.ingredientSupplierSingleItem.value.data!.name;
                                  _ingredientController.updateSupplierEmailCtlr.text =
                                      _ingredientController.ingredientSupplierSingleItem.value.data!.email;
                                  _ingredientController.updateSupplierPhoneCtlr.text=
                                      _ingredientController.ingredientSupplierSingleItem.value.data!.phone;
                                  _ingredientController.updateSupplierRefCtlr.text=
                                      _ingredientController.ingredientSupplierSingleItem.value.data!.reference;
                                  _ingredientController.updateSupplierAddressCtlr.text =
                                      _ingredientController.ingredientSupplierSingleItem.value.data!.address;

                                  showCustomDialog(context, 'Update Supplier',
                                      updateSupplier(item.id), 30, 400);
                                });

                              },
                              child: Image.asset(
                                "assets/edit-alt.png",
                                height: 15,
                                width: 15,
                                color: Color(0xffED7402),
                              ),
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
                              onTap: () {
                                showWarningDialog(
                                    "Do you want to delete this item?",
                                    onAccept: () async {
                                      _ingredientController
                                          .deleteIngredientSupplier(id: item.id);
                                      Get.back();
                                    }
                                );
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
                  'Ingredient',
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
                    "Add New Ingredient",
                    style: TextStyle(
                      color: primaryText,
                    ),
                  ),
                  onPressed: () {
                    showCustomDialog(context, "Add New Ingredient",
                        addIngrediant(1), 30, 400);
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
      else if (_currentSelection == 1) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  'Ingredient',
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
                    "Add New Category",
                    style: TextStyle(
                      color: primaryText,
                    ),
                  ),
                  onPressed: () {
                    showCustomDialog(context, 'Add New Category',
                        addIngredientcategory(1), 100, 400);
                  },
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(width: 1.0, color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      else if (_currentSelection == 2) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  'Ingredient',
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
                    "Add New Unit",
                    style: TextStyle(
                      color: primaryText,
                    ),
                  ),
                  onPressed: () {
                    showCustomDialog(
                        context, 'Add New Unit', addNewUnit(1), 100, 300);
                  },
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(width: 1.0, color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      else if (_currentSelection == 3) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  'Ingredient',
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
                    "Add New Supplier",
                    style: TextStyle(
                      color: primaryText,
                    ),
                  ),
                  onPressed: () {
                    showCustomDialog(context, "Add New Supplier",
                        addNewSupplier(1), 30, 400);
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
      return Container();
    });
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
                  'Ingredient',
                  style: TextStyle(
                      color: _currentSelection == 0 ? white : Colors.black),
                ),
                1: Text(
                  'Category',
                  style: TextStyle(
                      color: _currentSelection == 1 ? white : Colors.black),
                ),
                2: Text(
                  'Unit',
                  style: TextStyle(
                      color: _currentSelection == 2 ? white : Colors.black),
                ),
                3: Text(
                  'Supplier',
                  style: TextStyle(
                      color: _currentSelection == 3 ? white : Colors.black),
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
                            padding: const EdgeInsets.only(left: 15, right: 15),
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
      ),
    );
  }

  Widget addIngrediant(dynamic itemId) {
    return Container(
      height: Size.infinite.height,
      width: Size.infinite.width,
      padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
      child: Form(
        key: _ingredientController.addIngredintFormKey,
        child: ListView(children: [
          textRow('Name', 'Purchase Price'),
          textFieldRow('Enter Ingrediant name', 'Enter Purchase price',
              controller1: _ingredientController.addIngrediantNameCtlr,
              controller2: _ingredientController.addIngredientPriceCtlr,
              validator1: _ingredientController.textValidator,
              validator2: _ingredientController.textValidator,
              textInputType1: TextInputType.text,
              textInputType2: TextInputType.number),
          SizedBox(height: 10),
          textRow('Code', 'Alert Qty'),
          textFieldRow('Enter Code', 'Enter Alert Qty',
              controller1: _ingredientController.addIngredintCodeCtlr,
              controller2: _ingredientController.addIngredintUnitCtlr,
              validator1: _ingredientController.textValidator,
              validator2: _ingredientController.textValidator,
              textInputType1: TextInputType.number,
              textInputType2: TextInputType.number),
          SizedBox(height: 10),
          textRow('Select Category', 'Select Unit'),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child:
                  GetBuilder<IngredientController>(builder: (controller) {
                    return MultiSelectDropDown(
                      backgroundColor: secondaryBackground,
                      optionsBackgroundColor: secondaryBackground,
                      selectedOptionTextColor: primaryText,
                      selectedOptionBackgroundColor: primaryColor,
                      optionTextStyle:
                      TextStyle(color: primaryText, fontSize: 16),
                      onOptionSelected: (List<ValueItem> selectedOptions) {
                        // foodCtlr.updateMealPeriodIdList = selectedOptions
                        //     .map((ValueItem e) => int.parse(e.value!))
                        //     .toList();
                      },
                      // selectedOptions: foodCtlr.foodSingleItemDetails.value.data!.addons!.data!.map((MenuAddon e) {
                      //   return ValueItem(
                      //     label:e.name!,
                      //     value: e.id.toString(),
                      //   );
                      // }).toList(),
                      options: _ingredientController
                          .ingredientCategoryData.value.data
                          .map((IngrediantCategory e) {
                        return ValueItem(
                          label: e.name!,
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
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        border: Border.all(
                          color: primaryBackground,
                        ),
                      ),
                    );
                  })),
              SizedBox(width: 20),
              Expanded(
                  flex: 1,
                  child:
                  GetBuilder<IngredientController>(builder: (controller) {
                    return MultiSelectDropDown(
                      backgroundColor: secondaryBackground,
                      optionsBackgroundColor: secondaryBackground,
                      selectedOptionTextColor: primaryText,
                      selectedOptionBackgroundColor: primaryColor,
                      optionTextStyle:
                      TextStyle(color: primaryText, fontSize: 16),
                      onOptionSelected: (List<ValueItem> selectedOptions) {
                        // foodCtlr.updateMenuCategoryIdList = selectedOptions
                        //     .map((ValueItem e) => int.parse(e.value!))
                        //     .toList();
                      },
                      // selectedOptions: foodCtlr.foodSingleItemDetails.value.data!.addons!.data!.map((MenuAddon e) {
                      //   return ValueItem(
                      //     label:e.name!,
                      //     value: e.id.toString(),
                      //   );
                      // }).toList(),
                      options: _ingredientController
                          .ingredientUnitData.value.data
                          .map((IngrediantUnit e) {
                        return ValueItem(
                          label: e.name,
                          value: e.id.toString(),
                        );
                      }).toList(),
                      hint: 'Select Unit',
                      selectionType: SelectionType.single,
                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                      dropdownHeight: 300,
                      selectedOptionIcon: const Icon(Icons.check_circle),
                      inputDecoration: BoxDecoration(
                        color: secondaryBackground,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        border: Border.all(
                          color: primaryBackground,
                        ),
                      ),
                    );
                  })),
            ],
          ),
          SizedBox(height: 10),
          Container(
              height: 40,
              width: 50,
              alignment: Alignment.bottomRight,
              child: normalButton('Submit', primaryColor, white,
                  onPressed: () async {
                    if (_ingredientController.addIngredintFormKey.currentState!
                        .validate()) {
                      // foodCtlr.updateVariant(
                      //   foodCtlr.updateSelectVariantMenuItem[0],
                      //   foodCtlr.updateMealVariantsNameTextCtlr.text,
                      //   foodCtlr.updateMealVariantsPriceTextCtlr.text,
                      //   id:itemId,
                      // );

                      _ingredientController.addAndUpdateIngrediant(
                          true,
                          _ingredientController.addIngrediantNameCtlr.text,
                          _ingredientController.addIngredientPriceCtlr.text,
                          _ingredientController.addIngredintCodeCtlr.text,
                          2.toString(),
                          5.toString(),
                          1.toString(),
                      );
                    }
                  })),
        ]),
      ),
    );
  }

  Widget updateIngrediant(dynamic itemId) {
    return Container(
      height: Size.infinite.height,
      width: Size.infinite.width,
      padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
      child: Form(
        key: _ingredientController.updateIngredintFormKey,
        child: ListView(children: [
          textRow('Name', 'Purchase Price'),
          textFieldRow('Enter Ingredient name', 'Enter Purchase price',
            controller1: _ingredientController.updateIngrediantNameCtlr,
            controller2: _ingredientController.updateIngredientPriceCtlr,
            validator1: _ingredientController.textValidator,
            validator2: _ingredientController.textValidator,
            textInputType1: TextInputType.text,
            textInputType2: TextInputType.number,
          ),
          SizedBox(height: 10),
          textRow('Code', 'Alert Qty'),
          textFieldRow('Enter Code', 'Enter Alert Qty',
            controller1: _ingredientController.updateIngredintCodeCtlr,
            controller2: _ingredientController.updateIngredintAlertQtyCtlr,
            validator1: _ingredientController.textValidator,
            validator2: _ingredientController.textValidator,
            textInputType1: TextInputType.number,
            textInputType2: TextInputType.number,
          ),
          SizedBox(height: 10),
          textRow('Select Category', 'Select Unit'),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child:
                  GetBuilder<IngredientController>(builder: (controller) {
                    return MultiSelectDropDown(
                      backgroundColor: secondaryBackground,
                      optionsBackgroundColor: secondaryBackground,
                      selectedOptionTextColor: primaryText,
                      selectedOptionBackgroundColor: primaryColor,
                      optionTextStyle:
                      TextStyle(color: primaryText, fontSize: 16),
                      onOptionSelected: (List<ValueItem> selectedOptions) {
                        // foodCtlr.updateMealPeriodIdList = selectedOptions
                        //     .map((ValueItem e) => int.parse(e.value!))
                        //     .toList();
                      },
                      // selectedOptions: foodCtlr.foodSingleItemDetails.value.data!.addons!.data!.map((MenuAddon e) {
                      //   return ValueItem(
                      //     label:e.name!,
                      //     value: e.id.toString(),
                      //   );
                      // }).toList(),
                      options: _ingredientController
                          .ingredientCategoryData.value.data
                          .map((IngrediantCategory e) {
                        return ValueItem(
                          label: e.name,
                          value: e.id.toString(),
                        );
                      }).toList(),
                      hint: 'Select Category',
                      selectionType: SelectionType.single,
                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                      dropdownHeight: 300,
                      selectedOptionIcon: const Icon(Icons.check_circle),
                      inputDecoration: BoxDecoration(
                        color: secondaryBackground,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        border: Border.all(
                          color: primaryBackground,
                        ),
                      ),
                    );
                  })),
              SizedBox(width: 20),
              Expanded(
                  flex: 1,
                  child:
                  GetBuilder<IngredientController>(builder: (controller) {
                    return MultiSelectDropDown(
                      backgroundColor: secondaryBackground,
                      optionsBackgroundColor: secondaryBackground,
                      selectedOptionTextColor: primaryText,
                      selectedOptionBackgroundColor: primaryColor,
                      optionTextStyle:
                      TextStyle(color: primaryText, fontSize: 16),
                      onOptionSelected: (List<ValueItem> selectedOptions) {
                        // foodCtlr.updateMenuCategoryIdList = selectedOptions
                        //     .map((ValueItem e) => int.parse(e.value!))
                        //     .toList();
                      },
                      // selectedOptions: foodCtlr.foodSingleItemDetails.value.data!.addons!.data!.map((MenuAddon e) {
                      //   return ValueItem(
                      //     label:e.name!,
                      //     value: e.id.toString(),
                      //   );
                      // }).toList(),
                      options: _ingredientController
                          .ingredientUnitData.value.data
                          .map((IngrediantUnit e) {
                        return ValueItem(
                          label: e.name,
                          value: e.id.toString(),
                        );
                      }).toList(),
                      hint: 'Select Unit',
                      selectionType: SelectionType.multi,
                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                      dropdownHeight: 300,
                      selectedOptionIcon: const Icon(Icons.check_circle),
                      inputDecoration: BoxDecoration(
                        color: secondaryBackground,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        border: Border.all(
                          color: primaryBackground,
                        ),
                      ),
                    );
                  })),
            ],
          ),
          SizedBox(height: 10),
          Container(
            height: 40,
            width: 50,
            alignment: Alignment.bottomRight,
            child: normalButton('Submit', primaryColor, white,
                onPressed: () async {
                  if (_ingredientController.updateIngredintFormKey.currentState!
                      .validate()) {
                    _ingredientController.addAndUpdateIngrediant(
                        false,
                        _ingredientController.updateIngrediantNameCtlr.text,
                        _ingredientController.updateIngredientPriceCtlr.text,
                        _ingredientController.updateIngredintCodeCtlr.text,
                        _ingredientController.updateIngredintAlertQtyCtlr.text,
                        5.toString(),
                        1.toString(),
                      id: itemId.toString(),
                    );
                  }
                }),
          ),
        ]),
      ),
    );
  }

  Widget addIngredientcategory(dynamic itemId) {
    return Container(
      height: Size.infinite.height,
      width: Size.infinite.width,
      padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
      child: ListView(children: [
        textRow('Name', 'Status'),
        textFieldRow(
          'Enter Name',
          'Enter Status',
          controller1: _ingredientController.ingredientCategoryNameCtlr,
          controller2: _ingredientController.ingredientCategoryStatusCtlr,
          validator1: _ingredientController.textValidator,
          validator2: _ingredientController.textValidator,
          textInputType1: TextInputType.text,
          textInputType2: TextInputType.number,
        ),
        SizedBox(height: 10),
        Container(
          height: 40,
          width: 50,
          alignment: Alignment.bottomRight,
          child: normalButton(
            'Submit',
            primaryColor,
            white,
            onPressed: () async {
              _ingredientController.addAndUpdateIngrediantCategory(
                true,
                _ingredientController.ingredientCategoryNameCtlr.text,
                _ingredientController.ingredientCategoryStatusCtlr.text,
              );
            },
          ),
        ),
      ]),
    );
  }

  Widget addNewUnit(dynamic itemId) {
    return Container(
        height: Size.infinite.height,
        width: Size.infinite.width,
        padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
        child: ListView(
          children: [
            textRow('Name', 'Description'),
            textFieldRow(
              'Enter Unit Name',
              'Enter Description',
              controller1: _ingredientController.ingredientUnitNameCtlr,
              controller2: _ingredientController.ingredientUnitDescriptionCtlr,
              validator1: _ingredientController.textValidator,
              validator2: _ingredientController.textValidator,
              textInputType1: TextInputType.text,
              textInputType2: TextInputType.text,
            ),
            SizedBox(height: 10),
            Container(
              height: 40,
              width: 50,
              alignment: Alignment.bottomRight,
              child: normalButton(
                'Submit',
                primaryColor,
                white,
                onPressed: () async {
                  _ingredientController.addAndUpdateIngrediantUnit(
                    true,
                    _ingredientController.ingredientUnitNameCtlr.text,
                    _ingredientController.ingredientUnitDescriptionCtlr.text,
                    true,
                  );
                },
              ),
            ),
          ],
        ));
  }

  Widget addNewSupplier(dynamic itemId) {
    return Container(
        height: Size.infinite.height,
        width: Size.infinite.width,
        padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
        child: Form(
          key: _ingredientController.addIngredintSupplierFormKey,
          child: ListView(
            children: [
              textRow('Name', 'Email'),
              textFieldRow(
                'Enter Supplier name',
                'Enter Supplier Email',
                controller1:
                _ingredientController.addIngrediantSupplierNameCtlr,
                controller2:
                _ingredientController.addIngredientSupplierEmailCtlr,
                validator1: _ingredientController.textValidator,
                validator2: _ingredientController.textValidator,
                textInputType1: TextInputType.text,
                textInputType2: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),
              textRow('Phone', 'Reference'),
              textFieldRow(
                'Enter Phone',
                'Enter Reference',
                controller1:
                _ingredientController.addIngredintSupplierPhoneCtlr,
                controller2: _ingredientController.addIngredintSupplierRefCtlr,
                validator1: _ingredientController.textValidator,
                validator2: _ingredientController.textValidator,
                textInputType1: TextInputType.number,
                textInputType2: TextInputType.number,
              ),
              SizedBox(height: 10),
              textRow('Address', 'Status'),
              textFieldRow(
                'Enter Address',
                'Enter Status',
                controller1:
                _ingredientController.addIngredintSupplierAddressCtlr,
                controller2:
                _ingredientController.addIngredintSupplierStatusCtlr,
                validator1: _ingredientController.textValidator,
                validator2: _ingredientController.textValidator,
                textInputType1: TextInputType.text,
                textInputType2: TextInputType.number,
              ),
              SizedBox(height: 10),
              textRow('ID Card Front', 'ID Card Back'),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40,
                    width: 400,
                    child: OutlinedButton.icon(
                      icon: Icon(
                        Icons.cloud_upload_outlined,
                        color: primaryColor,
                      ),
                      label:
                      GetBuilder<IngredientController>(builder: (context) {
                        return Text(
                          _ingredientController.idCardFront == null
                              ? "Upload Image"
                              : _ingredientController.idCardFront!.path,
                          style: TextStyle(
                              color: textSecondary, fontSize: fontSmall),
                        );
                      }),
                      onPressed: () async {
                        _ingredientController.idCardFront =
                        await _ingredientController.getIdCardImage();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: primaryBackground,
                        side: BorderSide(width: 1.0, color: textSecondary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 400,
                    child: OutlinedButton.icon(
                      icon: Icon(
                        Icons.cloud_upload_outlined,
                        color: primaryColor,
                      ),
                      label:
                      GetBuilder<IngredientController>(builder: (context) {
                        return Text(
                          _ingredientController.idCardBack == null
                              ? "Upload Image"
                              : _ingredientController.idCardBack!.path,
                          style: TextStyle(
                              color: textSecondary, fontSize: fontSmall),
                        );
                      }),
                      onPressed: () async {
                        _ingredientController.idCardBack =
                        await _ingredientController.getIdCardImage();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: primaryBackground,
                        side: BorderSide(width: 1.0, color: textSecondary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                  height: 40,
                  width: 50,
                  alignment: Alignment.bottomRight,
                  child: normalButton('Submit', primaryColor, white,
                      onPressed: () async {
                        if (_ingredientController
                            .addIngredintSupplierFormKey.currentState!
                            .validate()) {
                          _ingredientController.addSupplierMethod(
                            _ingredientController
                                .addIngrediantSupplierNameCtlr.text,
                            _ingredientController
                                .addIngredientSupplierEmailCtlr.text,
                            _ingredientController
                                .addIngredintSupplierPhoneCtlr.text,
                            _ingredientController.addIngredintSupplierRefCtlr.text,
                            _ingredientController
                                .addIngredintSupplierAddressCtlr.text,
                            1.toString(),
                            _ingredientController.idCardFront,
                            _ingredientController.idCardBack,
                          );
                        } else {
                          print('Not Validate form!!');
                        }
                      })),
            ],
          ),
        ));
  }

  Widget updateSupplier(dynamic itemId) {
    return Container(
      height: Size.infinite.height,
      width: Size.infinite.width,
      padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
      child: Form(
        key: _ingredientController.updateSupplierFormKey,
        child: ListView(children: [
          textRow('Name', 'Email'),
          textFieldRow('Enter Ingredient name', 'Enter Email',
              controller1: _ingredientController.updateSupplierNameCtlr,
              controller2: _ingredientController.updateSupplierEmailCtlr,
              validator1: _ingredientController.textValidator,
              validator2: _ingredientController.textValidator,
              textInputType1: TextInputType.text,
              textInputType2: TextInputType.text),
          SizedBox(height: 10),
          textRow('Phone', 'Reference'),
          textFieldRow('Enter Phone', 'Enter Reference',
              controller1: _ingredientController.updateSupplierPhoneCtlr,
              controller2: _ingredientController.updateSupplierRefCtlr,
              validator1: _ingredientController.textValidator,
              validator2: _ingredientController.textValidator,
              textInputType1: TextInputType.number,
              textInputType2: TextInputType.number),
          SizedBox(height: 10),
          textRow('Address', 'Status'),
          textFieldRow(
            'Enter Address',
            'Enter Status',
            controller1:
            _ingredientController.updateSupplierAddressCtlr,
            // controller2: _ingredientController.addIngredintSupplierStatusCtlr,
            validator1: _ingredientController.textValidator,
            validator2: _ingredientController.textValidator,
            textInputType1: TextInputType.text,
            textInputType2: TextInputType.number,
          ),
          SizedBox(height: 10),
          textRow('ID Card Front', 'ID Card Back'),
          SizedBox(height:10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 40,
                width: 400,
                child: OutlinedButton.icon(
                  icon: Icon(
                    Icons.cloud_upload_outlined,
                    color: primaryColor,
                  ),
                  label:
                  GetBuilder<IngredientController>(builder: (context) {
                    return Text(
                      _ingredientController.idCardFront == null
                          ? "Upload Image"
                          : _ingredientController.idCardFront!.path,
                      style: TextStyle(
                          color: textSecondary, fontSize: fontSmall),
                    );
                  }),
                  onPressed: () async {
                    _ingredientController.idCardFront =
                    await _ingredientController.getIdCardImage();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: primaryBackground,
                    side: BorderSide(width: 1.0, color: textSecondary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                width: 400,
                child: OutlinedButton.icon(
                  icon: Icon(
                    Icons.cloud_upload_outlined,
                    color: primaryColor,
                  ),
                  label:
                  GetBuilder<IngredientController>(builder: (context) {
                    return Text(
                      _ingredientController.idCardBack == null
                          ? "Upload Image"
                          : _ingredientController.idCardBack!.path,
                      style: TextStyle(
                          color: textSecondary, fontSize: fontSmall),
                    );
                  }),
                  onPressed: () async {
                    _ingredientController.idCardBack =
                    await _ingredientController.getIdCardImage();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: primaryBackground,
                    side: BorderSide(width: 1.0, color: textSecondary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height:10),
          Container(
            height: 40,
            width: 50,
            alignment: Alignment.bottomRight,
            child: normalButton('Submit', primaryColor, white,
                onPressed: () async {
                  if (_ingredientController.updateSupplierFormKey.currentState!
                      .validate()) {
                      _ingredientController.updateSupplierMethod(
                        _ingredientController.updateSupplierNameCtlr.text,
                        _ingredientController.updateSupplierEmailCtlr.text,
                        _ingredientController.updateSupplierPhoneCtlr.text,
                        _ingredientController.updateSupplierRefCtlr.text,
                        _ingredientController.updateSupplierAddressCtlr.text,
                        1.toString(),
                        // _ingredientController.idCardFront,
                        // _ingredientController.idCardBack,
                        id: itemId
                      );
                  }
                }),
          ),
        ]),
      ),
    );
  }

  Widget viewSupplierDetails() {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child : ListView(
        children: [
          SizedBox(
            height: 60,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Name:',
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
                        _ingredientController.ingredientSupplierSingleItem.value.data!.name,
                        //foodCtlr.foodSingleItemDetails.value.data!.name!,
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
                        'Email:',
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
                        _ingredientController.ingredientSupplierSingleItem.value.data!.email,
                        //foodCtlr.foodSingleItemDetails.value.data!.name!,
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
                        'Phone:',
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
                        _ingredientController.ingredientSupplierSingleItem.value.data!.phone,
                        //foodCtlr.foodSingleItemDetails.value.data!.name!,
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
                        'Reference:',
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
                        _ingredientController.ingredientSupplierSingleItem.value.data!.reference,
                        //foodCtlr.foodSingleItemDetails.value.data!.name!,
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
                        'Address:',
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
                        _ingredientController.ingredientSupplierSingleItem.value.data!.address,
                        //foodCtlr.foodSingleItemDetails.value.data!.name!,
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
                        _ingredientController.ingredientSupplierSingleItem.value.data!.status.toString(),
                        //foodCtlr.foodSingleItemDetails.value.data!.name!,
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
            height: 200,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Front Image:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Image.network(
                      _ingredientController.ingredientSupplierSingleItem.value.data!.idCardFront,
                        height: 200,
                        width: 200,
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(height:50),
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Back Image:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Image.network(
                        _ingredientController.ingredientSupplierSingleItem.value.data!.idCardBack,
                        height: 200,
                        width: 200,
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(height:50),
        ],
      )
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:klio_staff/mvc/model/Ingredient_list_model.dart';
import 'package:klio_staff/mvc/model/food_menu_details_single_item.dart';
import 'package:klio_staff/mvc/model/food_menu_single_variant_details.dart';
import 'package:klio_staff/mvc/model/food_menu_variants.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:path/path.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:klio_staff/constant/color.dart';
import 'package:klio_staff/constant/value.dart';
import 'package:klio_staff/mvc/controller/food_management_controller.dart';
import 'package:klio_staff/mvc/model/Meal_period_model.dart';
import 'package:klio_staff/mvc/model/food_menu_addons.dart';
import 'package:klio_staff/mvc/model/food_menu_allergy.dart';
import 'package:klio_staff/mvc/model/food_menu_category_model.dart';
import 'package:klio_staff/mvc/model/food_menu_management.dart';
import 'package:klio_staff/mvc/view/dialog/custom_dialog.dart';
import 'package:klio_staff/mvc/view/widget/custom_widget.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

import '../../../utils/utils.dart';

class FoodManagement extends StatefulWidget {
  const FoodManagement({Key? key}) : super(key: key);

  @override
  State<FoodManagement> createState() => _FoodManagementState();
}

class _FoodManagementState extends State<FoodManagement>
    with SingleTickerProviderStateMixin {
  FoodManagementController foodCtlr = Get.find();
  int _currentSelection = 0;
  late TabController controller;
  TextEditingController textController = TextEditingController();

  Variant? selectedValue;
  List<String> selected = [];
  late ScrollController scrollController;

  @override
  void initState() {
    // TODO: implement initState

    scrollController = ScrollController();
    controller = TabController(vsync: this, length: 6);

    controller.addListener(() {
      _currentSelection = controller.index;
      foodCtlr.update(['changeCustomTabBar']);
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent * 0.95) {
        if (_currentSelection == 0 && !foodCtlr.isLoading) {
          foodCtlr.getFoodDataList();
        } else if (_currentSelection == 2 && !foodCtlr.isLoading) {
          foodCtlr.getFoodMenuCategory();
        } else if (_currentSelection == 3 && !foodCtlr.isLoading) {
          foodCtlr.getFoodMenuAllergy();
        } else if (_currentSelection == 4 && !foodCtlr.isLoading) {
          foodCtlr.getFoodMenuAddons();
        } else if (_currentSelection == 5 && !foodCtlr.isLoading) {
          foodCtlr.getFoodMenuVariants();
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            GetBuilder<FoodManagementController>(
                id: "changeCustomTabBar",
                builder: (controller) => itemTitleHeader()),
            customTapbarHeader(controller),
            Expanded(
              child: TabBarView(controller: controller, children: [
                menuDataTable(context),
                MealPeriodDataTable(context),
                FoodCategoryDataTable(context),
                FoodAllergyDataTable(context),
                FoodAddonsDataTable(context),
                FoodVariantsDataTable(context),
              ]),
            )
          ],
        ),
      ),
    );
  }

  DataRow buildLoadingAndNoData(bool showLoading, int rowNumber) {
    if (!showLoading) {
      return DataRow(cells: [
        if (rowNumber == 6)
          const DataCell(CircularProgressIndicator(color: Colors.transparent)),
        if (rowNumber == 6 || rowNumber == 5)
          const DataCell(CircularProgressIndicator(color: Colors.transparent)),
        const DataCell(CircularProgressIndicator(color: Colors.transparent)),
        DataCell(Text(
          'No Data',
          style: TextStyle(color: primaryText),
        )),
        const DataCell(CircularProgressIndicator(color: Colors.transparent)),
        //if (rowNumber == 8 || rowNumber == 7 || rowNumber == 5)
        const DataCell(CircularProgressIndicator(color: Colors.transparent)),
      ]);
    } else {
      return DataRow(cells: [
        if (rowNumber == 6)
          const DataCell(CircularProgressIndicator(color: Colors.transparent)),
        const DataCell(CircularProgressIndicator(color: Colors.transparent)),
        const DataCell(CircularProgressIndicator(color: Colors.transparent)),
        const DataCell(CircularProgressIndicator()),
        const DataCell(CircularProgressIndicator(color: Colors.transparent)),
        const DataCell(CircularProgressIndicator(color: Colors.transparent)),
      ]);
    }
  }

  Widget menuDataTable(BuildContext context) {
    return Card(
      color: secondaryBackground,
      child: SingleChildScrollView(
        controller: scrollController,
        child: GetBuilder<FoodManagementController>(
            id: "menuDataTable",
            builder: (controller) {
              List<FoodMenuManagementDatum> data =
                  controller.menusData.value.data ?? [];
              if (data.isEmpty) {
                return Center(
                    child: Container(
                        height: 40,
                        width: 40,
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.3),
                        child: CircularProgressIndicator()));
              }
              if (!controller.haveMoreMenuItem && data.last.id != 0) {
                data.add(FoodMenuManagementDatum(id: 0));
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
                        'Name',
                        style: TextStyle(color: textSecondary),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Price',
                        style: TextStyle(color: textSecondary),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Vat (%)',
                        style: TextStyle(color: textSecondary),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Image',
                        style: TextStyle(color: textSecondary),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Image',
                        style: TextStyle(color: textSecondary),
                      ),
                    ),
                  ],
                  rows: data.map(
                    (item) {
                      if (item.id == 0 && !controller.haveMoreMenuItem) {
                        return buildLoadingAndNoData(false, 6);
                      } else if (item ==
                              controller.menusData.value.data!.last &&
                          !controller.isLoading &&
                          controller.haveMoreMenuItem) {
                        return buildLoadingAndNoData(true, 6);
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
                              item.name ?? "",
                              style: TextStyle(color: primaryText),
                            ),
                          ),
                          DataCell(
                            Text(
                              item.price ?? "",
                              style: TextStyle(color: primaryText),
                            ),
                          ),
                          DataCell(
                            Text(
                              item.taxVat ?? "",
                              style: TextStyle(color: primaryText),
                            ),
                          ),
                          DataCell(Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  item.image!,
                                ),
                                //    image: NetworkImage('https://picsum.photos/250?image=9',),
                                fit: BoxFit.fill,
                              ),
                            ),
                          )),
                          DataCell(
                            Row(
                              // mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    foodCtlr
                                        .getSingleMenuDetails(id: item.id)
                                        .then((value) {
                                      showCustomDialog(context, "Menu Details",
                                          viewMenuDetails(), 100, 400);
                                    });
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffE1FDE8),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
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
                                GestureDetector(
                                  onTap: () {
                                    foodCtlr
                                        .getSingleMenuDetails(id: item.id)
                                        .then((value) {
                                      foodCtlr.nameUpdateTextCtlr.text =
                                          foodCtlr.foodSingleItemDetails.value
                                              .data!.name!;
                                      foodCtlr.varinetUpdatePricEditingCtlr
                                              .text =
                                          foodCtlr.foodSingleItemDetails.value
                                              .data!.price!;
                                      foodCtlr.caloriesUpdateEditingCtlr.text =
                                          foodCtlr.foodSingleItemDetails.value
                                              .data!.calories!;
                                      foodCtlr.descriptionUpdateEditingCtlr
                                              .text =
                                          foodCtlr.foodSingleItemDetails.value
                                              .data!.description!;
                                      foodCtlr.vatUpdateEditingCtlr.text =
                                          foodCtlr.foodSingleItemDetails.value
                                              .data!.taxVat!;
                                      foodCtlr.processTimeUpdateEditingCtlr
                                              .text =
                                          foodCtlr.foodSingleItemDetails.value
                                              .data!.processingTime!;
                                      /*foodCtlr.updateMenuAllergyIdList = */
                                      showCustomDialogResponsive(
                                          context,
                                          "Update menu",
                                          updateMenuForm(item.id),
                                          300,
                                          400);
                                    });
                                  },
                                  child: Container(
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
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showWarningDialog("Are you sure to delete?",
                                        onAccept: () {
                                      foodCtlr.deleteMenu(id: item.id);
                                      Get.back();
                                      Get.back();
                                    });
                                  },
                                  child: Container(
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
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ).toList());
            }),
      ),
    );
  }

  Widget MealPeriodDataTable(BuildContext context) {
    return Card(
      color: secondaryBackground,
      child: SingleChildScrollView(
        child: GetBuilder<FoodManagementController>(
            id: "mealPeriodTable",
            builder: (controller) {
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
                        'Image',
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
                  rows: controller.mealPeriod.value.data!.reversed
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
                            DataCell(Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.topLeft,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    item.image!,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )),
                            DataCell(
                              Row(
                                // mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      foodCtlr
                                          .getSinleMelaPeriodDetails(
                                              id: item.id)
                                          .then((value) {
                                        foodCtlr.mealPeriodUpdateTextCtlr.text =
                                            foodCtlr.singleMealPeriodDetails
                                                .value.data!.name!;
                                        print(foodCtlr
                                            .mealPeriodUpdateTextCtlr.text);
                                        showCustomDialogResponsive(
                                            context,
                                            'Update Meal Period',
                                            updateMealPeriodForm(item.id),
                                            200,
                                            300);
                                      });
                                    },
                                    child: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffFEF4E1),
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
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
                                  GestureDetector(
                                    onTap: () {
                                      showWarningDialog(
                                          "Are you sure to delete this?",
                                          onAccept: () {
                                        foodCtlr.deleteMealPeriod(id: item.id);
                                        Get.back();
                                        Get.back();
                                      });
                                    },
                                    child: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffFFE7E6),
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
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
                        ),
                      )
                      .toList());
            }),
      ),
    );
  }

  Widget FoodCategoryDataTable(BuildContext context) {
    return Card(
      color: secondaryBackground,
      child: SingleChildScrollView(
        controller: scrollController,
        child: GetBuilder<FoodManagementController>(
            id: "categoryDataTable",
            builder: (controller) {
              print("=============--------=====");
              List<MenuCategory> data =
                  controller.foodMenuCategory.value.data ?? [];
              if (!controller.haveMoreMealCategory && data.last.id != 0) {
                data.add(MenuCategory(id: 0));
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
                        'Image',
                        style: TextStyle(color: textSecondary),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'is Drinks',
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
                      if (item.id == 0 && !controller.haveMoreMealCategory) {
                        return buildLoadingAndNoData(false, 5);
                      } else if (item ==
                              controller.foodMenuCategory.value.data?.last &&
                          !controller.isLoading &&
                          controller.haveMoreMealCategory) {
                        return buildLoadingAndNoData(true, 5);
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
                          DataCell(Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  item.image!,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          )),
                          DataCell(
                            Text(
                              '${item.isDrinks ?? ""}',
                              style: TextStyle(color: primaryText),
                            ),
                          ),
                          DataCell(
                            Row(
                              // mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    foodCtlr
                                        .getSinleMealCategoryDetails(
                                            id: item.id)
                                        .then((value) {
                                      foodCtlr.mealCategoryUpdateTextCtlr.text =
                                          foodCtlr.singleMealCategoryDetails
                                              .value.data!.name!;
                                      print(
                                          'mealPeriod CategoryDetails${foodCtlr.mealCategoryUpdateTextCtlr.text}');
                                      showCustomDialogResponsive(
                                          context,
                                          'Update Meal Category',
                                          addMenuCategoryUpdateForm(item.id),
                                          200,
                                          300);
                                    });
                                  },
                                  child: Container(
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
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showWarningDialog("Are you sure to delete?",
                                        onAccept: () {
                                      foodCtlr.deleteMealCategory(id: item.id);
                                      Get.back();
                                      Get.back();
                                    });
                                  },
                                  child: Container(
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
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ).toList());
            }),
      ),
    );
  }

  Widget FoodAllergyDataTable(BuildContext context) {
    return Card(
      color: secondaryBackground,
      child: SingleChildScrollView(
        controller: scrollController,
        child: GetBuilder<FoodManagementController>(
            id: "allergyDataTable",
            builder: (controller) {
              List<Allergy> data = controller.foodMenuAllergy.value.data ?? [];
              if (!controller.haveMoreAllergy && data.last.id != 0) {
                data.add(Allergy(id: 0));
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
                        'Icon',
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
                      if (item.id == 0 && !controller.haveMoreAllergy) {
                        return buildLoadingAndNoData(false, 4);
                      } else if (item ==
                              controller.foodMenuAllergy.value.data?.last &&
                          !controller.isLoading &&
                          controller.haveMoreAllergy) {
                        return buildLoadingAndNoData(true, 4);
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
                          DataCell(Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  item.image!,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          )),
                          DataCell(
                            Row(
                              // mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    foodCtlr
                                        .getSinleMealAllergyDetails(id: item.id)
                                        .then((value) {
                                      foodCtlr.mealAllergyUpdateTextCtlr.text =
                                          foodCtlr.singleMealAllergyDetails
                                              .value.data!.name!;
                                      showCustomDialogResponsive(
                                          context,
                                          'Update Meal Allergy',
                                          addMenuAllergyUpdateForm(item.id),
                                          200,
                                          300);
                                    });
                                  },
                                  child: Container(
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
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showWarningDialog("Are you sure to delete?",
                                        onAccept: () {
                                      foodCtlr.deleteMealAllergy(id: item.id);
                                      Get.back();
                                      Get.back();
                                    });
                                  },
                                  child: Container(
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
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ).toList());
            }),
      ),
    );
  }

  Widget FoodAddonsDataTable(BuildContext context) {
    return Card(
      color: secondaryBackground,
      child: SingleChildScrollView(
        controller: scrollController,
        child: GetBuilder<FoodManagementController>(
            id: "addonsDataTable",
            builder: (controller) {
              List<MenuAddon> data = controller.foodAddons.value.data ?? [];
              if (!controller.haveMoreAddons && data.last.id != 0) {
                data.add(MenuAddon(id: 0));
              }
              return DataTable(
                  dataRowHeight: 80,
                  // columnSpacing: 120,
                  horizontalMargin: 15,
                  columns: [
                    DataColumn(
                      label: Text(
                        'SL.No',
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
                        'Price',
                        style: TextStyle(color: textSecondary),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Image',
                        style: TextStyle(color: textSecondary),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Details',
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
                      if (item.id == 0 && !controller.haveMoreAddons) {
                        return buildLoadingAndNoData(false, 6);
                      } else if (item ==
                              controller.foodAddons.value.data?.last &&
                          !controller.isLoading &&
                          controller.haveMoreAddons) {
                        return buildLoadingAndNoData(true, 6);
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
                              '${item.price ?? ""}',
                              style: TextStyle(color: primaryText),
                            ),
                          ),
                          DataCell(Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  item.image!,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          )),
                          DataCell(
                            Text(
                              '${item.details ?? ""}',
                              style: TextStyle(color: primaryText),
                            ),
                          ),
                          DataCell(
                            Row(
                              // mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    foodCtlr
                                        .getSinleMealAdddonsDetails(id: item.id)
                                        .then((value) {
                                      foodCtlr.udpateMealAddonsNameTextCtlr
                                              .text =
                                          foodCtlr.singleMealAddonsDetails.value
                                              .data!.name!;
                                      foodCtlr.updateMealAddonsPriceTextCtlr
                                              .text =
                                          foodCtlr.singleMealAddonsDetails.value
                                              .data!.price!;
                                      foodCtlr.updateMealAddonsDetailsTextCtlr
                                              .text =
                                          foodCtlr.singleMealAddonsDetails.value
                                              .data!.details!;
                                      print(
                                          'checkAddonss${foodCtlr.udpateMealAddonsNameTextCtlr.text}');
                                      print(
                                          'checkAddonss${foodCtlr.updateMealAddonsPriceTextCtlr.text}');
                                      print(
                                          'checkAddonss${foodCtlr.updateMealAddonsDetailsTextCtlr.text}');
                                      showCustomDialogResponsive(
                                          context,
                                          'Update Meal Addons',
                                          upateMenuAddonsForm(item.id),
                                          200,
                                          300);
                                    });
                                  },
                                  child: Container(
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
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showWarningDialog("Are you sure to delete?",
                                        onAccept: () {
                                      foodCtlr.deleteMealAddons(id: item.id);
                                      Get.back();
                                      Get.back();
                                    });
                                  },
                                  child: Container(
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
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ).toList());
            }),
      ),
    );
  }

  Widget FoodVariantsDataTable(BuildContext context) {
    return Card(
      color: secondaryBackground,
      child: SingleChildScrollView(
        controller: scrollController,
        child: GetBuilder<FoodManagementController>(
            id: "variantDataTable",
            builder: (controller) {
              List<Variant> data = controller.foodVariants.value.data ?? [];
              if (!controller.haveMoreVariants && data.last.id != 0) {
                data.add(Variant(id: 0));
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
                        'Menu Name',
                        style: TextStyle(color: textSecondary),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Price',
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
                      if (item.id == 0 && !controller.haveMoreVariants) {
                        return buildLoadingAndNoData(false, 5);
                      } else if (item ==
                              controller.foodVariants.value.data?.last &&
                          !controller.isLoading &&
                          controller.haveMoreVariants) {
                        return buildLoadingAndNoData(true, 5);
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
                              '${item.food!.name ?? ""}',
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
                              '${item.price ?? ""}',
                              style: TextStyle(color: primaryText),
                            ),
                          ),
                          DataCell(
                            Row(
                              // mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    foodCtlr
                                        .getSinleVariantDetails(
                                      id: item.id,
                                    )
                                        .then((value) {
                                      foodCtlr.updateMealVariantsNameTextCtlr
                                              .text =
                                          foodCtlr.singleVariantDetails.value
                                              .data!.name!;
                                      foodCtlr.updateMealVariantsPriceTextCtlr
                                              .text =
                                          foodCtlr.singleVariantDetails.value
                                              .data!.price!
                                              .toString();
                                      showCustomDialog(
                                          context,
                                          'Update Menu Variants',
                                          updateMenuVariantForm(item.id),
                                          200,
                                          600);
                                    });
                                  },
                                  child: Container(
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
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showWarningDialog("Are you sure to delete?",
                                        onAccept: () {
                                      foodCtlr.deleteVariant(id: item.id);
                                      Get.back();
                                      Get.back();
                                    });
                                  },
                                  child: Container(
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
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ).toList());
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
                  'Menu',
                  style: TextStyle(fontSize: fontBig, color: primaryText),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 25),
                child: OutlinedButton.icon(
                  icon: Icon(
                    Icons.add,
                    color: primaryText,
                  ),
                  label: Text(
                    "Add New Menu",
                    style: TextStyle(
                      color: primaryText,
                    ),
                  ),
                  onPressed: () {
                    showCustomDialog(context, "Add New menu",
                        addNewMenuForm(foodCtlr), 30, 400);
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
      } else if (_currentSelection == 1) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  'Menu',
                  style: TextStyle(fontSize: fontBig, color: primaryText),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 25),
                child: OutlinedButton.icon(
                  icon: Icon(
                    Icons.add,
                    color: primaryText,
                  ),
                  label: Text(
                    "Add Meal Period",
                    style: TextStyle(
                      color: primaryText,
                    ),
                  ),
                  onPressed: () {
                    showCustomDialog(context, 'Add New Meal Period',
                        addMealPeriodForm(), 100, 400);
                  },
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(width: 1.0, color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
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
                  'Menu',
                  style: TextStyle(fontSize: fontBig, color: primaryText),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 25),
                child: OutlinedButton.icon(
                  icon: Icon(
                    Icons.add,
                    color: primaryText,
                  ),
                  label: Text(
                    "Add Menu Category",
                    style: TextStyle(
                      color: primaryText,
                    ),
                  ),
                  onPressed: () {
                    showCustomDialog(context, 'Add New Menu Category',
                        addMenuCategoryForm(), 200, 400);
                  },
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(width: 1.0, color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else if (_currentSelection == 3) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  'Menu',
                  style: TextStyle(fontSize: fontBig, color: primaryText),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 25),
                child: OutlinedButton.icon(
                  icon: Icon(
                    Icons.add,
                    color: primaryText,
                  ),
                  label: Text(
                    "Add Menu Allergy",
                    style: TextStyle(
                      color: primaryText,
                    ),
                  ),
                  onPressed: () {
                    showCustomDialog(context, 'Add New Menu Allergy',
                        addMenuAllergyForm(), 100, 300);
                  },
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(width: 1.0, color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else if (_currentSelection == 4) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  'Menu',
                  style: TextStyle(fontSize: fontBig, color: primaryText),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 25),
                child: OutlinedButton.icon(
                  icon: Icon(
                    Icons.add,
                    color: primaryText,
                  ),
                  label: Text(
                    "Add Menu Addons",
                    style: TextStyle(
                      color: primaryText,
                    ),
                  ),
                  onPressed: () {
                    showCustomDialog(context, 'Add New Menu Addons',
                        addMenuAddonsForm(), 100, 300);
                  },
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(width: 1.0, color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else if (_currentSelection == 5) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  'Menu',
                  style: TextStyle(fontSize: fontBig, color: primaryText),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 25),
                child: OutlinedButton.icon(
                  icon: Icon(
                    Icons.add,
                    color: primaryText,
                  ),
                  label: Text(
                    "Add Menu Variants",
                    style: TextStyle(
                      color: primaryText,
                    ),
                  ),
                  onPressed: () {
                    showCustomDialog(context, 'Add New Menu Variants',
                        addMenuVariantForm(), 200, 600);
                  },
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(width: 1.0, color: primaryColor),
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
      return Container();
    });
  }

  Widget customTapbarHeader(TabController controller) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GetBuilder<FoodManagementController>(
              id: 'changeCustomTabBar',
              builder: (context) {
                return Expanded(
                  child: MaterialSegmentedControl(
                    children: {
                      0: Text(
                        'Menus',
                        style: TextStyle(
                            color: _currentSelection == 0 ? white : black),
                      ),
                      1: Text(
                        'Meal Period',
                        style: TextStyle(
                            color: _currentSelection == 1 ? white : black),
                      ),
                      2: Text(
                        'Menu Category',
                        style: TextStyle(
                            color: _currentSelection == 2 ? white : black),
                      ),
                      3: Text(
                        'Menu Allergy',
                        style: TextStyle(
                            color: _currentSelection == 3 ? white : black),
                      ),
                      4: Text(
                        'Menu Addons',
                        style: TextStyle(
                            color: _currentSelection == 4 ? white : black),
                      ),
                      5: Text(
                        'Menu Variants',
                        style: TextStyle(
                            color: _currentSelection == 5 ? white : black),
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
                      // if(index==0 && foodCtlr.menusData.value.data!.isEmpty){
                      //   foodCtlr.getFoodDataList();
                      // } else if(index ==1 && foodCtlr.mealPeriod.value.data!.isEmpty){
                      //   foodCtlr.getFoodMealPeriod();
                      // }else if(index==2 && foodCtlr.foodMenuCategory.value.data!.isEmpty){
                      //   foodCtlr.getFoodMenuCategory();
                      // } else if(index ==3 && foodCtlr.foodMenuAllergy.value.data!.isEmpty){
                      //   foodCtlr.getFoodMenuAllergy();
                      // }else if(index==4 && foodCtlr.foodAddons.value.data!.isEmpty){
                      //   foodCtlr.getFoodMenuAddons();
                      // } else if(index==5 && foodCtlr.foodVariants.value.data!.isEmpty){
                      //   foodCtlr.getFoodMenuVariants();
                      // }
                      print(index);
                      setState(() {
                        _currentSelection = index;
                        controller.index = _currentSelection;
                      });
                    },
                  ),
                );
              }),
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
                          onChanged: (text) async {},
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
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 20,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: textSecondary,
                              ),
                              onPressed: () {
                                textController.text = '';
                              },
                            ),
                            hintText: "Search Item",
                            hintStyle: const TextStyle(
                                fontSize: fontSmall, color: black),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget addNewMenuForm(FoodManagementController foodCtlr) {
    return Container(
      height: Size.infinite.height,
      width: Size.infinite.width,
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
      child: Form(
        key: foodCtlr.uploadMenuFormKey,
        child: ListView(children: [
          textRow('Name', 'Variant Price'),
          textFieldRow('Enter menu name', 'Enter variant price',
              controller1: foodCtlr.nameTextCtlr,
              controller2: foodCtlr.varinetPriceEditingCtlr,
              validator1: foodCtlr.textValidator,
              validator2: foodCtlr.textValidator,
              textInputType1: TextInputType.text,
              textInputType2: TextInputType.number),
          const SizedBox(height: 10),
          textRow('Vat (%)', 'Processing Time'),
          textFieldRow('Enter VAT', 'Enter food processing time',
              controller1: foodCtlr.vatEditingCtlr,
              controller2: foodCtlr.processTimeEditingCtlr,
              validator1: foodCtlr.textValidator,
              validator2: foodCtlr.textValidator,
              textInputType1: TextInputType.number,
              textInputType2: TextInputType.number),
          const SizedBox(height: 10),
          textRow('Image (130x130)', 'Calorie'),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child: SizedBox(
                      height: 35,
                      child: MaterialButton(
                        elevation: 0,
                        color: primaryBackground,
                        onPressed: () async {
                          foodCtlr.menuStoreImage = await foodCtlr.getImage();
                        },
                        child: GetBuilder<FoodManagementController>(
                            builder: (context) {
                          return Text(
                            foodCtlr.menuStoreImage == null
                                ? 'No file chosen'
                                : basename(foodCtlr.menuStoreImage!.path
                                    .split(Platform.pathSeparator.tr)
                                    .last),
                            style: TextStyle(
                                color: textSecondary, fontSize: fontSmall),
                          );
                        }),
                      )
                      // child: normalButton('No file chosen', primaryColor, primaryColor),
                      )),
              const SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: SizedBox(
                  //  height: 45,
                  child: TextFormField(
                      onChanged: (text) async {},
                      controller: foodCtlr.caloriesEditingCtlr,
                      onEditingComplete: () async {},
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      validator: foodCtlr.textValidator,
                      style:
                          TextStyle(fontSize: fontSmall, color: textSecondary),
                      decoration: InputDecoration(
                        hintText: "Enter Calories",
                        fillColor: secondaryBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        hintStyle: TextStyle(
                            fontSize: fontVerySmall, color: textSecondary),
                      )),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          textRow('Select Menu Meal Period', 'Select Menu Category'),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child: GetBuilder<FoodManagementController>(
                      builder: (controller) {
                    return MultiSelectDropDown(
                      backgroundColor: secondaryBackground,
                      optionsBackgroundColor: secondaryBackground,
                      selectedOptionTextColor: primaryText,
                      selectedOptionBackgroundColor: primaryColor,
                      optionTextStyle:
                          TextStyle(color: primaryText, fontSize: 16),
                      onOptionSelected: (List<ValueItem> selectedOptions) {
                        foodCtlr.uploadMealPeriodIdList = selectedOptions
                            .map((ValueItem e) => int.parse(e.value!))
                            .toList();
                        print(foodCtlr.uploadMealPeriodIdList);
                      },
                      // selectedOptions: foodCtlr.foodSingleItemDetails.value.data!.addons!.data!.map((MenuAddon e) {
                      //   return ValueItem(
                      //     label:e.name!,
                      //     value: e.id.toString(),
                      //   );
                      // }).toList(),
                      options: controller.mealPeriod.value.data!.map((Meal e) {
                        return ValueItem(
                          label: e.name!,
                          value: e.id.toString(),
                        );
                      }).toList(),
                      hint: 'Select Meal Period',
                      selectionType: SelectionType.multi,
                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                      dropdownHeight: 300,
                      selectedOptionIcon: const Icon(Icons.check_circle),
                      inputDecoration: BoxDecoration(
                        color: secondaryBackground,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        border: Border.all(
                          color: primaryBackground,
                        ),
                      ),
                    );
                  })),
              const SizedBox(width: 20),
              Expanded(
                  flex: 1,
                  child: GetBuilder<FoodManagementController>(
                      builder: (controller) {
                    return MultiSelectDropDown(
                      backgroundColor: secondaryBackground,
                      optionsBackgroundColor: secondaryBackground,
                      selectedOptionTextColor: primaryText,
                      selectedOptionBackgroundColor: primaryColor,
                      optionTextStyle:
                          TextStyle(color: primaryText, fontSize: 16),
                      onOptionSelected: (List<ValueItem> selectedOptions) {
                        foodCtlr.uploadMenuCategoryIdList = selectedOptions
                            .map((ValueItem e) => int.parse(e.value!))
                            .toList();
                      },
                      // selectedOptions: foodCtlr.foodSingleItemDetails.value.data!.addons!.data!.map((MenuAddon e) {
                      //   return ValueItem(
                      //     label:e.name!,
                      //     value: e.id.toString(),
                      //   );
                      // }).toList(),
                      options: controller.foodMenuCategory.value.data!
                          .map((MenuCategory e) {
                        return ValueItem(
                          label: e.name ?? '',
                          value: e.id.toString(),
                        );
                      }).toList(),
                      hint: 'Select Menu Category',
                      selectionType: SelectionType.multi,
                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                      dropdownHeight: 300,
                      selectedOptionIcon: const Icon(Icons.check_circle),
                      inputDecoration: BoxDecoration(
                        color: secondaryBackground,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        border: Border.all(
                          color: primaryBackground,
                        ),
                      ),
                    );
                  })),
            ],
          ),
          const SizedBox(height: 10),
          textRow('Select Menu Addons', 'Select Menu Allergies '),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child: GetBuilder<FoodManagementController>(
                      builder: (controller) {
                    return MultiSelectDropDown(
                      backgroundColor: secondaryBackground,
                      optionsBackgroundColor: secondaryBackground,
                      selectedOptionTextColor: primaryText,
                      selectedOptionBackgroundColor: primaryColor,
                      optionTextStyle:
                          TextStyle(color: primaryText, fontSize: 16),
                      onOptionSelected: (List<ValueItem> selectedOptions) {
                        foodCtlr.uploadMenuAddonsIdList = selectedOptions
                            .map((ValueItem e) => int.parse(e.value!))
                            .toList();
                      },
                      // selectedOptions: foodCtlr.foodSingleItemDetails.value.data!.addons!.data!.map((MenuAddon e) {
                      //   return ValueItem(
                      //     label:e.name!,
                      //     value: e.id.toString(),
                      //   );
                      // }).toList(),
                      options:
                          controller.foodAddons.value.data!.map((MenuAddon e) {
                        return ValueItem(
                          label: e.name ?? '',
                          value: e.id.toString(),
                        );
                      }).toList(),
                      hint: 'Select Menu Addons',
                      selectionType: SelectionType.multi,
                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                      dropdownHeight: 300,
                      selectedOptionIcon: const Icon(Icons.check_circle),
                      inputDecoration: BoxDecoration(
                        color: secondaryBackground,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        border: Border.all(
                          color: primaryBackground,
                        ),
                      ),
                    );
                  })),
              const SizedBox(width: 20),
              Expanded(
                  flex: 1,
                  child: GetBuilder<FoodManagementController>(
                      builder: (controller) {
                    return MultiSelectDropDown(
                      backgroundColor: secondaryBackground,
                      optionsBackgroundColor: secondaryBackground,
                      selectedOptionTextColor: primaryText,
                      selectedOptionBackgroundColor: primaryColor,
                      optionTextStyle:
                          TextStyle(color: primaryText, fontSize: 16),
                      onOptionSelected: (List<ValueItem> selectedOptions) {
                        foodCtlr.uploadMenuAllergyIdList = selectedOptions
                            .map((ValueItem e) => int.parse(e.value!))
                            .toList();
                      },
                      // selectedOptions: foodCtlr.foodSingleItemDetails.value.data!.addons!.data!.map((MenuAddon e) {
                      //   return ValueItem(
                      //     label:e.name!,
                      //     value: e.id.toString(),
                      //   );
                      // }).toList(),
                      options: controller.foodMenuAllergy.value.data!
                          .map((Allergy e) {
                        return ValueItem(
                          label: e.name ?? '',
                          value: e.id.toString(),
                        );
                      }).toList(),
                      hint: 'Select Menu Allergies',
                      selectionType: SelectionType.multi,
                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                      dropdownHeight: 300,
                      selectedOptionIcon: const Icon(Icons.check_circle),
                      inputDecoration: BoxDecoration(
                        color: secondaryBackground,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        border: Border.all(
                          color: primaryBackground,
                        ),
                      ),
                    );
                  })),
            ],
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 10),
          textRow('Menu Description', ''),
          TextFormField(
              onChanged: (text) async {},
              onEditingComplete: () async {},
              keyboardType: TextInputType.text,
              validator: foodCtlr.textValidator,
              controller: foodCtlr.descriptionEditingCtlr,
              maxLines: 2,
              style: TextStyle(fontSize: fontSmall, color: textSecondary),
              decoration: InputDecoration(
                fillColor: secondaryBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                hintStyle:
                    TextStyle(fontSize: fontVerySmall, color: textSecondary),
              )),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              normalButton('Submit', primaryColor, white, onPressed: () async {
                if (foodCtlr.uploadMenuFormKey.currentState!.validate()) {
                  if (foodCtlr.uploadMenuCategoryIdList.isEmpty) {
                    Utils.showSnackBar("Please select menu category");
                  } else if (foodCtlr.menuStoreImage == null) {
                    Utils.showSnackBar("Please select menu image");
                  } else {
                    await foodCtlr.addMenu(
                      foodCtlr.nameTextCtlr.text,
                      foodCtlr.varinetPriceEditingCtlr.text,
                      foodCtlr.processTimeEditingCtlr.text,
                      foodCtlr.vatEditingCtlr.text,
                      foodCtlr.caloriesEditingCtlr.text,
                      foodCtlr.descriptionEditingCtlr.text,
                      foodCtlr.uploadMealPeriodIdList,
                      foodCtlr.uploadMenuAddonsIdList,
                      foodCtlr.uploadMenuAllergyIdList,
                      foodCtlr.uploadMenuCategoryIdList,
                    );

                    foodCtlr.nameTextCtlr.clear();
                    foodCtlr.varinetPriceEditingCtlr.clear();
                    foodCtlr.vatEditingCtlr.clear();
                    foodCtlr.processTimeEditingCtlr.clear();
                    foodCtlr.caloriesEditingCtlr.clear();
                    foodCtlr.descriptionEditingCtlr.clear();
                    foodCtlr.menuStoreImage = null;
                  }
                }
              }),
            ],
          ),
        ]),
      ),
    );
  }

  Widget updateMenuForm(dynamic itemId) {
    return Container(
      height: Size.infinite.height,
      width: Size.infinite.width,
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
      child: Form(
        key: foodCtlr.updateMenuFormKey,
        child: ListView(children: [
          textRow('Name', 'Variant Price'),
          textFieldRow('Enter menu name', 'Enter variant price',
              controller1: foodCtlr.nameUpdateTextCtlr,
              controller2: foodCtlr.varinetUpdatePricEditingCtlr,
              validator1: foodCtlr.textValidator,
              validator2: foodCtlr.textValidator,
              textInputType1: TextInputType.text,
              textInputType2: TextInputType.number),
          const SizedBox(height: 10),
          textRow('Vat (%)', 'Processing Time'),
          textFieldRow('Enter VAT', 'Enter food processing time',
              controller1: foodCtlr.vatUpdateEditingCtlr,
              controller2: foodCtlr.processTimeUpdateEditingCtlr,
              validator1: foodCtlr.textValidator,
              validator2: foodCtlr.textValidator,
              textInputType1: TextInputType.number,
              textInputType2: TextInputType.number),
          const SizedBox(height: 10),
          textRow('Image (130x130)', 'Calorie'),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child: SizedBox(
                      height: 35,
                      child: MaterialButton(
                        elevation: 0,
                        color: primaryBackground,
                        onPressed: () async {
                          foodCtlr.menuUpdateImage = await foodCtlr.getImage();
                        },
                        child: GetBuilder<FoodManagementController>(
                            builder: (context) {
                          return Text(
                            foodCtlr.menuUpdateImage == null
                                ? 'No file chosen'
                                : basename(foodCtlr.menuUpdateImage!.path
                                    .split(Platform.pathSeparator.tr)
                                    .last),
                            style: TextStyle(
                                color: textSecondary, fontSize: fontSmall),
                          );
                        }),
                      )
                      // child: normalButton('No file chosen', primaryColor, primaryColor),
                      )),
              const SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: SizedBox(
                  //  height: 45,
                  child: TextFormField(
                    onChanged: (text) async {},
                    controller: foodCtlr.caloriesUpdateEditingCtlr,
                    onEditingComplete: () async {},
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    validator: foodCtlr.textValidator,
                    style: TextStyle(fontSize: fontSmall, color: textSecondary),
                    decoration: InputDecoration(
                      hintText: "Enter Calories",
                      fillColor: secondaryBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      hintStyle: TextStyle(
                        fontSize: fontVerySmall,
                        color: textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          textRow('Select Menu Meal Period', 'Select Menu Category'),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child: GetBuilder<FoodManagementController>(
                      builder: (controller) {
                    return MultiSelectDropDown(
                      backgroundColor: secondaryBackground,
                      optionsBackgroundColor: secondaryBackground,
                      selectedOptionTextColor: primaryText,
                      selectedOptionBackgroundColor: primaryColor,
                      optionTextStyle:
                          TextStyle(color: primaryText, fontSize: 16),
                      onOptionSelected: (List<ValueItem> selectedOptions) {
                        foodCtlr.updateMealPeriodIdList = selectedOptions
                            .map((ValueItem e) => int.parse(e.value!))
                            .toList();
                      },
                      // selectedOptions: foodCtlr.foodSingleItemDetails.value.data!.addons!.data!.map((MenuAddon e) {
                      //   return ValueItem(
                      //     label:e.name!,
                      //     value: e.id.toString(),
                      //   );
                      // }).toList(),
                      options: controller.mealPeriod.value.data!.map((Meal e) {
                        return ValueItem(
                          label: e.name!,
                          value: e.id.toString(),
                        );
                      }).toList(),
                      hint: 'Select Meal Period',
                      selectionType: SelectionType.multi,
                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                      dropdownHeight: 300,
                      selectedOptionIcon: const Icon(Icons.check_circle),
                      inputDecoration: BoxDecoration(
                        color: secondaryBackground,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        border: Border.all(
                          color: primaryBackground,
                        ),
                      ),
                    );
                  })),
              const SizedBox(width: 20),
              Expanded(
                  flex: 1,
                  child: GetBuilder<FoodManagementController>(
                      builder: (controller) {
                    return MultiSelectDropDown(
                      backgroundColor: secondaryBackground,
                      optionsBackgroundColor: secondaryBackground,
                      selectedOptionTextColor: primaryText,
                      selectedOptionBackgroundColor: primaryColor,
                      optionTextStyle:
                          TextStyle(color: primaryText, fontSize: 16),
                      onOptionSelected: (List<ValueItem> selectedOptions) {
                        foodCtlr.updateMenuCategoryIdList = selectedOptions
                            .map((ValueItem e) => int.parse(e.value!))
                            .toList();
                      },
                      // selectedOptions: foodCtlr.foodSingleItemDetails.value.data!.addons!.data!.map((MenuAddon e) {
                      //   return ValueItem(
                      //     label:e.name!,
                      //     value: e.id.toString(),
                      //   );
                      // }).toList(),
                      options: controller.foodMenuCategory.value.data!
                          .map((MenuCategory e) {
                        return ValueItem(
                          label: e.name.toString(),
                          value: e.id.toString(),
                        );
                      }).toList(),
                      hint: 'Select Menu Category',
                      selectionType: SelectionType.multi,
                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                      dropdownHeight: 300,
                      selectedOptionIcon: const Icon(Icons.check_circle),
                      inputDecoration: BoxDecoration(
                        color: secondaryBackground,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        border: Border.all(
                          color: primaryBackground,
                        ),
                      ),
                    );
                  })),
            ],
          ),
          const SizedBox(height: 10),
          textRow('Select Menu Addons', 'Select Menu Allergies '),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child: GetBuilder<FoodManagementController>(
                      builder: (controller) {
                    return MultiSelectDropDown(
                      backgroundColor: secondaryBackground,
                      optionsBackgroundColor: secondaryBackground,
                      selectedOptionTextColor: primaryText,
                      selectedOptionBackgroundColor: primaryColor,
                      optionTextStyle:
                          TextStyle(color: primaryText, fontSize: 16),
                      onOptionSelected: (List<ValueItem> selectedOptions) {
                        foodCtlr.updateMenuAddonsIdList = selectedOptions
                            .map((ValueItem e) => int.parse(e.value!))
                            .toList();
                      },
                      selectedOptions: foodCtlr
                          .foodSingleItemDetails.value.data!.addons!.data!
                          .map((MenuAddon e) {
                        return ValueItem(
                          label: e.name!,
                          value: e.id.toString(),
                        );
                      }).toList(),
                      options:
                          controller.foodAddons.value.data!.map((MenuAddon e) {
                        return ValueItem(
                          label: e.name.toString(),
                          value: e.id.toString(),
                        );
                      }).toList(),
                      hint: 'Select Menu Addons',
                      selectionType: SelectionType.multi,
                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                      dropdownHeight: 300,
                      selectedOptionIcon: const Icon(Icons.check_circle),
                      inputDecoration: BoxDecoration(
                        color: secondaryBackground,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        border: Border.all(
                          color: primaryBackground,
                        ),
                      ),
                    );
                  })),
              const SizedBox(width: 20),
              Expanded(
                  flex: 1,
                  child: GetBuilder<FoodManagementController>(
                      builder: (controller) {
                    return MultiSelectDropDown(
                      backgroundColor: secondaryBackground,
                      optionsBackgroundColor: secondaryBackground,
                      selectedOptionTextColor: primaryText,
                      selectedOptionBackgroundColor: primaryColor,
                      optionTextStyle:
                          TextStyle(color: primaryText, fontSize: 16),
                      onOptionSelected: (List<ValueItem> selectedOptions) {
                        foodCtlr.updateMenuAllergyIdList = selectedOptions
                            .map((ValueItem e) => int.parse(e.value!))
                            .toList();
                      },
                      // selectedOptions: foodCtlr.foodSingleItemDetails.value.data!.addons!.data!.map((MenuAddon e) {
                      //   return ValueItem(
                      //     label:e.name!,
                      //     value: e.id.toString(),
                      //   );
                      // }).toList(),
                      options: controller.foodMenuAllergy.value.data!
                          .map((Allergy e) {
                        return ValueItem(
                          label: e.name.toString(),
                          value: e.id.toString(),
                        );
                      }).toList(),
                      hint: 'Select Menu Allergies',
                      selectionType: SelectionType.multi,
                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                      dropdownHeight: 300,
                      selectedOptionIcon: const Icon(Icons.check_circle),
                      inputDecoration: BoxDecoration(
                        color: secondaryBackground,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        border: Border.all(
                          color: primaryBackground,
                        ),
                      ),
                    );
                  })),
            ],
          ),
          textRow('Select Menu Ingredient', ' '),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child: GetBuilder<FoodManagementController>(
                      builder: (controller) {
                    return MultiSelectDropDown(
                      backgroundColor: secondaryBackground,
                      optionsBackgroundColor: secondaryBackground,
                      selectedOptionTextColor: primaryText,
                      selectedOptionBackgroundColor: primaryColor,
                      optionTextStyle:
                          TextStyle(color: primaryText, fontSize: 16),
                      onOptionSelected: (List<ValueItem> selectedOptions) {
                        foodCtlr.updateMenuIngredientIdList = selectedOptions
                            .map((ValueItem e) => int.parse(e.value!))
                            .toList();
                      },
                      selectedOptions: foodCtlr.updateMealIngrediantSelectMeal
                          .map((SingleMenuDetailsData e) {
                        return ValueItem(
                          label: e.name!,
                          value: e.id.toString(),
                        );
                      }).toList(),
                      options: controller.ingredientData.value.data!
                          .map((Ingrediant e) {
                        return ValueItem(
                          label: e.name!,
                          value: e.id.toString(),
                        );
                      }).toList(),
                      selectionType: SelectionType.single,
                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                      dropdownHeight: 300,
                      selectedOptionIcon: const Icon(Icons.check_circle),
                      inputDecoration: BoxDecoration(
                        color: secondaryBackground,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        border: Border.all(
                          color: primaryBackground,
                        ),
                      ),
                    );
                  })),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 10),
          textRow('Menu Description', ''),
          TextFormField(
              onChanged: (text) async {},
              onEditingComplete: () async {},
              keyboardType: TextInputType.text,
              validator: foodCtlr.textValidator,
              controller: foodCtlr.descriptionUpdateEditingCtlr,
              maxLines: 2,
              style: TextStyle(fontSize: fontSmall, color: textSecondary),
              decoration: InputDecoration(
                fillColor: secondaryBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                hintStyle:
                    TextStyle(fontSize: fontVerySmall, color: textSecondary),
              )),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              normalButton('Submit', primaryColor, white, onPressed: () {
                if (foodCtlr.updateMenuFormKey.currentState!.validate()) {
                  foodCtlr.updateMenu(
                    foodCtlr.nameUpdateTextCtlr.text,
                    foodCtlr.varinetUpdatePricEditingCtlr.text,
                    foodCtlr.processTimeUpdateEditingCtlr.text,
                    foodCtlr.vatUpdateEditingCtlr.text,
                    foodCtlr.caloriesUpdateEditingCtlr.text,
                    foodCtlr.descriptionUpdateEditingCtlr.text,
                    foodCtlr.updateMenuIngredientIdList.isNotEmpty
                        ? foodCtlr.updateMenuIngredientIdList.first.toString()
                        : null,
                    foodCtlr.updateMealPeriodIdList,
                    foodCtlr.updateMenuAddonsIdList,
                    foodCtlr.updateMenuAllergyIdList,
                    foodCtlr.updateMenuCategoryIdList,
                    id: itemId,
                  );
                  /*if (foodCtlr.updateMenuCategoryIdList.isEmpty) {
                    Utils.showSnackBar("Please select menu category");
                  } else {

                  }*/
                }
              }),
            ],
          ),
        ]),
      ),
    );
  }

  Widget addMealPeriodForm() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Form(
        key: foodCtlr.uploadMealPeriodKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
                controller: foodCtlr.mealPeriodTextCtlr,
                validator: foodCtlr.textValidator,
                decoration: InputDecoration(
                  fillColor: secondaryBackground,
                  label: Text(
                    'Enter Meal period name',
                    style: TextStyle(color: primaryText),
                  ),
                  hintText: 'Enter Meal period name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  hintStyle:
                      TextStyle(fontSize: fontVerySmall, color: textSecondary),
                )),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  width: 300,
                  child: OutlinedButton.icon(
                    icon: const Icon(
                      Icons.cloud_upload_outlined,
                      color: primaryColor,
                    ),
                    label: GetBuilder<FoodManagementController>(
                        builder: (context) {
                      return Text(
                        foodCtlr.mealPeriodStoreImage == null
                            ? "Upload Image"
                            : foodCtlr.mealPeriodStoreImage!.path
                                .split(Platform.pathSeparator)
                                .last,
                        style: TextStyle(
                            color: textSecondary, fontSize: fontSmall),
                      );
                    }),
                    onPressed: () async {
                      foodCtlr.mealPeriodStoreImage = await foodCtlr.getImage();
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
            Container(
                height: 40,
                width: 200,
                child:
                    normalButton('Submit', primaryColor, white, onPressed: () {
                  if (foodCtlr.uploadMealPeriodKey.currentState!.validate()) {
                    foodCtlr.addMealPeriod(foodCtlr.mealPeriodTextCtlr.text);
                    foodCtlr.mealPeriodTextCtlr.clear();
                    foodCtlr.mealPeriodStoreImage = null;
                  }
                })),
          ],
        ),
      ),
    );
  }

  Widget updateMealPeriodForm(dynamic itemId) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Form(
        key: foodCtlr.updateMealPeriodKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
                controller: foodCtlr.mealPeriodUpdateTextCtlr,
                validator: foodCtlr.textValidator,
                decoration: InputDecoration(
                  fillColor: secondaryBackground,
                  label: Text(
                    'Enter Meal period name',
                    style: TextStyle(color: primaryText),
                  ),
                  hintText: 'Enter Meal period name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  hintStyle:
                      TextStyle(fontSize: fontVerySmall, color: textSecondary),
                )),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  width: 300,
                  child: OutlinedButton.icon(
                    icon: const Icon(
                      Icons.cloud_upload_outlined,
                      color: primaryColor,
                    ),
                    label: GetBuilder<FoodManagementController>(
                        builder: (context) {
                      return Text(
                        foodCtlr.mealPeriodUpdateStoreImage == null
                            ? "Upload Image"
                            : foodCtlr.mealPeriodUpdateStoreImage!.path
                                .split(Platform.pathSeparator)
                                .last,
                        style: TextStyle(
                            color: textSecondary, fontSize: fontSmall),
                      );
                    }),
                    onPressed: () async {
                      foodCtlr.mealPeriodUpdateStoreImage =
                          await foodCtlr.getImage();
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
                // Expanded(child: Obx(() {
                //   return CheckboxListTile(
                //     title: Text(
                //       "Is Drink",
                //       style: TextStyle(color: primaryText),
                //     ),
                //     value: foodCtlr.mealPeriodUpdateIsDrinks.value,
                //     onChanged: (newValue) {
                //       foodCtlr.mealPeriodUpdateIsDrinks.value = newValue!;
                //     },
                //     controlAffinity: ListTileControlAffinity
                //         .leading, //  <-- leading Checkbox
                //   );
                // }))
              ],
            ),
            Container(
                height: 40,
                width: 200,
                child:
                    normalButton('Submit', primaryColor, white, onPressed: () {
                  if (foodCtlr.updateMealPeriodKey.currentState!.validate()) {
                    foodCtlr.UpdateMealPeriod(
                        foodCtlr.mealPeriodUpdateTextCtlr.text,
                        id: itemId);
                  }
                })),
          ],
        ),
      ),
    );
  }

  Widget addMenuCategoryForm() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Form(
        key: foodCtlr.uploadMealCategoryKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
                controller: foodCtlr.mealCategoryTextCtlr,
                validator: foodCtlr.textValidator,
                decoration: InputDecoration(
                  fillColor: secondaryBackground,
                  label: Text(
                    'Enter Meal Category name',
                    style: TextStyle(color: primaryText),
                  ),
                  hintText: 'Enter Meal  Category name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  hintStyle:
                      TextStyle(fontSize: fontVerySmall, color: textSecondary),
                )),
            Container(
              height: 40,
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(
                  Icons.cloud_upload_outlined,
                  color: primaryColor,
                ),
                label: GetBuilder<FoodManagementController>(builder: (context) {
                  return Text(
                    foodCtlr.mealCategoryStoreImage == null
                        ? "Upload Image"
                        : foodCtlr.mealCategoryStoreImage!.path
                            .split(Platform.pathSeparator)
                            .last,
                    style: TextStyle(color: textSecondary, fontSize: fontSmall),
                  );
                }),
                onPressed: () async {
                  foodCtlr.mealCategoryStoreImage = await foodCtlr.getImage();
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
                width: 200,
                child:
                    normalButton('Submit', primaryColor, white, onPressed: () {
                  if (foodCtlr.uploadMealCategoryKey.currentState!.validate()) {
                    foodCtlr
                        .addMealCategory(foodCtlr.mealCategoryTextCtlr.text,
                            foodCtlr.mealCategoryStoreImage!)
                        .then((value) {
                      foodCtlr.mealCategoryTextCtlr.clear();
                      foodCtlr.mealCategoryStoreImage = null;
                    });
                  }
                })),
          ],
        ),
      ),
    );
  }

  Widget addMenuCategoryUpdateForm(dynamic itemId) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Form(
        key: foodCtlr.updateMealCategoryKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
                controller: foodCtlr.mealCategoryUpdateTextCtlr,
                validator: foodCtlr.textValidator,
                decoration: InputDecoration(
                  fillColor: secondaryBackground,
                  label: Text(
                    'Enter Meal period name',
                    style: TextStyle(color: primaryText),
                  ),
                  hintText: 'Enter Meal period name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  hintStyle:
                      TextStyle(fontSize: fontVerySmall, color: textSecondary),
                )),
            Container(
              height: 40,
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(
                  Icons.cloud_upload_outlined,
                  color: primaryColor,
                ),
                label: GetBuilder<FoodManagementController>(builder: (context) {
                  return Text(
                    foodCtlr.mealCategoryUpdateStoreImage == null
                        ? "Upload Image"
                        : foodCtlr.mealCategoryUpdateStoreImage!.path
                            .split(Platform.pathSeparator)
                            .last,
                    style: TextStyle(color: textSecondary, fontSize: fontSmall),
                  );
                }),
                onPressed: () async {
                  foodCtlr.mealCategoryUpdateStoreImage =
                      await foodCtlr.getImage();
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
                width: 200,
                child:
                    normalButton('Submit', primaryColor, white, onPressed: () {
                  if (foodCtlr.updateMealCategoryKey.currentState!.validate()) {
                    foodCtlr.updateMealCategory(
                      foodCtlr.mealCategoryUpdateTextCtlr.text,
                      id: itemId,
                    );
                  }
                })),
          ],
        ),
      ),
    );
  }

  Widget addMenuAllergyForm() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Form(
        key: foodCtlr.uploadMealAllergyKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
                controller: foodCtlr.mealAllergyTextCtlr,
                validator: foodCtlr.textValidator,
                decoration: InputDecoration(
                  fillColor: secondaryBackground,
                  label: Text(
                    'Enter Menu Allergy name',
                    style: TextStyle(color: primaryText),
                  ),
                  hintText: 'Enter Menu Allergy name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  hintStyle:
                      TextStyle(fontSize: fontVerySmall, color: textSecondary),
                )),
            Container(
              height: 40,
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(
                  Icons.cloud_upload_outlined,
                  color: primaryColor,
                ),
                label: GetBuilder<FoodManagementController>(builder: (context) {
                  return Text(
                    foodCtlr.mealAllergyStoreImage == null
                        ? "Upload Image"
                        : foodCtlr.mealAllergyStoreImage!.path
                            .split(Platform.pathSeparator)
                            .last,
                    style: TextStyle(color: textSecondary, fontSize: fontSmall),
                  );
                }),
                onPressed: () async {
                  foodCtlr.mealAllergyStoreImage = await foodCtlr.getImage();
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
            SizedBox(
                height: 40,
                width: 200,
                child:
                    normalButton('Submit', primaryColor, white, onPressed: () {
                  if (foodCtlr.uploadMealAllergyKey.currentState!.validate()) {
                    if (foodCtlr.mealAllergyStoreImage == null) {
                      Utils.showSnackBar("Please select an image");
                    } else {
                      foodCtlr
                          .addMealAllergy(foodCtlr.mealAllergyTextCtlr.text,
                              foodCtlr.mealAllergyStoreImage!)
                          .then((value) {
                        foodCtlr.mealAllergyTextCtlr.clear();
                        foodCtlr.mealAllergyStoreImage = null;
                      });
                    }
                  }
                })),
          ],
        ),
      ),
    );
  }

  Widget addMenuAllergyUpdateForm(dynamic itemId) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Form(
        key: foodCtlr.updateMealAllergyKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
                controller: foodCtlr.mealAllergyUpdateTextCtlr,
                validator: foodCtlr.textValidator,
                decoration: InputDecoration(
                  fillColor: secondaryBackground,
                  label: Text(
                    'Enter Menu Allergy name',
                    style: TextStyle(color: primaryText),
                  ),
                  hintText: 'Enter Menu Allergy name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  hintStyle:
                      TextStyle(fontSize: fontVerySmall, color: textSecondary),
                )),
            Container(
              height: 40,
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(
                  Icons.cloud_upload_outlined,
                  color: primaryColor,
                ),
                label: GetBuilder<FoodManagementController>(builder: (context) {
                  return Text(
                    foodCtlr.mealAllergyUpdateImage == null
                        ? "Upload Image"
                        : foodCtlr.mealAllergyUpdateImage!.path
                            .split(Platform.pathSeparator)
                            .last,
                    style: TextStyle(color: textSecondary, fontSize: fontSmall),
                  );
                }),
                onPressed: () async {
                  foodCtlr.mealAllergyUpdateImage = await foodCtlr.getImage();
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
                width: 200,
                child:
                    normalButton('Submit', primaryColor, white, onPressed: () {
                  if (foodCtlr.updateMealAllergyKey.currentState!.validate()) {
                    foodCtlr.updateMealAllergy(
                      foodCtlr.mealAllergyUpdateTextCtlr.text,
                      id: itemId,
                    );
                  }
                })),
          ],
        ),
      ),
    );
  }

  Widget addMenuAddonsForm() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Form(
        key: foodCtlr.uploadMealAddonsKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
                controller: foodCtlr.mealAddonsNameTextCtlr,
                validator: foodCtlr.textValidator,
                decoration: InputDecoration(
                  fillColor: secondaryBackground,
                  label: Text(
                    'Enter Addons name',
                    style: TextStyle(color: primaryText),
                  ),
                  hintText: 'Enter Addons name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  hintStyle:
                      TextStyle(fontSize: fontVerySmall, color: textSecondary),
                )),
            TextFormField(
                controller: foodCtlr.mealAddonsPriceTextCtlr,
                validator: foodCtlr.textValidator,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  fillColor: secondaryBackground,
                  label: Text(
                    'Enter price',
                    style: TextStyle(color: primaryText),
                  ),
                  hintText: 'Enter price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  hintStyle:
                      TextStyle(fontSize: fontVerySmall, color: textSecondary),
                )),
            TextFormField(
                controller: foodCtlr.mealAddonsDetailsTextCtlr,
                validator: foodCtlr.textValidator,
                minLines: 2,
                maxLines: 3,
                decoration: InputDecoration(
                  fillColor: secondaryBackground,
                  label: Text(
                    'Enter Details',
                    style: TextStyle(color: primaryText),
                  ),
                  hintText: 'Enter Details',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  hintStyle:
                      TextStyle(fontSize: fontVerySmall, color: textSecondary),
                )),
            Container(
              height: 40,
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(
                  Icons.cloud_upload_outlined,
                  color: primaryColor,
                ),
                label: GetBuilder<FoodManagementController>(builder: (context) {
                  return Text(
                    foodCtlr.mealAddonsStoreImage == null
                        ? "Upload Image"
                        : foodCtlr.mealAddonsStoreImage!.path
                            .split(Platform.pathSeparator)
                            .last,
                    style: TextStyle(color: textSecondary, fontSize: fontSmall),
                  );
                }),
                onPressed: () async {
                  foodCtlr.mealAddonsStoreImage = await foodCtlr.getImage();
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
                width: 200,
                child:
                    normalButton('Submit', primaryColor, white, onPressed: () {
                  if (foodCtlr.uploadMealAddonsKey.currentState!.validate()) {
                    foodCtlr
                        .addMealAddons(
                            foodCtlr.mealAddonsNameTextCtlr.text,
                            foodCtlr.mealAddonsPriceTextCtlr.text,
                            foodCtlr.mealAddonsDetailsTextCtlr.text,
                            foodCtlr.mealAddonsStoreImage)
                        .then((value) {
                      foodCtlr.mealAddonsNameTextCtlr.clear();
                      foodCtlr.mealAddonsPriceTextCtlr.clear();
                      foodCtlr.mealAddonsDetailsTextCtlr.clear();
                      foodCtlr.mealAddonsStoreImage = null;
                    });
                  }
                })),
          ],
        ),
      ),
    );
  }

  Widget upateMenuAddonsForm(dynamic itemId) {
    return Container(
      margin: const EdgeInsets.all(40),
      child: Form(
        key: foodCtlr.updateMealAddonsKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
                controller: foodCtlr.udpateMealAddonsNameTextCtlr,
                validator: foodCtlr.textValidator,
                decoration: InputDecoration(
                  fillColor: secondaryBackground,
                  label: Text(
                    'Enter Addons name',
                    style: TextStyle(color: primaryText),
                  ),
                  hintText: 'Enter Addons name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  hintStyle:
                      TextStyle(fontSize: fontVerySmall, color: textSecondary),
                )),
            TextFormField(
                controller: foodCtlr.updateMealAddonsPriceTextCtlr,
                validator: foodCtlr.textValidator,
                decoration: InputDecoration(
                  fillColor: secondaryBackground,
                  label: Text(
                    'Enter price',
                    style: TextStyle(color: primaryText),
                  ),
                  hintText: 'Enter price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  hintStyle:
                      TextStyle(fontSize: fontVerySmall, color: textSecondary),
                )),
            TextFormField(
                controller: foodCtlr.updateMealAddonsDetailsTextCtlr,
                validator: foodCtlr.textValidator,
                minLines: 2,
                maxLines: 3,
                decoration: InputDecoration(
                  fillColor: secondaryBackground,
                  label: Text(
                    'Enter Details',
                    style: TextStyle(color: primaryText),
                  ),
                  hintText: 'Enter Details',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  hintStyle:
                      TextStyle(fontSize: fontVerySmall, color: textSecondary),
                )),
            Container(
              height: 40,
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(
                  Icons.cloud_upload_outlined,
                  color: primaryColor,
                ),
                label: GetBuilder<FoodManagementController>(builder: (context) {
                  return Text(
                    foodCtlr.updateMealAddonsStoreImage == null
                        ? "Upload Image"
                        : foodCtlr.updateMealAddonsStoreImage!.path
                            .split(Platform.pathSeparator)
                            .last,
                    style: TextStyle(color: textSecondary, fontSize: fontSmall),
                  );
                }),
                onPressed: () async {
                  foodCtlr.updateMealAddonsStoreImage =
                      await foodCtlr.getImage();
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
                width: 200,
                child:
                    normalButton('Submit', primaryColor, white, onPressed: () {
                  if (foodCtlr.updateMealAddonsKey.currentState!.validate()) {
                    foodCtlr.updateMealAddons(
                      foodCtlr.udpateMealAddonsNameTextCtlr.text,
                      foodCtlr.updateMealAddonsPriceTextCtlr.text,
                      foodCtlr.updateMealAddonsDetailsTextCtlr.text,
                      id: itemId,
                    );
                  }
                })),
          ],
        ),
      ),
    );
  }

  Widget addMenuVariantForm() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Form(
        key: foodCtlr.uploadMealVariantsKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GetBuilder<FoodManagementController>(builder: (controller) {
              return MultiSelectDropDown(
                backgroundColor: secondaryBackground,
                optionsBackgroundColor: secondaryBackground,
                selectedOptionTextColor: primaryText,
                selectedOptionBackgroundColor: primaryColor,
                optionTextStyle: TextStyle(color: primaryText, fontSize: 16),
                onOptionSelected: (List<ValueItem> selectedOptions) {
                  foodCtlr.selectMenuItem = selectedOptions
                      .map((ValueItem e) => int.parse(e.value!))
                      .toList();
                },
                // selectedOptions: foodCtlr.foodSingleItemDetails.value.data!.addons!.data!.map((MenuAddon e) {
                //   return ValueItem(
                //     label:e.name!,
                //     value: e.id.toString(),
                //   );
                // }).toList(),
                hint: 'Menu Item Select',
                options: controller.menusData.value.data!
                    .map((FoodMenuManagementDatum e) {
                  return ValueItem(
                    label: e.name ?? '',
                    value: e.id.toString(),
                  );
                }).toList(),
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
            }),
            TextFormField(
                controller: foodCtlr.uploadMealVariantsNameTextCtlr,
                validator: foodCtlr.textValidator,
                decoration: InputDecoration(
                  fillColor: secondaryBackground,
                  label: Text(
                    'Enter variant  name',
                    style: TextStyle(color: primaryText),
                  ),
                  hintText: 'Enter variant name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  hintStyle:
                      TextStyle(fontSize: fontVerySmall, color: textSecondary),
                )),
            TextFormField(
                controller: foodCtlr.uploadMealVariantsPriceTextCtlr,
                validator: foodCtlr.textValidator,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  fillColor: secondaryBackground,
                  label: Text(
                    'Enter variant price',
                    style: TextStyle(color: primaryText),
                  ),
                  hintText: 'Enter variant price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  hintStyle:
                      TextStyle(fontSize: fontVerySmall, color: textSecondary),
                )),
            Container(
                height: 40,
                width: 200,
                child:
                    normalButton('Submit', primaryColor, white, onPressed: () {
                  if (foodCtlr.uploadMealVariantsKey.currentState!.validate()) {
                    foodCtlr
                        .addMenuVariant(
                            foodCtlr.selectMenuItem[0],
                            foodCtlr.uploadMealVariantsNameTextCtlr.text,
                            foodCtlr.uploadMealVariantsPriceTextCtlr.text)
                        .then((value) {
                      foodCtlr.uploadMealVariantsNameTextCtlr.clear();
                      foodCtlr.uploadMealVariantsPriceTextCtlr.clear();
                    });
                  }
                })),
          ],
        ),
      ),
    );
  }

  Widget updateMenuVariantForm(dynamic itemId) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Form(
        key: foodCtlr.updateMealVariantsKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GetBuilder<FoodManagementController>(builder: (controller) {
              return MultiSelectDropDown(
                backgroundColor: secondaryBackground,
                optionsBackgroundColor: secondaryBackground,
                selectedOptionTextColor: primaryText,
                selectedOptionBackgroundColor: primaryColor,
                optionTextStyle: TextStyle(color: primaryText, fontSize: 16),
                onOptionSelected: (List<ValueItem> selectedOptions) {
                  foodCtlr.updateSelectVariantMenuItem = selectedOptions
                      .map((ValueItem e) => int.parse(e.value!))
                      .toList();
                },
                selectedOptions:
                    foodCtlr.updateSelectedVariant.map((SinlgeVariantData e) {
                  return ValueItem(
                    label: e.name!,
                    value: e.id.toString(),
                  );
                }).toList(),
                hint: 'Menu Item Select',
                options: controller.foodVariants.value.data!.map((Variant e) {
                  return ValueItem(
                    label: e.name!,
                    value: e.id.toString(),
                  );
                }).toList(),
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
            }),
            TextFormField(
                controller: foodCtlr.updateMealVariantsNameTextCtlr,
                validator: foodCtlr.textValidator,
                decoration: InputDecoration(
                  fillColor: secondaryBackground,
                  label: Text(
                    'Enter variant  name',
                    style: TextStyle(color: primaryText),
                  ),
                  hintText: 'Enter variant name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  hintStyle:
                      TextStyle(fontSize: fontVerySmall, color: textSecondary),
                )),
            TextFormField(
                controller: foodCtlr.updateMealVariantsPriceTextCtlr,
                validator: foodCtlr.textValidator,
                decoration: InputDecoration(
                  fillColor: secondaryBackground,
                  label: Text(
                    'Enter variant price',
                    style: TextStyle(color: primaryText),
                  ),
                  hintText: 'Enter variant price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  hintStyle:
                      TextStyle(fontSize: fontVerySmall, color: textSecondary),
                )),
            Container(
                height: 40,
                width: 200,
                child:
                    normalButton('Submit', primaryColor, white, onPressed: () {
                  if (foodCtlr.updateMealVariantsKey.currentState!.validate()) {
                    foodCtlr.updateVariant(
                      foodCtlr.updateSelectVariantMenuItem[0],
                      foodCtlr.updateMealVariantsNameTextCtlr.text,
                      foodCtlr.updateMealVariantsPriceTextCtlr.text,
                      id: itemId,
                    );
                  }
                })),
          ],
        ),
      ),
    );
  }

  Widget viewMenuDetails() {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
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
                        foodCtlr.foodSingleItemDetails.value.data!.name!,
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
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Price',
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
                        foodCtlr.foodSingleItemDetails.value.data!.price!,
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
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'VAT:',
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
                        foodCtlr.foodSingleItemDetails.value.data!.taxVat!,
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
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Calories',
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
                        foodCtlr.foodSingleItemDetails.value.data!.calories!,
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
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Processing Time:',
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
                        foodCtlr
                            .foodSingleItemDetails.value.data!.processingTime!,
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
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Description:',
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
                        foodCtlr.foodSingleItemDetails.value.data!.description!,
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
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Categories:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                        // child: Text(
                        //   foodCtlr.foodSingleItemDetails.value.data!.calories!,
                        //   style: TextStyle(
                        //       fontSize: fontVerySmall,
                        //       color: primaryText,
                        //       fontWeight: FontWeight.bold),
                        // ),
                        )),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Meal Periods:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                        // child: Text(
                        //   foodCtlr.foodSingleItemDetails.value.data!.calories!,
                        //   style: TextStyle(
                        //       fontSize: fontVerySmall,
                        //       color: primaryText,
                        //       fontWeight: FontWeight.bold),
                        // ),
                        )),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Addons:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                        child: Row(
                      children: [
                        for (int i = 0;
                            i <
                                foodCtlr.foodSingleItemDetails.value.data!
                                    .addons!.data!.length;
                            i++)
                          Text(
                            'Name :' +
                                foodCtlr.foodSingleItemDetails.value.data!
                                    .addons!.data![i].name! +
                                "  " +
                                "price:" +
                                foodCtlr.foodSingleItemDetails.value.data!
                                    .addons!.data![i].price! +
                                "  ",
                            style: TextStyle(
                                fontSize: fontVerySmall,
                                color: primaryText,
                                fontWeight: FontWeight.bold),
                          ),
                      ],
                    )
                        // child: Text(
                        //   foodCtlr.foodSingleItemDetails.value.data!.calories!,
                        //   style: TextStyle(
                        //       fontSize: fontVerySmall,
                        //       color: primaryText,
                        //       fontWeight: FontWeight.bold),
                        // ),
                        )),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Allergies:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                        // child: Text(
                        //   foodCtlr.foodSingleItemDetails.value.data!.calories!,
                        //   style: TextStyle(
                        //       fontSize: fontVerySmall,
                        //       color: primaryText,
                        //       fontWeight: FontWeight.bold),
                        // ),
                        )),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Ingredient:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                        // child: Text(
                        //   foodCtlr.foodSingleItemDetails.value.data!.calories!,
                        //   style: TextStyle(
                        //       fontSize: fontVerySmall,
                        //       color: primaryText,
                        //       fontWeight: FontWeight.bold),
                        // ),
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
                        'Image:',
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
                        foodCtlr.foodSingleItemDetails.value.data!.image!,
                        height: 200,
                        width: 200,
                      ),
                      // child: Text(
                      //   foodCtlr.foodSingleItemDetails.value.data!.image!,
                      //   style: TextStyle(
                      //       fontSize: fontVerySmall,
                      //       color: primaryText,
                      //       fontWeight: FontWeight.bold),
                      // ),
                    )),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}

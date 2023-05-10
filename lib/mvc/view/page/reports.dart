import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import '../../../constant/color.dart';
import '../../../constant/value.dart';
class Reports extends StatefulWidget {
  const Reports({Key? key}) : super(key: key);

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> with SingleTickerProviderStateMixin {
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
                    stockReport(),
                    saleReport(),
                    profitLossReport(),
                    wasteReport(),
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

  stockReport() {
    return Card(
      color: secondaryBackground,
    );
  }

  saleReport() {
    return Card(
      color: secondaryBackground,
    );
  }

  profitLossReport() {
    return Card(
      color: secondaryBackground,
    );
  }

  wasteReport() {
    return Card(
      color: secondaryBackground,
    );
  }


}

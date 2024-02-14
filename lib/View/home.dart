import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobigic/universalController/universal_controller.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    askUserGridSize();
    super.initState();
  }

  final universalController = Get.put(UniversalController());

  final TextEditingController _mSizeController = TextEditingController();
  final TextEditingController _nSizeController = TextEditingController();
  final TextEditingController _addOrSearchValue = TextEditingController();

  final GlobalKey<FormState> _sizeKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _searchOrAddFormKey = GlobalKey<FormState>();

  askUserGridSize() => WidgetsBinding.instance.addPostFrameCallback((_) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Please Enter Grid Size"),
          content: Form(
            key: _sizeKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1)
                        ],
                        validator: (val){
                          if(val!.isEmpty ||val.isAlphabetOnly){
                            return "";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        controller: _nSizeController,
                        decoration: InputDecoration(
                            label: const Text("M-Size"),
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(20))),
                      ),
                    ),
                    const Spacer(),
                    Flexible(
                      child: TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1)
                        ],
                        keyboardType: TextInputType.number,
                        controller: _mSizeController,
                        validator: (val){
                          if(val!.isEmpty || val.isAlphabetOnly){
                            return "";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            label: const Text("N-Size"),
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(20))),
                      ),
                    ),
                  ],
                ),
                 ElevatedButton(
                     style: ElevatedButton.styleFrom(
                         shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(10)
                         )
                     ),
                      onPressed: () {
                       if(_sizeKey.currentState!.validate()){
                         universalController.isClicked.value = true;
                         if ((universalController
                             .validateNMValue(_mSizeController.text)
                             .value &&
                             universalController
                                 .validateNMValue(_nSizeController.text)
                                 .value)) {
                           universalController
                               .setMValue(_mSizeController.text);
                           universalController
                               .setNValue(_nSizeController.text);
                           universalController.matrixData.clear();
                           universalController.isSearched.value = false;
                           Get.back();
                         }
                         universalController.isClicked.value = false;

                       }
                      },
                      child: const Text("GO")),

              ],
            ),
          ),
        ));
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        title: const Text("M-WORD",style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.teal),),
       centerTitle: true,
        actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              )
          ),
          onPressed: (){
           askUserGridSize();
         },child:const  Text("Clear Matrix"),)
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: Obx(
                  () => Form(
                key: _searchOrAddFormKey,
                child: TextFormField(
                  textCapitalization: TextCapitalization.characters,
                  controller: _addOrSearchValue,
                  validator: (val) {
                    if(!universalController.isMatrixFilled){
                      if (val == null ||
                          val.isEmpty ||
                          val.length < universalController.getMValue ||
                          !val.isAlphabetOnly) {
                        return "Invalid Data";
                      }
                    }else if(val == null || !val.isAlphabetOnly){
                      return "Invalid Search Data";
                    }
                    return null;
                  },
                  keyboardAppearance: Brightness.dark,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                        universalController.getMValue)
                  ],
                  decoration: InputDecoration(

                      counter: universalController.isMatrixFilled
                          ? null
                          : Text(
                          "Filling Row-${universalController.getRowValue}/${universalController.getNValue}"),
                      label: Text(universalController.getTextFieldTitle),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                    onPressed: () {
                      if (_searchOrAddFormKey.currentState!.validate()) {
                        if (universalController.isMatrixFilled) {
                          setState(() {
                            universalController
                                .searchValueInMatrix(_addOrSearchValue.text);
                          });
                          FocusScope.of(context).unfocus();
                        } else {
                          universalController
                              .addValueToMatrix(_addOrSearchValue.text);
                        }
                      }
                      _addOrSearchValue.clear();
                    },
                    child: Text(universalController.buttonTitle)),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Obx(
                () => Expanded(
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: universalController.getMValue,
                    ),
                    itemCount: universalController.getMxNValue,
                    itemBuilder: (context, value) {
                      int row = value ~/ universalController.getMValue;
                      int col = value % universalController.getMValue;
                      return Obx(
                            () => Container(
                            decoration: BoxDecoration(
                                color: universalController.isSearched.value
                                    ? universalController
                                    .getColorsAgain(row, col)
                                    .value
                                    : universalController
                                    .getColor(row, col)
                                    .value,
                                borderRadius: BorderRadius.circular(10)),
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(5),
                            child: Text(
                              universalController.getEveryRowData(row, col) ??
                                  "?",
                              style:
                              const TextStyle(fontWeight: FontWeight.bold),
                            )),
                      );
                    })),
          )
        ],
      ),
    );
  }
}
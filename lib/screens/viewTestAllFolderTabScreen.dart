
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:connect/components/buttonView.dart';
import 'package:connect/models/folderModel.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';

class ViewTestAllFolderTabScreen extends StatefulWidget {
  const ViewTestAllFolderTabScreen({Key? key}) : super(key: key);

  @override
  _ViewTestAllFolderTabScreenState createState() => _ViewTestAllFolderTabScreenState();
}

class _ViewTestAllFolderTabScreenState extends State<ViewTestAllFolderTabScreen> {

  late final Folder newFolder;

  TextEditingController folderController = TextEditingController();

  @override
  void initState() {
    super.initState();

    setState(() {
      newFolder = Folder(
        name: 'Main Folder',
        isExpanded: true,
        isFolder: true,
        isVisible: true,
        isDelete: false,
        subfolders: [],
      );
    });

  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

      //--------------------All folder tab body view-------------------
    return allFolderView();
  }


//--------------------Popupmenu View-----------------------------------
  Widget addOrDeletePopMenuBox(Folder subFolder, bool isRoot, int index) {
    return PopupMenuButton(
      elevation: 1,
      icon: Icon(Icons.more_horiz),
      itemBuilder: (context) => [
        PopupMenuItem(
          padding: EdgeInsets.only(
              top: height * 0.01, left: width * 0.0065, right: width * 0.0065),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  addNewFolderNamePopUp(subFolder, isRoot, index);
                },
                child: Container(
                  margin: EdgeInsets.only(
                      left: width * 0.005, right: width * 0.005),
                  alignment: Alignment.center,
                  child: Text(
                    TextConst.addNewFolderPopUpText,
                    style: interRegular.copyWith(
                        color: ThemeManager().getBlackColor,
                        fontSize: width * 0.035),
                  ),
                ),
              ),
              isRoot == false
                  ? Container()
                  : Container(
                margin: EdgeInsets.only(
                    top: height * 0.01, bottom: height * 0.01),
                height: height * 0.001,
                width: double.infinity,
                color: ThemeManager().getBlackColor.withOpacity(0.19),
              ),
              isRoot == false
                  ? Container()
                  : InkWell(
                onTap: () {
                  setState(() {
                    subFolder.subfolders.removeAt(index);
                    Navigator.of(context).pop();
                  });
                },
                child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      TextConst.deleteFolderPopUpText,
                      style: interRegular.copyWith(
                          color: ThemeManager().getBlackColor,
                          fontSize: width * 0.035),
                    )),
              )
            ],
          ),
          // value: 1,
        ),
      ],
    );
  }

//---------------Add new folder Name Dialogue Box------------------
  addNewFolderNamePopUp(Folder folder, bool pos, int index) {
    final _formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (
            context,
            ) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              contentPadding: EdgeInsets.only(top: 10.0),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: height * 0.01,
                        left: width * 0.04,
                        right: width * 0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          TextConst.addSubFolderText,
                          style: interSemiBold.copyWith(
                            color: ThemeManager().getBlackColor,
                            fontSize: width * 0.04,
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.clear,
                              size: width * 0.06,
                              color: ThemeManager().getLightGrey4Color,
                            )),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: height * 0.015),
                    height: height * 0.001,
                    color: ThemeManager().getBlackColor.withOpacity(0.19),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: height * 0.02,
                        left: width * 0.04,
                        right: width * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          TextConst.folderNameText,
                          style: interMedium.copyWith(
                            color: ThemeManager().getPopUpTextGreyColor,
                            fontSize: width * 0.036,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: height * 0.015),
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: folderController,
                              maxLength: 10,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                                hintText: TextConst.textFieldFolderText,
                                hintStyle: interMedium.copyWith(
                                  color: ThemeManager().getLightGrey4Color,
                                  fontSize: width * 0.036,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(width * 0.014)),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: height * 0.0,
                                    horizontal: width * 0.045),
                                fillColor:
                                ThemeManager().getLightGreenTextFieldColor,
                                filled: true,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter folder name";
                                } else if (folderController.text.length > 10) {
                                  return "Name shold be 10 character only";
                                }
                              },
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: height * 0.015),
                          child: Text(
                            "*Name must be within 10 characters.",
                            style: interMedium.copyWith(
                              color: ThemeManager().getPopUpTextGreyColor,
                              fontSize: width * 0.03,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              pos == false
                                  ? folder.subfolders.add(Folder(
                                  name: folderController.text,
                                  isExpanded: false,
                                  isFolder: true,
                                  isVisible: true,
                                  isDelete: true,
                                  subfolders: []))
                                  : folder.subfolders[index].subfolders.add(
                                  Folder(
                                      name: folderController.text,
                                      isExpanded: false,
                                      isFolder: true,
                                      isVisible: true,
                                      isDelete: true,
                                      subfolders: []));

                              folderController.clear();

                              Navigator.of(context).pop();
                            } else {}
                          },
                          child: Container(
                              margin: EdgeInsets.only(
                                  top: height * 0.04, bottom: height * 0.02),
                              child: ButtonView(
                                  buttonLabel: TextConst.saveButtonText)
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

//------------------- Folder List----------------------------
  Widget allFolderView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: width * 0.03),
          child: Text(
            "Browse",
            style: interMedium.copyWith(
                color: ThemeManager().getLightGrey1Color,
                fontSize: width * 0.04),
          ),
        ),
        Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                  ),
                  height: height * 0.049,
                  width: width,
                  color: ThemeManager().getLightYellowColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin: EdgeInsets.only(
                            left: width * 0.04,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    newFolder.isExpanded = !(newFolder.isExpanded);
                                    newFolder.isVisible = !newFolder.isVisible;
                                  });
                                },
                                child: newFolder.isExpanded == false
                                    ? Icon(
                                  Icons.keyboard_arrow_up_outlined,
                                  size: width * 0.085,
                                  color: ThemeManager().getDarkGrey2Color,
                                )
                                    : Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  size: width * 0.085,
                                  color: ThemeManager().getDarkGrey2Color,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: width * 0.02,
                                ),
                                child: SvgPicture.asset(
                                  ("assets/svg/folderIcon.svg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                    left: width * 0.03,
                                  ),
                                  child: Text(
                                    newFolder.name,
                                    style: interRegular.copyWith(
                                      color: ThemeManager().getBlackColor,
                                      fontSize: width * 0.045,
                                    ),
                                  )),
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.only(
                          right: width * 0.03,
                        ),
                        child: addOrDeletePopMenuBox(newFolder, false, 0),
                      ),
                    ],
                  ),
                ),
                subFolderView(newFolder, 0, width * 0),
              ],
            )),
      ],
    );
  }

  //-------------------Sub-folder-----------------------------
  Widget subFolderView(Folder subfolder, int ia, var parentPadding,) {
    var padding = parentPadding + width * 0.09;

    return Visibility(
      visible: subfolder.isVisible,
      child: Column(
          children: List.generate(subfolder.subfolders.length, (index) {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                    left: padding,
                  ),
                  height: height * 0.049,
                  width: width,
                  color: ThemeManager().getWhiteColor.withOpacity(.2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin: EdgeInsets.only(
                            left: width * 0.04,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    subfolder.subfolders[index].isExpanded =
                                    !(subfolder.subfolders[index].isExpanded);
                                    subfolder.subfolders[index].isVisible =
                                    !subfolder.subfolders[index].isVisible;
                                  });
                                },
                                child:
                                subfolder.subfolders[index].isExpanded == true
                                    ? Icon(
                                  Icons.keyboard_arrow_up_outlined,
                                  size: width * 0.085,
                                  color: ThemeManager().getDarkGrey2Color,
                                )
                                    : Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  size: width * 0.085,
                                  color: ThemeManager().getDarkGrey2Color,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: width * 0.02,
                                ),
                                child: SvgPicture.asset(
                                  ("assets/svg/folderIcon.svg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                    left: width * 0.03,
                                  ),
                                  child: Text(
                                    subfolder.subfolders[index].name,
                                    style: interRegular.copyWith(
                                      color: ThemeManager().getBlackColor,
                                      fontSize: width * 0.045,
                                    ),
                                  )),
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.only(
                          right: width * 0.03,
                        ),
                        child: addOrDeletePopMenuBox(subfolder, true, index),
                      ),
                    ],
                  ),
                ),
                subfolder.subfolders[index].subfolders.length > 0
                    ? subFolderView(
                  subfolder.subfolders[index],
                  index,
                  padding + width * 0.09,
                )
                    : Container()
              ],
            );
          })),
    );
  }

}

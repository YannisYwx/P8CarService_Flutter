import 'package:flutter/material.dart';

class EntryType {
  UserType type;
  String label;
  Color color;

  EntryType(this.type, this.label, this.color);

  static List<EntryType> getEntryTypes() {
    List<EntryType> list = List();
    list.add(EntryType(UserType.AGENCY, "大主", Color.fromARGB(255, 59, 59, 91)));
    list.add(EntryType(UserType.INSPECTION, "地主", Color.fromARGB(255, 72, 152, 246)));
    list.add(EntryType(UserType.LANDLORD, "场主", Color.fromARGB(255, 30, 163, 136)));
    list.add(EntryType(UserType.LITTLE_AGENCY, "小主", Color.fromARGB(255, 247, 117, 57)));
    list.add(EntryType(UserType.MASTER, "台主", Color.fromARGB(255, 235, 200, 44)));
    list.add(EntryType(UserType.MIDDLE_AGENCY, "中主", Color.fromARGB(255, 49, 119, 172)));
    list.add(EntryType(UserType.OWN, "自主", Color.fromARGB(255, 192, 217, 245)));
    list.add(EntryType(UserType.BUILDER, "施主", Color.fromARGB(255, 20, 207, 160)));
    list.add(EntryType(UserType.OTHER, "其他", Color.fromARGB(255, 112, 111, 137)));
    return list;
  }


}

enum UserType {
  //大主
  AGENCY,
  //地主
  INSPECTION,
  //场主
  LANDLORD,
  //小主
  LITTLE_AGENCY,
  //台主
  MASTER,
  //中主
  MIDDLE_AGENCY,
  //自主
  OWN,
  //施主
  BUILDER,
  //其他
  OTHER
}

import 'package:flutter/material.dart';


double inputWidth = 200;
abstract class EventAdder{

  //EventAdder({this.eState});
  //AddEventPageState eState;
  String displayValue = '';
  Widget build(BuildContext context);
  void save(String name) async {}
}
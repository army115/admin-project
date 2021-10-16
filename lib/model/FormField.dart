import 'package:flutter/cupertino.dart';

class RecipeFormField {
  final int index;
  final TextEditingController savetrack;
  final TextEditingController savename;
  final TextEditingController savesale;

  const RecipeFormField(
      {this.index, this.savetrack, this.savename, this.savesale});
}
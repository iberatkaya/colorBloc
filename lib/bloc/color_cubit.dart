import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorCubit extends Cubit<List<Color>> {
  ColorCubit()
      : super([
          Colors.blue,
        ]);
  void addColor(Color mycolor) => emit([
        mycolor,
        ...state,
      ]);
}

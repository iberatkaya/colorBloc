import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint/bloc/color_cubit.dart';
import 'package:paint/mypaint.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paint and Bloc Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Paint and Bloc Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController rCont = TextEditingController();
  TextEditingController gCont = TextEditingController();
  TextEditingController bCont = TextEditingController();
  int space = 3;
  GlobalKey<FormState> _key = GlobalKey();

  ///Convert R, G, B strings into a Color
  ///Default value if a string parsing fails is 0
  Color rgbStringToColor(String r, String g, String b) {
    return Color.fromRGBO(
      int.tryParse(r) != null ? int.parse(r) : 0,
      int.tryParse(g) != null ? int.parse(g) : 0,
      int.tryParse(b) != null ? int.parse(b) : 0,
      1,
    );
  }

  int Function(Color) averageValueFromColor =
      (Color mycolor) => (mycolor.red + mycolor.green + mycolor.blue) ~/ 3;

  String validateUint8(String val) {
    if (int.tryParse(val) == null) {
      return "Not a valid number";
    } else if (int.tryParse(val) > 255) {
      return "Number has to be less than 255";
    } else if (int.tryParse(val) < 0) {
      return "Number has to be larger than -1";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: BlocProvider<ColorCubit>(
          create: (context) => ColorCubit(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(flex: 1),
              Expanded(
                flex: 5,
                child: BlocBuilder<ColorCubit, List<Color>>(builder: (blockContext, colors) {
                  return CustomPaint(
                    painter: MyPaint(
                      colors: colors,
                      space: space,
                    ),
                  );
                }),
              ),
              Expanded(
                flex: 3,
                child: Form(
                  key: _key,
                  child: Row(
                    children: [
                      Spacer(flex: 1),
                      Expanded(
                        flex: 8,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Red",
                          ),
                          validator: validateUint8,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                          ],
                          keyboardType: TextInputType.number,
                          controller: rCont,
                          onChanged: (val) => setState(() {}),
                        ),
                      ),
                      Spacer(flex: 1),
                      Expanded(
                        flex: 8,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Green",
                          ),
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                          ],
                          validator: validateUint8,
                          keyboardType: TextInputType.number,
                          controller: gCont,
                          onChanged: (val) => setState(() {}),
                        ),
                      ),
                      Spacer(flex: 1),
                      Expanded(
                        flex: 8,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Blue",
                          ),
                          validator: validateUint8,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                          ],
                          keyboardType: TextInputType.number,
                          controller: bCont,
                          onChanged: (val) => setState(() {}),
                        ),
                      ),
                      Spacer(flex: 1),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: BlocBuilder<ColorCubit, List<Color>>(
                  builder: (blockContext, colors) {
                    return FlatButton(
                        onPressed: () {
                          if (!_key.currentState.validate()) return;
                          BlocProvider.of<ColorCubit>(blockContext)
                              .addColor(rgbStringToColor(rCont.text, gCont.text, bCont.text));
                        },
                        child: Text(
                          "Add Color",
                          style: TextStyle(
                              color: averageValueFromColor(
                                          rgbStringToColor(rCont.text, gCont.text, bCont.text)) <
                                      127
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        color: rgbStringToColor(rCont.text, gCont.text, bCont.text));
                  },
                ),
              ),
              Spacer(flex: 1),
              Expanded(
                flex: 1,
                child: BlocBuilder<ColorCubit, List<Color>>(
                  builder: (blocContext, colors) {
                    return Container(
                      height: 60,
                      child: (colors.length > 0)
                          ? ListView.separated(
                              separatorBuilder: (listContext, index) {
                                return Container(
                                  width: 5,
                                );
                              },
                              scrollDirection: Axis.horizontal,
                              itemCount: colors.length,
                              itemBuilder: (listContext, index) {
                                return Container(
                                  height: 50,
                                  width: 50,
                                  color: colors[index],
                                );
                              },
                            )
                          : null,
                    );
                  },
                ),
              ),
              Spacer(flex: 1),
              Expanded(
                flex: 1,
                child: BlocBuilder<ColorCubit, List<Color>>(
                  builder: (blocContext, colors) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Space between circles: " + space.toString(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                            child: Text(
                          "Total Colors: " + colors.length.toString(),
                          textAlign: TextAlign.center,
                        )),
                      ],
                    );
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Slider(
                  value: space.toDouble(),
                  min: 1,
                  max: 25,
                  onChanged: (val) => setState(() => space = val.toInt()),
                ),
              ),
              Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

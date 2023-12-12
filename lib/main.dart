import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String text = "0";
  int? first, second;
  String? res, opp;
  List<String> calculationsHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        actions: [
          IconButton(
            onPressed: () {
              showHistoryDialog(context);
            },
            icon: Icon(Icons.history),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.bottomRight,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 60.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.deepOrange,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return buildCalculator();
                    },
                  );
                },
                child: Text("Open Calculator"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customOutlineButton(String val) {
    Color buttonColor = Colors.blue; // Default button color
    if (val == "sin" ||
        val == "cos" ||
        val == "tan" ||
        val == "log" ||
        val == "π" ||
        val == "√" ||
        val == "^" ||
        val == "+" ||
        val == "-" ||
        val == "/" ||
        val == "x" ||
        val == "=") {
      buttonColor = Colors.red; // Set buttons for operations to red
    } else if (val == "C") {
      buttonColor = Colors.black; // Set C button to black
    } else if (val == "0") {
      buttonColor = Colors.blue; // Set 0 button color to blue
    }

    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: MaterialButton(
        padding: EdgeInsets.all(20.0),
        onPressed: () => btnClicked(val),
        child: Text(
          val,
          style: TextStyle(fontSize: 35.0, color: buttonColor),
        ),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: Colors.black),
        ),
      ),
    );
  }

  void showHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Calculation History'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: calculationsHistory.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    calculationsHistory[index],
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void btnClicked(String btnText) {
    setState(() {
      if (btnText == "C") {
        res = "0";
        text = "0";
        first = null;
        second = null;
        opp = null;
      } else if (btnText == "+" || btnText == "-" || btnText == "x" || btnText == "/") {
        if (first == null) {
          first = int.parse(text);
          text += btnText;
          opp = btnText;
        } else {
          second = int.parse(text.substring(text.lastIndexOf(opp!) + 1));
          performOperation();
          text = res! + btnText;
          first = int.parse(res!);
          second = null;
          opp = btnText;
        }
      } else if (btnText == "=") {
        if (first != null && opp != null) {
          second = int.parse(text.substring(text.lastIndexOf(opp!) + 1));
          performOperation();
          String currentCalculation = text;
          calculationsHistory.add(currentCalculation);
          text += " = $res";

          first = int.parse(res!);
          second = null;
          opp = null;
          if (opp == "sin" || opp == "cos" || opp == "tan") {
            calculationsHistory.add(text);
          }
        }
      } else if (btnText == "sin" || btnText == "cos" || btnText == "tan") {
        if (text != "0") {
          String input = text;
          res = (double.parse(text) * (pi / 180)).toString();
          res = (double.parse(res!) % 360).toString();
          switch (btnText) {
            case "sin":
              res = "sin($input) = ${sin(double.parse(res!))}";
              break;
            case "cos":
              res = "cos($input) = ${cos(double.parse(res!))}";
              break;
            case "tan":
              res = "tan($input) = ${tan(double.parse(res!))}";
              break;
            default:
              break;
          }
          text = res!;
        }
        calculationsHistory.add(text);
      }  else if (btnText == "log") {
        if (text != "0") {
          res = (log(double.parse(text))).toString();
          text = res!;
        }
        calculationsHistory.add(text);
      } else if (btnText == "√") {
        if (text != "0") {
          res = (sqrt(double.parse(text))).toString();
          text = res!;
        }
        calculationsHistory.add(text);
      } else if (btnText == "π") {
        text = pi.toStringAsFixed(10);
        calculationsHistory.add(text);
      } else if (btnText == "^") {
        // For exponentiation
        if (first == null) {
          first = int.parse(text);
          text += btnText;
          opp = btnText;
        } else {
          second = int.parse(text.substring(text.lastIndexOf(opp!) + 1));
          res = (pow(first!, second!)).toString();
          text = res! + btnText;
          first = int.parse(res!);
          second = null;
          opp = btnText;
        }
        calculationsHistory.add(text);
      } else {
        if (text == "0") {
          text = btnText;
        } else {
          text += btnText;
        }
      }
    });
  }

  void performOperation() {
    if (opp == "+") {
      res = (first! + second!).toString();
    } else if (opp == "-") {
      res = (first! - second!).toString();
    } else if (opp == "x") {
      res = (first! * second!).toString();
    } else if (opp == "/") {
      if (second != 0) {
        res = (first! ~/ second!).toString();
      } else {
        res = "Error";
      }
    }
  }
  Widget buildCalculator() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 15.0,
          mainAxisSpacing: 15.0,
        ),
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return customOutlineButton(_getButtonText(index));
        },
      ),
    );
  }

  String _getButtonText(int index) {
    switch (index) {
      case 0:
        return "sin";
      case 1:
        return "cos";
      case 2:
        return "tan";
      case 3:
        return "+";
      case 4:
        return "C";
      case 5:
        return "log";
      case 6:
        return "7";
      case 7:
        return "8";
      case 8:
        return "9";
      case 9:
        return "√";
      case 10:
        return "4";
      case 11:
        return "5";
      case 12:
        return "6";
      case 13:
        return "^";
      case 14:
        return "1";
      case 15:
        return "2";
      case 16:
        return "3";
      case 17:
        return "π";
      case 18:
        return "0";
      case 19:
        return "=";
      default:
        return "";
    }
  }
}

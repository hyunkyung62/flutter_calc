// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          
          theme: ThemeData(
            primaryColor: Color.fromARGB(255,46, 47, 56),
            fontFamily : 'Pretendard',
            
          ),
          home: MyHomePage(title:'calculator'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String display = '0';
  String operand1 = '';
  String operand2 = '';
  String operator = '';
  String history = '';
  


void inputNumber(String number) {

        setState(() {
            if (operator.isEmpty) {
              
                operand1 += number;
                 display = formatInput(operand1);

            } else {
                operand2 += number;
                display = '${formatInput(operand1)}$operator${formatInput(operand2)}';
                
            }
        });
    }

void inputOperator(String op) {

        setState(() {
            operator = op;
            display += op;
           
        });
    }
    
void calculateResult() {


 double num1 = double.tryParse(operand1) ?? 0.0;  
 double num2 = double.tryParse(operand2) ?? 0.0;  
 double result = 0;
        switch (operator) {
            case '+':
                result = num1 + num2;
                break;
            case '-':
                result = num1 - num2;
                break;
            case '×':
                result = num1 * num2;
                break;
            case '÷':
                result = num1 / num2;
                break;         
        }

        setState(() {
            setHistory(); //계산식 set
          
            //결과값 set , 초기화
            display = formatInput(result.toString()); //3자리 콤마를 위한

            //operand1 = result.toString(); 이어서 
            operand1 = '';
            operand2 = '';
            operator = '';
            
        });
    }

void clearDisplay() {

        setState(() {
            display = '0';
            operand1 = '';
            operand2 = '';
            operator = '';
            history = '';
        });
        
        }

void setHistory(){
        setState(() {
          history = '${formatInput(operand1)}$operator${formatInput(operand2)}';
        });
    }

//백스페이스
void onBackspace() {
  setState(() {
    if (operator.isEmpty) {
      // 연산자 없으면 operand1에서 삭제
      String raw = operand1.replaceAll(',', '');
      if (raw.length > 1) {
        raw = raw.substring(0, raw.length - 1);
      } else {
        raw = '';
      }
      operand1 = raw;
      display = formatInput(operand1.isEmpty ? '0' : operand1);
    } else {
      if (operand2.isEmpty) {
        // 연산자 지우기 전에 display 업데이트 막음 (0으로 변하기때문에)
        operator = '';
        display = formatInput(operand1);
      } else {
        // operand2에서 삭제
        String raw = operand2.replaceAll(',', '');
        if (raw.length > 1) {
          raw = raw.substring(0, raw.length - 1);
        } else {
          raw = '';
        }
        operand2 = raw;
        display = '${formatInput(operand1)}$operator${formatInput(operand2)}';
      }
    }
  });
}

//소수 계산 & 3자리 콤마  
String formatInput(String input) {
  if (input.isEmpty) return '';

  final parts = input.split('.');
  final intPart = parts[0].replaceAll(',', ''); // 콤마 제거 후 변환
  final formattedInt = NumberFormat('#,###').format(int.tryParse(intPart) ?? 0);
  // 소수점이 있으면 그대로 이어붙이기 (포맷으로 인하여 점사라져서)
  return parts.length == 2 ? '$formattedInt.${parts[1]}' : formattedInt;
}
  

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color.fromARGB(255,46, 47, 56),
    appBar: AppBar(  
    ),
    body: SafeArea(
  child: Padding(
    padding: EdgeInsets.all(16.w),
    child: Column(
      
      children: [
         Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end, // 아래 정렬
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // 계산 history
                      Text(
                        history,
                        style: TextStyle(fontSize: 20.sp, color: Colors.grey),
                      ),
                      SizedBox(height: 16.h),
                      // 계산 결과
                      Container(
                        height: 60.h,
                        width: double.infinity,
                        alignment: Alignment.centerRight,
                        child: SingleChildScrollView( //스크롤
                          scrollDirection: Axis.horizontal,
                          reverse: false,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              display,
                              style: TextStyle(
                                fontSize: 36.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
              // 버튼 영역 
                 Column(
                    children: [
                      buildButtonRow(['초기화', '÷'], flex1: 3, flex2: 1),
                      buildButtonRow(['7', '8', '9', '×']),
                      buildButtonRow(['4', '5', '6', '+']),
                      buildButtonRow(['1', '2', '3', '-']),
                      buildButtonRow(['.', '0', '<', '=']),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


Widget buildButtonRow(List<String> labels, {int flex1 = 1, int flex2 = 1}) {
  return Row(
    children: [
      for (int i = 0; i < labels.length; i++) ...[
        Expanded(
          flex: (i == 0) ? flex1 : flex2, // 첫 번째 버튼은 flex1, 나머지는 flex2로 할당
          child: buildButton(labels[i]),
        ),
        if (i != labels.length - 1) SizedBox(width: 6.w), // 버튼 간 간격
      ],
    ],
  );
}

 Color getButtonColor(String label) {
    if (label == '초기화' ) {
      return Color.fromARGB(255, 118, 128, 134);    
    } else if (label == '÷' || label == '×' || label == '-' || label == '+' || label == '=') {
      return Color.fromARGB(255,75, 93, 252);
    } else {
      return Color.fromARGB(255, 78, 85, 90);
    }
  }

   Widget buildButton(String label) {
        return GestureDetector(
            onTap: () {
               // C 초기화
                if (label == '초기화') {
                    clearDisplay();
              // = 결과
                } else if (label == '=') {
                     
                     if ( operand2 == '' ) {return;} //두번째 값 없다면 return
                     else{ 
                      calculateResult(); //계산
                  
                      //계산 후 초기화
                      setState(() {     
                      operand1 = '';
                      operand2 = '';
                      operator = '';  
                      });
                      }

                //연산자일때
                } else if ('+-×÷'.contains(label)) {

                   if (operator.isEmpty && operand1.isNotEmpty){
                    inputOperator(label);}

                } else if (label=='.') {  //소수 유효성체크

                      if (operator.isEmpty) {
                        // 첫 번째 숫자에 소숫점 없다면
                        if (!operand1.contains('.')) {
                          inputNumber(label);
                        }
                      } else {
                        // 두 번째 숫자에 소숫점 없다면
                        if (!operand2.contains('.')) {
                         inputNumber(label);
                        }
                      }

              //백스페이스
              }else if(label == '<' ){  
                    if(display.isNotEmpty){ onBackspace();} 

              //그외 
              } else {
                    inputNumber(label);
                }
            },

           child: Container(
            margin: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: getButtonColor(label),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Center(
              //백스페이스버튼 
              child: label == '<'
               ? SvgPicture.asset(
                  'assets/images/delete.svg',
                   width: 28.w,
                   height: 28.w, 
                   fit: BoxFit.contain,
                  )
                : Text(
                    label,
                    style: TextStyle(fontSize: 20.sp, color: Colors.white),
                 ),
            ),
          ),
        );
      }
    
}

import 'package:flutter/material.dart';
import 'package:zense_project/pie_chart_data.dart';

class Indicators extends StatefulWidget {
  String start_date;
  String end_date;
  String? uid;
  Indicators(this.start_date,this.end_date,this.uid,{Key? key}) : super(key: key){}

  @override
  State<Indicators> createState() => _IndicatorsState();
}

class _IndicatorsState extends State<Indicators> {
  Future<List<Data>> getData() async {
    List<Data> data = await fetchData(widget.uid, widget.start_date,widget.end_date);
    return data;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot){
        if (snapshot.hasData){
          List<Data> data = snapshot.data!;
          return Container(
            color: Colors.grey[200],
            width: 150,
            child: Column(
              children: 
                data.map((e) => Container(
                  child: buildIndicator(color: e.color,text: e.name))
                ).toList(),
              
            ),
          );
        }
        else{
          return Container();
        }
      }
    
    );
  }

  Widget buildIndicator({
    required Color? color,
    required String? text,
    bool isSquare = false,
    double size = 16,
  }) => 
  Row(
    children: [
      Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
          color: color
        ),
      ),
      const SizedBox(width: 8,),
      Text(
        text!,
        style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold ),
      )
    ],
  );
}
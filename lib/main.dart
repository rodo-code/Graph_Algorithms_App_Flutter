import 'dart:async';
import 'dart:math';
import 'package:arrow_path/arrow_path.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Graph Algorithms Application',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return MainDraw();
  }
}


class MainDraw extends State<MyHomePage> {
  int option=-1;
  int selected=-1;
  bool move=false;
  List<double> px=List<double>();
  List<double> py=List<double>();
  List<int> cr=List<int>();
  List<int> cg=List<int>();
  List<int> cb=List<int>();
  List<int> edge1 = List<int>();
  List<int> edge2 = List<int>();
  int conection = -1;
  List<bool> act=List<bool>();
  var gr=Random();
  Future timer(int t)async{
    Completer c = Completer();
    Timer(Duration(milliseconds: t), (){
      c.complete(_loop(t));
    });
  }
  _loop(int t){
    timer(t);
  }
  //Main App
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Grafos')),
      body: GestureDetector(
        onTapDown: (TapDownDetails details) => _onTapDown(details),
        onTapUp: (TapUpDetails details) => _onTapUp(details),
        onPanStart: (DragStartDetails details)=> _onPanStart(details),
        onPanUpdate: (DragUpdateDetails details)=> _onPanUpdate(details),
        onPanDown: (DragDownDetails details)=> _onPanDown(details),
        child: Stack(
          children: <Widget>[
            CustomPaint(painter: Pelotas(px,py,cr,cg,cb,edge1,edge2),child: Container(),),
          ],
        ),
      ),

    );
  }
  _onPanDown(DragDownDetails details){
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    print("on pan down "+x.toString()+","+y.toString());

  }
  _onPanStart(DragStartDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    print("on pan start " + x.toString() + "," + y.toString());
    //CODE FOR MOVE AND THIS
    double xx = double.parse(x.toString());
    double yy = double.parse(y.toString());
    //print("tap down " + xx.toString() + ", " + yy.toString());
    yy -= 80;
    setState(() {
      conection = -1;
      double dist=0;
      for(int i=0;i<px.length;i++){
        double delx=(px[i]-xx);
        double dely=(py[i]-yy);
        dist=sqrt((delx*delx)+(dely*dely));
        if(dist<=30){
          selected=i;
        }
      }

    });
  }
  _onPanUpdate(DragUpdateDetails details){
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    print("on pan update "+x.toString()+","+y.toString());
    //CODE FOR MOVE

    double xx=double.parse(x.toString());
    double yy=double.parse(y.toString());
    yy-=80;
    setState(() {
      conection = -1;
      px[selected]=xx;
      py[selected]=yy;
    });
  }
  _onTapDown(TapDownDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    double xx=double.parse(x.toString());
    double yy=double.parse(y.toString());
    setState(() {
      int sel = isInCircle(xx, yy-80);
      if(sel!=-1){
        if(conection != -1){
          edge1.add(conection);
          edge2.add(sel);
          conection = -1;
        }
        else{
          conection = sel;
        }
      }
      else{
        conection = -1;
        if(conection == -1) {
          px.add(xx);
          py.add(yy - 80);
          selected = px.length - 1;
          cr.add(gr.nextInt(256));
          cg.add(gr.nextInt(256));
          cb.add(gr.nextInt(256));
        }
      }
    });
    /*print("tap down " + xx.toString() + ", " + yy.toString());
    yy-=80;
    if(xx!=null && yy!=null){
      setState(() {
        //px.add(xx);
        //py.add(yy);
        //cr.add(gr.nextInt(256));
        //cg.add(gr.nextInt(256));
        //cb.add(gr.nextInt(256));
      });
      //print("Tamanio "+px.length.toString());
    }*/
  }

  _onTapUp(TapUpDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    print("tap up " + x.toString() + ", " + y.toString());
  }
  int isInCircle(double x,double y){
    int res = -1;
    for(int i=0;i<px.length;i++){
      double dist = sqrt(((px[i]-x)*(px[i]-x))+((py[i]-y)*(py[i]-y)));
      print("La distancia de "+x.toString()+","+y.toString()+" a "+px[i].toString()+","+py[i].toString()+" es "+dist.toString());
      if(dist<=30){
        res = i;
      }
    }
    return res;
  }
}

class Pelotas extends CustomPainter{
  List<double>px,py;
  List<int>cr,cg,cb,edge1,edge2;
  Pelotas(this.px,this.py,this.cr,this.cg,this.cb,this.edge1,this.edge2);
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint=Paint()
      ..color=Colors.red
      ..style=PaintingStyle.fill
      ..strokeWidth=1.1;
    //canvas.drawCircle(Offset(300,300), 10, paint);
    //canvas.drawLine(Offset(size.width/2,size.height/2), Offset(100+(size.width/2),100+(size.height/2)), paint);
    for(int i=0;i<px.length;i++){
      paint.color=Color.fromARGB(255,cr[i],cg[i],cb[i]);
      canvas.drawCircle(Offset(px[i], py[i]), 30, paint);
      TextSpan span = new TextSpan(style: new TextStyle(color: Colors.black), text: i.toString());
      TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, new Offset(px[i], py[i]));

    }
    paint.color = Colors.black;
    for(int i=0;i<edge1.length;i++){
      Path path;
      Paint paint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = 3.0;
      path = Path();
      path.moveTo(px[edge1[i]], py[edge1[i]]);
      double mid1=(px[edge2[i]]+px[edge1[i]])/2;
      double mid2=(py[edge2[i]]+py[edge1[i]])/2;
      //Code for a previous conection between two nodes
      bool result = false;
      for(int j=0;j<i;j++){
        //Check for invert edge
        if(edge1[j]==edge2[i] && edge1[i]==edge2[j]){
          result = true;
        }
      }
      double dx=(px[edge2[i]]-px[edge1[i]]).abs();
      double dy=(py[edge2[i]]-py[edge1[i]]).abs();
      if(result){
        if(dx>=dy) {
          path.quadraticBezierTo(mid1, mid2 - 50, px[edge2[i]], py[edge2[i]]);
        }
        else{
          path.quadraticBezierTo(mid1-50, mid2, px[edge2[i]], py[edge2[i]]);
        }
      }
      else{
        if(dx>=dy){
          path.quadraticBezierTo(mid1,mid2+50,px[edge2[i]],py[edge2[i]]);
        }
        else{
          path.quadraticBezierTo(mid1+50,mid2,px[edge2[i]],py[edge2[i]]);
        }

      }

      //path.relativeCubicTo(0, 0, );
      path = ArrowPath.make(path: path);
      canvas.drawPath(path, paint..color = Colors.blue);
      //canvas.drawLine(Offset(px[edge1[i]], py[edge1[i]]), Offset(px[edge2[i]],py[edge2[i]]), paint);
    }

    /*
    paint.color=Colors.black;
    for(int i=0;i<px.length;i++){
      for(int j=0;j<px.length;j++){
        canvas.drawLine(Offset(px[i], py[i]), Offset(px[j],py[j]), paint);
      }
    }
    */

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}

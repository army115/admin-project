import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';

class NextPAge extends StatefulWidget {
  @override
  _NextPAgeState createState() => _NextPAgeState();
}

class _NextPAgeState extends State<NextPAge> {

  ScrollController _controller = ScrollController();

  final itemExtent = 100.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: DraggableScrollbar.semicircle(
            child: ListView.builder(
                itemCount: 100,
                controller: _controller,
                itemExtent: itemExtent,
                itemBuilder: (context,index){
                  return Container(
                    child: ListTile(
                      title: Text(index.toString()),
                      subtitle: Text('More...............'),
                    ),
                  );
                },
            ),
            controller: _controller,
          backgroundColor: Colors.lightGreenAccent,
          labelConstraints: BoxConstraints.tightFor(width: 80,height: 40),
          // labelTextBuilder: (double offset)=> Text('${offset ~/ itemExtent}'),
          alwaysVisibleScrollThumb: true,
          heightScrollThumb: 48.0,
        ),
      ),
    );
  }
}
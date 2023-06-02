import 'package:flutter/material.dart';
import 'dart:math';
import 'AStar.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

class TestGrid extends StatefulWidget {
  @override
  State<TestGrid> createState() {
    return GridLayoutTest();
  }
}

int N_ROW = 10, N_COL = 10;

class GridLayoutTest extends State<TestGrid> {
  int nTotalCount = N_ROW * N_COL;
  List<Vector2> path = [];
  // 0 libero, 1 muro
  List<List<int>> mat = List.generate(N_ROW, (a) => List.generate(N_COL, (a) => Random().nextInt(1)));
  int operation_type=0;
  Vector2 start = Vector2(0,0), finish = Vector2(0,0);
  bool insertStart=false, insertFinish=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("PathFinding")),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Container(
                  color: Colors.blue,
                  padding: EdgeInsets.all(20),
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return GridView.builder(
                      itemCount: nTotalCount,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: N_COL,
                        childAspectRatio:
                        constraints.maxWidth / constraints.maxHeight,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        Color colorCell;

                        if (mat[(index / N_COL).toInt()][index % N_COL] == 0) {
                          colorCell = Colors.green;
                        }
                        else if (mat[(index / N_COL).toInt()][index % N_COL] == 1) {
                          colorCell = Colors.black;
                        }
                        else if (mat[(index / N_COL).toInt()][index % N_COL] == 2){
                          colorCell = Colors.amber;
                        }
                        else if (mat[(index / N_COL).toInt()][index % N_COL] == 3){
                          colorCell = Colors.cyanAccent;
                        }
                        else if(mat[(index / N_COL).toInt()][index % N_COL] == 4){
                          colorCell = Colors.red;
                        }
                        else
                        {
                          colorCell = Colors.black;
                        }


                        return Center(
                          child: Padding(
                              padding: EdgeInsets.all(1),
                              child: Container(
                                //margin: EdgeInsets.all(5),
                                  color: colorCell,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        for(int i = 0; i < path.length-1; i++)
                                        {
                                          mat[path[i].y.toInt()][path[i].x.toInt()] = 0;
                                        }

                                        // Muro
                                        if(operation_type == 0) {
                                          if (mat[(index / N_COL).toInt()][index % N_COL] == 0) {
                                            mat[(index / N_COL).toInt()][index % N_COL] = 1;
                                          }
                                          else {
                                            mat[(index / N_COL).toInt()][index % N_COL] = 0;
                                          }
                                        }
                                        // Start
                                        else if(operation_type == 1)
                                        {
                                          if(insertStart) {
                                            mat[start.y.toInt()][start.x.toInt()] = 0;
                                          }
                                          start = Vector2((index % N_COL).toDouble(), index / N_COL);
                                          mat[(index / N_COL).toInt()][index % N_COL] = 2;
                                          insertStart = true;
                                        }
                                        // Finish
                                        else if(operation_type == 2)
                                        {
                                          if(insertFinish) {
                                            mat[finish.y.toInt()][finish.x.toInt()] = 0;
                                          }
                                          finish = Vector2((index % N_COL).toDouble(), index / N_COL);
                                          mat[(index / N_COL).toInt()][index % N_COL] = 3;
                                          insertFinish = true;
                                        }
                                      });

                                    },
                                  ))),
                        );
                      },
                      physics: AlwaysScrollableScrollPhysics(),
                    );
                  })),
            ),
            Expanded(
                child: Container(
                    color: Colors.grey,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            child: Text("Insert/remove wall"),
                            onPressed: (){
                              setState(() {
                                operation_type = 0;
                              });
                            },

                          ),
                          ElevatedButton(
                            child: Text("Insert start"),
                            onPressed: (){
                              setState(() {
                                operation_type = 1;
                              });
                            },

                          ),
                          ElevatedButton(
                            child: Text("Insert end"),
                            onPressed: (){
                              setState(() {
                                operation_type = 2;
                              });
                            },

                          ),
                          ElevatedButton(
                              child: Text('Find path'),
                              onPressed: (){
                                setState((){
                                  AStar A = AStar();

                                  path = A.aStar(mat, start.y.toInt(), start.x.toInt(), finish.y.toInt(), finish.x.toInt(), N_ROW, N_COL);

                                  for(int i = 0; i < path.length -1; i++)
                                  {
                                      mat[path[i].y.toInt()][path[i].x.toInt()] = 4;
                                  }

                                });
                              }
                          ),
                        ]
                    )
                ))
          , TextField(
              onChanged: (String a){
                try {
                  int row = int.parse(a);
                  setState((){
                    if(row <= 0)
                      {
                        row = 1;
                      }
                    else if(row > 100)
                      {
                        row = 100;
                      }
                    N_ROW = row;
                    nTotalCount = N_ROW * N_COL;
                    mat = List.generate(N_ROW, (a) => List.generate(N_COL, (a) => Random().nextInt(1)));
                  });
                }
                catch(e)
                {
                  print('$e');
                }
              },
                decoration: InputDecoration(labelText: "Row(Max 100)"),
                keyboardType: TextInputType.number),
            TextField(
                onChanged: (String a){
                  try {
                    int col = int.parse(a);
                    setState((){
                      if(col <= 0)
                      {
                        col = 1;
                      }
                      else if(col > 100)
                      {
                        col = 100;
                      }
                      N_COL = col;
                      nTotalCount = N_ROW * N_COL;
                      mat = List.generate(N_ROW, (a) => List.generate(N_COL, (a) => Random().nextInt(1)));
                    });
                  }
                  catch(e)
                  {
                    print('$e');
                  }
                },
                decoration: InputDecoration(labelText: "Column(Max 100)"),
                keyboardType: TextInputType.number)
            ],
        ));
  }
}

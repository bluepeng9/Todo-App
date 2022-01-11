import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled/data/database.dart';

import 'data/todo.dart';

class TodoWritePage extends StatefulWidget {
  final Todo todo;

  TodoWritePage({Key? key, required this.todo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TodoWritePageState();
  }
}

class _TodoWritePageState extends State<TodoWritePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController memoController = TextEditingController();
  final dbhelper = DataBaseHelper.instance;
  int colorIndex = 0;
  int ctIndex = 0;

  @override
  void initState(){
    super.initState();
    nameController.text = widget.todo.title.toString();
    memoController.text = widget.todo.memo.toString();
  }

  @override
  Widget getMain(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () async {
                  widget.todo.title = nameController.text;
                  widget.todo.memo = memoController.text;
                  await dbhelper.insertTodo(widget.todo);

                  Navigator.of(context).pop(widget.todo);
                },
                child: Text(
                  "저장",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: ListView.builder(
            itemCount: 6,
            itemBuilder: (ctx, index) {
              if (index == 0) {
                return Container(
                    child: Text(
                      "제목",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ));
              } else if (index == 1) {
                return Container(
                  child: TextField(
                    controller: nameController,
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                );
              } else if (index == 2) {
                return InkWell(
                  child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "색상",
                            style: TextStyle(fontSize: 20),
                          ),
                          Container(
                            width: 20,
                            height: 20,
                            color: Color(widget.todo.color),
                          )
                        ],
                      ),
                      margin: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      )),
                  onTap: () {
                    List<Color> colors = [
                      Color(0xFF80d3f4),
                      Color(0xFFa794fa),
                      Color(0xFFfb91d1),
                      Color(0xFFfb8a94),
                      Color(0xFFfebd9a),
                      Color(0xFF51e29d),
                      Color(0xFFFFFFFF),
                    ];
                    widget.todo.color = colors[colorIndex].value;
                    colorIndex++;

                    setState(() {
                      colorIndex = colorIndex % colors.length;
                    });
                  },
                );
              } else if (index == 3) {
                return InkWell(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "카테고리",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(widget.todo.category.toString()),
                      ],
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                  ),
                  onTap: () {
                    List<String> category = ["공부", "운동", "게임"];
                    widget.todo.category = category[ctIndex];
                    ctIndex++;
                    setState(() {
                      ctIndex = ctIndex % category.length;
                    });
                  },
                );
              } else if (index == 4) {
                return Container(
                  child: Text(
                    "메모",
                    style: TextStyle(fontSize: 20),
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                );
              } else if (index == 5) {
                return Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 1,
                      horizontal: 10,
                    ),
                    child: TextField(
                        controller: memoController,
                        minLines: 10,
                        maxLines: 10,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                        )));
              }
              return Container();
            }));
  }
}

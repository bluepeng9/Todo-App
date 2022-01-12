import 'package:flutter/material.dart';
import 'package:untitled/data/database.dart';
import 'package:untitled/write.dart';

import 'data/todo.dart';
import 'data/util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int selectIndex = 0;

  final dbHelper = DataBaseHelper.instance;

  List<Todo> todos = [
    //   Todo(
    //     title: "패캠강의듣기1",
    //     memo: "앱입문 듣기",
    //     color: Colors.redAccent.value,
    //     done: 0,
    //     category: "공부",
    //     date: 20210709,
    //   ),
    //   Todo(
    //     title: "패캠강의듣기2",
    //     memo: "앱입문 듣기",
    //     color: Colors.blue.value,
    //     done: 1,
    //     category: "공부",
    //     date: 20210709,
    //   )
  ];

  void getTodayTodo() async {
    todos = await dbHelper.getTodoByDate(Utils.getFormatTime(DateTime.now()));
    setState(() {});
  }

  void getAllTodo() async {
    allTodo = await dbHelper.getAllTodo();
    setState(() {});
  }

  @override
  void initState() {
    getTodayTodo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          // title: Text(widget.title),
          title: Text(widget.title),
        ),
        preferredSize: Size.fromHeight(0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Todo todo = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TodoWritePage(
                  todo: Todo(
                      title: "",
                      color: 0,
                      memo: "",
                      done: 0,
                      category: "",
                      date: Utils.getFormatTime(DateTime.now())))));
          getTodayTodo();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      body: getPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.today_outlined), label: "오늘"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "기록"),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "더보기")
        ],
        currentIndex: selectIndex,
        onTap: (idx) {
          if (idx == 1) {
            getAllTodo();
          }
          setState(() {
            selectIndex = idx;
          });
        },
      ),
    );
  }

  Widget getPage() {
    if (selectIndex == 0) {
      return getMain();
    } else {
      return getHistory();
    }
  }

  List<Todo> allTodo = [];

  Widget getMain() {
    return ListView.builder(
        itemCount: 4,
        itemBuilder: (ctx, idx) {
          if (idx == 0) {
            return Container(
              child: Text(
                "오늘 하루",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            );
          } else if (idx == 1) {
            List<Todo> undone = todos.where((t) {
              return t.done == 0;
            }).toList();
            return Container(
                child: Column(
                    children: List.generate(undone.length, (_index) {
              Todo t = undone[_index];

              return InkWell(
                child: TodoCardWidget(t: t),
                onLongPress: () async {
                  getTodayTodo();
                },
                onTap: () async {
                  setState(() {
                    if (t.done == 0) {
                      t.done = 1;
                    } else {
                      t.done = 0;
                    }
                  });
                  await dbHelper.insertTodo(t);
                },
              );
            })));
          } else if (idx == 2) {
            return Container(
              child: Text(
                "완료된 할 일",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            );
          } else if (idx == 3) {
            List<Todo> done =
                todos.where((element) => element.done == 1).toList();

            return Container(
                child: Column(
              children: List.generate(done.length, (_index) {
                Todo t = done[_index];
                return InkWell(
                  child: TodoCardWidget(t: t),
                  onLongPress: () async {
                    Todo todo = await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => TodoWritePage(todo: t)));
                    setState(() {});
                  },
                  onTap: () async {
                    setState(() {
                      if (t.done == 0) {
                        t.done = 1;
                      } else {
                        t.done = 0;
                      }
                    });
                    await dbHelper.insertTodo(t);
                  },
                );
              }),
            ));
          }
          return Container();
        });
  }

  Widget getHistory() {
    return ListView.builder(
      itemCount: allTodo.length,
      itemBuilder: (context, index) {
        return TodoCardWidget(t: allTodo[index]);
      },
    );
  }
}

class TodoCardWidget extends StatelessWidget {
  final Todo t;

  TodoCardWidget({Key? key, required this.t}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int now = Utils.getFormatTime(DateTime.now());
    DateTime time = Utils.numToDateTime(t.date);

    return Container(
        decoration: BoxDecoration(
          color: Color(t.color),
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.title.toString(),
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  t.done == 0 ? "미완료" : "완료",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            Container(
              height: 8,
            ),
            Text(t.memo),
            Text(
              now == t.date ? "" : "${time.month}월 ${time.day}일",
              style: TextStyle(color: Colors.white),
            )
          ],
        ));
  }
}

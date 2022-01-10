import 'package:flutter/material.dart';
import 'package:untitled/data/database.dart';
import 'package:untitled/write.dart';

import 'data/todo.dart';
import 'data/util.dart';

void main() {
  double bmi = 27.1;
  if (bmi > 30) {
    print("비만");
  } else if (bmi > 25) {
    print("ㅇㅇdd");
  } else {
    print("아");
  }
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _idx = 0;

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

  @override
  void initState() {
    getTodayTodo();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
      body: ListView.builder(
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
                      String done = "";
                      if (t.done == 0) {
                        done == "미완료";
                      }
                      return InkWell(
                        child: TodoCardWidget(t: t),
                        onLongPress: () async {
                          getTodayTodo();
                        },
                        onTap: () {
                          setState(() {
                            if (t.done == 0) {
                              t.done = 1;
                            } else {
                              t.done = 0;
                            }
                          });
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
                      onTap: () {
                        setState(() {
                          if (t.done == 0) {
                            t.done = 1;
                          } else {
                            t.done = 0;
                          }
                        });
                      },
                    );
                  }),
                ));
          }
          return Container();
        },

        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print("");
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.today_outlined), label: "오늘"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "기록"),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "더보기")
        ],
        onTap: (index) {
          setState(() {
            _idx = index;
          });
        },
        currentIndex: _idx,
      ),
    );
  }
}

class TodoCardWidget extends StatelessWidget {
  final Todo t;

  TodoCardWidget({Key? key, required this.t}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            Text(t.memo.toString()),
          ],
        ));
  }
}


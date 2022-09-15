import 'package:flutter/material.dart';
import 'FirstScreen.dart';
import 'SecondScreen.dart';
import 'ThirdScreen.dart';
import 'FourthScreen.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _exactlyPageNum = 0;
  PageController pageControll;

  @override
  void initState() {
    super.initState();
    pageControll = PageController();
  }

  @override
  void dispose() {
    pageControll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (pageNo) {
          setState(() {
            _exactlyPageNum = pageNo;
          });
        },
        controller: pageControll,
        children: <Widget>[
          FirstScreen(),
          SecondScreen(),
          ThirdScreen(),
          FourthScreen(),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _exactlyPageNum,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey[350],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home Page'),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Food'),
          BottomNavigationBarItem(icon: Icon(Icons.date_range_rounded), label: 'Graphs'),
          BottomNavigationBarItem(icon: Icon(Icons.wysiwyg_rounded ), label: 'Articles'),

        ],
        onTap: (currentPageNumber) {
          setState(() {
            pageControll.jumpToPage(currentPageNumber);
          });
        },
      ),
    );
  }
}
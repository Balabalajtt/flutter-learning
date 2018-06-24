import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome to Flutter',
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: new RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {

  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("选个单词"),
        actions: <Widget>[
          new IconButton(
              icon: const Icon(Icons.list),
              onPressed: _pushSaved//点击切换路由
          ),
        ],
      ),
      body: _buildSuggestions(),//body是一个ListView
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext _context, int i) {
          //如果这个是奇数个就返回一个分界线
          if (i.isOdd) {
            return new Divider();
          }
          final int index = i ~/ 2;//i ~/ 2 表示 i 除以 2 ，向下取整，计算出这是第几个单词
          //如果单词不够，就添加十个单词
          if (index + 10 >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);//调用方法，返回ListTile
        }
    );
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);//判断这个单词是否选哪种
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      //显示不同的图标样式
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved? Colors.red : null,
      ),
      //ListTile的点击事件
      onTap: () {
        //调用setState()通知状态已经改变，需要重新调用build()
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      //将新的页面push到导航器的栈中
      new MaterialPageRoute<void>(
          builder: (BuildContext context) {

            //获取一个ListTile的列表
            final Iterable<ListTile> tiles = _saved.map(
                (WordPair pair) {
                  return new ListTile(
                    title: new Text(
                      pair.asPascalCase,
                      style: _biggerFont,
                    ),
                  );
                },
            );

            //divideTiles()会在每个ListTile之间加亿像素分割线
            final List<Widget> divided = ListTile.divideTiles(
              context: context,
              tiles: tiles,
            ).toList();//转换成列表显示

            return new Scaffold(
              appBar: new AppBar(
                title: const Text('选中的单词'),
              ),
              body: new ListView(children: divided),
            );
          },
      ),
    );
  }
}
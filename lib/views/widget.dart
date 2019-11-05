// BottomNavigationBar 默认的实例
import 'package:flutter/material.dart';

class BottomNavigationBarFullDefault extends StatefulWidget {
  const BottomNavigationBarFullDefault() : super();

  @override
  State<StatefulWidget> createState() => _BottomNavigationBarFullDefault();
}

// BottomNavigationBar 默认的实例,有状态
class _BottomNavigationBarFullDefault extends State {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    if (mounted) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      // BottomNavigationBarType 中定义的类型，有 fixed 和 shifting 两种类型
      iconSize: 24.0,
      // BottomNavigationBarItem 中 icon 的大小
      currentIndex: _currentIndex,
      // 当前所高亮的按钮index
      onTap: _onItemTapped,
      // 点击里面的按钮的回调函数，参数为当前点击的按钮 index
      fixedColor: Colors.deepPurple,
      // 如果 type 类型为 fixed，则通过 fixedColor 设置选中 item 的颜色
      selectedFontSize: 12.0,
      unselectedFontSize: 12.0,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(title: Text("贴图"), icon: Icon(Icons.home)),
        BottomNavigationBarItem(title: Text("文字"), icon: Icon(Icons.list)),
        BottomNavigationBarItem(title: Text("涂鸦"), icon: Icon(Icons.message)),
        BottomNavigationBarItem(title: Text("裁剪"), icon: Icon(Icons.add)),
      ],
    );
  }
}

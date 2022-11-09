import 'package:flutter/material.dart';
import 'package:seven_learn_nick/ui/home/home.dart';

const int homeIndex = 0;
const int cartIndex = 1;
const int profileIndex = 2;

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int selectedScreeniIndex = homeIndex;
  final List<int> _history = [];

  GlobalKey<NavigatorState> _homeKey = GlobalKey();
  GlobalKey<NavigatorState> _cartKey = GlobalKey();
  GlobalKey<NavigatorState> _profileKey = GlobalKey();

  late final map = {
    homeIndex: _homeKey,
    cartIndex: _cartKey,
    profileIndex: _profileKey
  };

  Future<bool> _onWillPOp() async {
    final NavigatorState currentSelectedTabNavigatorState =
        map[selectedScreeniIndex]!.currentState!;
    if (currentSelectedTabNavigatorState.canPop()) {
      currentSelectedTabNavigatorState.pop();
      return false;
    } else if (_history.isNotEmpty) {
      setState(() {
        selectedScreeniIndex = _history.last;
        _history.removeLast();
      });
      return true;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPOp,
      child: Scaffold(
        body: const HomeScreen(),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (selectIndex){
            this.selectedScreeniIndex = selectIndex;
          },
          currentIndex: selectedScreeniIndex,
          items: [],

        ),
      ),
    );
  }
}

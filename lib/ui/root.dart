import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seven_learn_nick/data/repo/auth_reposityory.dart';
import 'package:seven_learn_nick/data/repo/cart_repository.dart';
import 'package:seven_learn_nick/ui/cart/cart.dart';
import 'package:seven_learn_nick/ui/home/home.dart';
import 'package:seven_learn_nick/ui/widget/badge.dart';

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

  @override
  void initState() {
    super.initState();
    cartRepository.count();
  }

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
        body: IndexedStack(
          index: selectedScreeniIndex,
          children: [
            _navigator(_homeKey, homeIndex, const HomeScreen()),
            _navigator(_cartKey, cartIndex, const CartScreen()),
            _navigator(
                _profileKey,
                profileIndex,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Profile'),
                    ElevatedButton(
                        onPressed: () {
                          CartRepository.cartItemCountNotifier.value = 0;
                          authRepository.signOut();
                        },
                        child: const Text('Sign Out')),
                  ],
                )),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (selectIndex) {
            setState(() {
              _history.remove(selectedScreeniIndex);
              _history.add(selectedScreeniIndex);
              selectedScreeniIndex = selectIndex;
            });
          },
          currentIndex: selectedScreeniIndex,
          items: [
            const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home), label: 'خانه'),
            BottomNavigationBarItem(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(CupertinoIcons.cart),
                    Positioned(
                      right: -10,
                      child: ValueListenableBuilder<int>(
                        valueListenable: CartRepository.cartItemCountNotifier,
                        builder: (BuildContext context, value, Widget? child) {
                          return Badge(value: value);
                        },
                      ),
                    ),
                  ],
                ),
                label: 'سبد خرید'),
            const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person), label: 'پروفایل'),
          ],
        ),
      ),
    );
  }

  Widget _navigator(GlobalKey key, int index, Widget child) {
    return key.currentState == null && selectedScreeniIndex != index
        ? const SizedBox()
        : Navigator(
            key: key,
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => Offstage(
                offstage: selectedScreeniIndex != index,
                child: child,
              ),
            ),
          );
  }
}

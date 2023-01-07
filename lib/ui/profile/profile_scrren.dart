import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seven_learn_nick/data/auth_info.dart';
import 'package:seven_learn_nick/data/repo/auth_reposityory.dart';
import 'package:seven_learn_nick/data/repo/cart_repository.dart';
import 'package:seven_learn_nick/ui/auth/auth.dart';
import 'package:seven_learn_nick/ui/favorites/favorite_screen.dart';
import 'package:seven_learn_nick/ui/order/order_history_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('پروفایل'),
        ),
      ),
      body: ValueListenableBuilder<AuthInfo?>(
        valueListenable: AuthRepository.authChangeNotifier,
        builder: (context, authinfo, child) {
          final isLogin = authinfo != null && authinfo.accessToken.isNotEmpty;
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    height: 65,
                    width: 65,
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.only(top: 32.0, bottom: 8.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                    child: Image.asset('assets/img/nike_logo.png')),
                Text(isLogin ? authinfo!.email : 'کاربر میهمان'),
                const SizedBox(
                  height: 32.0,
                ),
                const Divider(
                  height: 1,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const FavoriteListScreen()));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 56,
                    child: Row(
                      children: const [
                        Icon(CupertinoIcons.heart),
                        SizedBox(
                          width: 16,
                        ),
                        Text('لیست علاقه مندی ها'),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const OrderHistoryScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 56,
                    child: Row(
                      children: const [
                        Icon(CupertinoIcons.cart),
                        SizedBox(
                          width: 16,
                        ),
                        Text('سوابق سفارش'),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                InkWell(
                  onTap: () async {
                    if (isLogin) {
                      showDialog(
                        context: context,
                        useRootNavigator: false,
                        builder: (context) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: AlertDialog(
                              title: const Text('خروج از حساب کاربری'),
                              content: const Text(
                                  ' آیا میخواهید از حساب خود خارج شوید ؟'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    CartRepository.cartItemCountNotifier.value =
                                        0;
                                    authRepository.signOut();
                                  },
                                  child: const Text('بله'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('خیر'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => const AuthScreen(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 56,
                    child: Row(
                      children: [
                        Icon(
                          isLogin
                              ? CupertinoIcons.arrowtriangle_right_square
                              : CupertinoIcons.arrowtriangle_left_square,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Text(isLogin
                            ? 'خروج به حساب کاربری'
                            : 'ورود به حساب کاربری'),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

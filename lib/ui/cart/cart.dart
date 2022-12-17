import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:seven_learn_nick/data/repo/auth_reposityory.dart';
import 'package:seven_learn_nick/data/repo/cart_repository.dart';
import 'package:seven_learn_nick/ui/auth/auth.dart';
import 'package:seven_learn_nick/ui/cart/bloc/cart_bloc.dart';
import 'package:seven_learn_nick/ui/cart/cart_item.dart';
import 'package:seven_learn_nick/ui/cart/price_info.dart';
import 'package:seven_learn_nick/ui/widget/empty_state.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc? cartBloc;
  StreamSubscription? stateStreamSubscription;
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    AuthRepository.authChangeNotifier.addListener(authChangeNotifierListener);
  }

  void authChangeNotifierListener() => cartBloc!
      .add(CartAuthInfoChanged(AuthRepository.authChangeNotifier.value));

  @override
  void dispose() {
    AuthRepository.authChangeNotifier
        .removeListener(authChangeNotifierListener);
    cartBloc!.close();
    stateStreamSubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('سبد خرید'),
        ),
        body: BlocProvider(
          create: (context) {
            final bloc = CartBloc(cartRepository);
            stateStreamSubscription = bloc.stream.listen((state) {
              if (_refreshController.isRefresh) {
                if (state is CartSuccess) {
                  _refreshController.refreshCompleted();
                } else if (state is CartError) {
                  _refreshController.refreshFailed();
                }
              }
            });
            cartBloc = bloc;
            bloc.add(CartStarted(AuthRepository.authChangeNotifier.value));
            return bloc;
          },
          child: BlocBuilder<CartBloc, CartState>(
            builder: (BuildContext context, state) {
              if (state is CartLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is CartError) {
                return Center(
                  child: Text(state.exception.message),
                );
              } else if (state is CartSuccess) {
                return SmartRefresher(
                  controller: _refreshController,
                  header: const ClassicHeader(
                    completeText: 'باموفقیت انجام شد',
                    refreshingText: 'در حال به روزرسانی',
                    idleText: 'برای به روزسانی پایین بکشید',
                    releaseText: 'رها کنید',
                    failedText: 'خطای نامشخص',
                    spacing: 2,
                    completeIcon: Icon(
                      CupertinoIcons.checkmark_circle,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                  onRefresh: () {
                    cartBloc?.add(CartStarted(
                        AuthRepository.authChangeNotifier.value,
                        isRefreshing: true));
                  },
                  child: ListView.builder(
                      itemCount: state.cartResponse.cartItems.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < state.cartResponse.cartItems.length) {
                          final data = state.cartResponse.cartItems[index];
                          return CartItem(
                            data: data,
                            onDeleteButtonClick: () {
                              cartBloc!.add(CartDeleteButtonClicked(data.id));
                            },
                          );
                        } else {
                          return PriceInfo(
                            payablePrice: state.cartResponse.payablePrice,
                            totalPrice: state.cartResponse.totalPrice,
                            shippingCost: state.cartResponse.shippingCost,
                          );
                        }
                      }),
                );
              } else if (state is CartAuthRequired) {
                return EmotyView(
                    message:
                        'برای مشاهده ی سبد خرید ابتدا وارد حساب کاربری خود شوید',
                    callToAction: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const AuthScreen()));
                        },
                        child: const Text('ورود به حساب کاربری')),
                    image: SvgPicture.asset(
                      'assets/img/auth_required.svg',
                      width: 120,
                    ));
              } else if (state is CartEmpty) {
                return EmotyView(
                    message:
                        'تاکنون هیچ محصولی به سبد خرید خود اضافه نکرده اید',
                    image: SvgPicture.asset(
                      'assets/img/empty_cart.svg',
                      width: 200,
                    ));
              } else {
                throw Exception('Current Cart State Is Not Valid');
              }
            },
          ),
        )
        // ValueListenableBuilder<AuthInfo?>(
        //   valueListenable: AuthRepository.authChangeNotifier,
        //   builder: (context, authState, child) {
        //     bool isAuthenticated =
        //         authState != null && authState.accessToken.isNotEmpty;
        //     return SizedBox(
        //       width: double.maxFinite,
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         children: [
        //           Text(isAuthenticated
        //               ? 'خوش آمدید'
        //               : 'لطفا وارد حساب کاربری خود شوید'),
        //           isAuthenticated
        //               ? ElevatedButton(
        //                   onPressed: () {
        //                     authRepository.signOut();
        //                   },
        //                   child: const Text('خروج از حساب'),
        //                 )
        //               : ElevatedButton(
        //                   onPressed: () {
        //                     Navigator.of(context, rootNavigator: true).push(
        //                         MaterialPageRoute(
        //                             builder: (context) => const AuthScreen()));
        //                   },
        //                   child: const Text('ورود'),
        //                 ),
        //           ElevatedButton(
        //             onPressed: () async {
        //               await authRepository.refreshToken();
        //             },
        //             child: const Text('Refresh Token'),
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // ),
        );
  }
}

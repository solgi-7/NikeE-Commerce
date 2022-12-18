import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:seven_learn_nick/common/exceptions.dart';
import 'package:seven_learn_nick/data/auth_info.dart';
import 'package:seven_learn_nick/data/repo/cart_repository.dart';
import 'package:seven_learn_nick/data/source/cart_response.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ICartRepository cartRepository;
  CartBloc(this.cartRepository) : super(CartLoading()) {
    on<CartEvent>(
      (event, emit) async {
        if (event is CartStarted) {
          final authInfo = event.authInfo;
          if (authInfo == null || authInfo.accessToken.isEmpty) {
            emit(CartAuthRequired());
          } else {
            try {
              if (!event.isRefreshing) {
                emit(CartLoading());
              }
              await Future.delayed(const Duration(seconds: 2));
              final result = await cartRepository.getAll();
              if (result.cartItems.isEmpty) {
                emit(CartEmpty());
              } else {
                emit(CartSuccess(result));
              }
            } catch (e) {
              emit(CartError(AppException()));
            }
          }
        } else if (event is CartDeleteButtonClicked) {
          try {
            if (state is CartSuccess) {
              final successState = (state as CartSuccess);
              final index = successState.cartResponse.cartItems
                  .indexWhere((element) => element.id == event.cartItemId);
              successState.cartResponse.cartItems[index].deleteButtonLoading =
                  true;
              emit(CartSuccess(successState.cartResponse));
            }
            await Future.delayed(const Duration(seconds: 2));
            await cartRepository.delete(event.cartItemId);
            await cartRepository.count();

            if (state is CartSuccess) {
              final successState = (state as CartSuccess);
              successState.cartResponse.cartItems
                  .removeWhere((element) => element.id == event.cartItemId);
              if (successState.cartResponse.cartItems.isEmpty) {
                emit(CartEmpty());
              } else {
                emit(calculatePriceInfo(successState.cartResponse));
              }
            }
          } catch (e) {
            debugPrint(e.toString());
          }
        } else if (event is CartAuthInfoChanged) {
          if (event.authInfo == null || event.authInfo!.accessToken.isEmpty) {
            emit(CartAuthRequired());
          } else {
            if (state is CartAuthRequired) {
              try {
                final result = await cartRepository.getAll();
                if (result.cartItems.isEmpty) {
                  emit(CartEmpty());
                } else {
                  emit(CartSuccess(result));
                }
              } catch (e) {
                emit(CartError(AppException()));
              }
            }
          }
        } else if (event is CartIncreaseCountButtonClicked ||
            event is CartDecreaseCountButtonClicked) {
          try {
            int cartItemId = 0;
            if (event is CartIncreaseCountButtonClicked) {
              cartItemId = event.cartItemId;
            } else if (event is CartDecreaseCountButtonClicked) {
              cartItemId = event.cartItemId;
            }
            if (state is CartSuccess) {
              final successState = (state as CartSuccess);
              final index = successState.cartResponse.cartItems
                  .indexWhere((element) => element.id == cartItemId);
              successState.cartResponse.cartItems[index].changeCountLoading =
                  true;
              emit(CartSuccess(successState.cartResponse));

              await Future.delayed(const Duration(seconds: 2));
              final newCount = event is CartIncreaseCountButtonClicked
                  ? ++successState.cartResponse.cartItems[index].count
                  : --successState.cartResponse.cartItems[index].count;
              await cartRepository.changeCount(cartItemId, newCount);
              await cartRepository.count();

              successState.cartResponse.cartItems
                  .firstWhere((element) => element.id == cartItemId)
                  ..count = newCount..changeCountLoading = false;

              emit(calculatePriceInfo(successState.cartResponse));
            }
          } catch (e) {
            debugPrint(e.toString());
          }
        }
      },
    );
  }
  CartSuccess calculatePriceInfo(CartResponse cartResponse) {
    int totalPrice = 0;
    int payablePrice = 0;
    int shippingCost = 0;

    cartResponse.cartItems.forEach((cartItem) {
      totalPrice += cartItem.product.priviousPrice * cartItem.count;
      payablePrice += cartItem.product.price * cartItem.count;
    });

    shippingCost = payablePrice >= 250000 ? 0 : 30000;
    cartResponse.totalPrice = totalPrice;
    cartResponse.payablePrice = payablePrice;
    cartResponse.shippingCost = shippingCost;

    return CartSuccess(cartResponse);
  }

  // Future<void> loadCartItems(emit) async {
  //   try {
  //     emit(CartLoading());
  //     final result = await cartRepository.getAll();
  //     if (result.cartItems.isEmpty) {
  //       emit(CartEmpty());
  //     } else {
  //       emit(CartSuccess(result));
  //     }
  //   } catch (e) {
  //     emit(CartError(AppException()));
  //   }
  // }

}

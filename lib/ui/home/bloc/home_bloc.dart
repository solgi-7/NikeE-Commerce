import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seven_learn_nick/common/exceptions.dart';
import 'package:seven_learn_nick/data/banner_entity.dart';
import 'package:seven_learn_nick/data/product_entity.dart';
import 'package:seven_learn_nick/data/repo/banner_repository.dart';
import 'package:seven_learn_nick/data/repo/product_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IProductRepository productRepository;
  final IBannerRepository bannerRepository;
  HomeBloc({required this.bannerRepository, required this.productRepository})
      : super(HomeLoading()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeStarted || event is HomeRefresh) {
        try {
          emit(HomeLoading());
          final banners = await bannerRepository.getAll();
          final latestProducts =
              await productRepository.getAll(ProductSort.latest);
          final popularProducts =
              await productRepository.getAll(ProductSort.popular);
          emit(
            HomeSuccess(
              banners: banners,
              latestProducts: latestProducts,
              popularProducts: popularProducts,
            ),
          );
        } catch (e) {
          emit(HomeError(exception: e is AppException ? e : AppException()));
        }
      }
    });
  }
}

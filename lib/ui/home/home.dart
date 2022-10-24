import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seven_learn_nick/data/banner_entity.dart';
import 'package:seven_learn_nick/data/repo/banner_repository.dart';
import 'package:seven_learn_nick/data/repo/product_repository.dart';
import 'package:seven_learn_nick/ui/widget/image.dart';
import 'package:seven_learn_nick/ui/widget/slider.dart';

import 'bloc/home_bloc.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  Size? size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    double height = size!.height;
    double width = size!.width;
    return BlocProvider(
      create: (context) {
        final homeBloc = HomeBloc(
          bannerRepository: banerRepository,
          productRepository: productRepository,
        );
        homeBloc.add(HomeStarted());
        return homeBloc;
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeSuccess) {
                return ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    switch (index) {
                      case 0:
                        return Container(
                          height: 56,
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/nike_logo.png',
                            height: 32,
                            fit: BoxFit.fitHeight,
                          ),
                        );
                      case 1:
                        return BannerSlider(
                          banners: state.banners,
                        );
                      default:
                        return Container(
                          color: Colors.blue,
                        );
                    }
                  },
                );
              } else if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is HomeError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(state.exception.message),
                      ElevatedButton.icon(
                          onPressed: () {
                            BlocProvider.of<HomeBloc>(context)
                                .add(HomeRefresh());
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('تلاش دوباره'))
                    ],
                  ),
                );
              } else {
                throw Exception('State is not supported');
              }
            },
          ),
        ),
      ),
    );
  }
}

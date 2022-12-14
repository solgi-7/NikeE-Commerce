import 'package:seven_learn_nick/data/repo/product_repository.dart';
import 'package:seven_learn_nick/data/repo/banner_repository.dart';
import 'package:seven_learn_nick/data/product_entity.dart';
import 'package:seven_learn_nick/ui/list/list.dart';
import 'package:seven_learn_nick/ui/product/product.dart';
import 'package:seven_learn_nick/ui/widget/error.dart';
import 'package:seven_learn_nick/ui/widget/slider.dart';
import 'package:seven_learn_nick/common/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'bloc/home_bloc.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                  physics: defualtScrollPhysics,
                  itemBuilder: (BuildContext context, int index) {
                    switch (index) {
                      case 0:
                        return Column(
                          children: [
                            Container(
                              height: 56,
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/img/nike_logo.png',
                                height: 32,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  right: 12, left: 12, bottom: 12),
                              height: 56,
                              child: TextField(
                                controller: _searchController,
                                onSubmitted: (value) => _search(context),
                                decoration: InputDecoration(
                                  label: const Text('??????????'),
                                  isCollapsed: false,
                                  prefixIcon: IconButton(
                                    onPressed: () => _search(context),
                                    icon: const Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(CupertinoIcons.search),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28),
                                    borderSide: BorderSide(color: Theme.of(context).dividerColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28),
                                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary,),),
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                ),
                                textInputAction: TextInputAction.search,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            )
                          ],
                        );
                      case 2:
                        return BannerSlider(
                          banners: state.banners,
                        );
                      case 3:
                        return _HorizontalProductList(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ProductListScreen(
                                    sort: ProductSort.latest)));
                          },
                          products: state.latestProducts,
                          title: '????????????????',
                        );
                      case 4:
                        return _HorizontalProductList(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ProductListScreen(
                                    sort: ProductSort.popular)));
                          },
                          products: state.popularProducts,
                          title: '????????????????????????',
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
                return AppErrorWidget(
                  exception: state.exception,
                  onPressed: () {
                    BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
                  },
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
  void _search (BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductListScreen.search(searchTerm: _searchController.text)));
  }
}

class _HorizontalProductList extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;
  final List<ProductEntity> products;
  const _HorizontalProductList({
    Key? key,
    required this.onTap,
    required this.title,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onTap,
                child: const Text('???????????? ??????'),
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 290,
          child: ListView.builder(
              itemCount: products.length,
              physics: defualtScrollPhysics,
              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                final product = products[index];
                return ProductItem(
                  product: product,
                  borderRadius: BorderRadius.circular(12.0),
                );
              }),
        )
      ],
    );
  }
}

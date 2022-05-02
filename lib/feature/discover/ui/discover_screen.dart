import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';
import 'package:lcp_mobile/feature/discover/bloc/discover_bloc.dart';
import 'package:lcp_mobile/feature/discover/model/product.dart';
import 'package:lcp_mobile/feature/menu/bloc/category_bloc.dart';
import 'package:lcp_mobile/feature/product_category/model/system_category.dart';
import 'package:lcp_mobile/feature/product_category/repository/api_product_category_repository.dart';
import 'package:lcp_mobile/references/user_preference.dart';
import 'package:lcp_mobile/resources/R.dart';
import 'package:lcp_mobile/resources/api_strings.dart';
import 'package:lcp_mobile/resources/resources.dart';
import 'package:lcp_mobile/route/route_constants.dart';
import 'package:lcp_mobile/widget/appbar.dart';
import 'package:lcp_mobile/widget/card_product.dart';
import 'package:lcp_mobile/widget/search_bar.dart';

import '../../../route/route_constants.dart';
import '../bloc/discover_bloc.dart';
import '../model/product.dart';

class DiscoverScreen extends StatefulWidget {
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with TickerProviderStateMixin {
  bool _firstLoad = true;

  var _isSelectedCategory = false;
  var _currentIndexCategory = 0;

  var _isSelectedCategoryChild = false;
  var _currentIndexCategoryChild = 0;

  var _isSelectedProductType = false;
  var _currentIndexProductType = 0;

  String _currentProductType = '';
  String _currentCategory = '';
  String _currentCategoryChild = '';

  double width;
  double height;

  List<Product> listProduct = [];
  List<SysCategory> listSysCategories = [];
  List<SysCategory> listChildCategories = [];

  TabController _tabController;
  // DiscoverFreshItemScreen _freshItemScreen;
  // DiscoverItemScreen _otherItemScreen;
  ApiProductCategoryRepository _apiProductCate;
  UserData _userData;
  RefreshTokens _refreshTokens;

  @override
  void initState() {
    super.initState();
    setState(() {
      _userData = UserPreferences.getUser();

      _refreshTokens = TokenPreferences.getRefreshTokens();
    });

    // print("userData:");
    // print(_userData);
    // print("refreshToken:");
    print(_refreshTokens);

    _apiProductCate = new ApiProductCategoryRepository();

    context.bloc<CategoryBloc>().add(LoadingCategoryEvent());

    context.bloc<DiscoverBloc>().add(LoadingDiscoverEvent(
        apartmentId: _userData == null ? "AP001" : _userData.apartmentId,
        category: _currentCategory));
  }

  // getSysCategory() async {
  //   listSysCategories = await _apiProductCate.getAllCategories();
  // }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: height * 0.13,
          backgroundColor: Colors.grey.withOpacity(0.2),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CommonAppBar(title: 'LCP'),
                  // Padding(padding: EdgeInsets.only(bottom: 50)),
                  Flexible(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: SearchField(hintText: "Tìm sản phẩm"),
                    ),
                  ),
                  // TabBar(
                  //   controller: _tabController,
                  //   indicatorColor: AppColors.indianRed,
                  //   tabs: const <Widget>[
                  //     Tab(
                  //       text: "FRESH",
                  //     ),
                  //     Tab(
                  //       text: "OTHER",
                  //     )
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
        // body: TabBarView(
        //     controller: _tabController,
        //     children: <Widget>[_freshItemScreen, _otherItemScreen]),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Container(height: 70, child: _buildListCategory()),
            Row(
              children: [
                Container(
                    width: width * 0.1,
                    height: height * 0.40,
                    child: _buildListCategoryChild()),
                Container(
                    width: width * 0.9,
                    height: height * 0.40,
                    child: _buildListProduct()),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thêm',
                    style: headingText,
                  ),
                  IconButton(
                      icon: Image.asset(
                        R.icon.rightArrow,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, RouteConstant.productCategory,
                            arguments: {
                              "listProduct": listProduct,
                              "categoryName": _firstLoad
                                  ? "Tất cả"
                                  : listSysCategories[_currentIndexCategory]
                                      .sysCategoryName
                            });
                      })
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  // Flexible(flex: 2, child: _buildCardBottomNew()),
                  // Flexible(flex: 2, child: _buildCardBottomNew()),
                  Container(
                      height: 150, width: width * 0.917, child: _buildTestList())
                ],
              ),
            )
          ],
        ));
  }

  Widget _buildTestList() {
    return BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
      //   listSysCategories = [];

      //   if (state is CategoryChildLoadFinished) {
      //     listSysCategories = state.categories;
      //   }

      return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: listSysCategories.length,
          itemBuilder: (context, index) {
            var category = listSysCategories[index];
            _isSelectedCategory = _currentIndexCategory == index;
            return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Card(
                  color: Colors.white,
                  child: Container(
                    width: width * 0.5,
                    height: width * 0.4,
                    child: Stack(
                      children: [
                        // Align(
                        //   child: IconButton(
                        //       icon: Image.asset(
                        //         R.icon.heartOutline,
                        //         width: 20,
                        //         height: 20,
                        //       ),
                        //       onPressed: () {}),
                        //   alignment: Alignment.topRight,
                        // ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    category.categoryImage,
                                    // R.icon.snkr01,
                                    width: constraints.maxWidth * 0.5,
                                    height: constraints.maxHeight * 0.5,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        category.sysCategoryName,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          });
    });
  }

  Widget _buildCardBottomNew() {
    return Card(
      color: Colors.white,
      child: Container(
        width: width * 0.5,
        height: width * 0.4,
        child: Stack(
          children: [
            Align(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: constraints.maxWidth * 0.15,
                    height: constraints.maxHeight * 0.5,
                    color: AppColors.indianRed,
                    child: Center(
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: Text(
                          'New',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
              alignment: Alignment.topLeft,
            ),
            Align(
              child: IconButton(
                  icon: Image.asset(
                    R.icon.heartOutline,
                    width: 20,
                    height: 20,
                  ),
                  onPressed: () {}),
              alignment: Alignment.topRight,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        R.icon.snkr01,
                        width: constraints.maxWidth * 0.5,
                        height: constraints.maxHeight * 0.5,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Hủ tiếu',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$5.00',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListProduct() {
    return BlocBuilder<DiscoverBloc, DiscoverState>(
      builder: (context, state) {
        listProduct = [];

        if (state is DiscoverLoadFinished) {
          listProduct = state.products;
        }

        return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: listProduct.length,
            itemBuilder: (context, index) {
              var product = listProduct[index];
              return CardProduct(
                product: product,
                onTapCard: () {
                  Navigator.pushNamed(
                      context, RouteConstant.productDetailsRoute,
                      arguments: product.productId);
                },
              );
            });
      },
    );
  }

  Widget _buildListType() {
    return ListView.builder(
        itemCount: ProductType.values().length,
        itemBuilder: (context, index) {
          var type = ProductType.values()[index];
          _isSelectedProductType = _currentIndexProductType == index;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: RotatedBox(
              quarterTurns: -1,
              child: FlatButton(
                  onPressed: () => _onClickFilterProductType(index, type),
                  child: Text(
                    type,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _isSelectedProductType
                            ? Colors.black
                            : Colors.grey),
                  )),
            ),
          );
        });
  }

  Widget _buildListCategory() {
    return BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
      listSysCategories = [];

      if (state is CategoryChildLoadFinished) {
        listSysCategories = state.categories;
      }
      return ListView.builder(
          // shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: listSysCategories.length,
          itemBuilder: (context, index) {
            var category = listSysCategories[index];
            _isSelectedCategory = _currentIndexCategory == index;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: FlatButton(
                  onPressed: () => {
                        _onClickFilterCategory(index, category.sysCategoryID),
                      },
                  child: Text(
                    category.sysCategoryName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _isSelectedCategory && !_firstLoad
                            ? Colors.black
                            : Colors.grey),
                  )),
            );
          });
    });
  }

  Widget _buildListCategoryChild() {
    return BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
      listChildCategories = [];

      if (state is CategoryChildLoadFinished) {
        listChildCategories = state.cateChild;
      }
      return ListView.builder(
          // shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: listChildCategories.length,
          itemBuilder: (context, index) {
            var category = listChildCategories[index];
            _isSelectedCategoryChild = _currentIndexCategoryChild == index;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RotatedBox(
                quarterTurns: -1,
                child: FlatButton(
                    onPressed: () => {
                          _onClickFilterCategoryChild(
                              index, category.sysCategoryID),
                        },
                    child: Text(
                      category.sysCategoryName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isSelectedCategoryChild && !_firstLoad
                              ? Colors.black
                              : Colors.grey),
                    )),
              ),
            );
          });
    });
  }

  _onClickFilterProductType(int index, String type) {
    setState(() {
      _currentIndexProductType = index;
    });
    _currentProductType = type;

    BlocProvider.of<DiscoverBloc>(context).add(LoadingDiscoverEvent(
        category: _currentCategory, apartmentId: _userData.apartmentId));

    BlocProvider.of<CategoryBloc>(context)
        .add(LoadingCategoryChildEvent(category: _currentCategory));
  }

  _onClickFilterCategory(int index, String category) {
    setState(() {
      _currentIndexCategory = index;
      _firstLoad = false;
    });

    _currentCategory = category;

    BlocProvider.of<CategoryBloc>(context).add(LoadingCategoryChildEvent(
        category: _currentCategory, categories: listSysCategories));

    // BlocProvider.of<DiscoverBloc>(context).add(LoadingDiscoverEvent(
    //     category: _currentCategory, apartmentId: _userData.apartmentId));
    _currentIndexCategoryChild = ApiStrings.zero;
    _onClickFilterCategoryChild(ApiStrings.zero, category);
  }

  _onClickFilterCategoryChild(int index, String category) {
    setState(() {
      _currentIndexCategoryChild = index;
    });

    _currentCategoryChild = category;

    BlocProvider.of<DiscoverBloc>(context).add(LoadingDiscoverEvent(
        category: _currentCategoryChild, apartmentId: _userData.apartmentId));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:lcp_mobile/feature/apartment/model/apartment.dart';
import 'package:lcp_mobile/feature/apartment/repository/api_apartment_repository.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';
import 'package:lcp_mobile/feature/cart/repository/api_cart_repository.dart';
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
  bool _firstChildCateLoad = true;

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
  List<Product> listSearchProduct = [];

  TabController _tabController;

  ApiApartmentRepository _apartmentRepository;
  ApiDiscoverRepository _apiDiscoverRepository;
  ApiProductCategoryRepository _apiProductCate;

  UserData _userData;
  RefreshTokens _refreshTokens;
  List<Apartment> _lstApartment = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _userData = UserPreferences.getUser();

      _refreshTokens = TokenPreferences.getRefreshTokens();

      _apartmentRepository = new ApiApartmentRepository();
      _apiDiscoverRepository = new ApiDiscoverRepository();

      print("_userData");
      print(_userData);

      _userData != null
          ? getApartment(_userData.apartmentId)
          : getApartment("AP001");
    });

    // getApartment(_userData.apartmentId);

    print(_refreshTokens);

    _apiProductCate = new ApiProductCategoryRepository();

    context.bloc<CategoryBloc>().add(LoadingCategoryEvent());

    context.bloc<DiscoverBloc>().add(LoadingDiscoverEvent(
        apartmentId: _userData == null ? "AP001" : _userData.apartmentId,
        category: _currentCategory));
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: _appBar(AppBar().preferredSize.height),
        body: ListView(
          padding: EdgeInsets.only(top: 1.0),
          scrollDirection: Axis.vertical,
          children: [
            Container(height: height * 0.05, child: _buildListCategory()),
            if (!_firstLoad) ...[
              Container(
                  height: height * 0.05, child: _buildListCategoryChild()),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container(
                //     width: width * 0.1,
                //     height: height * 0.40,
                //     child: _buildListCategoryChild()),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Container(
                      width: width * 0.9,
                      height: height * 0.40,
                      child: _buildListProduct()),
                ),
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
                      height: 150,
                      width: width * 0.917,
                      child: _buildTestList())
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
                child: GestureDetector(
                  onTap: () async {
                    listSearchProduct = await _apiDiscoverRepository
                        .searchProductByName(category.sysCategoryName);
                    if (listSearchProduct != null) {
                      Navigator.pushNamed(
                          context, RouteConstant.productCategory, arguments: {
                        "listProduct": listSearchProduct,
                        "categoryName": category.sysCategoryName
                      });
                    }
                  },
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
          getApartment(_userData.apartmentId);
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
                      arguments: {
                        'productId': product.productId,
                        'residentId': product.residentId,
                      });
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
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: FlatButton(
                  onPressed: () => {
                        _onClickFilterCategory(index, category),
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
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: listChildCategories.length,
          itemBuilder: (context, index) {
            var category = listChildCategories[index];
            _isSelectedCategoryChild = _currentIndexCategoryChild == index;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: FlatButton(
                  onPressed: () => {
                        _onClickFilterCategoryChild(index, category),
                      },
                  child: Text(
                    category.sysCategoryName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _isSelectedCategoryChild &&
                                !_firstLoad &&
                                !_firstChildCateLoad
                            ? Colors.black
                            : Colors.grey),
                  )),
            );
          });
    });
  }

  _appBar(height) => PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, height + 60),
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                      child: Image(
                    alignment: Alignment.center,
                    image: AssetImage(R.icon.lcpLogo),
                    width: 100,
                    height: 150,
                  )),
                  Container(
                    width: width * 0.6,
                    height: 50,
                    alignment: Alignment.center,
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(8),
                    //     color: Colors.white.withOpacity(0.8)),
                    child: Row(
                      children: [
                        Icon(FontAwesome5Solid.location_arrow,
                            color: AppColors.aliceBlue, size: 16),
                        Padding(padding: EdgeInsets.only(left: 5)),
                        Flexible(
                          child: Text(
                            _lstApartment.length != 0
                                ? _lstApartment[0].apartmentName
                                : "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              color: Theme.of(context).primaryColor,
              height: height + 75,
              width: MediaQuery.of(context).size.width,
            ),

            Container(), // Required some widget in between to float AppBar

            Positioned(
              // To take AppBar Size only
              top: 100.0,
              left: 20.0,
              right: 20.0,
              child: AppBar(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                primary: false,
                title: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                        hintText: "Tìm sản phẩm",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey))),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.search,
                        color: Theme.of(context).primaryColor),
                    onPressed: () async {
                      listSearchProduct = await _apiDiscoverRepository
                          .searchProductByName(_searchController.text);
                      if (listSearchProduct != null) {
                        Navigator.pushNamed(
                            context, RouteConstant.productCategory, arguments: {
                          "listProduct": listSearchProduct,
                          "categoryName": _searchController.text
                        });
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      );

  _onClickFilterProductType(int index, String type) {
    setState(() {
      _currentIndexProductType = index;
    });
    _currentProductType = type;

    BlocProvider.of<CategoryBloc>(context)
        .add(LoadingCategoryChildEvent(category: _currentCategory));

    BlocProvider.of<DiscoverBloc>(context).add(LoadingDiscoverEvent(
        category: _currentCategory,
        apartmentId: _userData.apartmentId,
        lstChildCategory: listChildCategories));
  }

  _onClickFilterCategory(int index, SysCategory category) {
    setState(() {
      _currentIndexCategory = index;
      _firstLoad = false;
      _firstChildCateLoad = true;
    });

    _currentCategory = category.sysCategoryID;

    BlocProvider.of<CategoryBloc>(context).add(LoadingCategoryChildEvent(
        category: _currentCategory, categories: listSysCategories));

    // if (_firstChildCateLoad) {

    // }

    BlocProvider.of<DiscoverBloc>(context).add(LoadingDiscoverEvent(
        category: _currentCategory,
        apartmentId: _userData.apartmentId,
        lstChildCategory: category.lstSysCategories));

    _currentIndexCategoryChild = ApiStrings.zero;
    // _onClickFilterCategoryChild(ApiStrings.zero, category);
  }

  _onClickFilterCategoryChild(int index, SysCategory category) {
    setState(() {
      _currentIndexCategoryChild = index;
      _firstChildCateLoad = false;
    });

    _currentCategoryChild = category.sysCategoryID;

    BlocProvider.of<DiscoverBloc>(context).add(LoadingDiscoverEvent(
        category: _currentCategoryChild,
        apartmentId: _userData.apartmentId,
        lstChildCategory: category.lstSysCategories));
  }

  getApartment(String id) async {
    _lstApartment = await _apartmentRepository.getApartmentById(id);
  }
}

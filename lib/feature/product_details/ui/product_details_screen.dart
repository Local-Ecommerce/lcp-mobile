import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:lcp_mobile/feature/discover/model/product.dart';
import 'package:lcp_mobile/feature/discover/repository/api_discover_repository.dart';
import 'package:lcp_mobile/feature/product_details/bloc/product_details_bloc.dart';
import 'package:lcp_mobile/feature/store/model/store.dart';
import 'package:lcp_mobile/resources/api_strings.dart';
import 'package:lcp_mobile/resources/app_theme.dart';
import 'package:lcp_mobile/resources/colors.dart';
import 'package:lcp_mobile/route/route_constants.dart';
import 'package:lcp_mobile/widget/bottom_dialog.dart';
import 'package:lcp_mobile/widget/loader_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'popup_desc_details.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({Key key, this.productId}) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final formatCurrency =
      NumberFormat.currency(locale: "en_US", symbol: "VNĐ ", decimalDigits: 0);

  var _isSelectedSize = false;
  var _isSelectedColor = false;
  var _isSelectedWeight = false;

  var _currentIndexWeight = 0;
  var _currentIndexColor = 0;
  var _currentIndexSize = 0;
  var _price;
  var _imageIndex = 0;

  Product product;
  Store store;
  List<Product> relatedProduct;

  List<String> lstSize = [];
  List<num> lstWeight = [];
  List<String> lstColor = [];

  bool isHaveSize = false;
  bool isHaveWeight = false;
  bool isHaveColor = false;
  bool isFirstLoad = true;

  ApiDiscoverRepository _apiDiscoverRepository;

  var _isAddedToBag = false;

  @override
  void initState() {
    super.initState();
    _apiDiscoverRepository = new ApiDiscoverRepository();
    context
        .bloc<ProductDetailsBloc>()
        .add(LoadProductDetails(widget.productId));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
      builder: (context, state) {
        if (state is LoadProductDetailsFinished) {
          product = state.product;
          if (isFirstLoad == true) _price = product.defaultPrice;
          lstWeight.clear();
          lstSize.clear();
          lstColor.clear();
          isHaveSize = false;
          isHaveWeight = false;
          isHaveColor = false;
          if (product.children != null) {
            relatedProduct = product.children;
            relatedProduct.forEach((product) {
              if (product.color != null) {
                isHaveColor = true;
                if (!lstColor.contains(product.color))
                  lstColor.add(product.color);
              }
              if (product.weight != 0) {
                isHaveWeight = true;
                if (!lstWeight.contains(product.weight))
                  lstWeight.add(product.weight);
              }
              if (product.size != null) {
                isHaveSize = true;
                if (!lstSize.contains(product.size)) lstSize.add(product.size);
              }
            });
          }
        }

        return Scaffold(
          appBar: product == null
              ? AppBar(
                  backgroundColor: Colors.white38,
                )
              : _toolbar(),
          body: product == null
              ? LoaderPage()
              : Stack(
                  children: [_contentBody(), _buttonAddToBag()],
                ),
        );
      },
    );
  }

  Widget _contentBody() {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(
                            MediaQuery.of(context).size.width / 2))),
                child: Center(
                    child: Container(
                  margin: EdgeInsets.only(right: 40),
                  child: Image.network(
                    splitImageStringToList(product.images)[_imageIndex],
                    width: 200,
                    fit: BoxFit.fill,
                  ),
                ))),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        SizedBox(
            height: 100,
            child: listImageDetails(splitImageStringToList(product.images))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Container(
            height: 2,
            color: Colors.grey[300],
          ),
        ),
        bodyContentDetails()
      ],
    );
  }

  Widget _toolbar() {
    return AppBar(
      backgroundColor: Colors.redAccent,
      elevation: 0,
      title: Text(
        product.systemCategoryId ?? "",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            onPressed: () => addToWishlistClick(),
            color: Colors.redAccent,
            shape: CircleBorder(),
            elevation: 6,
            child: Icon(
              product.isFavorite == 1
                  ? Ionicons.ios_heart
                  : Ionicons.ios_heart_empty,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget bodyContentDetails() {
    getShopName();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  product.productName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              // Text(
              //   formatCurrency.format(_price),
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //     fontSize: 20,
              //   ),
              // ),
              Column(
                children: [
                  Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: formatCurrency.format(_price),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        if (_price != product.defaultPrice) ...[
                          TextSpan(
                            text: formatCurrency.format(product.defaultPrice),
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          if (store != null) ...[
            Text(
              store.storeName,
              style:
                  TextStyle(color: Colors.black54, fontStyle: FontStyle.italic),
              maxLines: 2,
            ),
          ],
          SizedBox(
            height: 20,
          ),
          Text(
            product.description,
            style: TextStyle(color: Colors.black54),
            maxLines: 5,
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () async {
              await showModalBottomSheet(
                context: context,
                elevation: 30,
                backgroundColor: Colors.transparent,
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: BottomDialog(
                    title: product.productName,
                    child: Text('${product.description}'),
                  ),
                ),
              );
            },
            child: Text(
              'XEM CHI TIẾT',
              style: TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 26,
          ),
          if (isHaveColor == true) ...[
            _buildAttributeTitle("Màu sắc"),
            SizedBox(
              height: 16,
            ),
            SizedBox(height: 60, child: listColor()),
            Padding(padding: EdgeInsets.symmetric(vertical: 16)),
          ],
          if (isHaveSize == true) ...[
            _buildAttributeTitle("Kích thước"),
            SizedBox(
              height: 16,
            ),
            SizedBox(height: 60, child: listSize()),
            Padding(padding: EdgeInsets.symmetric(vertical: 16)),
          ],
          if (isHaveWeight == true) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAttributeTitle("Khối lượng"),
                Text(
                  "(Kg)",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(height: 60, child: listWeight()),
            Padding(padding: EdgeInsets.symmetric(vertical: 16)),
          ],
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget listImageDetails(List<String> images) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: images.length - ApiStrings.one,
      itemBuilder: (context, index) {
        String image = images[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              _imageIndex = index;
            });
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 6.0),
            width: 100,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image.network(
                image,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buttonAddToBag() {
    return BlocListener(
      bloc: context.bloc<ProductDetailsBloc>(),
      listener: (context, state) {
        if (state is AddProductToBagFinished) {
          if (_isAddedToBag) {
            Navigator.pushNamed(context, RouteConstant.cart);
          }
          setState(() {
            _isAddedToBag = true;
          });
        }
      },
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            width: double.infinity,
            child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                onPressed: () => _isAddedToBag
                    ? Navigator.pushNamed(context, RouteConstant.cart)
                    : addProductToCart(),
                color: _isAddedToBag
                    ? AppColors.paleVioletRed
                    : AppColors.indianRed,
                child: Text(
                  _isAddedToBag ? 'ĐI ĐẾN GIỎ HÀNG' : 'THÊM VÀO GIỎ',
                  style: whiteText,
                )),
          )),
    );
  }

  Widget _buildAttributeTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget listColor() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: lstColor.length,
      itemBuilder: (context, index) {
        var attribute = lstColor[index];

        _isSelectedSize = _currentIndexColor == index;
        return GestureDetector(
          onTap: () => {onSelectedIndexColor(index), getPrice()},
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 6.0),
            width: 100,
            height: 50,
            decoration: BoxDecoration(
                color: isFirstLoad == true
                    ? Colors.white
                    : _isSelectedSize
                        ? Colors.black
                        : Colors.white,
                border: Border.all(color: Colors.grey[300]),
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Center(
                  child: Text(
                    "$attribute",
                    style: TextStyle(
                        color: isFirstLoad == true
                            ? Colors.black
                            : _isSelectedSize
                                ? Colors.white
                                : Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                )),
          ),
        );
      },
    );
  }

  Widget listSize() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: lstSize.length,
      itemBuilder: (context, index) {
        var attribute = lstSize[index];

        _isSelectedSize = _currentIndexSize == index;
        return GestureDetector(
          onTap: () => {onSelectedIndexSize(index), getPrice()},
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 6.0),
            width: 100,
            height: 50,
            decoration: BoxDecoration(
                color: isFirstLoad == true
                    ? Colors.white
                    : _isSelectedSize
                        ? Colors.black
                        : Colors.white,
                border: Border.all(color: Colors.grey[300]),
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Center(
                  child: Text(
                    "$attribute",
                    style: TextStyle(
                        color: isFirstLoad == true
                            ? Colors.black
                            : _isSelectedSize
                                ? Colors.white
                                : Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                )),
          ),
        );
      },
    );
  }

  Widget listWeight() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: lstWeight.length,
      itemBuilder: (context, index) {
        var weight = lstWeight[index];
        _isSelectedSize = _currentIndexWeight == index;
        return GestureDetector(
          onTap: () => {onSelectedIndexWeight(index), getPrice()},
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 6.0),
            width: 100,
            height: 50,
            decoration: BoxDecoration(
                color: isFirstLoad == true
                    ? Colors.white
                    : _isSelectedSize
                        ? Colors.black
                        : Colors.white,
                border: Border.all(color: Colors.grey[300]),
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Center(
                  child: Text(
                    "$weight",
                    style: TextStyle(
                        color: isFirstLoad == true
                            ? Colors.black
                            : _isSelectedSize
                                ? Colors.white
                                : Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                )),
          ),
        );
      },
    );
  }

  onSelectedIndexColor(int index) {
    setState(() {
      _currentIndexColor = index;
    });
  }

  onSelectedIndexSize(int index) {
    setState(() {
      _currentIndexSize = index;
    });
  }

  onSelectedIndexWeight(int index) {
    setState(() {
      _currentIndexWeight = index;
    });
  }

  addProductToCart() {
    if (!isHaveColor && !isHaveSize && !isHaveWeight) {
      BlocProvider.of<ProductDetailsBloc>(context)
          .add(AddProductToCart(product));
    } else if (isHaveColor || isHaveSize || isHaveWeight) {
      if (!isFirstLoad) {
        BlocProvider.of<ProductDetailsBloc>(context).add(AddProductToCart(
            product.children.length != 0 ? getDetailProduct() : product));
      } else {
        Fluttertoast.showToast(
          msg: "Bạn chưa chọn sản phẩm chi tiết", // message
          toastLength: Toast.LENGTH_LONG, // length
          gravity: ToastGravity.CENTER, // location
        );
      }
    }
  }

  addToWishlistClick() {
    context.bloc<ProductDetailsBloc>().add(AddToWishlistEvent(product));
  }

  splitImageStringToList(String images) {
    return images.split("|");
  }

  Product getDetailProduct() {
    List<Product> selectedProduct = [];
    var _color, _size, _weight;
    lstColor.isNotEmpty ? _color = lstColor[_currentIndexColor] : _color = null;
    lstSize.isNotEmpty ? _size = lstSize[_currentIndexSize] : _size = null;
    lstWeight.isNotEmpty
        ? _weight = lstWeight[_currentIndexWeight]
        : _weight = 0;

    selectedProduct = relatedProduct
        .where((product) =>
            product.size == _size &&
            product.color == _color &&
            product.weight == _weight)
        .toList();

    selectedProduct[0].images = product.images;
    selectedProduct[0].productName = product.productName;

    print(selectedProduct[0]);
    return selectedProduct[0];
  }

  getPrice() {
    Product _product = getDetailProduct();
    setState(() {
      _price = _product.defaultPrice;
      isFirstLoad = false;
      _isAddedToBag = false;
    });
  }

  getShopName() async {
    store = await _apiDiscoverRepository
        .getStoreNameByResidentId(product.residentId);
    // setState(() {});
  }
}

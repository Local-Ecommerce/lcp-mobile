import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lcp_mobile/feature/order/bloc/order_bloc.dart';
import 'package:lcp_mobile/feature/order/model/order.dart';
import 'package:lcp_mobile/resources/colors.dart';
import 'package:lcp_mobile/resources/resources.dart';
import 'package:lcp_mobile/route/route_constants.dart';
import 'package:lcp_mobile/widget/block_header.dart';
import 'package:lcp_mobile/widget/loader_widget.dart';
import 'package:lcp_mobile/widget/order_title.dart';
import 'package:lcp_mobile/widget/wrapper.dart';

class MyOrdersView extends StatefulWidget {
  @override
  _MyOrdersViewState createState() => _MyOrdersViewState();
}

class _MyOrdersViewState extends State<MyOrdersView> {
  final List<Widget> tabs = <Widget>[
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Tab(text: 'Đã giao'),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Tab(text: 'Đang giao'),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Tab(text: 'Huỷ bỏ'),
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var width = MediaQuery.of(context).size.width;
    return BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {},
        builder: (context, state) {
          var bloc = BlocProvider.of<OrderBloc>(context);
          if (state is OrderListLoadFinished) {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: AppColors.white,
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
              ),
              body: DefaultTabController(
                length: tabs.length,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.sidePadding),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            OpenFlutterBlockHeader(
                              title: 'Đơn hàng của tôi',
                              width: width,
                            ),
                            Padding(padding: EdgeInsets.only(bottom: 15)),
                            TabBar(
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelColor: AppColors.white,
                              labelPadding: EdgeInsets.symmetric(horizontal: 2),
                              unselectedLabelColor: AppColors.black,
                              indicator: BubbleTabIndicator(
                                indicatorHeight: 32,
                                indicatorColor: Colors.black,
                                tabBarIndicatorSize: TabBarIndicatorSize.tab,
                              ),
                              tabs: tabs,
                              unselectedLabelStyle: _theme.textTheme.headline6,
                              labelStyle: _theme.textTheme.headline6
                                  .copyWith(color: AppColors.white),
                            ),
                          ]),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 15)),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TabBarView(
                          children: <Widget>[
                            buildOrderList(state.lstOrder, bloc, 5007, 1),
                            buildOrderList(state.lstOrder, bloc, 5001, 5006),
                            buildOrderList(state.lstOrder, bloc, 5002, 1),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return LoaderPage();
        });
  }

  ListView buildOrderList(
      List<Order> orders, OrderBloc bloc, int status, int status2) {
    List<Order> tmpLst = orders
        .where((order) => order.status == status || order.status == status2)
        .toList();
    return ListView.builder(
        shrinkWrap: true,
        itemCount: tmpLst.length,
        itemBuilder: (context, index) {
          return OpenFlutterOrderTile(
            order: tmpLst[index],
            onClick: ((String orderId) => {
                  // bloc..add(LoadingOrderEvent(orderId: orderId)),
                  // widget.changeView(changeType: ViewChangeType.Exact, index: 7)
                  Navigator.pushNamed(context, RouteConstant.orderDetail,
                      arguments: tmpLst[index])
                }),
          );
        });
  }
}

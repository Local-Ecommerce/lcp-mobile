import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';
import 'package:lcp_mobile/feature/order/bloc/order_bloc.dart';
import 'package:lcp_mobile/feature/profile/bloc/profile_bloc.dart';
import 'package:lcp_mobile/resources/app_data.dart';
import 'package:lcp_mobile/resources/resources.dart';
import 'package:lcp_mobile/route/route_constants.dart';
import 'package:lcp_mobile/widget/appbar.dart';
import 'package:lcp_mobile/widget/loader_widget.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double height;

  @override
  void initState() {
    super.initState();
    context.bloc<ProfileBloc>().add(GetCurrentUser());
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    return BlocConsumer<ProfileBloc, ProfileState>(
      bloc: context.bloc<ProfileBloc>(),
      listener: (context, state) {
        if (state is LogoutFinished) {
          Navigator.pushReplacementNamed(context, RouteConstant.loginRoute);
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: CommonAppBar(title: 'Profile'), body: listFeature(state));
      },
    );
  }

  Widget listFeature(ProfileState state) {
    UserData userData;
    if (state is GetCurrentUserFinish) {
      userData = state.userData;
    }
    return ListView(
      shrinkWrap: true,
      children: [
        Container(
          height: height * 0.3,
          color: Colors.blue,
          child: userData == null
              ? LoaderPage()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userData.fullName,
                      style: headingTextWhite,
                    ),
                    Text(
                      userData.email,
                      style: whiteText,
                    ),
                  ],
                ),
        ),
        Container(
          child: ListView.separated(
              shrinkWrap: true,
              // 1st add
              physics: ClampingScrollPhysics(),
              // 2nd add
              itemBuilder: (context, index) {
                var title = AppSettings.values;
                return rowFeature(title[index]);
              },
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemCount: AppSettings.values.length),
        )
      ],
    );
  }

  Widget rowFeature(AppSettings settings) {
    return InkWell(
      onTap: () {
        actionSettings(settings);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              settings.name,
              style: textMedium,
            ),
            IconButton(icon: Icon(Ionicons.ios_arrow_forward), onPressed: () {})
          ],
        ),
      ),
    );
  }

  actionSettings(AppSettings settings) {
    switch (settings) {
      case AppSettings.MY_ORDER:
        context.bloc<OrderBloc>().add(LoadingListOrderEvent());
        Navigator.pushNamed(context, RouteConstant.orderHistoryRoute);
        break;
      case AppSettings.LOGOUT:
        context.bloc<ProfileBloc>().add(LogoutEvent());
        break;
      case AppSettings.INFO:
        Navigator.pushNamed(context, RouteConstant.updateProfileRoute);
        break;
      default:
        break;
    }
  }
}

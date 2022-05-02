import 'package:flutter/material.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';
import 'package:lcp_mobile/resources/colors.dart';

class ProfileTabView extends StatelessWidget {
  const ProfileTabView({Key key, this.appUser, this.onClicked, this.isEdit})
      : super(key: key);

  final UserData appUser;
  final VoidCallback onClicked;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(children: [
        buildImage(),
        Positioned(
          bottom: 0,
          right: 4,
          child: buildEditIcon(AppColors.blue),
        )
      ]),
    );
  }

  Widget buildImage() {
    final imageDefault = AssetImage("assets/images/default-user-image.png");
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: appUser.profileImage != null ? NetworkImage(appUser.profileImage) : imageDefault,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: onClicked),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: AppColors.aliceBlue,
        all: 3,
        child: buildCircle(
          color: AppColors.skyBlue,
          all: 8,
          child: Icon(
            isEdit ? Icons.add_a_photo : Icons.edit,
            color: AppColors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    Widget child,
    double all,
    Color color,
  }) =>
      ClipOval(
          child: Container(
        padding: EdgeInsets.all(all),
        color: color,
        child: child,
      ));
}

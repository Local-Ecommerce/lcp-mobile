import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lcp_mobile/feature/portal/model/new.dart';
import 'package:lcp_mobile/feature/portal/model/poi.dart';
import 'package:lcp_mobile/feature/portal_details/bloc/portal_detail_bloc.dart';
import 'package:lcp_mobile/widget/loader_widget.dart';

class POIDetailScreen extends StatefulWidget {
  final String poiId;
  final POI poi;

  const POIDetailScreen({Key key, this.poiId, this.poi}) : super(key: key);

  @override
  State<POIDetailScreen> createState() => _POIDetailScreenState();
}

class _POIDetailScreenState extends State<POIDetailScreen> {
  double width;
  double height;

  // New news = new New();
  @override
  void initState() {
    super.initState();
    // context.bloc<PortalDetailsBloc>().add(LoadNewDetails(widget.newId));
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    // return BlocBuilder<PortalDetailsBloc, PortalDetailsState>(
    // builder: (context, state) {
    // if (state is LoadNewDetailsFinished) {
    // TODO
    // }
    var image = widget.poi.images == null
        ? null
        : splitImageStringToList(widget.poi.images)[0];

    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: widget.poi == null
          ? LoaderPage()
          : SizedBox(
              height: size.height,
              width: size.width,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (image != null) ...[
                      SizedBox(
                        height: 250,
                        width: size.width,
                        child: Image.network(
                          image,
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        widget.poi.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                      child: Text(widget.poi.text),
                    ),
                    // InkWell(
                    //   // onTap: () async {
                    //   //   if (connected) {
                    //   //     await launch(widget.news.residentId);
                    //   //   }
                    //   // },
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(
                    //         top: 15.0, left: 15.0, right: 15),
                    //     child: Row(
                    //       children: const [
                    //         // Text(
                    //         //   "See full story ",
                    //         //   style: TextStyle(
                    //         //     fontSize: 15,
                    //         //     color: Color(0xff0C54BE),
                    //         //   ),
                    //         // ),
                    //         // Icon(Icons.arrow_forward_ios,
                    //         //     color: Color(0xff0C54BE), size: 12)
                    //       ],
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
    );
  }

  splitImageStringToList(String images) {
    return images.split("|");
  }
}

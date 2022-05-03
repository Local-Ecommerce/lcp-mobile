import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lcp_mobile/feature/portal/model/new.dart';
import 'package:lcp_mobile/resources/R.dart';
import 'package:lcp_mobile/widget/loader_widget.dart';

class NewDetailScreen extends StatefulWidget {
  final String newId;
  final New news;

  const NewDetailScreen({Key key, this.newId, this.news}) : super(key: key);

  @override
  State<NewDetailScreen> createState() => _NewDetailScreenState();
}

class _NewDetailScreenState extends State<NewDetailScreen> {
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
    var image = widget.news.image == null
        ? null
        : splitImageStringToList(widget.news.image)[0];

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
      body: widget.news == null
          ? LoaderPage()
          : SizedBox(
              height: size.height,
              width: size.width,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (image != null) ...[
                      if (splitImageStringToList(widget.news.image).length >
                          2) ...[
                        buildListCarouse(),
                      ],
                      if (splitImageStringToList(widget.news.image).length <= 2) ...[
                        SizedBox(
                          height: 250,
                          width: size.width,
                          child: Image.network(
                            image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ]
                    ],
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        widget.news.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                      child: Text(widget.news.text),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  splitImageStringToList(String images) {
    print(images);
    return images.split("|");
  }

  Widget buildListCarouse() {
    var mediaQuery = MediaQuery.of(context);
    return CarouselSlider(
      items: List.generate(splitImageStringToList(widget.news.image).length - 1,
          (index) {
        String image = splitImageStringToList(widget.news.image)[index];
        return Container(
          child: ClipRRect(
            child: CachedNetworkImage(
              imageUrl: image,
              height: 192.0,
              width: mediaQuery.size.width,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Image.asset(
                R.icon.snkr01,
                fit: BoxFit.cover,
              ),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
          height: height * 0.25,
          scrollDirection: Axis.horizontal,
          autoPlayAnimationDuration: Duration(milliseconds: 2000),
          autoPlayCurve: Curves.fastOutSlowIn,
          autoPlay: true,
          onPageChanged: (index, reason) {}),
    );
  }
}

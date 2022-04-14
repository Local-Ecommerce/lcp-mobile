import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lcp_mobile/feature/portal_details/bloc/portal_detail_bloc.dart';
import 'package:lcp_mobile/widget/loader_widget.dart';

class POIDetailScreen extends StatefulWidget {
  final String poiId;

  const POIDetailScreen({Key key, this.poiId}) : super(key: key);

  @override
  State<POIDetailScreen> createState() => _POIDetailScreenState();
}

class _POIDetailScreenState extends State<POIDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.bloc<PortalDetailsBloc>().add(LoadPOIDetails(widget.poiId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortalDetailsBloc, PortalDetailsState>(
      builder: (context, state) {
        if (state is LoadNewDetailsFinished) {
          //TODO
        }

        return Scaffold(
            //TODO
            );
      },
    );
  }
}

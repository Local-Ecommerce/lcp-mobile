import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lcp_mobile/feature/portal_details/bloc/portal_detail_bloc.dart';
import 'package:lcp_mobile/widget/loader_widget.dart';

class NewDetailScreen extends StatefulWidget {
  final String newId;

  const NewDetailScreen({Key key, this.newId}) : super(key: key);

  @override
  State<NewDetailScreen> createState() => _NewDetailScreenState();
}

class _NewDetailScreenState extends State<NewDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.bloc<PortalDetailsBloc>().add(LoadNewDetails(widget.newId));
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

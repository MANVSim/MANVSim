import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:manvsim/models/multi_media.dart';
import 'package:manvsim/services/api_service.dart';

import '../services/location_service.dart';

class MultiMediaView extends StatefulWidget {
  final MultiMediaCollection multiMediaCollection;

  const MultiMediaView({super.key, required this.multiMediaCollection});

  @override
  State<MultiMediaView> createState() => _MultiMediaViewState();
}

class _MultiMediaViewState extends State<MultiMediaView> {
  String buildMediaUrl(String reference) {
    ApiService apiService = GetIt.instance.get<ApiService>();
    return apiService.buildMediaUrl(context, reference);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.multiMediaCollection.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final item = widget.multiMediaCollection[index];
        return Padding(
          padding: EdgeInsets.fromLTRB(0, (index == 0) ? 0 : 32, 0, 0),
          child: _buildMediaItem(item),
        );
      },
    );
  }

  Widget _buildMediaItem(MultiMediaItem item) {
    switch (item.type) {
      case MediaType.image:
        return _buildImageItem(item);
      case MediaType.video:
        return _buildVideoItem(item);
      case MediaType.text:
        return _buildTextItem(item);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildImageItem(MultiMediaItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (item.title != null)
          Text(
            item.title!,
            style: Theme.of(context).textTheme.headline6,
          ),
        if (item.reference != null)
          SizedBox(
            width: double.infinity,
            child: Image.network(
              buildMediaUrl(item.reference!),
              fit: BoxFit.contain,
            ),
          ),
      ],
    );
  }

  Widget _buildVideoItem(MultiMediaItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (item.title != null)
          Text(
            item.title!,
            style: Theme.of(context).textTheme.headline6,
          ),
        if (item.reference != null)
          throw UnimplementedError() // Implement video player here
      ],
    );
  }

  Widget _buildTextItem(MultiMediaItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (item.title != null)
          Text(
            item.title!,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        if (item.text != null)
          Text(
            item.text!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
      ],
    );
  }
}

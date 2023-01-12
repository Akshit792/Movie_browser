import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';
import 'package:movie_browser/utils/widgets/loading_indicators.dart';

class MbLoadMoreDelegate extends LoadMoreDelegate with LoadingIndicators {
  @override
  Widget buildChild(LoadMoreStatus status,
      {LoadMoreTextBuilder builder = DefaultLoadMoreTextBuilder.chinese}) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: status == LoadMoreStatus.loading
          ? getLoadingIndicator()
          : Container(),
    );
  }

  @override
  double widgetHeight(LoadMoreStatus status) {
    if (status == LoadMoreStatus.loading) {
      return 62;
    }
    return 0;
  }
}

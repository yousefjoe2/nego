import 'package:flutter/material.dart';

import 'empy_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T items);

class AppListViewBuilder<T> extends StatelessWidget {
  const AppListViewBuilder({
    Key key,
    @required this.snapshot,
    @required this.builder,
  }) : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> builder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;
      if (items.isNotEmpty) {
        _buildListItems(items);
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Error',
        message: 'Can\'t show items right now ... try again later',
      );
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildListItems(List<T> items) {
    return ListView.separated(
      separatorBuilder: (__, index) => Divider(height: 0.5),
      itemCount: snapshot.data.length,
      itemBuilder: (context, index) => builder(context, items[index]),
    );
  }
}

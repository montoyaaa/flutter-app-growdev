import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class DemoBottomAppBar extends StatelessWidget {
  const DemoBottomAppBar({
    this.fabLocation = FloatingActionButtonLocation.endDocked,
    this.shape = const CircularNotchedRectangle(),
  });

  final FloatingActionButtonLocation fabLocation;
  final NotchedShape shape;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: shape,
      color: Theme.of(context).primaryColor,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onSecondary),
        child: Row(
          children: <Widget>[
            Spacer(),
            IconButton(
              tooltip: 'Search',
              icon: NeumorphicIcon(
                Icons.home,
                style: NeumorphicStyle(
                    shape: NeumorphicShape.convex,
                    depth: 1,
                    lightSource: LightSource.topLeft,
                    color: Theme.of(context).colorScheme.onSecondary),
                size: 25,
              ),
              onPressed: () {},
            ),
            Spacer(),
            Spacer(),
            IconButton(
              tooltip: 'Search',
              icon: NeumorphicIcon(
                Icons.settings,
                style: NeumorphicStyle(
                    shape: NeumorphicShape.convex,
                    depth: 1,
                    lightSource: LightSource.topLeft,
                    color: Theme.of(context).colorScheme.onSecondary),
                size: 25,
              ),
              onPressed: () {},
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

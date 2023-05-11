import 'package:flutter/cupertino.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
  final AxisDirection direction;

  CustomPageRoute({
    required this.child,
    this.direction = AxisDirection.right,
}) : super(
    transitionDuration: Duration(seconds: 1),
    pageBuilder: (context, animation, secondaryAnimation) => child,
  );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    // TODO: implement buildTransitions
    return SlideTransition(
      position: Tween<Offset>(
        begin: getBeginOffset(),
      ).animate(animation),
      child: child,
    );
  }

  getBeginOffset() {
    switch(direction){
      case AxisDirection.up:
        return const Offset(0, 1);
      case AxisDirection.down:
        return const Offset(0, -1);
      case AxisDirection.right:
        return const Offset(-1, 0);
      case AxisDirection.left:
        return const Offset(1, 0);
    }
  }
}
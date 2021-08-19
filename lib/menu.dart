import 'dart:math';

import 'package:flutter/material.dart';

enum MenuType {
  circle,
  topLeft,
  bottomLeft,
  topRight,
  bottomRight,
  halfCircle,
}

typedef MenuItemClick = bool Function(int index);

class Menu extends StatefulWidget {
  final List<Widget> menus;
  final Widget center;
  final double radius;
  final double startAngle;
  final double swapAngle;
  final double hideOpacity;
  final Duration duration;
  final MenuType menuType;
  final Curve curve;
  final MenuItemClick menuItemClick;

  const Menu({
    Key? key,
    required this.menus,
    required this.center,
    this.radius = 100,
    this.swapAngle = 120,
    this.startAngle = -60,
    this.hideOpacity = 0,
    this.curve = Curves.ease,
    this.duration = const Duration(milliseconds: 300),
    this.menuType = MenuType.circle,
    required this.menuItemClick,
  }) : super(key: key);

  Menu.topLeft({
    required this.menus,
    required this.menuItemClick,
    required this.radius,
    required this.center,
    this.hideOpacity = 0,
    this.curve = Curves.ease,
    this.duration = const Duration(milliseconds: 300),
    this.menuType = MenuType.topLeft,
    this.swapAngle = 90,
    this.startAngle = 0,
  });

  Menu.bottomLeft({
    required this.menus,
    required this.menuItemClick,
    required this.radius,
    required this.center,
    this.hideOpacity = 0,
    this.curve = Curves.ease,
    this.duration = const Duration(milliseconds: 300),
    this.menuType = MenuType.bottomLeft,
    this.swapAngle = 90,
    this.startAngle = -90,
  });

  Menu.topRight({
    required this.menus,
    required this.menuItemClick,
    required this.radius,
    required this.center,
    this.hideOpacity = 0,
    this.curve = Curves.ease,
    this.duration = const Duration(milliseconds: 500),
    this.menuType = MenuType.topRight,
    this.swapAngle = -90,
    this.startAngle = 180,
  });

  Menu.bottomRight({
    required this.menus,
    required this.menuItemClick,
    required this.radius,
    required this.center,
    this.hideOpacity = 0,
    this.curve = Curves.ease,
    this.duration = const Duration(milliseconds: 300),
    this.menuType = MenuType.bottomRight,
    this.swapAngle = 90,
    this.startAngle = 180,
  });

  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<Menu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // 是否已关闭
  bool _closed = true;
  late Animation<double> curveAnim; // 1.定义曲线动画

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    curveAnim = CurvedAnimation(
        parent: _controller, curve: widget.curve); //<--2.创建曲线动画
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.radius * 2,
        height: widget.menuType == MenuType.halfCircle
            ? widget.radius
            : widget.radius * 2,
        alignment: Alignment.center,
        child: Flow(
          delegate: _CircleFlowDelegate(curveAnim,
              startAngle: widget.startAngle,
              hideOpacity: widget.hideOpacity,
              swapAngle: widget.swapAngle,
              menuType: widget.menuType),
          children: [
            ...widget.menus.asMap().keys.map((int index) => GestureDetector(
              onTap: () => _handleItemClick(index),
              child: widget.menus[index],
            )),
            GestureDetector(onTap: toggle, child: widget.center)
          ],
        ));
  }

  void _handleItemClick(int index) {
    if (widget.menuItemClick == null) {
      toggle();
      return;
    }
    bool close = widget.menuItemClick.call(index);
    if (close) toggle();
  }

  @override
  void didUpdateWidget(Menu oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.duration != oldWidget.duration) {
      _controller.dispose();
      _controller = AnimationController(duration: widget.duration, vsync: this);
    }
    if (widget.curve != oldWidget.curve ||
        widget.duration != oldWidget.duration) {
      curveAnim = CurvedAnimation(parent: _controller, curve: widget.curve);
    }
  }

  void toggle() {
    print("--$_closed------------");

    if (_closed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _closed = !_closed;
  }
}

class _CircleFlowDelegate extends FlowDelegate {
  // 菜单圆弧的扫描角度
  final double swapAngle;

  // 菜单圆弧的起始角度
  final double startAngle;
  final double hideOpacity;
  final MenuType menuType;

  final Animation<double> animation;

  _CircleFlowDelegate(
      this.animation, {
        this.swapAngle = 120,
        this.hideOpacity = 0.3,
        this.startAngle = -60,
        this.menuType = MenuType.circle,
      }) : super(repaint: animation);

  //绘制孩子的方法
  @override
  void paintChildren(FlowPaintingContext context) {
    double radius = context.size.shortestSide / 2;
    final double halfCenterSize =
        context.getChildSize(context.childCount - 1)!.width / 2;

    switch (menuType) {
      case MenuType.circle:
        paintWithOffset(context, Offset.zero);
        break;
      case MenuType.topLeft:
        Offset centerOffset =
        Offset(-radius + halfCenterSize, -radius + halfCenterSize);
        paintWithOffset(context, centerOffset);
        break;
      case MenuType.bottomLeft:
        Offset centerOffset =
        Offset(-radius + halfCenterSize, radius - halfCenterSize);
        paintWithOffset(context, centerOffset);
        break;
      case MenuType.topRight:
        Offset centerOffset =
        Offset(radius - halfCenterSize, -radius + halfCenterSize);
        paintWithOffset(context, centerOffset);
        break;
      case MenuType.bottomRight:
        Offset centerOffset =
        Offset(radius - halfCenterSize, radius - halfCenterSize);
        paintWithOffset(context, centerOffset);
        break;
      case MenuType.halfCircle:
        Offset centerOffset = Offset(radius, radius - halfCenterSize);
        paintWithOffset(context, centerOffset);
        break;
    }
  }

  void paintWithOffset(FlowPaintingContext context, Offset centerOffset) {
    final double radius = context.size.shortestSide / 2;

    final int count = context.childCount - 1;
    final double perRad = swapAngle / 180 * pi / (count - 1);
    final double rotate = startAngle / 180 * pi;

    if (animation.value > hideOpacity) {
      for (int i = 0; i < count; i++) {
        final double cSizeX = context.getChildSize(i)!.width / 2;
        final double cSizeY = context.getChildSize(i)!.height / 2;

        final double beforeRadius = (radius - cSizeX);
        final double now = beforeRadius + centerOffset.dy.abs();
        final swapRadius = (radius - cSizeX) / beforeRadius * now;

        final double offsetX =
            animation.value * swapRadius * cos(i * perRad + rotate) +
                radius +
                centerOffset.dx;
        final double offsetY =
            animation.value * swapRadius * sin(i * perRad + rotate) +
                radius +
                centerOffset.dy;

        context.paintChild(
          i,
          transform: Matrix4.translationValues(
            offsetX - cSizeX,
            offsetY - cSizeY,
            0.0,
          ),
          opacity: animation.value,
        );
      }
    }

    context.paintChild(
      context.childCount - 1,
      transform: Matrix4.translationValues(
        radius -
            context.getChildSize(context.childCount - 1)!.width / 2 +
            centerOffset.dx,
        radius -
            context.getChildSize(context.childCount - 1)!.height / 2 +
            centerOffset.dy,
        0.0,
      ),
    );
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) => false;
}

class Circled extends StatelessWidget {
  final Widget child;
  final Color color;
  final double radius;

  Circled({required this.child, this.color = Colors.blue, this.radius = 15});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      child: child,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(radius))),
    );
  }
}


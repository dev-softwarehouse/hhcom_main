import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hhcom/Utils/Constant/constant.dart';
import 'package:hhcom/Utils/Constant/constant_widget.dart';
import 'package:hhcom/Utils/app_theme.dart';
import 'package:hhcom/Utils/utils.dart';
import 'package:hhcom/controller/navigation_controller.dart';
import 'package:sizer/sizer.dart';

class BaseScaffold extends StatefulWidget {
  const BaseScaffold(
      {Key? key,
      this.child,
      this.bottomNavigationBar,
      this.drawer,
      this.scaffoldKey,
      this.backgroundColor,
      this.hasMenu = false,
      this.hasBack = false,
      this.hasCustomBackground = true})
      : super(key: key);
  final Widget? child;
  final bool hasBack;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool hasMenu;
  final Color? backgroundColor;
  final bool hasCustomBackground;

  @override
  _BaseScaffoldState createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: NavigationController().notifierInitLoading,
        builder: (ctx, isLoading, child) {
          return Stack(
            children: [
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Scaffold(
                  key: widget.scaffoldKey,
                  bottomNavigationBar: widget.bottomNavigationBar,
                  drawer: widget.drawer,
                  resizeToAvoidBottomInset: false,
                  backgroundColor: widget.backgroundColor,
                  body: SafeArea(
                    top: false,
                    child: Stack(
                      children: [
                        if (widget.hasCustomBackground) CustomBackground(),
                        Container(
                          width: Utils().screenSize(context).width,
                          child: widget.child,
                        ),
                        if (widget.hasBack) CustomBackArrow(),
                        if (widget.hasMenu)
                          Padding(
                            padding: EdgeInsets.only(left: 5.0.h, top: 10.h), //Utils().safePaddingTop(context)),
                            child: GestureDetector(
                                onTap: () => widget.scaffoldKey!.currentState!.openDrawer(),
                                child: customIcon(icon: drawer_icn)),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    color: AppColors.dark_3.withOpacity(0.6),
                    child: Container(
                      width: 80.0,
                      height: 80.0,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.lightest, borderRadius: BorderRadius.circular(8)),
                      child: Opacity(
                        opacity: 0.4,
                        child: Image.asset(
                          'assets/double_ring_loading_io.gif',
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        });
  }
}

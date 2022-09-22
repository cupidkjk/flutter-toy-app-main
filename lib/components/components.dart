import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toy_app/model/product.model.dart';
import 'package:toy_app/pack/lib/bottom_navy_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:toy_app/provider/app_locale.dart';
import 'package:toy_app/provider/index.dart';
import 'package:provider/provider.dart';

import 'dart:math' as math;

import 'package:toy_app/widget/detailPage_test.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function() press;
  final Color color, textColor;

  const RoundedButton(
      {Key key, this.text, this.press, this.color, this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.75,
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(83.0),
              side: const BorderSide(color: Colors.white),
            ),
          ),
        ),
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final Widget title;
  final Function() leadingAction;
  final Widget leadingIcon;
  final Color backgroundColor;
  final Color leadingIconColor;
  const CustomAppBar(
      {Key key,
      this.title,
      this.leadingAction,
      this.leadingIcon,
      this.backgroundColor,
      this.leadingIconColor})
      : preferredSize = const Size.fromHeight(50),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      elevation: 0.0,
      toolbarHeight: 50,
      title: Container(
        padding: EdgeInsets.zero,
        child: title,
      ),
      leading: Transform.translate(
        // offset: const Offset(0, -20),
        offset: const Offset(0, 0),
        child: IconButton(
          icon: leadingIcon ??
              Icon(
                Icons.arrow_back,
                size: 30,
                color: leadingIconColor ?? Colors.black,
              ),
          onPressed: leadingAction,
        ),
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          // borderRadius: BorderRadius.only(
          //   bottomLeft: Radius.circular(20),
          //   bottomRight: Radius.circular(20),
          // ),
          // gradient: LinearGradient(
          //     colors: [Colors.red, Colors.pink],
          //     begin: Alignment.bottomCenter,
          //     end: Alignment.topCenter),
        ),
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }
}

class CustomBottomNavbar extends StatelessWidget {
  final BuildContext context;
  final int selectedIndex;
  const CustomBottomNavbar({Key key, this.context, this.selectedIndex})
      : super(key: key);

  void onTabTapped(int index) {
    if (index == 0) {
      Navigator.pushNamed(context, '/home');
    }
    if (index == 1) {
      Navigator.pushNamed(context, '/categories');
    }
    if (index == 2) {
      Navigator.pushNamed(context, '/cart');
    }
    if (index == 3) {
      Navigator.pushNamed(context, '/saved');
    }
    if (index == 4) {
      Navigator.pushNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavyBar(
      selectedIndex: selectedIndex,
      showElevation: true,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      onItemSelected: (index) => {onTabTapped(index)},
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: const Icon(Icons.home),
          title: Text(AppLocalizations.of(context).babytoyspage_home),
          activeBackColor: const Color(0xFF283488),
          activeColor: Colors.white,
          textAlign: TextAlign.center,
          inactiveColor: Colors.grey[600],
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.apps),
          title: Text(AppLocalizations.of(context).babytoyspage_categories),
          activeBackColor: const Color(0xFF283488),
          activeColor: Colors.white,
          textAlign: TextAlign.center,
          inactiveColor: Colors.grey[600],
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.shopping_cart),
          title: Text(AppLocalizations.of(context).babytoyspage_scart),
          activeBackColor: const Color(0xFF283488),
          activeColor: Colors.white,
          textAlign: TextAlign.center,
          inactiveColor: Colors.grey[600],
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.favorite_outline),
          title: Text(AppLocalizations.of(context).babytoyspage_saved),
          activeBackColor: const Color(0xFF283488),
          activeColor: Colors.white,
          textAlign: TextAlign.center,
          inactiveColor: Colors.grey[600],
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.account_circle_outlined),
          title: Text(AppLocalizations.of(context).babytoyspage_profile),
          activeBackColor: const Color(0xFF283488),
          activeColor: Colors.white,
          textAlign: TextAlign.center,
          inactiveColor: Colors.grey[600],
        ),
      ],
    );
  }
}

// float button for transition language
@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key key,
    this.initialOpen,
    this.distance,
    this.children,
  }) : super(key: key);

  final bool initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _expandAnimation;
  bool _open = false;

  AppState _appState;
  String _languageCode = "en";
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
    _appState = Provider.of<AppState>(context, listen: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _appState.getLocale().then((locale) {
      setState(() {
        _languageCode = locale.languageCode;
      });
    });
    if (_languageCode == "en") {
      return SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, bottom: 80),
          child: Stack(
            alignment: Alignment.bottomLeft,
            clipBehavior: Clip.none,
            children: [
              _buildTapToCloseFab(),
              ..._buildExpandingActionButtons(),
              _buildTapToOpenFab(),
            ],
          ),
        ),
      );
    } else {
      return SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.only(left: 0, bottom: 80),
          child: Stack(
            alignment: Alignment.bottomLeft,
            clipBehavior: Clip.none,
            children: [
              _buildTapToCloseFab(),
              ..._buildExpandingActionButtons(),
              _buildTapToOpenFab(),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: const Padding(
              padding: EdgeInsets.all(2.0),
              child: Icon(
                Icons.close,
                color: Color(0xff757579),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            mini: true,
            backgroundColor: const Color(0xff757579),
            onPressed: _toggle,
            child: const Icon(Icons.language),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    Key key,
    this.directionInDegrees,
    this.maxDistance,
    this.progress,
    this.child,
  }) : super(key: key);

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          left: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    Key key,
    this.onPressed,
    this.title,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: const Color(0xff757579),
      elevation: 4.0,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(8.0),
          primary: Colors.white,
          textStyle: const TextStyle(fontSize: 16),
        ),
        onPressed: onPressed,
        child: Text(title),
      ),
      // child: IconButton(
      //   onPressed: onPressed,
      //   icon: icon,
      //   color: theme.colorScheme.secondary,
      // ),
    );
  }
}

// language setting stateful widget
class LanguageTransitionWidget extends StatefulWidget {
  const LanguageTransitionWidget({Key key}) : super(key: key);

  @override
  _LanguageTransitionWidget createState() => _LanguageTransitionWidget();
}

class _LanguageTransitionWidget extends State<LanguageTransitionWidget> {
  // provider setting
  AppState _appState;
  AppLocale _appLocale;
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    _appState = Provider.of<AppState>(context, listen: false);
    _appLocale = Provider.of<AppLocale>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appState.getLocale().then((locale) {
      _appLocale.changeLocale(Locale(locale.languageCode));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      distance: 80.0,
      children: [
        ActionButton(
          onPressed: () {
            _appState.setLocale("en");
            _appLocale.changeLocale(const Locale("en"));
          },
          title: "EN",
        ),
        ActionButton(
          onPressed: () {
            _appState.setLocale("ar");
            _appLocale.changeLocale(const Locale("ar"));
          },
          title: "AR",
        ),
      ],
    );
  }
}

class ProductSearchItemBuilder extends StatelessWidget {
  const ProductSearchItemBuilder({
    this.entry,
    Key key,
  }) : super(key: key);

  final ProductM entry;

  @override
  Widget build(BuildContext context) => InkWell(
        hoverColor: Colors.pink,
        onTap: () {
          Navigator.pushNamed(
            context,
            DetailPageTest.routeName,
            arguments: entry,
          );
        },
        child: Container(
          padding: EdgeInsets.zero,
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 1),
                blurRadius: 5,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    bottomLeft: Radius.circular(32.0)),
                child: entry?.images?.isEmpty ?? true
                    ? const Text("")
                    : Image.network(
                        entry?.images[0],
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.4,
                        fit: BoxFit.cover,
                      ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.5,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 20, bottom: 5),
                          child: Text(
                            entry?.name?.isEmpty ?? true
                                ? ""
                                : entry?.name.toString(),
                            style: const TextStyle(
                              fontFamily: 'Avenir Next',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            entry?.categoryName?.isEmpty ?? true
                                ? ""
                                : entry?.categoryName,
                            style: const TextStyle(
                              fontFamily: 'Avenir Next',
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.zero,
                                child: Text(
                                  entry?.price?.isNaN ?? true
                                      ? ""
                                      : '\$' + entry?.price.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'Avenir Next',
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.zero,
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: RawMaterialButton(
                                    onPressed: () {},
                                    elevation: 1.0,
                                    fillColor: const Color(0xff283488),
                                    child: const Icon(
                                      Icons.shopping_cart_outlined,
                                      size: 16.0,
                                      color: Colors.white,
                                    ),
                                    padding: const EdgeInsets.all(0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(32.0),
                      bottomRight: Radius.circular(32.0)),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
}

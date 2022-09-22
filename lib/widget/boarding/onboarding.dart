import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:toy_app/provider/app_locale.dart';
import 'package:toy_app/provider/index.dart';
import 'package:provider/provider.dart';

// import 'package:toy_app/model/app_language.dart';

// import componenet
import 'package:toy_app/components/components.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key key}) : super(key: key);

  @override
  _Onboarding createState() => _Onboarding();
}

class _Onboarding extends State<Onboarding> {
  // slide setting
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  Color _activeBackgroundColor;
  int _currentPage = 0;

  // provider setting
  AppState _appState;
  AppLocale _appLocale;
  @override
  void initState() {
    super.initState();
    _init();
    setState(() {
      _activeBackgroundColor = const Color(0xffdb6241);
    });
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

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }

    return list;
  }

  void _setBoardBackground(int _index) {
    switch (_index) {
      case 0:
        setState(() {
          _activeBackgroundColor = const Color(0xffdb6241);
        });

        break;
      case 1:
        setState(() {
          _activeBackgroundColor = const Color(0xff7dcbe1);
        });

        break;
      case 2:
        setState(() {
          _activeBackgroundColor = const Color(0xfff8c327);
        });

        break;
      default:
    }
  }

  void _onNextPage() {
    if (_currentPage != _numPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      if (_appState.user == null) {
        Navigator.pushNamed(context, '/auth');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 35.0 : 8.0,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(bottom: 0, top: 30, left: 0, right: 0),
          decoration: BoxDecoration(
            color: _activeBackgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  // padding: EdgeInsets.zero,
                  // height: MediaQuery.of(context).size.height * 0.75,
                  child: PageView(
                    physics: const ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                      _setBoardBackground(page);
                    },
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 50),
                              child: Text(
                                AppLocalizations.of(context)
                                    .onboarding_explorer,
                                style: const TextStyle(
                                  fontFamily: 'Avenir Next',
                                  fontSize: 32,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Text(
                                AppLocalizations.of(context).onboarding_text1,
                                style: const TextStyle(
                                  fontFamily: 'Avenir Next',
                                  fontSize: 32,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 50),
                                  child: Image(
                                    image: AssetImage(
                                      'assets/img/onboarding/1-2.png',
                                    ),
                                    fit: BoxFit.scaleDown,
                                    height: 400,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 50),
                              child: Text(
                                AppLocalizations.of(context)
                                    .onboarding_toys_title,
                                style: const TextStyle(
                                  fontFamily: 'Avenir Next',
                                  fontSize: 32,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Text(
                                AppLocalizations.of(context).onboarding_toys,
                                style: const TextStyle(
                                  fontFamily: 'Avenir Next',
                                  fontSize: 32,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 50),
                                  child: Image(
                                    image: AssetImage(
                                      'assets/img/onboarding/2-2.png',
                                    ),
                                    fit: BoxFit.scaleDown,
                                    height: 400,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 50),
                              child: Text(
                                AppLocalizations.of(context)
                                    .onboarding_shopping_title,
                                style: const TextStyle(
                                  fontFamily: 'Avenir Next',
                                  fontSize: 32,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Text(
                                AppLocalizations.of(context)
                                    .onboarding_shopping,
                                style: const TextStyle(
                                  fontFamily: 'Avenir Next',
                                  fontSize: 32,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 50),
                                  child: Image(
                                    image: AssetImage(
                                      'assets/img/onboarding/3-2.png',
                                    ),
                                    fit: BoxFit.scaleDown,
                                    height: 400,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: _buildPageIndicator(),
                      ),
                      SizedBox(
                        width: 140,
                        child: RoundedButton(
                          text: (_currentPage != _numPages - 1)
                              ? AppLocalizations.of(context).onboarding_next
                              : AppLocalizations.of(context)
                                  .onboarding_explorer,
                          press: _onNextPage,
                          textColor: Colors.black,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: const LanguageTransitionWidget(),
      ),
    );
  }
}

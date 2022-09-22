import 'package:flutter/widgets.dart';

// Splash, Boarding Pages
import 'package:toy_app/widget/boarding/splash.dart';
import 'package:toy_app/widget/boarding/onboarding.dart';

// Auth Pages
import 'package:toy_app/widget/auth/auth.dart';
import 'package:toy_app/widget/auth/login.dart';
import 'package:toy_app/widget/auth/register.dart';

// Home
import 'package:toy_app/widget/home.dart';
import 'package:toy_app/widget/navigationPages/categoriesPage.dart';
import 'package:toy_app/widget/navigationPages/categoryItemPage.dart';
import 'package:toy_app/widget/navigationPages/savedPage.dart';

// Search
import 'package:toy_app/widget/search/searchPage.dart';
import 'package:toy_app/widget/search/searchlistPage.dart';

// Cart
import 'package:toy_app/widget/shopping/cartPage.dart';
import 'package:toy_app/widget/shopping/deliveryPage.dart';
import 'package:toy_app/widget/shopping/orderPage.dart';
import 'package:toy_app/widget/shopping/paymentPage.dart';
import 'package:toy_app/widget/shopping/wrapPage.dart';
import 'package:toy_app/widget/shopping/wraporderPage.dart';

// Profile
import 'package:toy_app/widget/profile/editPage.dart';
import 'package:toy_app/widget/profile/profilePage.dart';

// Toy Detail Page
import 'package:toy_app/widget/saveddetailPage.dart';
import 'package:toy_app/widget/detailPage_test.dart';

// List Pages
import 'package:toy_app/widget/listPages/popularPage.dart';
import 'package:toy_app/widget/listPages/legoPage.dart';
import 'package:toy_app/widget/listPages/hotwheelsPage.dart';
import 'package:toy_app/widget/listPages/barbiePage.dart';
import 'package:toy_app/widget/listPages/disneyPage.dart';
import 'package:toy_app/widget/listPages/bratzPage.dart';
import 'package:toy_app/widget/listPages/starwarsPage.dart';
import 'package:toy_app/widget/listPages/toystoryPage.dart';
import 'package:toy_app/widget/listPages/marvelPage.dart';

import 'package:toy_app/widget/listPages/bikePage.dart';
import 'package:toy_app/widget/listPages/partyPage.dart';
import 'package:toy_app/widget/listPages/schoolPage.dart';
import 'package:toy_app/widget/listPages/topPage.dart';
import 'package:toy_app/widget/listPages/robotsPage.dart';
import 'package:toy_app/widget/listPages/babytoysPage.dart';
import 'package:toy_app/widget/listPages/cakePage.dart';
import 'package:toy_app/widget/listPages/newarrivalsPage.dart';
import 'package:toy_app/widget/listPages/recommendedPage.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/splash': (BuildContext context) => const Splash(),
  '/auth': (BuildContext context) => const Auth(),
  '/login': (BuildContext context) => const LoginScreen(),
  '/register': (BuildContext context) => const Register(),
  '/onboarding': (BuildContext context) => const Onboarding(),
  '/home': (BuildContext context) => const Home(),
  '/categories': (BuildContext context) => const Categories(),
  '/categoryItem': (BuildContext context) => const CategoryItems(),
  '/cart': (BuildContext context) => const Cart(),
  '/delivery': (BuildContext context) => const Delivery(),
  '/order': (BuildContext context) => const Order(),
  '/payment': (BuildContext context) => const Payment(),
  '/wrap': (BuildContext context) => WrapPage(),
  '/wraporder': (BuildContext context) => const Wraporder(),
  '/saved': (BuildContext context) => const Saved(),
  '/profile': (BuildContext context) => const Profile(),
  '/edit': (BuildContext context) => const Edit(),
  '/detail': (BuildContext context) => const DetailPage(),
  DetailPageTest.routeName: (BuildContext context) => const DetailPageTest(),
  '/popular': (BuildContext context) => const Popular(),
  '/lego': (BuildContext context) => const Lego(),
  '/hotwheels': (BuildContext context) => const Hotwheels(),
  '/barbie': (BuildContext context) => const Barbie(),
  '/disney': (BuildContext context) => const Disney(),
  '/bratz': (BuildContext context) => const Bratz(),
  '/starwars': (BuildContext context) => const Starwars(),
  '/toystory': (BuildContext context) => const Toystory(),
  '/marvel': (BuildContext context) => const Marvel(),
  '/bike': (BuildContext context) => const Bike(),
  '/party': (BuildContext context) => const Party(),
  '/school': (BuildContext context) => const School(),
  '/top': (BuildContext context) => const Top(),
  '/robots': (BuildContext context) => const Robots(),
  '/baby': (BuildContext context) => const Babytoys(),
  '/cakes': (BuildContext context) => const Cake(),
  '/new': (BuildContext context) => const Newarrivals(),
  '/recommended': (BuildContext context) => const Recommended(),
  '/search': (BuildContext context) => const Search(),
  '/searchlist': (BuildContext context) => Searchlist(),
  // '/fingerregister': (BuildContext context) => new FingerRegister(),
  // '/forgotpassword': (BuildContext context) => new ForgotPassword(),
  // '/pincodescreen': (BuildContext context) => new PinCodeScreen(),
  // '/verficationcode': (BuildContext context) => new VerificationCode(),
  // '/changepassword': (BuildContext context) => new ChangePassword(),
  // '/homescreen': (BuildContext context) => new HomeScreen(),
  // '/loanscreen': (BuildContext context) => new LoanScreen(),
  // '/profilescreen': (BuildContext context) => new ProfileScreen(),
};

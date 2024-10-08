import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/widgets/intro_widget.dart';
import 'package:frontend/l10n/app_localizations.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();

  int _activePage = 0;

  void onNextPage() {
    if (_activePage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastEaseInToSlowEaseOut,
      );
    }
  }

  List<Map<String, dynamic>> _pages = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pages = [
      {
        'color': '#16325B',
        'title': AppLocalizations.of(context).translate('welcome'),
        'image': 'assets/images/1.PNG',
        'description': AppLocalizations.of(context).translate('description1'),
        'skip': true
      },
      {
        'color': '#227B94',
        'title': AppLocalizations.of(context).translate('clients'),
        'image': 'assets/images/2.PNG',
        'description': AppLocalizations.of(context).translate('description2'),
        'skip': true
      },
      {
        'color': '#78B7D0',
        'title': AppLocalizations.of(context).translate('operators'),
        'image': 'assets/images/3.PNG',
        'description': AppLocalizations.of(context).translate('description3'),
        'skip': false
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            scrollBehavior: AppScrollBehavior(),
            onPageChanged: (int page) {
              setState(() {
                _activePage = page;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return IntroWidget(
                index: index,
                color: _pages[index]['color'],
                title: _pages[index]['title'],
                description: _pages[index]['description'],
                image: _pages[index]['image'],
                skip: _pages[index]['skip'],
                onTab: onNextPage,
              );
            },
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 1.75,
            right: 0,
            left: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildIndicator(),
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildIndicator() {
    final indicators = <Widget>[];

    for (var i = 0; i < _pages.length; i++) {
      if (_activePage == i) {
        indicators.add(_indicatorsTrue());
      } else {
        indicators.add(_indicatorsFalse());
      }
    }
    return indicators;
  }

  Widget _indicatorsTrue() {
    final String color;
    if (_activePage == 0) {
      color = '#16325B';
    } else if (_activePage == 1) {
      color = '#227B94';
    } else {
      color = '#78B7D0';
    }

    return AnimatedContainer(
      duration: const Duration(microseconds: 300),
      height: 6,
      width: 42,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: hexToColor(color),
      ),
    );
  }

  Widget _indicatorsFalse() {
    return AnimatedContainer(
      duration: const Duration(microseconds: 300),
      height: 8,
      width: 8,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.grey.shade100,
      ),
    );
  }
}

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

import 'package:flutter/material.dart';
import 'package:parichaya_frontend/screens/about_us_screen.dart';
import 'package:parichaya_frontend/widgets/more_screen_listtile.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  static const routeName = '/about_us';

  @override
  Widget build(BuildContext context) {
    final double customWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Text('About Us',
                    style: Theme.of(context).textTheme.headlineLarge)),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: customWidth * 0.05),
              child: Text(
                "Know more about us",
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            MoreScreenListTile(
              name: "About DANK",
              description: "Team Overview",
              icon: SvgPicture.asset(('assets/icons/info.svg'),
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary, BlendMode.srcIn)),
              trailingIcon: null,
              onTap: () => Navigator.of(context, rootNavigator: true)
                  .pushNamed(AboutUsScreen.routeName),
            ),
            MoreScreenListTile(
              name: "Open Source Licenses",
              description: "View Open Source Licenses",
              icon: SvgPicture.asset(('assets/icons/licenses.svg'),
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary, BlendMode.srcIn)),
              trailingIcon: null,
              onTap: () => showLicensePage(
                context: context,
                applicationIcon: const Icon(
                  Icons.fingerprint,
                  color: Colors.blue,
                ),
                applicationLegalese: "View all open source licenses.",
                useRootNavigator: true,
                applicationVersion: "v2.15",
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

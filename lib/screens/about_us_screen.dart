import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  static const routeName = '/about_us_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "About Us",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Text(
              "Company Overview",
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Parichaya is a blockchain-based digital identify system that provides a tamper-proof and immutable record of identity information to enable self-sovereign identity management.",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Parichaya provides a secure de-centralized way to store and manage personal identifications information and improves the access to financial and other services for individuals and businesses.",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Follow us on",
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () async {
                    const url = "https://www.facebook.com/thekingempire.10";
                    launchUrlString(url);
                  },
                  icon: SvgPicture.asset(
                    "assets/icons/facebook.svg",
                    width: 24,
                    height: 24,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    const url = "https://twitter.com/raj_giri4";
                    launchUrlString(url);
                  },
                  icon: SvgPicture.asset(
                    "assets/icons/twitter.svg",
                    width: 24,
                    height: 24,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    const url =
                        "https://www.youtube.com/watch?v=dQw4w9WgXcQ&ab_channel=RickAstley";
                    launchUrlString(url);
                  },
                  icon: SvgPicture.asset(
                    "assets/icons/youtube.svg",
                    width: 24,
                    height: 24,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    const url = "https://www.instagram.com/rgiri4367/";
                    launchUrlString(url);
                  },
                  icon: SvgPicture.asset(
                    "assets/icons/instagram.svg",
                    width: 24,
                    height: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
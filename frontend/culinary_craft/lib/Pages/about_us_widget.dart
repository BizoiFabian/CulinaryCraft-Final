import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';

class AboutUsWidget extends StatelessWidget {
  AboutUsWidget({super.key});

  final String iconUrl = 'assets/images/icon2.png';
  final String creatorImageUrl = 'assets/images/Fabian.jpg';
  final String creatorName = 'Bizoi Fabian-Mario';
  final String creatorLinkedinUrl =
      'https://www.linkedin.com/in/fabian-mario-bizoi-45963b273/';
  final String creatorEmail = 'fabianbizoi50@gmail.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.aboutUs),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Image.asset(
              iconUrl,
              width: 300,
              height: 300,
            ),
            const Spacer(),
            _buildCreatorInfo(
              context: context,
              imageUrl: creatorImageUrl,
              linkedinUrl: creatorLinkedinUrl,
              email: creatorEmail,
              name: creatorName,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatorInfo({
    required BuildContext context,
    required String imageUrl,
    required String linkedinUrl,
    required String email,
    required String name,
  }) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.asset(
            imageUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object error, StackTrace? stack) {
              return Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.secondaryContainer,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.person,
                  size: 56,
                  color: colorScheme.onSecondaryContainer,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.linkedin,
                    size: 30,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _launchURL(linkedinUrl),
                      child: Text(
                        linkedinUrl,
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.envelope,
                    size: 30,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _launchURL('mailto:$email'),
                      child: Text(
                        email,
                        style: TextStyle(color: colorScheme.onSurface),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }
}

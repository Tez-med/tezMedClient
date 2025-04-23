import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tez_med_client/data/clinic/model/clinics_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactButtons extends StatelessWidget {
  final Clinic clinic;

  const ContactButtons({super.key, required this.clinic});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (clinic.instagramLink.isNotEmpty)
          _ContactButtonItem(
            icon: FontAwesomeIcons.instagram,
            text: 'Instagram',
            onTap: () => _launchUrl(clinic.instagramLink),
          ),
        if (clinic.tgLink.isNotEmpty)
          _ContactButtonItem(
            icon: FontAwesomeIcons.telegram,
            text: 'Telegram',
            onTap: () => _launchUrl(clinic.tgLink),
          ),
      ],
    );
  }

  void _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}

// MARK: - Contact Button Item
class _ContactButtonItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _ContactButtonItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 24,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}

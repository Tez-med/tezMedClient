import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/gen/assets.gen.dart';
import 'package:tez_med_client/generated/l10n.dart';

@RoutePage()
class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  String _policyText = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPolicy();
  }

  Future<void> _loadPolicy() async {
    try {
      final String policy =
          await rootBundle.loadString(Assets.pirvacyPolicy.privacyPolicyMd);
      setState(() {
        _policyText = policy;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _policyText = 'Xatolik yuz berdi: Faylni yuklab bo\'lmadi';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.buttonBackColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: AppColor.buttonBackColor,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () => context.router.maybePop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
        title:  Text(
          S.of(context).consent4,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.white,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              child: Markdown(
                data: _policyText,
                styleSheet: MarkdownStyleSheet(
                  h1: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  h2: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  h3: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  p: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                  listBullet: const TextStyle(
                    color: Colors.black87,
                  ),
                  blockquote: const TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                  code: const TextStyle(
                    backgroundColor: Color(0xFFF3F3F3),
                    fontFamily: 'monospace',
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final List<FAQItem> _faqItems = [
    FAQItem(
      question: 'Do I need to keep the app open for mining?',
      answer: 'No. Once the nap session starts, mining continues even if you close the app.',
    ),
    FAQItem(
      question: 'Can I earn more NAP?',
      answer: 'Yes! Invite friends and increase your mining rate with each referral.',
    ),
    FAQItem(
      question: 'How long is each mining session?',
      answer: 'Each mining session lasts for 12 hours. After that, you can start a new session.',
    ),
    FAQItem(
      question: 'What is the base mining rate?',
      answer: 'The base mining rate is 4.33333 NAP per hour. This increases by 1.33333 NAP/hr for each friend you invite.',
    ),
    FAQItem(
      question: 'When can I withdraw my NAP tokens?',
      answer: 'The withdrawal feature is coming soon! We\'re working on integrating with major exchanges and wallets.',
    ),
    FAQItem(
      question: 'Is my data safe?',
      answer: 'Yes! All your mining data is stored locally on your device. We prioritize your privacy and security.',
    ),
    FAQItem(
      question: 'What happens if I lose my phone?',
      answer: 'Currently, data is stored locally. We recommend backing up your referral code. Cloud backup features are coming soon.',
    ),
    FAQItem(
      question: 'How do referrals work?',
      answer: 'Share your unique referral code or link with friends. When they sign up and start mining, your mining rate increases permanently.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D1B3D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'FAQ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(
                    Icons.help_outline,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Frequently Asked Questions',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Find answers to common questions about NAPCOIN',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // FAQ List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _faqItems.length,
                itemBuilder: (context, index) {
                  return _buildFAQItem(_faqItems[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(FAQItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ExpansionTile(
        title: Text(
          item.question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              item.answer,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}


import 'package:flutter/material.dart';

import 'package:user_app/dining/bankOffersLIst.dart';
import 'package:user_app/dining/discoverVibeList.dart';
import 'package:user_app/dining/lookingForList.dart';
import 'package:user_app/dining/MostLovedRestaurentsList.dart';
import 'package:user_app/dining/mustTriesList.dart';
import 'package:user_app/dining/popularRestaurentItems.dart';
import 'package:user_app/dining/popularRestaurents.dart';
import 'package:user_app/dining/popularRestaurents1.dart';
import 'package:user_app/dining/popularRestaurents2.dart';
import 'package:user_app/dining/diningHomeList.dart';

class DiningHome extends StatelessWidget {
  const DiningHome({super.key});

  static const Color deepBlue = Color(0xFF1565C0);
  static const Color mediumBlue = Color(0xFF42A5F5);
  static const Color lightBlue = Color(0xFFE3F2FD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                14,
                42,
                14,
                20,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    deepBlue,
                    mediumBlue,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                        size: 34,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delivering to',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Your saved location',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/profile.jpeg',
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                color: deepBlue,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Payment cards
                  Row(
                    children: [
                      Expanded(
                        child: _PaymentCard(
                          title: 'Pay with App Card',
                          icon: Icons.account_balance_wallet_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _PaymentCard(
                          title: 'Pay with Personal Card',
                          icon: Icons.credit_card_outlined,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            _SectionTitle(
              title: 'ARE YOU HERE?',
            ),

            const SizedBox(
              height: 180,
              width: double.infinity,
              child: DiningHomeList(),
            ),

            _SectionTitle(
              title: 'MOST LOVED RESTAURANTS',
              subtitle: 'Picked by people around you',
            ),

            Container(
              height: 200,
              width: double.infinity,
              color: lightBlue,
              child: const MostLovedRestaurentsList(),
            ),

            _SectionTitle(
              title: 'WHAT ARE YOU LOOKING FOR?',
            ),

            const SizedBox(
              height: 450,
              width: double.infinity,
              child: LookingForList(),
            ),

            _SectionTitle(
              title: 'MUST-TRIES',
              subtitle: 'Popular food picks for you',
            ),

            const SizedBox(
              height: 240,
              width: double.infinity,
              child: MustTriesList(),
            ),

            // Bank Offers intentionally kept for now.
            _SectionTitle(
              title: 'AVAILABLE BANK OFFERS',
            ),

            const SizedBox(
              height: 170,
              width: double.infinity,
              child: BankOffersList(),
            ),

            _SectionTitle(
              title: 'DISCOVER WITH VIBE',
            ),

            const SizedBox(
              height: 240,
              width: double.infinity,
              child: DiscoverVibeList(),
            ),

            _SectionTitle(
              title: 'POPULAR RESTAURANTS AROUND YOU',
            ),

            const SizedBox(
              height: 350,
              width: double.infinity,
              child: PopularRestaurentItems(),
            ),

            const SizedBox(
              height: 350,
              width: double.infinity,
              child: PopularRestaurent(),
            ),

            const SizedBox(
              height: 350,
              width: double.infinity,
              child: PopularRestaurent2(),
            ),

            const SizedBox(
              height: 350,
              width: double.infinity,
              child: PopularRestaurent1(),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _SectionTitle({
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        14,
        18,
        14,
        10,
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PaymentCard({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
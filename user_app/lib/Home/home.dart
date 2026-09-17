import 'package:flutter/material.dart';

import '../cake/cakeItems.dart';
import '../restaurent/restaurent1.dart';
import '../restaurent/restaurent2.dart';
import '../restaurent/restaurent3.dart';
import '../restaurent/restaurent4.dart';
import '../restaurent/restaurent5.dart';

import 'HomeLargeItems.dart';
import 'HomePageItems3.dart';
import 'HomePageMediumItems.dart';
import 'HomepageItems4.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static const Color deepBlue = Color(0xFF1565C0);
  static const Color mediumBlue = Color(0xFF42A5F5);
  static const Color lightBlue = Color(0xFFE3F2FD);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Main promotional banner
            const SizedBox(
              height: 250,
              width: double.infinity,
              child: HomeLargeItems(),
            ),

            const SizedBox(height: 10),

            const _SectionHeading(
              title: 'EXPLORE',
            ),

            const SizedBox(
              height: 180,
              width: double.infinity,
              child: HomeMediumItems(),
            ),

            const _SectionHeading(
              title: 'WHAT\'S ON YOUR MIND?',
            ),

            const SizedBox(
              height: 100,
              width: double.infinity,
              child: HomePageItems3(),
            ),

            const SizedBox(
              height: 100,
              width: double.infinity,
              child: HomePageItems4(),
            ),

            const _SectionHeading(
              title: 'IN THE SPOTLIGHT',
            ),

            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: lightBlue,
              ),
              child: const SizedBox(
                height: 220,
                child: CakeItems1(),
              ),
            ),

            const _SectionHeading(
              title: 'FEATURED RESTAURANTS',
              subtitle: 'Discover restaurants and order your favourite food',
            ),

            const SizedBox(
              height: 300,
              width: double.infinity,
              child: Restaurent1(),
            ),

            const SizedBox(
              height: 300,
              width: double.infinity,
              child: Restaurent2(),
            ),

            const SizedBox(
              height: 300,
              width: double.infinity,
              child: Restaurent3(),
            ),

            const SizedBox(
              height: 300,
              width: double.infinity,
              child: Restaurent4(),
            ),

            const SizedBox(
              height: 300,
              width: double.infinity,
              child: Restaurent5(),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _SectionHeading({
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        14,
        22,
        14,
        12,
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF1565C0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 5),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
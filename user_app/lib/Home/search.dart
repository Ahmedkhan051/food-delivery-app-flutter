import 'package:flutter/material.dart';

import 'package:user_app/mainScreens/search_screen.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  static const Color deepBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFFE3F2FD);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SearchScreen(),
            ),
          );
        },
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFBBDEFB),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(25, 0, 0, 0),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              const Icon(
                Icons.search,
                color: deepBlue,
                size: 25,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Restaurant name or dish...',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                height: 36,
                width: 36,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.mic_none,
                  color: deepBlue,
                  size: 21,
                ),
              ),
              const SizedBox(width: 2),
            ],
          ),
        ),
      ),
    );
  }
}
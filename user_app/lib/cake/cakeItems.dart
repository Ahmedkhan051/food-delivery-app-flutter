import 'package:flutter/material.dart';

import 'cakeItemsModel.dart';

class CakeItems1 extends StatelessWidget {
  const CakeItems1({super.key});

  static final List<CakeItemsModel> cakeItems = [
    CakeItemsModel(
      cakeImageLink: 'assets/images/cake1.jpeg',
      name: 'Cake Brown Factory',
      cakeRating: '4.0',
      cakeDiscount: '10% OFF up to Rs.150',
    ),
    CakeItemsModel(
      cakeImageLink: 'assets/images/cake2.jpeg',
      name: 'Binze Cake',
      cakeRating: '3.9',
      cakeDiscount: '20% OFF up to Rs.100',
    ),
    CakeItemsModel(
      cakeImageLink: 'assets/images/cake3.jpeg',
      name: 'Cake Brand',
      cakeRating: '4.0',
      cakeDiscount: '30% OFF up to Rs.250',
    ),
  ];

  void showCakeSelected(
      BuildContext context,
      String cakeName,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$cakeName selected.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: PageView.builder(
        itemCount: cakeItems.length,
        controller: PageController(
          viewportFraction: 0.88,
        ),
        itemBuilder: (context, index) {
          final CakeItemsModel cake = cakeItems[index];

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 8,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                showCakeSelected(
                  context,
                  cake.name,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage(
                      cake.cakeImageLink,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color.fromARGB(215, 0, 0, 0),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (cake.cakeDiscount != null)
                        Text(
                          cake.cakeDiscount!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              cake.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E7D32),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  cake.cakeRating,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                const Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
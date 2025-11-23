import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealGridItem extends StatelessWidget {
  final MealSummary meal;
  final VoidCallback onTap;

  const MealGridItem({
    super.key,
    required this.meal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                meal.thumb,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Text(
                meal.name,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

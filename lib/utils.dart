import 'main.dart';

double calculateDiscountRate(Map<ItemType, MenuItem?> items) {
  final hasSandwich = items[ItemType.sandwich] != null;
  final hasFries = items[ItemType.fries] != null;
  final hasDrink = items[ItemType.drink] != null;

  if (hasSandwich && hasFries && hasDrink) return 0.20;
  if (hasSandwich && hasDrink) return 0.15;
  if (hasSandwich && hasFries) return 0.10;
  return 0.0;
}

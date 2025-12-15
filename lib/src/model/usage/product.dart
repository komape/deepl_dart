import 'package:deepl_dart/src/model/usage/billing_unit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable(createToJson: false)
class Product {
  /// The type of product (e.g., 'write', 'translate').
  final String productType;

  /// The billing unit for this product type.
  final BillingUnit billingUnit;

  /// Units used for this product by this API key in the current period.
  final int apiKeyUnitCount;

  /// Total units used for this product in the current period.
  final int accountUnitCount;

  Product({
    required this.productType,
    required this.billingUnit,
    required this.apiKeyUnitCount,
    required this.accountUnitCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  @override
  String toString() =>
      'Product[productType: $productType, billingUnit: $billingUnit, apiKeyUnitCount: $apiKeyUnitCount, accountUnitCount: $accountUnitCount]';
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      productType: json['product_type'] as String?,
      billingUnit:
          $enumDecodeNullable(_$BillingUnitEnumMap, json['billing_unit']),
      apiKeyUnitCount: (json['api_key_unit_count'] as num?)?.toInt(),
      accountUnitCount: (json['account_unit_count'] as num?)?.toInt(),
    );

const _$BillingUnitEnumMap = {
  BillingUnit.characters: 'characters',
  BillingUnit.milliseconds: 'milliseconds',
};

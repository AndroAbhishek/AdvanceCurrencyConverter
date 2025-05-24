// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_exchange_rate_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currencyExchangeRateViewModelHash() =>
    r'fa3ba5a943555bb51bd83f524f9afc9f7efa2c7d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$CurrencyExchangeRateViewModel
    extends BuildlessAsyncNotifier<CurrencyRateModel> {
  late final String base;
  late final List<String> symbols;

  FutureOr<CurrencyRateModel> build({
    required String base,
    required List<String> symbols,
  });
}

/// See also [CurrencyExchangeRateViewModel].
@ProviderFor(CurrencyExchangeRateViewModel)
const currencyExchangeRateViewModelProvider =
    CurrencyExchangeRateViewModelFamily();

/// See also [CurrencyExchangeRateViewModel].
class CurrencyExchangeRateViewModelFamily
    extends Family<AsyncValue<CurrencyRateModel>> {
  /// See also [CurrencyExchangeRateViewModel].
  const CurrencyExchangeRateViewModelFamily();

  /// See also [CurrencyExchangeRateViewModel].
  CurrencyExchangeRateViewModelProvider call({
    required String base,
    required List<String> symbols,
  }) {
    return CurrencyExchangeRateViewModelProvider(
      base: base,
      symbols: symbols,
    );
  }

  @override
  CurrencyExchangeRateViewModelProvider getProviderOverride(
    covariant CurrencyExchangeRateViewModelProvider provider,
  ) {
    return call(
      base: provider.base,
      symbols: provider.symbols,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'currencyExchangeRateViewModelProvider';
}

/// See also [CurrencyExchangeRateViewModel].
class CurrencyExchangeRateViewModelProvider extends AsyncNotifierProviderImpl<
    CurrencyExchangeRateViewModel, CurrencyRateModel> {
  /// See also [CurrencyExchangeRateViewModel].
  CurrencyExchangeRateViewModelProvider({
    required String base,
    required List<String> symbols,
  }) : this._internal(
          () => CurrencyExchangeRateViewModel()
            ..base = base
            ..symbols = symbols,
          from: currencyExchangeRateViewModelProvider,
          name: r'currencyExchangeRateViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$currencyExchangeRateViewModelHash,
          dependencies: CurrencyExchangeRateViewModelFamily._dependencies,
          allTransitiveDependencies:
              CurrencyExchangeRateViewModelFamily._allTransitiveDependencies,
          base: base,
          symbols: symbols,
        );

  CurrencyExchangeRateViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.base,
    required this.symbols,
  }) : super.internal();

  final String base;
  final List<String> symbols;

  @override
  FutureOr<CurrencyRateModel> runNotifierBuild(
    covariant CurrencyExchangeRateViewModel notifier,
  ) {
    return notifier.build(
      base: base,
      symbols: symbols,
    );
  }

  @override
  Override overrideWith(CurrencyExchangeRateViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: CurrencyExchangeRateViewModelProvider._internal(
        () => create()
          ..base = base
          ..symbols = symbols,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        base: base,
        symbols: symbols,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<CurrencyExchangeRateViewModel, CurrencyRateModel>
      createElement() {
    return _CurrencyExchangeRateViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrencyExchangeRateViewModelProvider &&
        other.base == base &&
        other.symbols == symbols;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, base.hashCode);
    hash = _SystemHash.combine(hash, symbols.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CurrencyExchangeRateViewModelRef
    on AsyncNotifierProviderRef<CurrencyRateModel> {
  /// The parameter `base` of this provider.
  String get base;

  /// The parameter `symbols` of this provider.
  List<String> get symbols;
}

class _CurrencyExchangeRateViewModelProviderElement
    extends AsyncNotifierProviderElement<CurrencyExchangeRateViewModel,
        CurrencyRateModel> with CurrencyExchangeRateViewModelRef {
  _CurrencyExchangeRateViewModelProviderElement(super.provider);

  @override
  String get base => (origin as CurrencyExchangeRateViewModelProvider).base;
  @override
  List<String> get symbols =>
      (origin as CurrencyExchangeRateViewModelProvider).symbols;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

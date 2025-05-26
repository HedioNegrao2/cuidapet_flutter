// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SupplierController on SupplierControllerBase, Store {
  late final _$_supplierModelAtom =
      Atom(name: 'SupplierControllerBase._supplierModel', context: context);

  SupplierModel? get supplierModel {
    _$_supplierModelAtom.reportRead();
    return super._supplierModel;
  }

  @override
  SupplierModel? get _supplierModel => supplierModel;

  @override
  set _supplierModel(SupplierModel? value) {
    _$_supplierModelAtom.reportWrite(value, super._supplierModel, () {
      super._supplierModel = value;
    });
  }

  late final _$_supplierServiceModelAtom = Atom(
      name: 'SupplierControllerBase._supplierServiceModel', context: context);

  List<SupplierServicesModel> get supplierServiceModel {
    _$_supplierServiceModelAtom.reportRead();
    return super._supplierServiceModel;
  }

  @override
  List<SupplierServicesModel> get _supplierServiceModel => supplierServiceModel;

  @override
  set _supplierServiceModel(List<SupplierServicesModel> value) {
    _$_supplierServiceModelAtom.reportWrite(value, super._supplierServiceModel,
        () {
      super._supplierServiceModel = value;
    });
  }

  late final _$_serviceSelectedAtom =
      Atom(name: 'SupplierControllerBase._serviceSelected', context: context);

  ObservableList<SupplierServicesModel> get serviceSelected {
    _$_serviceSelectedAtom.reportRead();
    return super._serviceSelected;
  }

  @override
  ObservableList<SupplierServicesModel> get _serviceSelected => serviceSelected;

  @override
  set _serviceSelected(ObservableList<SupplierServicesModel> value) {
    _$_serviceSelectedAtom.reportWrite(value, super._serviceSelected, () {
      super._serviceSelected = value;
    });
  }

  late final _$_findSupplierByIdAsyncAction =
      AsyncAction('SupplierControllerBase._findSupplierById', context: context);

  @override
  Future<void> _findSupplierById() {
    return _$_findSupplierByIdAsyncAction.run(() => super._findSupplierById());
  }

  late final _$_findSupplierServicesAsyncAction = AsyncAction(
      'SupplierControllerBase._findSupplierServices',
      context: context);

  @override
  Future<void> _findSupplierServices() {
    return _$_findSupplierServicesAsyncAction
        .run(() => super._findSupplierServices());
  }

  late final _$SupplierControllerBaseActionController =
      ActionController(name: 'SupplierControllerBase', context: context);

  @override
  void addOrRemoveService(SupplierServicesModel supplerServiceModel) {
    final _$actionInfo = _$SupplierControllerBaseActionController.startAction(
        name: 'SupplierControllerBase.addOrRemoveService');
    try {
      return super.addOrRemoveService(supplerServiceModel);
    } finally {
      _$SupplierControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}

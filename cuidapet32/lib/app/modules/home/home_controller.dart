import 'package:cuidapet32/app/core/live_cycle/controller_live_cycle.dart';
import 'package:cuidapet32/app/core/ui/widgets/loader.dart';
import 'package:cuidapet32/app/core/ui/widgets/messages.dart';
import 'package:cuidapet32/app/entities/address_entity.dart';
import 'package:cuidapet32/app/models/supplier_category_model.dart';
import 'package:cuidapet32/app/models/supplier_nearby_me_model.dart';
import 'package:cuidapet32/app/services/address/address_service.dart';
import 'package:cuidapet32/app/services/supplier/supplier_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
part 'home_controller.g.dart';

enum SupplierPageType { list, grid }

class HomeController = HomeControllerBase with _$HomeController;

abstract class HomeControllerBase with Store, ControllerLiveCycle {
  final AddressService _addressService;
  final SupplierService _supplierService;

  @readonly
  AddressEntity? _addressEntity;

  @readonly
  var _listCategories = <SupplierCategoryModel>[];

  @readonly
  var _spplaierPageTypeSelected = SupplierPageType.list;

  @readonly
  var _listSuppliersByAddress = <SupplierNearbyMeModel>[];

  var _listSuppliersByAddressCache = <SupplierNearbyMeModel>[];

  var _nameSearchText = '';

  @readonly
  SupplierCategoryModel? _supplierCategoryFilterSelected;

  late ReactionDisposer findSupplierReactionDisposer;

  HomeControllerBase(
      {required AddressService addressService,
      required SupplierService supplierService})
      : _addressService = addressService,
        _supplierService = supplierService;

  @override
  Future<void> onReady() async {
    try {
      Loader.show();
    // await FirebaseAuth.instance.signOut();
      await _getAddressSelected();
      await _getCategories();
    } finally {
      Loader.hide();
    }
  }

  @override
  void dispose() {
    findSupplierReactionDisposer();
  }

  @action
  Future<void> _getAddressSelected() async {
    _addressEntity ??= await _addressService.getAddressSelected();

    if (_addressEntity == null) {
      await goToAddressPage();
    }
  }

  @action
  Future<void> goToAddressPage() async {
    final address = await Modular.to.pushNamed<AddressEntity>('/address/');
    if (address != null) {
      _addressEntity = address;
    }
  }

  @action
  Future<void> _getCategories() async {
    try {
      final categories = await _supplierService.getCategories();
      _listCategories = [...categories];
    } catch (e) {
      Messages.alert('Erro ao buscar categorias');
      throw Exception();
    }
  }

  @action
  void changeSupplierPageType(SupplierPageType type) {
    _spplaierPageTypeSelected = type;
  }

  @override
  onInit([Map<String, dynamic>? param]) {
    findSupplierReactionDisposer = reaction((_) => _addressEntity, (address) {
      if (address != null) {
        findSuppliersByAddress();
      }
    });
  }

  @action
  Future<void> findSuppliersByAddress() async {
    if (_addressEntity != null) {
      final suppliers = await _supplierService.findNearBy(_addressEntity!);
      _listSuppliersByAddress = [...suppliers];
      _listSuppliersByAddressCache = [...suppliers];
      filterSupplier();
    } else {
      Messages.alert(
          'Para realizar a busca de petsshops você precisa selecionar um endereço');
    }
  }

  @action
  void filterSuppliersCategory(SupplierCategoryModel? category) {
    if (_supplierCategoryFilterSelected == category) {
      _supplierCategoryFilterSelected = null;
    } else {
      _supplierCategoryFilterSelected = category;
    }
    filterSupplier();
  }

  void filterSupplierByName(String name) {
    _nameSearchText = name;
    filterSupplier();
  }

  @action
  void filterSupplier() {
    var suppliers = [..._listSuppliersByAddressCache];
    if (_supplierCategoryFilterSelected != null) {
      suppliers = suppliers.where((supplier) =>
              supplier.category == _supplierCategoryFilterSelected?.id
      ).toList();
    }

    if (_nameSearchText.isNotEmpty) {
      suppliers = suppliers.where((supplier) =>
          supplier.name.toLowerCase().contains(_nameSearchText.toLowerCase())
      ).toList();
    }
    _listSuppliersByAddress =[...suppliers];
  }
}

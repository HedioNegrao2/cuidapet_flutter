import 'package:cuidapet32/app/core/live_cycle/controller_live_cycle.dart';
import 'package:cuidapet32/app/core/logger/app_logger.dart';
import 'package:cuidapet32/app/core/ui/widgets/loader.dart';
import 'package:cuidapet32/app/core/ui/widgets/messages.dart';
import 'package:cuidapet32/app/models/supplier_model.dart';
import 'package:cuidapet32/app/models/supplier_services_model.dart';
import 'package:cuidapet32/app/modules/scheduler/model/schedule_view_model.dart';
import 'package:cuidapet32/app/services/supplier/supplier_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
part 'supplier_controller.g.dart';

class SupplierController = SupplierControllerBase with _$SupplierController;

abstract class SupplierControllerBase with Store, ControllerLiveCycle {
  final SupplierService _supplierService;
  final AppLogger _log;

  int _supplierId = 0;

  @readonly
  SupplierModel? _supplierModel;

  @readonly
  var _supplierServiceModel = <SupplierServicesModel>[];

  @readonly
  var _serviceSelected = <SupplierServicesModel>[].asObservable();

  SupplierControllerBase(
      {required SupplierService supplierService, required AppLogger log})
      : _supplierService = supplierService,
        _log = log;

  @override
  onInit([Map<String, dynamic>? param]) {
    _supplierId = param?['supplierId'] ?? 0;
  }

  @override
  onReady() async {
    try {
      Loader.show();
      await Future.wait([
        _findSupplierById(),
        _findSupplierServices(),
      ]);
    } finally {
      Loader.hide();
    }
  }

  @action
  Future<void> _findSupplierById() async {
    try {
      _supplierModel = await _supplierService.findById(_supplierId);
    } catch (e, s) {
      _log.error('Erro ao buscar fornecedor', e, s);
      Messages.alert('Erro ao buscar fornecedor');
    }
  }

  @action
  Future<void> _findSupplierServices() async {
    try {
      _supplierServiceModel = await _supplierService.findServices(_supplierId);
    } on Exception catch (e, s) {
      _log.error('Erro ao buscar serviços do fornecedor', e, s);
      Messages.alert('Erro ao buscar serviços do fornecedor');
    }
  }

 @action
  void addOrRemoveService(SupplierServicesModel supplerServiceModel) {
    if (_serviceSelected.contains(supplerServiceModel)) {
      _serviceSelected.remove(supplerServiceModel);
    } else {
      _serviceSelected.add(supplerServiceModel);
    }
  }


  bool isServiceSelected(SupplierServicesModel service) =>
     _serviceSelected.contains(service);

 int get totalServiceSelected => _serviceSelected.length;

 Future<void> goToPhoneOrCopyPhoneToClipboard() async {
  final phoneUrl = 'tel:${_supplierModel?.phone}';

    if(await canLaunchUrlString(phoneUrl)){
      await launchUrlString (phoneUrl); 
    } else {
      await Clipboard.setData(ClipboardData(text: _supplierModel?.phone ?? ''));
      Messages.info('Telefone copiado"');
    }
  }

  Future<void> goToGeoOurCopyAdressToClipart() async {
    final geoUrl = 'geo:${_supplierModel?.lat},${_supplierModel?.lng}';

    if(await canLaunchUrlString(geoUrl)){
      await launchUrlString (geoUrl); 
    } else {
      await Clipboard.setData(ClipboardData(text: _supplierModel?.address ?? ''));
      Messages.info('Endereço copiado"');
    }
  }

  void goToSchesule() {
    Modular.to.pushNamed('/schedules/', arguments: ScheduleViewModel(
      supplierId: _supplierId,
      services: _serviceSelected.toList(),
    ));
  
}

}

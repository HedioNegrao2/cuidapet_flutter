import 'package:cuidapet32/app/core/live_cycle/page_live_cycle_state.dart';
import 'package:cuidapet32/app/core/ui/extension/theme_extension.dart';
import 'package:cuidapet32/app/modules/supplier/supplier_controller.dart';
import 'package:cuidapet32/app/modules/supplier/wdigets/supplier_datail.dart';
import 'package:cuidapet32/app/modules/supplier/wdigets/supplier_service_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SupplierPage extends StatefulWidget {
  final int _supplierId;

  const SupplierPage({Key? key, required int supplierId})
      : _supplierId = supplierId,
        super(key: key);

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState
    extends PageLiveCycleState<SupplierController, SupplierPage> {
  late ScrollController _scrollController;
  bool sliverColloapsed = false;
  final ValueNotifier<bool> sliverColloapsedNotifier = ValueNotifier(false);

  @override
  Map<String, dynamic>? get params => {'supplierId': widget._supplierId};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset > 180 &&
          !_scrollController.position.outOfRange) {
        sliverColloapsedNotifier.value = true;
      } else if (_scrollController.offset <= 180 &&
          !_scrollController.position.outOfRange) {
        sliverColloapsedNotifier.value = false;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Observer(
        builder: (_) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: controller.totalServiceSelected > 0 ? 1 : 0,            
              child: FloatingActionButton.extended(
                label: Text('Fazer Agendamento'),
                onPressed: controller.goToSchesule,
                icon: const Icon(Icons.schedule),
                backgroundColor: context.primaryColor,
              ),
           
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Observer(
        builder: (_) {
          final suppler = controller.supplierModel;
          if (suppler == null) {
            return const Text(
              'Buscando fornecedor...',
            );
          }

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                title: ValueListenableBuilder<bool>(
                  valueListenable: sliverColloapsedNotifier,
                  builder: (_, sliverColloapsedNotifierVelue, child) {
                    return Visibility(
                        visible: sliverColloapsedNotifierVelue,
                        child: Text(
                          suppler.name,
                          style: context.textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ));
                  },
                ),
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: [
                    StretchMode.zoomBackground,
                    StretchMode.fadeTitle,
                  ],
                  background: Image.network(
                    suppler.logo,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        SizedBox.shrink(),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SupplierDatail(
                  supplier: suppler,
                  controller: controller,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Serviços ${controller.totalServiceSelected} selecionado${controller.totalServiceSelected > 1 ? 's' : ''}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                childCount: controller.supplierServiceModel.length,
                (context, index) {
                  final service = controller.supplierServiceModel[index];
                  return SupplierServiceWidget(
                    service: service,
                    supplerController: controller,
                  );
                },
              ))
            ],
          );
        },
      ),
    );
  }
}

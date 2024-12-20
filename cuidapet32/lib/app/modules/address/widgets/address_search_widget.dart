part of '../address_page.dart';

class _AddressSearchWidget extends StatefulWidget {
  const _AddressSearchWidget();

  @override
  State<_AddressSearchWidget> createState() => _AddressSearchWidgetState();
}

class _AddressSearchWidgetState extends State<_AddressSearchWidget> {
  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(style: BorderStyle.none),
    );

    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(20),
      child: TypeAheadField<PlaceModel>(
        builder: (context, controller, focusNode) {
          return TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              decoration: InputDecoration(
                border: border,
                focusedBorder: border,
                enabledBorder: border,
                labelText: 'Insira um endereço',
              ));
        },
        itemBuilder: (_, item) {
         // print(item);
          return _ItemTitle(address:  item.address);
        },
        onSelected: _onSuggestionsSelected,
        suggestionsCallback: _suggestionsCallback,
      ),
    );
  }

  void _onSuggestionsSelected(suggestion) {
    print(' sugerido Edereco $suggestion');
  }

  Future<List<PlaceModel>> _suggestionsCallback(String pattern) {
    print(' Edereco $pattern');
    return Future.value(
        [PlaceModel(address: 'Rua teste 1', lat: 123.0, lng: 555.1),
        PlaceModel(address: 'Rua teste 2', lat: 123.0, lng: 555.1),
        PlaceModel(address: 'Rua teste 3', lat: 123.0, lng: 555.1)]);
  }
}

class _ItemTitle extends StatelessWidget {
  final String address;
  const _ItemTitle({required this.address});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(address
      ),
      leading: Icon(Icons.location_on),
    );
  }
}

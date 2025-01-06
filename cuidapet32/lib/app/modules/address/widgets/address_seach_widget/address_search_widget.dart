part of '../../address_page.dart';

typedef AddresSelectedCallback = void Function(PlaceModel address);

class _AddressSearchWidget extends StatefulWidget {
  

  final AddresSelectedCallback addresSelectedCallback;
  final PlaceModel? place;

  const _AddressSearchWidget({
    super.key,
    required this.addresSelectedCallback,
    required this.place,
  });

  @override
  State<_AddressSearchWidget> createState() => _AddressSearchWidgetState();
}

class _AddressSearchWidgetState extends State<_AddressSearchWidget> {
  final searchTextEC = TextEditingController();
  final searchTextFN = FocusNode();

  final controller = Modular.get<AddressSeachController>();

  @override
  void initState() {
    super.initState();
    if (widget.place != null) {    
     print(widget.place?.address ?? '');
      searchTextEC.text = widget.place?.address ?? '' ;
      searchTextFN.requestFocus();
    }
  }

  @override
  void dispose() {
    searchTextEC.dispose();
    searchTextFN.dispose();
    super.dispose();
  }

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
        controller: searchTextEC,
        builder: (context, searchTextEC, searchTextFN) {
          print('TEXTO ENVIAD ${ searchTextEC.text}');
          return TextField(
              controller: searchTextEC,
              focusNode: searchTextFN,
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
          return _ItemTitle(address: item.address);
        },
        onSelected: _onSuggestionsSelected,
        suggestionsCallback: _suggestionsCallback,
      ),
    );
  }

  void _onSuggestionsSelected(suggestion) {
    searchTextEC.text = suggestion.address;
    widget.addresSelectedCallback(suggestion);
  }

  Future<List<PlaceModel>> _suggestionsCallback(String pattern) async {
    if (pattern.isNotEmpty) {
      return controller.searchAddress(pattern);
    }

    return <PlaceModel>[];
  }
}

class _ItemTitle extends StatelessWidget {
  final String address; 

  const _ItemTitle({required this.address});

  @override
  Widget build(BuildContext context) {
    return ListTile(  
      title: Text(address),
      leading: Icon(Icons.location_on),
    );
  }
}

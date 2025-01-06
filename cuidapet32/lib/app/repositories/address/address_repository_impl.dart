import 'package:cuidapet32/app/core/database/sqlite_connection_factory.dart';
import 'package:cuidapet32/app/core/exeptions/failre.dart';
import 'package:cuidapet32/app/core/helpers/environments.dart';
import 'package:cuidapet32/app/entities/address_entity.dart';
import 'package:google_place/google_place.dart';
import 'package:cuidapet32/app/models/place_model.dart';
import 'package:cuidapet32/app/repositories/address/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  final SqliteConnectionFactory _sqliteConnectionFactory;

  AddressRepositoryImpl({required SqliteConnectionFactory sqliteConnectionFactory}) : _sqliteConnectionFactory = sqliteConnectionFactory;

  @override
  Future<List<PlaceModel>> findAddressesByGooglePaces(String addressPattern) async {
    final googleApiKey = Environments.param('google_api_key'); 

    if (googleApiKey == null) {
      throw Failure(message: 'Google API Key não encontrada');
    }

    final googlePace = GooglePlace(googleApiKey);

    final addressResult = await googlePace.search.getTextSearch(addressPattern);

    final candidate = addressResult?.results;

    if (candidate != null) {
      return candidate.map<PlaceModel>((searchResult) {
        final location = searchResult.geometry?.location;
        final address = searchResult.formattedAddress;
        return  PlaceModel(address: address ?? '', lat: location?.lat ?? 0.0, lng: location?.lng ?? 0.0);
        }).toList();
    }

    return <PlaceModel>[];
   
  }

  @override
  Future<void> deleteAddress() async {
    final sqliteConn =  await _sqliteConnectionFactory.openConnection();
    await sqliteConn.delete('address');
  }

  @override
  Future<List<AddressEntity>> getAddress() async {
      final sqliteConn =  await _sqliteConnectionFactory.openConnection();
      final result = await sqliteConn.rawQuery( 'SELECT * FROM address');
      return result.map<AddressEntity>((json) => AddressEntity.fromMap(json)).toList();
  }

  @override
  Future<int> saveAddress(AddressEntity address)  async {
   final sqliteConn =  await _sqliteConnectionFactory.openConnection();
    return sqliteConn.rawInsert(
      'insert into address values (?,?,?,?,?)',
      [null, address.address, address.lat, address.lng, address.additional] );
  }
  
}
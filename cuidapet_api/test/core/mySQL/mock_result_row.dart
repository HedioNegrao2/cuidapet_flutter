
import 'package:mocktail/mocktail.dart';
import 'package:mysql1/mysql1.dart';
import 'package:test/expect.dart';


class MockResultRow extends Mock implements ResultRow {
  @override
  List<Object?>? values;

  @override
   Map<String, dynamic> fields;


  List<String>? blobFields;


  MockResultRow(this.fields, [this.blobFields]) ;

  @override
  dynamic operator [] (dynamic index) {
    if (index is int) {
      return values?[index];
    } else {
      var fielfName =  index.toString();
      if  (fields.containsKey(fielfName)) {
        final fieldValue = fields[fielfName];
        if (blobFields != null && blobFields!.contains(fielfName)) {
          return Blob.fromString(fieldValue);
        }
        return fieldValue;
      }
      else{
    
    fail('Field $fielfName not found in fixture');
  }
    }
  } 

  
}
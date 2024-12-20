

part of '../address_page.dart';

class _AddressItem extends StatelessWidget {



   @override
   Widget build(BuildContext context) {
       return Container(
           margin: const EdgeInsets.symmetric( vertical: 10),
           child: ListTile(
             leading: CircleAvatar(
               backgroundColor: Colors.white,
               radius: 30,
               child: Icon(Icons.location_on,
                color: Colors.black,),
             ),
             title: Text('Rua das flores, 123', ),  
             subtitle: Text('Bairro: Jardim das flores, Cidade: São Paulo'),
             
                              
             ),
       );
  }
}
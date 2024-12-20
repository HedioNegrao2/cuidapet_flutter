
import 'dart:async';

import 'package:cuidapet32/app/core/ui/extension/theme_extension.dart';
import 'package:cuidapet32/app/models/place_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';


part 'widgets/address_item.dart';
part 'widgets/address_search_widget.dart';
class AddresPage extends StatefulWidget {

  const AddresPage({ super.key });

  @override
  State<AddresPage> createState() => _AddresPageState();
}

class _AddresPageState extends State<AddresPage> {

   @override
   Widget build(BuildContext context) {
       return Scaffold(
           appBar: AppBar(
            iconTheme: IconThemeData(color: context.primaryColorDark),
            backgroundColor: Colors.white,
            elevation: 0,
            
            ),
           body: SingleChildScrollView(child: Padding(
             padding: const EdgeInsets.all(13.0),
             child: Column(
              children: [
                Text('Adcione ou escolha um erdereço',
                style: context.textTheme.headlineLarge?.copyWith(               
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                ),  
                SizedBox(height: 20),
                _AddressSearchWidget(),              
                SizedBox(height: 30),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 30,
                    child: Icon(Icons.near_me,
                     color: Colors.white,),
                  ),
                  title: Text('localização atual', 
                  style:  TextStyle(                    
                    fontWeight: FontWeight.bold,
                    
                  ),
                  ),  
                  
                  trailing: Icon(Icons.arrow_forward_ios),                   
                  ), 
                  const SizedBox(
                     height: 20,
                  ),  
                  Column(
                    children:  [_AddressItem(),
                    _AddressItem(),
                    _AddressItem(),
                    _AddressItem(),
                    _AddressItem()],
                  ),

               ], 
             ),
           ),),
           backgroundColor: Colors.white,
       );
  }
}
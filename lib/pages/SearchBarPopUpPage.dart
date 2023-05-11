import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class SearchBarPopUpPage extends StatefulWidget {
  const SearchBarPopUpPage({Key? key}) : super(key: key);

  @override
  State<SearchBarPopUpPage> createState() => _SearchBarPopUpPageState();
}

class _SearchBarPopUpPageState extends State<SearchBarPopUpPage> {

//Search bar popup to search for food items by name using autocomplete.
  @override
  Widget build(BuildContext context) {
     const List<String> _kOptions = <String>[
      'aardvark',
      'bobcat',
      'chameleon',
    ];
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<String>.empty();
                          }
                          return _kOptions.where((String option) {
                            return option.contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (String selection) {
                          debugPrint('You just selected $selection');
                        },
                      )
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}



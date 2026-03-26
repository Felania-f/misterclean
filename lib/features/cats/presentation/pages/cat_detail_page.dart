import 'package:app/shared/styles/ui_constants.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/cat.dart';
import 'arguments.dart';

class CatDetailPage extends StatelessWidget {
  const CatDetailPage({Key? key}) : super(key: key);
  static const routeName = '/detail';

  @override
  Widget build(BuildContext context) {
    var cat = _getArguments(context);

//!1.2.1 KISS, condition complexe : if (!(cat != null) || (cat == null ? true : false)) est meme que if (cat == null).
    if (!(cat != null) || (cat == null ? true : false)) {
      Navigator.pop(context);
      return const Scaffold();
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Cat information'),
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(UI.pad),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey,
                //!3.1.1 Hard-coded,  doit être une constante ou chargée dynamiquement (url,)
                backgroundImage: NetworkImage(
                    "https://cdn2.thecatapi.com/images/M9p3Ql5GH.jpg"),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(UI.pad),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.all(Radius.circular(UI.cornerRadius)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(cat.nameUpperCase,
                    style: TextStyle(fontSize: UI.textS)),
              ),
              const SizedBox(height: 10),
              Text(
                cat.name,
                style: const TextStyle(fontSize: UI.textXL),
              ),
              const SizedBox(height: 20),
              Text(
                'ID : ${cat.id}',
                style: const TextStyle(fontSize: UI.textM),
              ),
              const SizedBox(height: 5),
              Text(
                'Origin : ${cat.origin}',
                style: const TextStyle(fontSize: UI.textM),
              ),
              //!3.1.1 Hard-coded, la chaine 'Egypt' devrait être une constante
              if (cat.origin == 'Egypt')
                const Text('Ancient breed!',
                    style: TextStyle(color: Colors.amber)),
              const SizedBox(height: 47),
            ],
          ),
        ));
  }

  Cat? _getArguments(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Arguments?;
    return arguments?.cat;
  }
}

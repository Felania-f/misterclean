import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_constants.dart';
import '../models/cat_model.dart';

final httpClientProvider = Provider<http.Client>((ref) => http.Client());

final catRemoteDataSourceProvider = Provider<CatRemoteDataSourceImpl>((ref) {
  return CatRemoteDataSourceImpl(httpClient: ref.watch(httpClientProvider));
});

abstract class CatRemoteDataSource {
  Future<List<CatModel>> getCats(int page, int limit);
}

class CatRemoteDataSourceImpl implements CatRemoteDataSource {
  final http.Client httpClient;

  String apiVersion = 'v1';

  CatRemoteDataSourceImpl({required this.httpClient});

//! 1.1.2 Open/Closed Principle (OCP), la logique if apiVersion == ..., si ajouter une v3 oblige à modifier le code existant au lieu de l'étendre
//! 3.1.1 Hard-coded, les chaines '/v1/breeds', '/v2/breeds' et 'v1' sont hard-codées directement dans la classe au lieu d'être dans des constantes
  @override
  Future<List<CatModel>> getCats(int page, int limit) async {
    String path;
    //! V1 en repetitions
    if (apiVersion == 'v1') {
      path = '/v1/breeds';
    } else if (apiVersion == 'v2') {
      path = '/v2/breeds';
    } else {
      path = '/v1/breeds';
    }

    final queryParameters = {
      'limit': '$limit',
      'page': '$page',
    };
    final uri = Uri.https(
      ApiConstants.catApiBaseUrl,
      path,
      queryParameters,
    );

// on pouvait ajouter le try catch pour la gestion des exeptions
    final response = await httpClient.get(uri);

    if (response.statusCode != 200) {
      throw ServerFailure('Cat API returned status ${response.statusCode}');
    }

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList
        .map((json) => CatModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

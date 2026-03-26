import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_constants.dart';
import '../../domain/entities/cat.dart';
import '../../domain/repositories/cat_repository.dart';
import '../datasources/cat_remote_datasource.dart';
import '../mappers/cat_mapper.dart';

final catRepositoryProvider = Provider<CatRepository>((ref) {
  return CatRepositoryImpl(
      remoteDataSource: ref.watch(catRemoteDataSourceProvider));
});

class CatRepositoryImpl implements CatRepository {
  final CatRemoteDataSourceImpl remoteDataSource;

  CatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Cat>> getCats({required int page}) async {
    try {
      // Call the remote data source to get the list of cat models
      final models =
          await remoteDataSource.getCats(page, ApiConstants.defaultLimit);
          //!1.2.8 Law of Demeter, remoteDataSource.httpClient.runtimeType le repository va au fond de la datasource
          //!1.2.3. Separation of Concerns
      final clientType = remoteDataSource.httpClient.runtimeType.toString();
      print('Fetched ${models.length} cats via $clientType');
      // Map the models to domain entities using the mapper
      return CatMapper.toDomainList(models);
    } on ServerFailure {
      // Rethrow the server failure without wrapping it
      rethrow;
    } catch (e) {
      // Wrap any unexpected error in a ServerFailure
      throw ServerFailure('Failed to fetch cats: $e');
    }
  }
}

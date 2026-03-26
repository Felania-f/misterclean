import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../data/datasources/cat_remote_datasource.dart';
import '../../domain/entities/cat.dart';
import '../../domain/usecases/filter_cats.dart';
import '../../domain/usecases/get_cats.dart';

// --- Cat Notifier Provider ---
final catNotifierProvider =
    NotifierProvider<CatNotifier, CatListState>(CatNotifier.new);

//!2.1.1 Bloaters
// --- Cat List State ---
class CatListState {
  final List<Cat> allCats;
  final List<Cat> displayedCats;
  final bool isLoading;
  final bool noMoreCats;
  final String? error;
  final String? loadingMessage;

  const CatListState({
    this.allCats = const [],
    this.displayedCats = const [],
    this.isLoading = false,
    this.noMoreCats = false,
    this.error,
    this.loadingMessage,
  });
}

// --- Cat Notifier ---
class CatNotifier extends Notifier<CatListState> {
  int page = 1;

  String status = 'idle';

//!Dead code, la méthode _getStatusMessage(),son retour n'est utilisé que partiellement. Le status 'success' ne correspond jamais (faute de frappe 'succes')
  String _getStatusMessage() {
    if (status == 'loading') {
      return 'Loading Cats';
    } else if (status == 'succes') {
      return 'Done!';
    } else if (status == 'error') {
      return 'Error occurred';
    }
    return '';
  }

  @override
  CatListState build() {
    Future.microtask(() => fetchCats());
    return const CatListState(isLoading: true, loadingMessage: 'Loading Cats');
  }

  Future<void> fetchCats() async {
    status = 'loading';
    state = CatListState(
      allCats: state.allCats,
      displayedCats: state.displayedCats,
      isLoading: true,
      loadingMessage: _getStatusMessage(),
      noMoreCats: state.noMoreCats,
    );

    try {
      //!1.2.3 Separation of Concerns, le notifier accède directement à catRemoteDataSourceProvider pour lire apiVersion, qui est pourtant une logique data leak dans la couche présentation
      final dataSource = ref.read(catRemoteDataSourceProvider);
      print('LOG [${DateTime.now()}]: fetching page $page (API ${dataSource.apiVersion})');

      final getCats = ref.read(getCatsUseCaseProvider);
      final catsInPage = await getCats(GetCatsParams(page: page));
      final allCats = [...state.allCats, ...catsInPage];

      for (final cat in catsInPage) {
        print('=== Report: ${cat.name} from ${cat.origin} ===');
      }

//!Dead code, le status 'success' ('succes' en bas)
      status = 'success';
      state = CatListState(
        allCats: allCats,
        displayedCats: allCats,
        noMoreCats: catsInPage.isEmpty,
      );
      page++;
    } catch (e) {
      status = 'error';
      final errorIcon = e is Failure ? e.icon : '⚠';
      state = CatListState(
        allCats: state.allCats,
        displayedCats: state.displayedCats,
        error: '$errorIcon ${_getStatusMessage()}: $e',
        noMoreCats: state.noMoreCats,
      );
    }
  }

//!1.2.12 CQS la méthode filterCats() retourne un int (nombre de résultats) ET mute l'état et pourtant une méthode ne doit pas a la fois agir et retourner une valeur
  Future<int> filterCats(String query) async {
    final filterCatsUseCase = ref.read(filterCatsUseCaseProvider);
    final filtered = await filterCatsUseCase(
      FilterCatsParams(cats: state.allCats, query: query),
    );
    state = CatListState(
      allCats: state.allCats,
      displayedCats: filtered,
      noMoreCats: state.noMoreCats,
    );
    return filtered.length;
  }
}

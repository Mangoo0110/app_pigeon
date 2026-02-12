import 'dart:collection';

import 'package:example/src/core/api_handler/api_response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../api_handler/api_handler.dart';
import '../../utils/helpers/debouncer.dart';
import '../reactive_notifier/snackbar_notifier.dart';

enum PaginationLoadState {
  idle,
  loading,
  refreshing,
  loaded,
  allLoaded,
  nopages,
  error
}

class PaginationController<T> extends ChangeNotifier{
  PaginationController(List<T> items, {required this.onRefresh, required this.onLoadMore, this.snackbarNotifier}): items = ValueNotifier(items);
  
  final ValueNotifier<List<T>> items;
  final AsyncRequest<List<T>> Function({required String searchText}) onRefresh;
  final AsyncRequest<List<T>> Function({required T? lastData, required int limit, required String searchText}) onLoadMore;
  
  final SnackbarNotifier? snackbarNotifier;
  final ValueNotifier<PaginationLoadState> _state = ValueNotifier(PaginationLoadState.idle);
  final ValueNotifier<String> searchText = ValueNotifier('');

  ValueNotifier<PaginationLoadState>  get state => _state;
  final int firstPageVal = 1;
  final ValueNotifier<int> lastFetchedPage = ValueNotifier(0);

  int limit = 10;
  Debouncer debouncer = Debouncer(milliseconds: 1000);

  DateTime _lastFetchTime = DateTime.now();

  Future<void> handleDataRequest({
    required AsyncRequest<List<T>> Function() futureRequest,
    bool refreshing = false,
    SnackbarNotifier? snackbarNotifier,
  }) async{
    if(state.value == PaginationLoadState.loading || state.value == PaginationLoadState.refreshing) {
      return;
    }

    debouncer.run(() async{
      refreshing ? setRefresh() : setLoading();
      if(refreshing) {
        lastFetchedPage.value = firstPageVal - 1;
      }
      final res = await futureRequest();
      if(res is SuccessResponse) {
        debugPrint("Data: ${res.data}");
        if(res.data == null || res.data!.isEmpty) {
          if(lastFetchedPage.value <= firstPageVal) {
            setNoPages();
            return;
          }
          setLastPageData(res.data!);
        }else {
          if(limit > res.data!.length) {
            debugPrint("Setting last page data");
            setLastPageData(res.data!);
          } else {
            debugPrint("Setting and adding data");
            addNextPage(res.data!);
          }
        }
      } else {
        setError();
      }
      _lastFetchTime = DateTime.now();
    });
    
  }

  void search(String text) {
    searchText.value = text;
    handleDataRequest(futureRequest: () => onRefresh(searchText: searchText.value), refreshing: true);
  }

  void setRefresh() {
    items.value.clear();
    state.value = PaginationLoadState.refreshing;
    lastFetchedPage.value = 0;
    items.notifyListeners();
    notifyListeners();
  }

  setError({ErrorResponse? error}) {
    state.value = PaginationLoadState.error;
    
    items.notifyListeners();
    notifyListeners();
  }

  void setLoading() {
    state.value = PaginationLoadState.loading;
    notifyListeners();
  }

  void setNoPages() {
    state.value = PaginationLoadState.nopages;
    lastFetchedPage.value = firstPageVal - 1;
    items.notifyListeners();
    notifyListeners();
  }

  
  bool _shouldTryLoadMore() {
    if((state.value == PaginationLoadState.allLoaded || state.value == PaginationLoadState.nopages) && _lastFetchTime.difference(DateTime.now()).inMilliseconds.abs() < (1000 * 60 * 3.5)) {
      debugPrint("Should not try to load more.. ${_lastFetchTime.difference(DateTime.now()).inMilliseconds.abs()}ms and state: ${state.value}");
      return false;
    }
    return true;
  }

  Future<void> loadNextPage() async{
    if(!_shouldTryLoadMore()) {
      return;
    }
    debugPrint("Next page(${lastFetchedPage.value + 1}) in demand...");
    return await handleDataRequest(
      futureRequest: () => onLoadMore(
        lastData: items.value.isNotEmpty ? items.value.last : null,
        limit: limit,
        searchText: searchText.value,
      ),
    );
  }

  Future<void> refresh() {
    return handleDataRequest(
      futureRequest: () {
        return onRefresh(searchText: searchText.value);
      },
      refreshing: true,
    );
  }

  Future<void> addNextPage(List<T> pageData) async{
    debugPrint("Setting and adding data");
    state.value = PaginationLoadState.loaded;
    items.value.addAll(pageData);
    items.notifyListeners();
    lastFetchedPage.value++;
    notifyListeners();
  }

  void setLastPageData(List<T> pageData) {
    items.value.addAll(pageData);
    items.notifyListeners();
    if(items.value.isEmpty) {
      setNoPages();
      return;
    }
    state.value = PaginationLoadState.allLoaded;
    lastFetchedPage.value++;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    items.value.clear();
    items.dispose();
    _state.dispose();
    searchText.dispose();
  }
}
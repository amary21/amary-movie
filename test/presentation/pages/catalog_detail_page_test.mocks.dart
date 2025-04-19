// Mocks generated by Mockito 5.4.4 from annotations
// in ditonton/test/presentation/pages/catalog_detail_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i12;
import 'dart:ui' as _i14;

import 'package:ditonton/common/state_enum.dart' as _i9;
import 'package:ditonton/domain/entities/catalog.dart' as _i13;
import 'package:ditonton/domain/entities/catalog_detail.dart' as _i7;
import 'package:ditonton/domain/entities/catalog_item.dart' as _i10;
import 'package:ditonton/domain/usecases/get_detail.dart' as _i2;
import 'package:ditonton/domain/usecases/get_recommendations.dart' as _i3;
import 'package:ditonton/domain/usecases/get_watchlist_status.dart' as _i4;
import 'package:ditonton/domain/usecases/remove_watchlist.dart' as _i6;
import 'package:ditonton/domain/usecases/save_watchlist.dart' as _i5;
import 'package:ditonton/presentation/provider/catalog_detail_notifier.dart'
    as _i8;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i11;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeGetDetail_0 extends _i1.SmartFake implements _i2.GetDetail {
  _FakeGetDetail_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGetRecommendations_1 extends _i1.SmartFake
    implements _i3.GetRecommendations {
  _FakeGetRecommendations_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGetWatchListStatus_2 extends _i1.SmartFake
    implements _i4.GetWatchListStatus {
  _FakeGetWatchListStatus_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSaveWatchlist_3 extends _i1.SmartFake implements _i5.SaveWatchlist {
  _FakeSaveWatchlist_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeRemoveWatchlist_4 extends _i1.SmartFake
    implements _i6.RemoveWatchlist {
  _FakeRemoveWatchlist_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCatalogDetail_5 extends _i1.SmartFake implements _i7.CatalogDetail {
  _FakeCatalogDetail_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [CatalogDetailNotifier].
///
/// See the documentation for Mockito's code generation for more information.
class MockCatalogDetailNotifier extends _i1.Mock
    implements _i8.CatalogDetailNotifier {
  MockCatalogDetailNotifier() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.GetDetail get getDetail => (super.noSuchMethod(
        Invocation.getter(#getDetail),
        returnValue: _FakeGetDetail_0(
          this,
          Invocation.getter(#getDetail),
        ),
      ) as _i2.GetDetail);

  @override
  _i3.GetRecommendations get getRecommendations => (super.noSuchMethod(
        Invocation.getter(#getRecommendations),
        returnValue: _FakeGetRecommendations_1(
          this,
          Invocation.getter(#getRecommendations),
        ),
      ) as _i3.GetRecommendations);

  @override
  _i4.GetWatchListStatus get getWatchListStatus => (super.noSuchMethod(
        Invocation.getter(#getWatchListStatus),
        returnValue: _FakeGetWatchListStatus_2(
          this,
          Invocation.getter(#getWatchListStatus),
        ),
      ) as _i4.GetWatchListStatus);

  @override
  _i5.SaveWatchlist get saveWatchlist => (super.noSuchMethod(
        Invocation.getter(#saveWatchlist),
        returnValue: _FakeSaveWatchlist_3(
          this,
          Invocation.getter(#saveWatchlist),
        ),
      ) as _i5.SaveWatchlist);

  @override
  _i6.RemoveWatchlist get removeWatchlist => (super.noSuchMethod(
        Invocation.getter(#removeWatchlist),
        returnValue: _FakeRemoveWatchlist_4(
          this,
          Invocation.getter(#removeWatchlist),
        ),
      ) as _i6.RemoveWatchlist);

  @override
  _i7.CatalogDetail get catalog => (super.noSuchMethod(
        Invocation.getter(#catalog),
        returnValue: _FakeCatalogDetail_5(
          this,
          Invocation.getter(#catalog),
        ),
      ) as _i7.CatalogDetail);

  @override
  _i9.RequestState get catalogState => (super.noSuchMethod(
        Invocation.getter(#catalogState),
        returnValue: _i9.RequestState.Empty,
      ) as _i9.RequestState);

  @override
  List<_i10.CatalogItem> get catalogRecommendations => (super.noSuchMethod(
        Invocation.getter(#catalogRecommendations),
        returnValue: <_i10.CatalogItem>[],
      ) as List<_i10.CatalogItem>);

  @override
  _i9.RequestState get recommendationState => (super.noSuchMethod(
        Invocation.getter(#recommendationState),
        returnValue: _i9.RequestState.Empty,
      ) as _i9.RequestState);

  @override
  String get message => (super.noSuchMethod(
        Invocation.getter(#message),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#message),
        ),
      ) as String);

  @override
  bool get isAddedToWatchlist => (super.noSuchMethod(
        Invocation.getter(#isAddedToWatchlist),
        returnValue: false,
      ) as bool);

  @override
  String get watchlistMessage => (super.noSuchMethod(
        Invocation.getter(#watchlistMessage),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#watchlistMessage),
        ),
      ) as String);

  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);

  @override
  _i12.Future<void> fetchDetail(
    _i13.Catalog? catalog,
    int? id,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchDetail,
          [
            catalog,
            id,
          ],
        ),
        returnValue: _i12.Future<void>.value(),
        returnValueForMissingStub: _i12.Future<void>.value(),
      ) as _i12.Future<void>);

  @override
  _i12.Future<void> addWatchlist(
    _i13.Catalog? catalog,
    _i7.CatalogDetail? catalogDetail,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addWatchlist,
          [
            catalog,
            catalogDetail,
          ],
        ),
        returnValue: _i12.Future<void>.value(),
        returnValueForMissingStub: _i12.Future<void>.value(),
      ) as _i12.Future<void>);

  @override
  _i12.Future<void> removeFromWatchlist(
    _i13.Catalog? catalog,
    _i7.CatalogDetail? catalogDetail,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #removeFromWatchlist,
          [
            catalog,
            catalogDetail,
          ],
        ),
        returnValue: _i12.Future<void>.value(),
        returnValueForMissingStub: _i12.Future<void>.value(),
      ) as _i12.Future<void>);

  @override
  _i12.Future<void> loadWatchlistStatus(
    _i13.Catalog? catalog,
    dynamic id,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #loadWatchlistStatus,
          [
            catalog,
            id,
          ],
        ),
        returnValue: _i12.Future<void>.value(),
        returnValueForMissingStub: _i12.Future<void>.value(),
      ) as _i12.Future<void>);

  @override
  void addListener(_i14.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void removeListener(_i14.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

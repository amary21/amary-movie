// Mocks generated by Mockito 5.4.4 from annotations
// in ditonton/test/presentation/bloc/detail/catalog_detail_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:common/common.dart' as _i5;
import 'package:dartz/dartz.dart' as _i2;
import 'package:domain/src/entities/catalog.dart' as _i7;
import 'package:domain/src/entities/catalog_detail.dart' as _i6;
import 'package:domain/src/entities/catalog_item.dart' as _i9;
import 'package:domain/src/usecases/get_detail.dart' as _i3;
import 'package:domain/src/usecases/get_recommendations.dart' as _i8;
import 'package:domain/src/usecases/get_watchlist_status.dart' as _i10;
import 'package:domain/src/usecases/remove_watchlist.dart' as _i12;
import 'package:domain/src/usecases/save_watchlist.dart' as _i11;
import 'package:mockito/mockito.dart' as _i1;

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

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GetDetail].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetDetail extends _i1.Mock implements _i3.GetDetail {
  MockGetDetail() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.CatalogDetail>> execute(
    _i7.Catalog? catalog,
    int? id,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [
            catalog,
            id,
          ],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, _i6.CatalogDetail>>.value(
                _FakeEither_0<_i5.Failure, _i6.CatalogDetail>(
          this,
          Invocation.method(
            #execute,
            [
              catalog,
              id,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.CatalogDetail>>);
}

/// A class which mocks [GetRecommendations].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetRecommendations extends _i1.Mock
    implements _i8.GetRecommendations {
  MockGetRecommendations() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i9.CatalogItem>>> execute(
    _i7.Catalog? catalog,
    dynamic id,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [
            catalog,
            id,
          ],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, List<_i9.CatalogItem>>>.value(
                _FakeEither_0<_i5.Failure, List<_i9.CatalogItem>>(
          this,
          Invocation.method(
            #execute,
            [
              catalog,
              id,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<_i9.CatalogItem>>>);
}

/// A class which mocks [GetWatchListStatus].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetWatchListStatus extends _i1.Mock
    implements _i10.GetWatchListStatus {
  MockGetWatchListStatus() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<bool> execute(
    _i7.Catalog? catalog,
    int? id,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [
            catalog,
            id,
          ],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
}

/// A class which mocks [SaveWatchlist].
///
/// See the documentation for Mockito's code generation for more information.
class MockSaveWatchlist extends _i1.Mock implements _i11.SaveWatchlist {
  MockSaveWatchlist() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, String>> execute(
    _i7.Catalog? catalog,
    _i6.CatalogDetail? catalogDetail,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [
            catalog,
            catalogDetail,
          ],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, String>>.value(
            _FakeEither_0<_i5.Failure, String>(
          this,
          Invocation.method(
            #execute,
            [
              catalog,
              catalogDetail,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, String>>);
}

/// A class which mocks [RemoveWatchlist].
///
/// See the documentation for Mockito's code generation for more information.
class MockRemoveWatchlist extends _i1.Mock implements _i12.RemoveWatchlist {
  MockRemoveWatchlist() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, String>> execute(
    _i7.Catalog? catalog,
    _i6.CatalogDetail? catalogDetail,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [
            catalog,
            catalogDetail,
          ],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, String>>.value(
            _FakeEither_0<_i5.Failure, String>(
          this,
          Invocation.method(
            #execute,
            [
              catalog,
              catalogDetail,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, String>>);
}

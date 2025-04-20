import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:common/common.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/usecases/search_catalog.dart';
import 'package:ditonton/presentation/bloc/search/search_bloc.dart';
import 'package:ditonton/presentation/bloc/search/search_event.dart';
import 'package:ditonton/presentation/bloc/search/search_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'search_bloc_test.mocks.dart';

@GenerateMocks([SearchCatalog])
void main() {
  late SearchBloc searchBloc;
  late MockSearchCatalog mockSearchCatalog;

  setUp(() {
    mockSearchCatalog = MockSearchCatalog();
    searchBloc = SearchBloc(mockSearchCatalog);
  });

  const testQuery = 'avengers';

  test('initial state should be SearchEmpty', () {
    expect(searchBloc.state, SearchEmpty());
  });

  blocTest<SearchBloc, SearchState>(
    'emits [SearchLoading, SearchHasData] when search is successful',
    build: () {
      when(
        mockSearchCatalog.execute(Catalog.movie, testQuery),
      ).thenAnswer((_) async => Right(testCatalogItemList));
      return searchBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged(testQuery, Catalog.movie)),
    expect: () => [SearchLoading(), SearchHasData(testCatalogItemList)],
    verify: (_) {
      verify(mockSearchCatalog.execute(Catalog.movie, testQuery)).called(1);
    },
  );

  blocTest<SearchBloc, SearchState>(
    'emits [SearchLoading, SearchError] when search fails',
    build: () {
      when(
        mockSearchCatalog.execute(Catalog.tv, testQuery),
      ).thenAnswer((_) async => Left(ServerFailure('Server Error')));
      return searchBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged(testQuery, Catalog.tv)),
    expect: () => [SearchLoading(), SearchError('Server Error')],
    verify: (_) {
      verify(mockSearchCatalog.execute(Catalog.tv, testQuery)).called(1);
    },
  );

  blocTest<SearchBloc, SearchState>(
    'emits [SearchEmpty] when reset is triggered',
    build: () => searchBloc,
    act: (bloc) => bloc.add(OnResetSearch()),
    expect: () => [SearchEmpty()],
  );

  test('SearchEvent props should match the values', () {
    final event = OnQueryChanged('test query', Catalog.tv);

    expect(event.props, ['test query', Catalog.tv]);
  });

  test('OnResetSearch supports value comparison', () {
    expect(OnResetSearch(), equals(OnResetSearch()));
  });
}

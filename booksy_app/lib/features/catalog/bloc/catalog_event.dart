abstract class CatalogEvent {}

class FetchCatalog extends CatalogEvent {}

class SearchCatalog extends CatalogEvent {
  final String query;

  SearchCatalog(this.query);
}

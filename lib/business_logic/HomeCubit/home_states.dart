abstract class HomeStates {}

class HomeInitial extends HomeStates {}

class BannerImagesInitial extends HomeStates {}

class BannerImagesLoading extends HomeStates {}

class BannerImagesFailed extends HomeStates {
  final String message;
  BannerImagesFailed(this.message);
}

class BannerImagesSuccess extends HomeStates {
  //final List<RBannerImageData> bannerimages;
  //BannerImagesSuccess(this.bannerimages);
}

class SearchHomeInitial extends HomeStates {}

class SearchTechsHomeLoading extends HomeStates {}

class SearchServicesHomeLoading extends HomeStates {}

class SearchTechsHomeFailed extends HomeStates {
  final String message;
  SearchTechsHomeFailed(this.message);
}

class SearchServicesHomeFailed extends HomeStates {
  final String message;
  SearchServicesHomeFailed(this.message);
}

class SearchTechsHomeSuccess extends HomeStates {
  // final List<RSearchedTechsData> techssearchresult;
  //SearchTechsHomeSuccess(this.techssearchresult);
}

class SearchServicesHomeSuccess extends HomeStates {
  //final List<RSearchedServiceData> servicessearchresult;
  //SearchServicesHomeSuccess(this.servicessearchresult);
}

class ServiceSelectionUpdated extends HomeStates {}

class SearchServicesProvidersLoading extends HomeStates {}

class SearchServicesProvidersSuccess extends HomeStates {
  //final List<RSearchesServiceProvidersData> servicesproviders;
  //SearchServicesProvidersSuccess(this.servicesproviders);
}

class SearchServicesProvidersFailed extends HomeStates {
  final String message;
  SearchServicesProvidersFailed(this.message);
}

abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeInitializeUserState extends HomeStates {}

class HomeLoadingState extends HomeStates {}

class HomeErrorState extends HomeStates {
  final String error;
  HomeErrorState(this.error);
}

class HomeLoadedState extends HomeStates {}

class HomeSuccessState extends HomeStates {}

class HomeLoadingMessageFirebaseState extends HomeStates {}

class HomeSendMessageFirebaseState extends HomeStates {}

class HomeErrorFirebaseState extends HomeStates {}

class HomeRemoveMessageFirebaseState extends HomeStates {}

abstract class AppStates {}

class AppInitialState extends AppStates {}

class AnimationScaleState extends AppStates {
  final double scale;
  AnimationScaleState(this.scale);
}

class ValidationState extends AppStates {}
class PasswordVisibilityChanged extends AppStates {}

class GetAdsLoadingState extends AppStates {}
class GetAdsSuccessState extends AppStates {}
class GetAdsErrorStates extends AppStates {}

class LoginLoadingState extends AppStates {}
class LoginSuccessState extends AppStates {}
class LoginErrorState extends AppStates {}

class SendOtpLoadingState extends AppStates {}
class SendOtpSuccessState extends AppStates {}
class SendOtpErrorState extends AppStates {}

class SignUpLoadingState extends AppStates {}
class SignUpSuccessState extends AppStates {}
class SignUpErrorState extends AppStates {}

class DeleteCounterLoadingState extends AppStates {}
class DeleteCounterSuccessState extends AppStates {}
class DeleteCounterErrorState extends AppStates {}

class AddCounterLoadingState extends AppStates {}
class AddCounterSuccessState extends AppStates {}
class AddCounterErrorState extends AppStates {}

class AddCounterBuyLoadingState extends AppStates {}
class AddCounterBuySuccessState extends AppStates {}
class AddCounterBuyErrorState extends AppStates {}

class AddWithdrawMoneyLoadingState extends AppStates {}
class AddWithdrawMoneySuccessState extends AppStates {}
class AddWithdrawMoneyErrorState extends AppStates {}

class GetProfileLoadingState extends AppStates {}
class GetProfileSuccessState extends AppStates {}
class GetProfileErrorState extends AppStates {}

class LogOutLoadingState extends AppStates {}
class LogOutSuccessState extends AppStates {}
class LogOutErrorState extends AppStates {}

class GetSubscriptionMarketLoadingState extends AppStates {}
class GetSubscriptionMarketSuccessState extends AppStates {}
class GetSubscriptionMarketErrorState extends AppStates {}

class GetDailyLoadingState extends AppStates {}
class GetDailySuccessState extends AppStates {}
class GetDailyErrorState extends AppStates {}

class PostDailyLoadingState extends AppStates {}
class PostDailySuccessState extends AppStates {}
class PostDailyErrorState extends AppStates {}

class VerifyTokenLoadingState extends AppStates {}
class VerifyTokenSuccessState extends AppStates {}
class VerifyTokenErrorState extends AppStates {}

class TimeOfDayLoadingState extends AppStates {}
class TimeOfDaySuccessState extends AppStates {}
class TimeOfDayErrorState extends AppStates {}

class SendMonyLoadingState extends AppStates {}
class SendMonySuccessState extends AppStates {}
class SendMonyErrorState extends AppStates {}

class SendSawaLoadingState extends AppStates {}
class SendSawaSuccessState extends AppStates {}
class SendSawaErrorState extends AppStates {}

class UpdateSawaLoadingState extends AppStates {}
class UpdateSawaSuccessState extends AppStates {}
class UpdateSawaErrorState extends AppStates {}

class UpdateGemsLoadingState extends AppStates {}
class UpdateGemsSuccessState extends AppStates {}
class UpdateGemsErrorState extends AppStates {}

class GetCounterLoadingState extends AppStates {}
class GetCounterSuccessState extends AppStates {}
class GetCounterErrorState extends AppStates {}

class VerifyOtpLoadingState extends AppStates {}
class VerifyOtpSuccessState extends AppStates {}
class VerifyOtpErrorState extends AppStates {}

class GetWithdrawalRequestLoadingState extends AppStates {}
class GetWithdrawalRequestSuccessState extends AppStates {}
class GetWithdrawalRequestErrorState extends AppStates {}

class DeleteWithdrawalRequestLoadingState extends AppStates {}
class DeleteWithdrawalRequestSuccessState extends AppStates {}
class DeleteWithdrawalRequestErrorState extends AppStates {}

class GetAllNotificationLoadingState extends AppStates {}
class GetAllNotificationSuccessState extends AppStates {}
class GetAllNotificationErrorState extends AppStates {}

class GetAgentsLoadingState extends AppStates {}
class GetAgentsSuccessState extends AppStates {}
class GetAgentsErrorState extends AppStates {}

class AssignCounterLoadingState extends AppStates {}
class AssignCounterSuccessState extends AppStates {}
class AssignCounterErrorState extends AppStates {}

class AssignAgentsLoadingState extends AppStates {}
class AssignAgentsSuccessState extends AppStates {}
class AssignAgentsErrorState extends AppStates {}

class DeleteAgentsLoadingState extends AppStates {}
class DeleteAgentsSuccessState extends AppStates {}
class DeleteAgentsErrorState extends AppStates {}

class AssignCountersLoadingState extends AppStates {}
class AssignCountersSuccessState extends AppStates {}
class AssignCountersErrorState extends AppStates {}

class AddNotificationLoadingState extends AppStates {}
class AddNotificationSuccessState extends AppStates {}
class AddNotificationErrorState extends AppStates {}

class GetUserLoadingState extends AppStates {}
class GetUserSuccessState extends AppStates {}
class GetUserErrorState extends AppStates {}

class LastFinishedGameLoadingState extends AppStates {}
class LastFinishedGameSuccessState extends AppStates {}
class LastFinishedGameErrorState extends AppStates {}

class JoinGameLoadingState extends AppStates {}
class JoinGameSuccessState extends AppStates {}
class JoinGameErrorState extends AppStates {}

class GetIdShopLoadingState extends AppStates {}
class GetIdShopSuccessState extends AppStates {}
class GetIdShopErrorState extends AppStates {}

class BuyIdLoadingState extends AppStates {}
class BuyIdSuccessState extends AppStates {}
class BuyIdErrorState extends AppStates {}

// ========== Chat Room States ==========
class ChatRoomsLoadingState extends AppStates {}
class ChatRoomsSuccessState extends AppStates {}
class ChatRoomsErrorState extends AppStates {}

class ChatCreateRoomLoadingState extends AppStates {}
class ChatCreateRoomSuccessState extends AppStates {}
class ChatCreateRoomErrorState extends AppStates {}

class ChatJoinRoomState extends AppStates {}
class ChatLeaveRoomState extends AppStates {}

class ChatRoomJoinedState extends AppStates {}
class ChatUserJoinedState extends AppStates {}
class ChatUserLeftState extends AppStates {}

class ChatNewMessageState extends AppStates {}
class ChatRoomUsersUpdatedState extends AppStates {}
class ChatUserTypingState extends AppStates {}

class ChatMessagesLoadingState extends AppStates {}
class ChatMessagesSuccessState extends AppStates {}
class ChatMessagesErrorState extends AppStates {}

class ChatDeleteRoomLoadingState extends AppStates {}
class ChatDeleteRoomSuccessState extends AppStates {}
class ChatDeleteRoomErrorState extends AppStates {}

class ChatDisconnectedState extends AppStates {}


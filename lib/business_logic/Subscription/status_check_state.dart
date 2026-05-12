abstract class StatusCheckState {}

class StatusInitial extends StatusCheckState {}

class StatusLoading extends StatusCheckState {}

// حالة توجه المستخدم لصفحة الاشتراكات لأنه غير مشترك
class NavigateToSubscriptionPlans extends StatusCheckState {}

// حالة تخبر المستخدم أن اشتراكه منتهي (لكن لا تزال توجهه لصفحة الاشتراكات)
class SubscriptionIsExpired extends StatusCheckState {}

// حالة توجه المستخدم للصفحة الرئيسية لأن اشتراكه فعال
class NavigateToMainApp extends StatusCheckState {}

class RoutePaths {
  // Public Entry / Auth
  static const String welcome = '/';
  static const String phoneLogin = '/login';
  static const String otpVerification = '/verify-otp';
  static const String customerProfileSetup = '/setup/customer';
  static const String partnerProfileSetup = '/setup/partner';

  // Customer Routes
  static const String customerHome = '/customer/home';
  static const String customerSearch = '/customer/search';
  static const String customerSubscriptions = '/customer/subscriptions';
  static const String customerSubscriptionDetail = '/customer/subscriptions/:id';
  static const String customerMealCalendar = '/customer/subscriptions/:id/calendar';
  static const String customerOrders = '/customer/orders';
  static const String customerOrderDetail = '/customer/orders/:id';
  static const String customerOrderTracking = '/customer/orders/:id/track';
  static const String customerProfile = '/customer/profile';
  static const String customerAddressPicker = '/customer/addresses/picker';
  static const String customerPartnerDetail = '/customer/partner/:id';
  static const String customerCart = '/customer/cart';

  // Partner Routes
  static const String partnerDashboard = '/partner/dashboard';
  static const String partnerKitchenView = '/partner/kitchen';
  static const String partnerOrders = '/partner/orders';
  static const String partnerMenuManagement = '/partner/menu';
  static const String partnerPlansManagement = '/partner/plans';
  static const String partnerSubscribers = '/partner/subscribers';
  static const String partnerDeliveryStaff = '/partner/delivery-staff';
  static const String partnerEarnings = '/partner/earnings';
  static const String partnerSettings = '/partner/settings';
}

class RouteNames {
  static const String welcome = 'welcome';
  static const String phoneLogin = 'phoneLogin';
  static const String otpVerification = 'otpVerification';
  static const String customerProfileSetup = 'customerProfileSetup';
  static const String partnerProfileSetup = 'partnerProfileSetup';

  // Customer
  static const String customerHome = 'customerHome';
  static const String customerSearch = 'customerSearch';
  static const String customerSubscriptions = 'customerSubscriptions';
  static const String customerSubscriptionDetail = 'customerSubscriptionDetail';
  static const String customerMealCalendar = 'customerMealCalendar';
  static const String customerOrders = 'customerOrders';
  static const String customerOrderDetail = 'customerOrderDetail';
  static const String customerOrderTracking = 'customerOrderTracking';
  static const String customerProfile = 'customerProfile';
  static const String customerAddressPicker = 'customerAddressPicker';
  static const String customerPartnerDetail = 'customerPartnerDetail';
  static const String customerCart = 'customerCart';

  // Partner
  static const String partnerDashboard = 'partnerDashboard';
  static const String partnerKitchenView = 'partnerKitchenView';
  static const String partnerOrders = 'partnerOrders';
  static const String partnerMenuManagement = 'partnerMenuManagement';
  static const String partnerPlansManagement = 'partnerPlansManagement';
  static const String partnerSubscribers = 'partnerSubscribers';
  static const String partnerDeliveryStaff = 'partnerDeliveryStaff';
  static const String partnerEarnings = 'partnerEarnings';
  static const String partnerSettings = 'partnerSettings';
}

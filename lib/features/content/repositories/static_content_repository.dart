import 'package:hiweb_app_management/features/cart_checkout/cart_checkout.dart';
import 'package:hiweb_app_management/features/cart_checkout/models/buy_now_mock_data.dart';
import 'package:hiweb_app_management/features/home/home.dart';
import 'package:hiweb_app_management/features/notification/models/notification_model.dart';
import 'package:hiweb_app_management/features/product/product.dart';
import 'package:hiweb_app_management/features/search/search.dart';
import 'package:hiweb_app_management/features/user/user.dart';
import 'package:hiweb_app_management/features/video/video.dart';

class StaticContentRepository {
  const StaticContentRepository();

  List<BannerModel> get banners => BannerModel.mockBanners;
  List<CategoryModel> get homeCategories => CategoryModel.mockCategories;
  List<TopSearchModel> get topSearches => TopSearchModel.mockTopSearches;
  List<FilterOptionModel> get filterCategories => FilterModel.mockCategories;
  List<FilterOptionModel> get filterBrands => FilterModel.mockBrands;
  List<FilterOptionModel> get filterOrigins => FilterModel.mockOrigins;
  List<FilterOptionModel> get filterLocations => FilterModel.mockLocations;
  List<OrderStatusOption> get orderStatuses => ProfileMockData.orderStatuses;
  List<QuickActionOption> get quickActions => ProfileMockData.quickActions;
  List<ToolServiceOption> get toolServices => ProfileMockData.toolServices;
  List<NotificationModel> get notifications => NotificationMockData.items;
  List<FlashSaleSlotInfo> get flashSaleSlots => FlashSaleModel.mockDailySlots;
  List<String> get flashSaleCategories => FlashSaleModel.mockCategories;
  List<SearchSuggestionModel> get searchSuggestions =>
      SearchSuggestionModel.mockSuggestions;
  List<SearchPopularCategoryModel> get popularSearchCategories =>
      SearchPopularCategoryModel.mockPopularCategories;
  List<String> get searchQuickTags => SearchQuickTagModel.mockQuickTags;
  List<VideoProductSheetItemModel> get videoProductItems =>
      VideoProductSheetData.mockItems;
  List<String> get videoReportReasons => VideoReportMockData.reasons;
    List<VideoItemModel> get videos => VideoItemModel.mockVideos;
  List<String> get buyNowFallbackImages => BuyNowMockData.fallbackImages;
  int get buyNowStock => BuyNowMockData.stock;
    int get coinsBalance => CheckoutMockData.coinsBalance;
    String get shopName => CheckoutMockData.shopName;
    String get productVariantPrefix => CheckoutMockData.productVariantPrefix;
    String get shippingMethod => CheckoutMockData.shippingMethod;
    String get shippingDate => CheckoutMockData.shippingDate;
    int get shippingFee => CheckoutMockData.shippingFee;
    String get vietMadeVoucherLabel => CheckoutMockData.vietMadeVoucherLabel;
    String get coinsLabel => CheckoutMockData.coinsLabel;
    String get checkoutFallbackImage => CheckoutMockData.fallbackImage;
}

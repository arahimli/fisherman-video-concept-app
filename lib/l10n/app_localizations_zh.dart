// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '老渔翁';

  @override
  String get create => '创建';

  @override
  String get selectImage => '选择\n图片';

  @override
  String get changeImage => '更改\n图片';

  @override
  String get generateVideo => '生成\n视频';

  @override
  String get videoReady => '视频已就绪';

  @override
  String get previewVideo => '视频预览';

  @override
  String get recentVideos => '最近的视频';

  @override
  String get viewAll => '查看全部';

  @override
  String get history => '历史';

  @override
  String get allVideos => '所有视频';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get thisWeek => '本周';

  @override
  String get thisMonth => '本月';

  @override
  String get older => '更早';

  @override
  String get noVideos => '暂无视频';

  @override
  String get noVideosDesc => '创建您的第一个视频以在此处查看';

  @override
  String get deleteVideo => '删除视频';

  @override
  String get deleteConfirm => '您确定要删除此视频吗？';

  @override
  String get delete => '删除';

  @override
  String get cancel => '取消';

  @override
  String get reset => '重置';

  @override
  String get resetConfirmTitle => '重置';

  @override
  String get resetConfirmMessage => '您要重置所有更改吗？';

  @override
  String get no => '否';

  @override
  String get yes => '是';

  @override
  String get imageProcessing => '正在处理图片...';

  @override
  String get videoGenerating => '正在生成视频...';

  @override
  String get videoGenerated => '视频已生成 ✓';

  @override
  String get videoGenerationError => '生成视频时出错';

  @override
  String get selectImageFirst => '请先选择一张图片';

  @override
  String error(Object error) {
    return '错误：$error';
  }

  @override
  String get filterByDate => '按日期筛选';

  @override
  String get allDates => '所有日期';

  @override
  String get allLanguages => '全部';

  @override
  String get loadMore => '加载更多';

  @override
  String videosCount(int count) {
    return '$count 个视频';
  }

  @override
  String get videoPreviewTitle => '预览';

  @override
  String get shareSheet => '分享';

  @override
  String get save => '保存';

  @override
  String get saving => '正在保存...';

  @override
  String get saveToGallery => '保存到相册';

  @override
  String get saveToGalleryDesc => '将保存到您手机的相册中';

  @override
  String get videoSavedSuccess => '✓ 视频已保存到相册';

  @override
  String get share => '分享';

  @override
  String get shareSubtitle => 'WhatsApp、Telegram 及其他应用';

  @override
  String get shareVideoText => '看看我的视频！';

  @override
  String get selectFromGallery => '从您的照片库中选择';

  @override
  String get takePhoto => '拍照';

  @override
  String get takePhotoDesc => '打开相机并拍摄新照片';

  @override
  String shareError(Object error) {
    return '分享错误：$error';
  }

  @override
  String get settings => '设置';

  @override
  String get watermark => '水印';

  @override
  String get imageWatermark => '图片水印';

  @override
  String get imageWatermarkDesc => '在视频上叠加徽标或图片';

  @override
  String get watermarkPosition => '水印位置';

  @override
  String get watermarkHint => '禁用水印以创建没有任何叠加层的视频。';

  @override
  String get watermarkChangeImage => '更改图片';

  @override
  String get watermarkRemove => '删除';

  @override
  String get watermarkSelectImage => '选择图片';

  @override
  String get positionTopLeft => '左上';

  @override
  String get positionTopRight => '右上';

  @override
  String get positionBottomLeft => '左下';

  @override
  String get positionBottomRight => '右下';

  @override
  String get backToSelectImageTitle => '返回';

  @override
  String get backToSelectImageMessage => '您确定要返回选择图片模式吗？';

  @override
  String get pressBackAgainToExit => '再次按返回键退出';

  @override
  String get support => '支持';

  @override
  String get supportDesc => '观看视频广告，帮助保持应用免费并支持开发';

  @override
  String get shortVideo => '短视频';

  @override
  String get shortVideoDesc => '观看短广告以支持应用';

  @override
  String get longVideo => '长视频';

  @override
  String get longVideoDesc => '观看更长的广告以获得额外支持';

  @override
  String get watchAd => '观看';

  @override
  String get thankYouSupport => '感谢您的支持！';

  @override
  String get adsWatched => '已观看广告';

  @override
  String get adsWatchedToday => '今天';

  @override
  String get adsWatchedTotal => '总计';

  @override
  String get selectVideoLanguage => '选择语言';

  @override
  String get englishVoice => '英语';

  @override
  String get englishVoiceDesc => '生成带英语旁白的视频';

  @override
  String get turkishVoice => '土耳其语';

  @override
  String get turkishVoiceDesc => '生成带土耳其语旁白的视频';

  @override
  String get russianVoice => '俄语';

  @override
  String get russianVoiceDesc => '生成带俄语旁白的视频';

  @override
  String get frenchVoice => '法语';

  @override
  String get frenchVoiceDesc => '生成带法语旁白的视频';

  @override
  String get arabicVoice => '阿拉伯语';

  @override
  String get arabicVoiceDesc => '生成带阿拉伯语旁白的视频';

  @override
  String get chineseVoice => '中文';

  @override
  String get chineseVoiceDesc => '生成带普通话旁白的视频';

  @override
  String get spanishVoice => '西班牙语';

  @override
  String get spanishVoiceDesc => '生成带西班牙语旁白的视频';

  @override
  String get hindiVoice => '印地语';

  @override
  String get hindiVoiceDesc => '生成带印地语旁白的视频';

  @override
  String get forceUpdateTitle => '需要更新';

  @override
  String get forceUpdateMessage => '有新版本可用。请更新以继续。';

  @override
  String get forceUpdateButton => '立即更新';
}

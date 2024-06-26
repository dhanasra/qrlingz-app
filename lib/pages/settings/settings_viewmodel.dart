import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:qrlingz_app/base/base_viewmodel.dart';
import 'package:qrlingz_app/constants/string_const.dart';
import 'package:qrlingz_app/network/local_db.dart';
import 'package:qrlingz_app/utils/global.dart';
import 'package:qrlingz_app/utils/utils.dart';
import 'package:qrlingz_app/widgets/language_sheet.dart';
import 'package:qrlingz_app/widgets/theme_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/theme/theme_cubit.dart';
import '../../widgets/confirm_sheet.dart';
import 'bloc/account_bloc.dart';

class SettingsViewModel extends BaseViewModel {

  final InAppReview inAppReview = InAppReview.instance;


  rateApp(BuildContext context)async{
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }else{
      inAppReview.openStoreListing();
    }
  }

  openThemeSheet(BuildContext context){
     showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_){ 
        return ThemeSheet(
          onSave: (v){
            Future.delayed(const Duration(milliseconds: 500), (){
              context.read<ThemeCubit>().toggleTheme(v);
            });
          },
        );
      }
    );
  }

  openLanguageSheet(BuildContext context){
     showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_){ 
        return LanguageSheet(
          value: context.locale.languageCode,
          onSaved: (v){
            Future.delayed(const Duration(milliseconds: 500), (){
              LocalDB().saveSettings('language', {"code": v});
              context.setLocale(getLocale(v));
            });
          },
        );
      }
    );
  }
  
  updateSettings(key, value)async{
    await LocalDB().saveSettings(key, {'enabled': value});
    if(key=="vibrate"){
      Global.vibrateOnScan = value;
    }else if(key=="sound"){
      Global.soundOnScan = value;
    }else if(key=="autoOpen"){
      Global.openLinkOnScan = value;
    }else if(key=="addScanToHistory"){
      Global.addScanToHistory = value;
    } 
  }

  recommendApp()async{
    await Share.share(StringConst.recommendContent.tr());
  }

  sendReportOrFeedback(String type)async{
    
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@spiderlingz.com',
      query: 'subject=$type&body=Model: ${androidInfo.model}\nBrand: ${androidInfo.brand}\nAndroid Version: ${androidInfo.version.release}\nManufacturer: ${androidInfo.manufacturer}',
    );

    launchUrl(emailLaunchUri);
  }

  openConfirmSheet(BuildContext context, String type){
     showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_){ 
        return ConfirmSheet(
          title: type=="delete"
            ? "Delete Account"
            : "Signout",
          content: type=="delete"
            ? "Are you sure ? You will lose all your data, Your links will become invalid."
            : "Are you sure ? You want to logout",
          icon: type,
          onSuccess: (){
            if(type=="delete"){
              context.read<AccountBloc>().add(DeleteAccountEvent());
            }else{
              context.read<AccountBloc>().add(LogoutEvent());
            }
          },
        );
      }
    );
  }

  @override
  dispose() {

  }
}
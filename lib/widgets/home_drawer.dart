import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:qrlingz_app/constants/url_const.dart';
import 'package:qrlingz_app/extensions/context_exten.dart';
import 'package:qrlingz_app/extensions/number_exten.dart';
import 'package:qrlingz_app/extensions/string_exten.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../constants/string_const.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> with TickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  
    return  Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      width: MediaQuery.of(context).size.width*0.8,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 8, 0),
              child: IconButton(onPressed: ()=>context.back(), icon: const Icon(Icons.arrow_forward))),
          ),
          Image.asset("res/logo/app_logo.png", width: 200,),
          16.h(),
          StringConst.welcomeText1.ts(context),
          4.h(),
          StringConst.welcomeText2.bs(context),
          32.h(),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              ListTile(
                onTap: ()async{
                  await Share.share(StringConst.recommendContent.tr());
                },
                leading: const Icon(Icons.thumb_up_alt_outlined, size: 20),
                title: const Text(StringConst.recommendopt).tr(),
              ),
              ListTile(
                onTap: ()async{
                  final InAppReview inAppReview = InAppReview.instance;
                  if (await inAppReview.isAvailable()) {
                    inAppReview.requestReview();
                  }else{
                    inAppReview.openStoreListing();
                  }
                },
                leading: const Icon(Icons.star_border, size: 20),
                title: const Text(StringConst.rateOpt).tr(),
              ),
              ListTile(
                onTap: ()=>{
                  launchUrlString(UrlConst.privacyPolicy)
                },
                leading: const Icon(Icons.security_outlined, size: 20),
                title: const Text(StringConst.privacy).tr(),
              ),
              ListTile(
                onTap: ()=>{
                  launchUrlString(UrlConst.termsAndConditions)
                },
                leading: const Icon(Icons.question_mark_outlined, size: 20),
                title: const Text(StringConst.terms).tr(),
              ),
              ListTile(
                onTap: ()=>{
                  launchUrlString(UrlConst.aboutUs)
                },
                leading: const Icon(Icons.business_outlined, size: 20),
                title: const Text(StringConst.about).tr(),
              )
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                "Version".ts(context, color: Theme.of(context).primaryColor),
                "1.0.0".bs(context)
              ],
            ),
          ),
          32.h()
        ],
      ),
    );
  }
}
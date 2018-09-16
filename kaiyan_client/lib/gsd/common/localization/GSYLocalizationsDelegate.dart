
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:kaiyan_client/gsd/common/localization/GSYLocalizations.dart';

class GSYLocalizationsDelegate extends LocalizationsDelegate<GSYLocalizations> {

  @override
  bool isSupported(Locale locale) {
    ///支持中文和英语
    return ['en', 'zh'].contains(locale.languageCode);
  }

  ///根据locale，创建一个对象用于提供当前locale下的文本显示
  @override
  Future<GSYLocalizations> load(Locale locale) {
    return new SynchronousFuture<GSYLocalizations>(new GSYLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<GSYLocalizations> old) {
    return false;
  }

  static GSYLocalizationsDelegate delegate = new GSYLocalizationsDelegate();
  GSYLocalizationsDelegate();

}
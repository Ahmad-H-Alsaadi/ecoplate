import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => GlobalKey<NavigatorState>());
}

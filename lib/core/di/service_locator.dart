import 'package:dio/dio.dart';

import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:islamic_app/core/api/api_consumer.dart';
import 'package:islamic_app/core/api/dio_consumer.dart';
import 'package:islamic_app/core/network/network_cubit.dart';
import 'package:islamic_app/core/network/network_info.dart';
import 'package:islamic_app/core/services/audio/audio_service.dart';
import 'package:islamic_app/core/services/location/location_services.dart';
import 'package:islamic_app/core/services/notify/firebase_messaging_service.dart';
import 'package:islamic_app/core/services/notify/local_notify_service.dart';
import 'package:islamic_app/features/home/ahadeth/data/repositories/hadeth_repo_impl.dart';
import 'package:islamic_app/features/home/ahadeth/domain/repositories/hadeth_repository.dart';
import 'package:islamic_app/features/home/radio/data/repositories/radio_repo_impl.dart';
import 'package:islamic_app/features/home/radio/domain/repositories/Radio_repository.dart';
import 'package:islamic_app/features/home/radio/domain/usecases/get_radio_urls_use_case.dart';
import 'package:islamic_app/features/home/radio/presentaion/cubit/radio_cubit.dart';

final sl = GetIt.instance;

Future <void> setupServiceLocator() async{

//network
  sl.registerLazySingleton<InternetConnectionChecker>(
        () => InternetConnectionChecker.createInstance(),
  );

  sl.registerLazySingleton<NetworkInfo>(
        () => NetworkInfo(
      sl<InternetConnectionChecker>(),
    ),
  );

  sl.registerFactory<NetworkCubit>(
        () => NetworkCubit(
      sl<NetworkInfo>(),
    ),
  );

  //api
  sl.registerLazySingleton<Dio>(() => Dio());

  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio: sl()));

//services
  sl.registerLazySingleton<AudioService>(() => JustAudioServiceImpl());
  sl.registerLazySingleton<LocalNotifyService>(() => LocalNotifyServiceImpl());
  sl.registerLazySingleton<LocationService>(() => LocationServiceImpl());
  sl.registerLazySingleton<FirebaseNotifyService>(() => FirebaseNotifyServiceImpl());


  //radio
  sl.registerLazySingleton<RadioRepository>(() => RadioRepoImpl(api: sl()));
  sl.registerLazySingleton<GetRadioUrlsUseCase>(() => GetRadioUrlsUseCase(radioRepo: sl()));
  sl.registerFactory<RadioCubit>(() => RadioCubit(
    getRadioUrlsUseCase: sl(),

    audioService: sl(),
  ));

  //ahadeth
  sl.registerLazySingleton<HadethRepository>(() => HadethRepoImpl(
    api: sl(),
    networkInfo: sl(),
  ));
}

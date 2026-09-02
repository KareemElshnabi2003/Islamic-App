import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:islamic_app/features/drawer/azan/data/repositories/azan_time_repo_impl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 👈 استدعاء SharedPreferences

import 'package:islamic_app/core/api/api_consumer.dart';
import 'package:islamic_app/core/api/dio_consumer.dart';
import 'package:islamic_app/core/network/network_cubit.dart';
import 'package:islamic_app/core/network/network_info.dart';
import 'package:islamic_app/core/services/audio/audio_service.dart';
import 'package:islamic_app/core/services/location/location_services.dart';
import 'package:islamic_app/core/services/notify/firebase_messaging_service.dart';
import 'package:islamic_app/core/services/notify/local_notify_service.dart';
import 'package:islamic_app/core/services/video/video_services.dart';
import 'package:islamic_app/features/drawer/compus/presentaion/cubit/compus_cubit.dart';
import 'package:islamic_app/features/drawer/doaa/data/repositories/doaa_repo_impl.dart';
import 'package:islamic_app/features/drawer/doaa/domain/repositories/doaa_repository.dart';
import 'package:islamic_app/features/drawer/doaa/domain/usecases/get_categories_use_case.dart';
import 'package:islamic_app/features/drawer/doaa/presentaion/cubit/doaa_cubit.dart';
import 'package:islamic_app/features/drawer/doaa/presentaion/cubit/oaa_reader_cubit.dart';
import 'package:islamic_app/features/drawer/stories/data/repositories/story_repo_impl.dart';
import 'package:islamic_app/features/drawer/stories/domain/repositories/story_repository.dart';
import 'package:islamic_app/features/drawer/stories/domain/usecases/get_story_use_case.dart';
import 'package:islamic_app/features/drawer/stories/presentaion/cubit/story_cubit.dart';
import 'package:islamic_app/features/drawer/times/data/repositories/times_repo_impl.dart';
import 'package:islamic_app/features/drawer/times/domain/repositories/times_repository.dart';
import 'package:islamic_app/features/drawer/times/domain/usecases/get_times_use_case.dart';
import 'package:islamic_app/features/drawer/times/presentaion/cubit/times_cubit.dart';
import 'package:islamic_app/features/drawer/videos/data/repositories/videos_repo_impl.dart';
import 'package:islamic_app/features/drawer/videos/domain/repositories/videos_repository.dart';
import 'package:islamic_app/features/drawer/videos/domain/usecases/get_all_videos_use_case.dart';
import 'package:islamic_app/features/drawer/videos/presentaion/cubit/video_cubit.dart';
import 'package:islamic_app/features/drawer/videos/presentaion/cubit/video_player_cubit.dart';
import 'package:islamic_app/features/drawer/zekr/data/repositories/zekr_notify_repo_impl.dart';
import 'package:islamic_app/features/drawer/zekr/domain/repositories/zekr_notify_repository.dart';
import 'package:islamic_app/features/drawer/zekr/domain/usecases/get_zekr_use_case.dart';
import 'package:islamic_app/features/drawer/zekr/domain/usecases/save_zekr_use_case.dart';
import 'package:islamic_app/features/drawer/zekr/presentaion/cubit/zekr_notify_cubit.dart';
import 'package:islamic_app/features/home/ahadeth/data/repositories/hadeth_repo_impl.dart';
import 'package:islamic_app/features/home/ahadeth/domain/repositories/hadeth_repository.dart';
import 'package:islamic_app/features/home/ahadeth/domain/usecases/get_hadeth_author_use_case.dart';
import 'package:islamic_app/features/home/ahadeth/domain/usecases/get_hadeth_use_case.dart';
import 'package:islamic_app/features/home/ahadeth/presentaion/cubit/ahadeth_cubit.dart';
import 'package:islamic_app/features/home/ahadeth/presentaion/cubit/hadeth_author_cubit.dart';
import 'package:islamic_app/features/home/quran/data/repositories/quran_repo_impl.dart';
import 'package:islamic_app/features/home/quran/domain/repositories/quran_repository.dart';
import 'package:islamic_app/features/home/quran/domain/usecases/get_all_sour_use_case.dart';
import 'package:islamic_app/features/home/quran/domain/usecases/get_ayat_use_case.dart';
import 'package:islamic_app/features/home/quran/presentaion/cubit/all_sour_cubit.dart';
import 'package:islamic_app/features/home/quran/presentaion/cubit/ayat_cubit.dart';
import 'package:islamic_app/features/home/radio/data/repositories/radio_repo_impl.dart';
import 'package:islamic_app/features/home/radio/domain/repositories/Radio_repository.dart';
import 'package:islamic_app/features/home/radio/domain/usecases/get_radio_urls_use_case.dart';
import 'package:islamic_app/features/home/radio/presentaion/cubit/radio_cubit.dart';

// 👈 استدعاءات ميزة الأذان
import 'package:islamic_app/features/drawer/azan/data/datasource/azan_local_data_source.dart';
import 'package:islamic_app/features/drawer/azan/domain/repositories/azan_repository.dart';
import 'package:islamic_app/features/drawer/azan/domain/usecases/get_cached_time_azan_use_case.dart';
import 'package:islamic_app/features/drawer/azan/presentaion/cubit/azan_cubit.dart';
import 'package:islamic_app/features/drawer/azan/presentaion/cubit/azan_audio_cubit.dart';

final sl = GetIt.instance;

// 👈 غيرنا دي لـ async عشان نقدر نـ await الـ SharedPreferences
Future<void> setupServiceLocator() async {

  // 👈 تعريف SharedPreferences في الـ GetIt
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

//network
  sl.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker.createInstance(),);
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfo(sl<InternetConnectionChecker>(),),);
  sl.registerFactory<NetworkCubit>(() => NetworkCubit(sl<NetworkInfo>(),),);

  //api
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio: sl()));

//services
  sl.registerLazySingleton<AudioService>(() => JustAudioServiceImpl());
  sl.registerFactory<VideoService>(() => VideoService());
  sl.registerFactory<VideoPlayerCubit>(() => VideoPlayerCubit(videoService: sl()));
  sl.registerLazySingleton<LocalNotifyService>(() => LocalNotifyServiceImpl());
  sl.registerLazySingleton<LocationService>(() => LocationServiceImpl());
  sl.registerLazySingleton<FirebaseNotifyService>(() => FirebaseNotifyServiceImpl());

  //radio
  sl.registerLazySingleton<RadioRepository>(() => RadioRepoImpl(api: sl()));
  sl.registerLazySingleton<GetRadioUrlsUseCase>(() => GetRadioUrlsUseCase(radioRepo: sl()));
  sl.registerFactory<RadioCubit>(() => RadioCubit(getRadioUrlsUseCase: sl(), audioService: sl(),),);

  //ahadeth

  sl.registerLazySingleton<HadethRepository>(() => HadethRepoImpl(api: sl(),),);
  sl.registerLazySingleton<GetHadethAuthorUseCase>(() => GetHadethAuthorUseCase(hadethRepositories: sl()));
  sl.registerFactory<HadethAuthorCubit>(() => HadethAuthorCubit(getHadethAuthorUseCase: sl()));
  sl.registerLazySingleton<GetHadethUseCase>(() => GetHadethUseCase(hadethRepositories: sl()));
  sl.registerFactory<AhadethCubit>(() => AhadethCubit(getHadethUseCase: sl()));

  //Quraan

  sl.registerLazySingleton<QuranRepository>(() => QuranRepoImpl(api: sl(),),);
  sl.registerLazySingleton<GetAllSourUseCase>(() => GetAllSourUseCase(quranRepository: sl()));
  sl.registerFactory<AllSourCubit>(() => AllSourCubit(getAllSourUseCase: sl()));
  sl.registerLazySingleton<GetAyatUseCase>(() => GetAyatUseCase(quranRepository: sl()));
  sl.registerFactory<AyatCubit>(() => AyatCubit(getAyatUseCase: sl(),audioService: sl()));

  //Qibla

  sl.registerFactory(() => QiblaCubit(locationService: sl()));

  // times
  sl.registerLazySingleton<TimesRepository>(() => TimesRepoImpl(api: sl(),),);
  sl.registerLazySingleton<GetTimesUseCase>(() => GetTimesUseCase(timesRepository: sl()));
  sl.registerFactory<TimesCubit>(() => TimesCubit(getTimesUseCase: sl(),locationService: sl()));

  //stories
  sl.registerLazySingleton<StoryRepository>(() => StoryRepoImpl(),);
  sl.registerLazySingleton<GetStoryUseCase>(() => GetStoryUseCase(storyRepository: sl()));
  sl.registerFactory<StoriesCubit>(() => StoriesCubit(getStoryUseCase: sl()));

  //videos
  sl.registerLazySingleton<VideosRepository>(() => VideosRepoImpl(api: sl()),);
  sl.registerLazySingleton<GetAllVideosUseCase>(() => GetAllVideosUseCase(videosRepository: sl()));
  sl.registerFactory<VideoCubit>(() => VideoCubit(getAllVideosUseCase: sl()));

// doaa
  sl.registerFactory<DoaaReaderCubit>(() => DoaaReaderCubit());
  sl.registerLazySingleton<DoaaRepository>(() => DoaaRepoImpl(api: sl()),);
  sl.registerLazySingleton<GetCategoriesUseCase>(() => GetCategoriesUseCase(doaaRepository: sl()));
  sl.registerFactory<DoaaCubit>(() => DoaaCubit(getCategoriesUseCase: sl()));

  // Zekr Notifications Settings
  sl.registerLazySingleton<ZekrSettingsRepository>(() => ZekrSettingsRepoImpl());
  sl.registerLazySingleton<GetZekrSettingsUseCase>(() => GetZekrSettingsUseCase(repository: sl()));
  sl.registerLazySingleton<SaveZekrSettingsUseCase>(() => SaveZekrSettingsUseCase(repository: sl()));
  sl.registerFactory<ZekrNotificationCubit>(() => ZekrNotificationCubit(
    getZekrSettingsUseCase: sl(),
    saveZekrSettingsUseCase: sl(),
  ));

  // =====================================
  // 👇 إضافات ميزة الأذان (Azan)
  // =====================================

  // Data Source
  sl.registerLazySingleton<BaseAdhanLocalDataSource>(() => AdhanLocalDataSourceImpl(sl()));

  // Repository
  sl.registerLazySingleton<BaseAdhanTimerRepository>(() => AdhanTimerRepositoryImpl(sl()));

  // Use Case
  sl.registerLazySingleton<GetCachedTimesUseCase>(() => GetCachedTimesUseCase(sl()));

  // Cubits
  sl.registerFactory<AdhanTimerCubit>(() => AdhanTimerCubit(sl()));
  sl.registerFactory<AdhanAudioCubit>(() => AdhanAudioCubit());
}
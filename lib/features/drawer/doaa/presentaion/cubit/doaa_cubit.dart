import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/drawer/doaa/domain/usecases/get_categories_use_case.dart';
import 'doaa_state.dart';

class DoaaCubit extends Cubit<DoaaState> {
  final GetCategoriesUseCase getCategoriesUseCase;

  DoaaCubit({required this.getCategoriesUseCase}) : super(DoaaInitial());

  Future<void> getAllCategoriesWithDuas() async {
    emit(DoaaLoading());

    final result = await getCategoriesUseCase.call();

    result.fold(
          (failure) {
        if (isClosed) return;
        emit(DoaaError(message: failure.errorModel.errorMessage));
      },
          (categories) {
        if (isClosed) return;
        emit(DoaaSuccess(categories: categories));
      },
    );
  }



  String getArabicCategoryName(String id) {
    switch (id) {
      case 'morning':
        return 'أذكار الصباح';
      case 'evening':
        return 'أذكار المساء';
      case 'wudu':
        return 'الوضوء والطهارة';
      case 'prayer':
        return 'أدعية أثناء الصلاة';
      case 'after_prayer':
        return 'أذكار بعد الصلاة';
      case 'sleep':
        return 'أذكار النوم';
      case 'food':
        return 'أدعية الطعام والشراب';
      case 'travel':
        return 'أدعية السفر';
      case 'home':
        return 'أدعية دخول وخروج المنزل';
      case 'masjid':
        return 'أدعية المسجد';
      case 'distress':
        return 'أدعية الكرب والهم';
      case 'forgiveness':
        return 'الاستغفار والتوبة';
      case 'illness':
        return 'أدعية المرض والشفاء';
      case 'weather':
        return 'أدعية الطقس والمطر';
      case 'knowledge':
        return 'طلب العلم';
      case 'parents':
        return 'الدعاء للوالدين';
      case 'guidance':
        return 'طلب الهداية والاستخارة';
      case 'gratitude':
        return 'شكر وحمد الله';
      case 'protection':
        return 'أدعية الحفظ والتحصين';
      case 'dhikr':
        return 'أذكار عامة';
      case 'marriage':
        return 'أدعية الزواج والأسرة';
      case 'hajj':
        return 'أدعية الحج والعمرة';
      case 'grief':
        return 'أدعية الحزن والمصيبة';
      case 'children':
        return 'أدعية للأبناء';
      case 'business':
        return 'أدعية الرزق والعمل';
      case 'night_prayer':
        return 'أدعية قيام الليل';
      case 'quran_recitation':
        return 'أدعية تلاوة القرآن';
      default:
        return 'أدعية متنوعة';
    }
  }
}
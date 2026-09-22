// ================= Cubit =================
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/home/quran/domain/usecases/get_all_sour_use_case.dart';
import 'package:islamic_app/features/home/quran/presentaion/cubit/all_sour_state.dart';

class AllSourCubit extends Cubit<AllSourState> {
  final GetAllSourUseCase getAllSourUseCase;

  AllSourCubit({required this.getAllSourUseCase}) : super(AllSourInitial());

  Future<void> getAllSour() async {
    bool hasEmittedCache = false;

    // 1. عرض البيانات المحفوظة محلياً فوراً
    final cachedResult = await getAllSourUseCase.callCached();
    cachedResult.fold(
      (failure) {},
      (allSour) {
        if (!isClosed) {
          emit(AllSourSuccess(allSour: allSour));
          hasEmittedCache = true;
        }
      },
    );

    if (!hasEmittedCache) {
      emit(AllSourLoading());
    }

    // 2. جلب البيانات الحديثة
    final result = await getAllSourUseCase.call();
    result.fold(
      (failure) {
        if (isClosed) return;
        if (!hasEmittedCache) {
          emit(AllSourError(message: failure.errorModel.errorMessage));
        }
      },
      (allSour) {
        if (isClosed) return;
        emit(AllSourSuccess(allSour: allSour));
      },
    );
  }
}
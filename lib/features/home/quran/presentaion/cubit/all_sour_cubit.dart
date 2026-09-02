// ================= Cubit =================
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/home/quran/domain/usecases/get_all_sour_use_case.dart';
import 'package:islamic_app/features/home/quran/presentaion/cubit/all_sour_state.dart';

class AllSourCubit extends Cubit<AllSourState> {
  final GetAllSourUseCase getAllSourUseCase;

  AllSourCubit({required this.getAllSourUseCase}) : super(AllSourInitial());

  Future<void> getAllSour() async {
    emit(AllSourLoading());

    final result = await getAllSourUseCase.call();
    result.fold(
          (failure) {
            if (isClosed) return; // السطر ده للحماية

            emit(AllSourError(message: failure.errorModel.errorMessage));
          },
          (allSour) {
            if (isClosed) return; // السطر ده للحماية

            emit(AllSourSuccess(allSour: allSour));
          },
    );
  }
}
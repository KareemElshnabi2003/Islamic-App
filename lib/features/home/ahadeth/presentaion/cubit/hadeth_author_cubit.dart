import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/home/ahadeth/domain/usecases/get_hadeth_author_use_case.dart';

import 'package:islamic_app/features/home/ahadeth/presentaion/cubit/hadeth_author_state.dart';


class HadethAuthorCubit extends Cubit<HadethAuthorState> {
  final GetHadethAuthorUseCase getHadethAuthorUseCase;
  HadethAuthorCubit( {required this.getHadethAuthorUseCase}):super(HadethAuthorInitial());

  Future<void> getAuthors() async {
    bool hasEmittedCache = false;

    // 1. عرض البيانات المحفوظة محلياً فوراً
    final cachedResult = await getHadethAuthorUseCase.callCached();
    cachedResult.fold(
      (failure) {},
      (authors) {
        if (!isClosed) {
          emit(HadethAuthorSuccess(authors: authors));
          hasEmittedCache = true;
        }
      },
    );

    if (!hasEmittedCache) {
      emit(HadethAuthorLoading());
    }

    // 2. جلب البيانات الحديثة
    final result = await getHadethAuthorUseCase.call();
    result.fold(
      (failure) {
        if (isClosed) return;
        if (!hasEmittedCache) {
          emit(HadethAuthorError(message: failure.errorModel.errorMessage));
        }
      },
      (authors) {
        if (isClosed) return;
        emit(HadethAuthorSuccess(authors: authors));
      },
    );
  }





}
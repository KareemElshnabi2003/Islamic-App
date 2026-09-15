import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/home/ahadeth/domain/usecases/get_hadeth_author_use_case.dart';

import 'package:islamic_app/features/home/ahadeth/presentaion/cubit/hadeth_author_state.dart';


class HadethAuthorCubit extends Cubit<HadethAuthorState> {
  final GetHadethAuthorUseCase getHadethAuthorUseCase;
  HadethAuthorCubit( {required this.getHadethAuthorUseCase}):super(HadethAuthorInitial());

  Future <void>getAuthors()async{
    emit(HadethAuthorLoading());

    final result=await getHadethAuthorUseCase.call();
    result.fold(
          (failure) {
            if (isClosed) return; // السطر ده للحماية

            emit(HadethAuthorError(message: failure.errorModel.errorMessage));
      },
          (authors) {
            if (isClosed) return; // السطر ده للحماية

            emit(HadethAuthorSuccess(authors: authors));
      },
    );
  }





}
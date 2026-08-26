import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/services/audio/audio_service.dart';
import 'package:islamic_app/features/home/ahadeth/domain/usecases/get_hadeth_use_case.dart';
import 'package:islamic_app/features/home/ahadeth/presentaion/cubit/ahadeth_state.dart';
import 'package:islamic_app/features/home/radio/data/repositories/radio_repo_impl.dart';
import 'package:islamic_app/features/home/radio/domain/usecases/get_radio_urls_use_case.dart';
import 'package:islamic_app/features/home/radio/presentaion/cubit/radio_state.dart';

class AhadethCubit extends Cubit<AhadethState> {
  final GetHadethUseCase getHadethUseCase;
  AhadethCubit( {required this.getHadethUseCase}):super(HadethInitial());

  Future <void>gethadeth({required String author})async{
    emit(HadethLoading());

    final result=await getHadethUseCase.call(author: author);
    result.fold(
          (failure) {
        emit(HadethError(message: failure.errorModel.errorMessage));
      },
          (hadeth) {
        emit(HadethSuccess(ahadeth: hadeth));
      },
    );
  }





}
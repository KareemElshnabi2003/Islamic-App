
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/drawer/doaa/domain/entities/doaa_entity.dart';
import 'package:islamic_app/features/drawer/doaa/presentaion/cubit/doaa_reader_state.dart';


class DoaaReaderCubit extends Cubit<DoaaReaderState> {
  List<DoaaEntity> duas = [];

  DoaaReaderCubit() : super(const DoaaReaderState());


  void init(List<DoaaEntity> categoryDuas) {
    duas = categoryDuas;
    emit(const DoaaReaderState(currentIndex: 0));
  }

  void nextDoaa() {
    if (state.currentIndex < duas.length - 1) {
      emit(state.copyWith(currentIndex: state.currentIndex + 1));
    }
  }

  void prevDoaa() {
    if (state.currentIndex > 0) {
      emit(state.copyWith(currentIndex: state.currentIndex - 1));
    }
  }
}
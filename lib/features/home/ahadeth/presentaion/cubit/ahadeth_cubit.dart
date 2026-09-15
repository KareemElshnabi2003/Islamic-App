import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/home/ahadeth/domain/usecases/get_hadeth_use_case.dart';
import 'package:islamic_app/features/home/ahadeth/presentaion/cubit/ahadeth_state.dart';

class AhadethCubit extends Cubit<AhadethState> {
  final GetHadethUseCase getHadethUseCase;
  AhadethCubit({required this.getHadethUseCase}) : super(HadethInitial());

  int currentPage = 1;
  bool isFetching = false;
  String currentAuthor = '';

  Future<void> gethadeth({required String author, bool isRefresh = true}) async {
    if (isFetching) return;

    if (!isRefresh && state is HadethSuccess && (state as HadethSuccess).hasReachedMax) return;

    isFetching = true;

    if (isRefresh) {
      currentPage = 1;
      currentAuthor = author;
      emit(HadethLoading());
    } else {
      if (state is HadethSuccess) {
        emit((state as HadethSuccess).copyWith(isFetchingMore: true));
      }
    }

    final result = await getHadethUseCase.call(author: currentAuthor, page: currentPage);

    result.fold(
          (failure) {
            if (isClosed) return; // السطر ده للحماية

            if (isRefresh) {
          emit(HadethError(message: failure.errorModel.errorMessage));
        } else if (state is HadethSuccess) {
          emit((state as HadethSuccess).copyWith(isFetchingMore: false));
        }
        isFetching = false;
      },
          (newAhadeth) {
            if (isClosed) return; // السطر ده للحماية

            if (isRefresh) {
          emit(HadethSuccess(
            ahadeth: newAhadeth,
            hasReachedMax: newAhadeth.length < 50,
          ));
        } else {
          if (state is HadethSuccess) {
            final currentState = state as HadethSuccess;
            final allAhadeth = List.of(currentState.ahadeth)..addAll(newAhadeth);

            emit(currentState.copyWith(
              ahadeth: allAhadeth,
              isFetchingMore: false,
              hasReachedMax: newAhadeth.isEmpty || newAhadeth.length < 50,
            ));
          }
        }
        currentPage++;
        isFetching = false;
      },
    );
  }


  void setSelectedIndex(int index) {
    if (state is HadethSuccess) {
      emit((state as HadethSuccess).copyWith(currentIndex: index));
    }
  }

  void nextHadeth() {
    if (state is HadethSuccess) {
      final currentState = state as HadethSuccess;
      if (currentState.currentIndex < currentState.ahadeth.length - 1) {
        emit(currentState.copyWith(currentIndex: currentState.currentIndex + 1));
      } else if (!currentState.hasReachedMax) {
        gethadeth(author: currentAuthor, isRefresh: false);
      }
    }
  }

  void prevHadeth() {
    if (state is HadethSuccess) {
      final currentState = state as HadethSuccess;
      if (currentState.currentIndex > 0) {
        emit(currentState.copyWith(currentIndex: currentState.currentIndex - 1));
      }
    }
  }
}
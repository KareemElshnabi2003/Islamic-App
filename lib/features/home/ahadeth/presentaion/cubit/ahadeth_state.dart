import 'package:equatable/equatable.dart';
import 'package:islamic_app/features/home/ahadeth/domain/entities/hadeth_entity.dart';

abstract class AhadethState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HadethInitial extends AhadethState {}
class HadethLoading extends AhadethState {}

class HadethSuccess extends AhadethState {
  final List<HadethEntity> ahadeth;
  final bool isFetchingMore; // حالة تحميل الصفحة الإضافية
  final bool hasReachedMax;  // هل وصلنا لآخر أحاديث عند الراوي ده؟
  final int currentIndex;    // رقم الحديث الحالي (عشان شاشة القراءة)

  HadethSuccess({
    required this.ahadeth,
    this.isFetchingMore = false,
    this.hasReachedMax = false,
    this.currentIndex = 0,
  });

  HadethSuccess copyWith({
    List<HadethEntity>? ahadeth,
    bool? isFetchingMore,
    bool? hasReachedMax,
    int? currentIndex,
  }) {
    return HadethSuccess(
      ahadeth: ahadeth ?? this.ahadeth,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [ahadeth, isFetchingMore, hasReachedMax, currentIndex];
}

class HadethError extends AhadethState {
  final String message;
  HadethError({required this.message});

  @override
  List<Object?> get props => [message];
}
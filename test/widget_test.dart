import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_app/features/drawer/videos/domain/entities/single_video_entity.dart';
import 'package:islamic_app/features/drawer/videos/domain/entities/video_entity.dart';

void main() {
  test('VideoEntity model equality test', () {
    const video1 = SingleVideoEntity(
      id: 1,
      type: 1,
      videoUrl: 'https://example.com/video.mp4',
      img: 'https://example.com/thumb.jpg',
    );

    const entity1 = VideoEntity(
      id: 10,
      name: 'سورة الفاتحة',
      videos: [video1],
    );

    const entity2 = VideoEntity(
      id: 10,
      name: 'سورة الفاتحة',
      videos: [video1],
    );

    expect(entity1, equals(entity2));
  });
}

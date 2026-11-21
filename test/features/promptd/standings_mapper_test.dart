import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/promptd/domain/promptd_standing.dart';
import 'package:socialdeck/features/promptd/presentation/standings/standings_mapper.dart';

PromptdStanding result(
  String id,
  int rank,
  int points, {
  String name = 'Sam',
  String? photo,
}) => PromptdStanding(
  playerId: id,
  playerName: name,
  rank: rank,
  points: points,
  photoUrl: photo,
);

void main() {
  test(
    'screens 4-8 receive five players with supplied points and placements',
    () {
      final entries = mapPromptdStandings([
        result(
          'a',
          1,
          220,
          name: 'Alex',
          photo: 'https://example.com/alex.jpg',
        ),
        result('b', 2, 185),
        result('c', 3, 170),
        result('d', 4, 140),
        result('e', 5, 100),
      ]);
      expect(entries.map((e) => e.points), ['220', '185', '170', '140', '100']);
      expect(entries.first.playerName, 'Alex');
      expect(entries.first.photoUrl, 'https://example.com/alex.jpg');
      expect(entries.map((e) => e.standing), [
        SDeckLeaderboardStanding.gold,
        SDeckLeaderboardStanding.silver,
        SDeckLeaderboardStanding.bronze,
        SDeckLeaderboardStanding.plain,
        SDeckLeaderboardStanding.plain,
      ]);
      expect(() => entries.clear(), throwsUnsupportedError);
    },
  );
  test('ties and zero scores are preserved without awarding extra points', () {
    final input = [result('a', 1, 0), result('b', 1, 0)];
    for (var i = 0; i < 2; i++) {
      final entries = mapPromptdStandings(input);
      expect(entries.map((e) => e.points), ['0', '0']);
      expect(
        entries.every((e) => e.standing == SDeckLeaderboardStanding.gold),
        isTrue,
      );
    }
  });
  test('missing names and photos use existing row fallbacks', () {
    final entry =
        mapPromptdStandings([result('a', 1, 10, name: ' ', photo: ' ')]).single;
    expect(entry.playerName, 'Player');
    expect(entry.photoUrl, isNull);
  });
  test('reject duplicate players, unordered ranks and invalid identifiers', () {
    expect(
      () => mapPromptdStandings([result('a', 1, 1), result('a', 2, 0)]),
      throwsArgumentError,
    );
    expect(
      () => mapPromptdStandings([result('a', 2, 0), result('b', 1, 1)]),
      throwsArgumentError,
    );
    expect(() => result('', 1, 0), throwsArgumentError);
    expect(() => result('a', 0, 0), throwsArgumentError);
  });
  test('empty input does not invent results', () {
    expect(mapPromptdStandings([]), isEmpty);
  });
}

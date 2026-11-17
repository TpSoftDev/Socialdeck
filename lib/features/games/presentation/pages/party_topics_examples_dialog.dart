import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';
import '../../domain/game_setup_state.dart';

// IA: Frontend shell reuses app controls. Both views share one fixed-size card.
// Frontend team: replace placeholder styling/artwork while retaining scrolling.
class PartyTopicsExamplesDialog extends StatefulWidget {
  const PartyTopicsExamplesDialog({super.key, required this.draft});
  final GameSetupState draft;
  @override
  State<PartyTopicsExamplesDialog> createState() => _SummaryState();
}

class _SummaryState extends State<PartyTopicsExamplesDialog> {
  bool _examples = false;
  int _exampleIndex = 0;
  int _topicIndex = 0;
  Widget _section(String label, List<String> values, SDeckChipColor color) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: SDeckSpace.gap8),
          Wrap(
            spacing: SDeckSpace.gap4,
            runSpacing: SDeckSpace.gap4,
            children: [
              for (final value in values) SDeckChip(label: value, color: color),
            ],
          ),
          const SizedBox(height: SDeckSpace.padding16),
        ],
      );
  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    final groups =
        draft.groupCategories
            .expand((v) => v == 'Other' ? draft.customGroups : [v])
            .toList();
    final topics =
        draft.selectedTopics
            .expand((v) => v == 'Other' ? draft.customTopics : [v])
            .toList();
    final style = switch (draft.styleLevel) {
      'light' => 'Light (SFW)',
      'bold' => 'Bold',
      'wild' => 'Wild (NSFW)',
      _ => 'Not selected',
    };
    // IA: Read the saved approvals only; rejected/generated-only prompts stay out.
    final prompts = draft.approvedExamples;
    final pageCount =
        _examples
            ? prompts.length
            : draft.groupDescription.trim().isEmpty
            ? 1
            : 2;
    final pageIndex = _examples ? _exampleIndex : _topicIndex;
    void move(int delta) => setState(() {
      if (_examples) {
        _exampleIndex += delta;
      } else {
        _topicIndex += delta;
      }
    });
    return Dialog(
      backgroundColor: context.semantic.surface,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SizedBox(
        key: const ValueKey('topics-examples-card'),
        width: 360,
        height: math.min(520, MediaQuery.sizeOf(context).height * .76),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _examples ? 'Examples' : 'Topics',
                style: Theme.of(context).textTheme.h6,
              ),
              const SizedBox(height: SDeckSpace.padding16),
              // IA: Only content scrolls. Card and footer do not jump when toggled.
              Expanded(
                child: SingleChildScrollView(
                  key: ValueKey('$_examples-$pageIndex'),
                  child:
                      _examples
                          ? prompts.isEmpty
                              ? Text(
                                'No examples approved yet.',
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                              // IA: Frontend shell uses existing colors/chips and keeps approved text unchanged.
                              // IA: Fixed gray-card height across every example; long content scrolls inside.
                              : Container(
                                key: const ValueKey('approved-example-card'),
                                height: 280,
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: context.component.selectionTargetBorder
                                      .withValues(alpha: .10),
                                  border: Border.all(
                                    color:
                                        context.component.selectionTargetBorder,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: SingleChildScrollView(
                                  key: ValueKey(
                                    'example-content-$_exampleIndex',
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        '${_exampleIndex + 1} of ${prompts.length}',
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                      ),
                                      // IA: Keep the counter separate. Group saved topic tags together
                                      // with consistent gaps; extra tags wrap instead of spreading apart.
                                      if ((draft.approvedExampleTopics[prompts[_exampleIndex]] ??
                                              const <String>[])
                                          .isNotEmpty) ...[
                                        const SizedBox(height: 10),
                                        Wrap(
                                          spacing: 6,
                                          runSpacing: 6,
                                          children: [
                                            for (final topic
                                                in draft
                                                    .approvedExampleTopics[prompts[_exampleIndex]]!)
                                              SDeckChip(
                                                label: topic,
                                                color: SDeckChipColor.mintGreen,
                                              ),
                                          ],
                                        ),
                                      ],
                                      const SizedBox(height: 24),
                                      Icon(
                                        Icons.format_quote_rounded,
                                        size: 30,
                                        color: context.component.textSecondary
                                            .withValues(alpha: .45),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        '“${prompts[_exampleIndex]}”',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          height: 1.45,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                    ],
                                  ),
                                ),
                              )
                          : _topicIndex == 1
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'About your group',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                draft.groupDescription,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          )
                          : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _section(
                                "Who's playing?",
                                groups,
                                SDeckChipColor.tangerine,
                              ),
                              _section(
                                'What topics?',
                                topics,
                                SDeckChipColor.mintGreen,
                              ),
                              _section('Prompt style', [
                                style,
                              ], SDeckChipColor.vibrantYellow),
                              Text(
                                'Safe Mode: ${draft.safeMode ? 'On' : 'Off'}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              if (draft.averageAge != null)
                                Text(
                                  'Average group age: ${draft.averageAge}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                            ],
                          ),
                ),
              ),
              // IA: Fixed arrow controls; stop at each end instead of wrapping unexpectedly.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    key: const ValueKey('summary-previous'),
                    tooltip: 'Previous page',
                    style: IconButton.styleFrom(
                      side: BorderSide(
                        color: context.component.selectionTargetBorder,
                      ),
                      shape: const CircleBorder(),
                    ),
                    icon: const Icon(Icons.chevron_left),
                    onPressed: pageIndex > 0 ? () => move(-1) : null,
                  ),
                  Text(
                    pageCount == 0
                        ? '0 approved'
                        : '${pageIndex + 1} / $pageCount',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  IconButton(
                    key: const ValueKey('summary-next'),
                    tooltip: 'Next page',
                    style: IconButton.styleFrom(
                      side: BorderSide(
                        color: context.component.selectionTargetBorder,
                      ),
                      shape: const CircleBorder(),
                    ),
                    icon: const Icon(Icons.chevron_right),
                    onPressed: pageIndex + 1 < pageCount ? () => move(1) : null,
                  ),
                ],
              ),
              const SizedBox(height: SDeckSpace.padding16),
              Row(
                children: [
                  Expanded(
                    child: SDeckSolidButton(
                      key: const ValueKey('summary-close'),
                      text: 'Close',
                      fullWidth: true,
                      size: SDeckButtonSize.small,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: SDeckSpace.gap8),
                  Expanded(
                    child: SDeckOutlineButton(
                      key: const ValueKey('summary-toggle'),
                      text: _examples ? 'Topics' : 'Examples',
                      fullWidth: true,
                      size: SDeckButtonSize.small,
                      onPressed: () => setState(() => _examples = !_examples),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

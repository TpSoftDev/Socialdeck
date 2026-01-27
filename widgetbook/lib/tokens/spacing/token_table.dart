/*----------------------------- token_table.dart --------------------------------*/
// Reusable table component for displaying design tokens
// Matches Figma table structure: Variable, Group, Value, Description
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/tokens/colors/index.dart';
import 'package:socialdeck/design_system/tokens/spacing/index.dart';

/*----------------------------- TokenTableRow ------------------------------*/
/// Data model for a table row
class TokenTableRow {
  const TokenTableRow({
    required this.variable,
    required this.group,
    required this.value,
    required this.description,
    this.valueReference,
    this.valueDisplay,
  });

  final String variable;
  final String group;
  final String value;
  final String description;
  final String? valueReference; // For showing reference token (e.g., "sizeZero")
  final String? valueDisplay; // For showing actual value (e.g., "0")
}

/*----------------------------- TokenTable ------------------------------*/
/// Reusable table widget for displaying token data
/// Matches Figma design with 4 columns: Variable, Group, Value, Description
class TokenTable extends StatelessWidget {
  const TokenTable({
    super.key,
    required this.rows,
  });

  final List<TokenTableRow> rows;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //----------------------------- Header ---------------------------//
          _TableHeader(),
          //----------------------------- Rows ---------------------------//
          ...rows.map((row) => _TableRow(row: row)),
        ],
      ),
    );
  }
}

/*----------------------------- _TableHeader ------------------------------*/
/// Table header row
class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _HeaderCell(
          width: 240,
          child: Text(
            'Variable',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: context.component.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        _HeaderCell(
          width: 160,
          child: Text(
            'Group',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: context.component.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        _HeaderCell(
          width: 240,
          child: Text(
            'Value',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: context.component.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        _HeaderCell(
          width: 418,
          child: Text(
            'Description',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: context.component.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }
}

/*----------------------------- _HeaderCell ------------------------------*/
/// Header cell with grey background
class _HeaderCell extends StatelessWidget {
  const _HeaderCell({
    required this.width,
    required this.child,
  });

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: context.semantic.outlineVariant.withOpacity(0.3),
        border: Border.all(
          color: context.semantic.outlineVariant,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: SDeckSpace.padding16,
        vertical: SDeckSpace.padding16,
      ),
      child: child,
    );
  }
}

/*----------------------------- _TableRow ------------------------------*/
/// Table data row
class _TableRow extends StatelessWidget {
  const _TableRow({required this.row});

  final TokenTableRow row;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _DataCell(
          width: 240,
          child: _VariableBadge(variable: row.variable),
        ),
        _DataCell(
          width: 160,
          child: Text(
            row.group,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: context.component.textPrimary,
                ),
          ),
        ),
        _DataCell(
          width: 240,
          child: row.valueReference != null && row.valueDisplay != null
              ? _ValueReference(
                  reference: row.valueReference!,
                  display: row.valueDisplay!,
                )
              : Text(
                  row.value,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: context.component.textPrimary,
                      ),
                ),
        ),
        _DataCell(
          width: 418,
          child: Text(
            row.description,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: context.component.textPrimary,
                ),
          ),
        ),
      ],
    );
  }
}

/*----------------------------- _DataCell ------------------------------*/
/// Data cell with border
class _DataCell extends StatelessWidget {
  const _DataCell({
    required this.width,
    required this.child,
  });

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border.all(
          color: context.semantic.outlineVariant,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: SDeckSpace.padding16,
        vertical: SDeckSpace.padding16,
      ),
      child: child,
    );
  }
}

/*----------------------------- _VariableBadge ------------------------------*/
/// Variable name badge/pill matching Figma style
class _VariableBadge extends StatelessWidget {
  const _VariableBadge({required this.variable});

  final String variable;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SDeckSpace.padding8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.02),
        border: Border.all(
          color: context.semantic.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.tag,
            size: 8.167,
            color: context.component.textPrimary,
          ),
          SizedBox(width: SDeckSize.size4),
          Text(
            variable,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: context.component.textPrimary,
                ),
          ),
        ],
      ),
    );
  }
}

/*----------------------------- _ValueReference ------------------------------*/
/// Value cell showing reference token badge + dot separator + actual value
/// Matches Figma style for Radius tokens
class _ValueReference extends StatelessWidget {
  const _ValueReference({
    required this.reference,
    required this.display,
  });

  final String reference;
  final String display;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: SDeckSpace.padding8,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.02),
            border: Border.all(
              color: context.semantic.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(SDeckRadius.borderRadius4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tag,
                size: 14,
                color: context.component.textPrimary,
              ),
              SizedBox(width: SDeckSize.size4),
              Text(
                reference,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: context.component.textPrimary,
                    ),
              ),
            ],
          ),
        ),
        SizedBox(width: SDeckSize.size3),
        Text(
          '·',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: context.semantic.outlineVariant,
              ),
        ),
        SizedBox(width: SDeckSize.size3),
        Text(
          display,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: context.component.textSecondary,
              ),
        ),
      ],
    );
  }
}


import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_service.dart';

class MetricsRealtimeSubscription {
  final VoidCallback onRefresh;
  final Duration debounce;
  final RealtimeChannel _channel;
  Timer? _debounceTimer;
  bool _closed = false;

  MetricsRealtimeSubscription._({
    required this.onRefresh,
    required this.debounce,
    required RealtimeChannel channel,
  }) : _channel = channel;

  factory MetricsRealtimeSubscription.forCard({
    required String cardId,
    required VoidCallback onRefresh,
    Duration debounce = const Duration(milliseconds: 450),
  }) {
    final subscription = MetricsRealtimeSubscription._(
      onRefresh: onRefresh,
      debounce: debounce,
      channel: SupabaseService.client.channel(
        'metrics:card:$cardId:${DateTime.now().microsecondsSinceEpoch}',
      ),
    );

    subscription
      .._watchTable(
        table: 'visit_events',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'card_id',
          value: cardId,
        ),
      )
      .._watchTable(
        table: 'link_stats',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'card_id',
          value: cardId,
        ),
      )
      .._watchTable(
        table: 'leads',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'card_id',
          value: cardId,
        ),
      )
      .._watchTable(table: 'lead_actions')
      .._subscribe();

    return subscription;
  }

  factory MetricsRealtimeSubscription.forOrganization({
    required String orgId,
    required VoidCallback onRefresh,
    Duration debounce = const Duration(milliseconds: 500),
  }) {
    final subscription = MetricsRealtimeSubscription._(
      onRefresh: onRefresh,
      debounce: debounce,
      channel: SupabaseService.client.channel(
        'metrics:org:$orgId:${DateTime.now().microsecondsSinceEpoch}',
      ),
    );

    subscription
      .._watchTable(table: 'visit_events')
      .._watchTable(table: 'link_stats')
      .._watchTable(table: 'leads')
      .._watchTable(table: 'lead_actions')
      .._watchTable(
        table: 'campaigns',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'org_id',
          value: orgId,
        ),
      )
      .._watchTable(table: 'campaign_members')
      .._watchTable(
        table: 'users',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'org_id',
          value: orgId,
        ),
      )
      .._watchTable(
        table: 'digital_cards',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'org_id',
          value: orgId,
        ),
      )
      .._subscribe();

    return subscription;
  }

  void _watchTable({required String table, PostgresChangeFilter? filter}) {
    _channel.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: table,
      filter: filter,
      callback: (_) => _scheduleRefresh(),
    );
  }

  void _subscribe() {
    _channel.subscribe();
  }

  void _scheduleRefresh() {
    if (_closed) return;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounce, () {
      if (_closed) return;
      onRefresh();
    });
  }

  void close() {
    if (_closed) return;
    _closed = true;
    _debounceTimer?.cancel();
    unawaited(SupabaseService.client.removeChannel(_channel));
  }
}

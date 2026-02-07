import 'package:flutter/material.dart';
import '../../models/tile.dart';
import '../../models/player.dart';
import '../../models/trade.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';
import 'animated_dialog.dart';

/// Dialog for proposing trades between players
class TradeDialog extends StatefulWidget {
  final Player currentPlayer;
  final List<Player> otherPlayers;
  final List<TileData> tiles;
  final Function(TradeOffer) onTradeProposed;

  const TradeDialog({super.key, required this.currentPlayer, required this.otherPlayers, required this.tiles, required this.onTradeProposed});

  @override
  State<TradeDialog> createState() => _TradeDialogState();
}

class _TradeDialogState extends State<TradeDialog> {
  Player? _selectedPartner;
  final Set<int> _offeredPropertyIndices = {};
  final Set<int> _requestedPropertyIndices = {};
  int _offeredCash = 0;
  int _requestedCash = 0;

  List<TileData> get _myProperties {
    return widget.tiles.where((tile) {
      if (tile is PropertyTileData) return tile.ownerId == widget.currentPlayer.id && !tile.isMortgaged;
      if (tile is RailroadTileData) return tile.ownerId == widget.currentPlayer.id && !tile.isMortgaged;
      if (tile is UtilityTileData) return tile.ownerId == widget.currentPlayer.id && !tile.isMortgaged;
      return false;
    }).toList();
  }

  List<TileData> get _partnerProperties {
    if (_selectedPartner == null) return [];
    return widget.tiles.where((tile) {
      if (tile is PropertyTileData) return tile.ownerId == _selectedPartner!.id && !tile.isMortgaged;
      if (tile is RailroadTileData) return tile.ownerId == _selectedPartner!.id && !tile.isMortgaged;
      if (tile is UtilityTileData) return tile.ownerId == _selectedPartner!.id && !tile.isMortgaged;
      return false;
    }).toList();
  }

  bool get _isValidTrade {
    if (_selectedPartner == null) return false;
    if (_offeredPropertyIndices.isEmpty && _offeredCash == 0 && _requestedPropertyIndices.isEmpty && _requestedCash == 0) {
      return false;
    }
    if (_offeredCash > widget.currentPlayer.cash) return false;
    if (_requestedCash > _selectedPartner!.cash) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450, maxHeight: 600),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.teal, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildPartnerSelection(),
                    if (_selectedPartner != null) ...[_buildOfferSection(), _buildRequestSection()],
                  ],
                ),
              ),
            ),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Column(
        children: [
          const Icon(Icons.swap_horiz, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.proposeTrade,
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPartnerSelection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.tradeWith, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.otherPlayers.where((p) => p.status == PlayerStatus.active).map((player) {
              final isSelected = _selectedPartner?.id == player.id;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPartner = player;
                    _requestedPropertyIndices.clear();
                    _requestedCash = 0;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? player.color : player.color.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        player.name,
                        style: TextStyle(color: Colors.white, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                      ),
                      const SizedBox(width: 8),
                      Text('\$${player.cash}', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.currentPlayer.color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.currentPlayer.color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.arrow_upward, color: widget.currentPlayer.color, size: 20),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.youOffer(widget.currentPlayer.name),
                style: TextStyle(color: widget.currentPlayer.color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Cash slider
          Row(
            children: [
              Text(AppLocalizations.of(context)!.cashLabel, style: const TextStyle(color: Colors.white70)),
              Expanded(
                child: Slider(
                  value: _offeredCash.toDouble(),
                  min: 0,
                  max: widget.currentPlayer.cash.toDouble(),
                  divisions: (widget.currentPlayer.cash / 10).ceil().clamp(1, 100),
                  activeColor: AppTheme.cashGreen,
                  onChanged: (value) {
                    setState(() {
                      _offeredCash = (value / 10).round() * 10;
                    });
                  },
                ),
              ),
              SizedBox(
                width: 60,
                child: Text(
                  '\$$_offeredCash',
                  style: const TextStyle(color: AppTheme.cashGreen, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          // Properties
          if (_myProperties.isNotEmpty) ...[
            Text(AppLocalizations.of(context)!.propertiesLabel, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _myProperties.map((prop) {
                final isSelected = _offeredPropertyIndices.contains(prop.index);
                return _buildPropertyChip(prop, isSelected, () {
                  setState(() {
                    if (isSelected) {
                      _offeredPropertyIndices.remove(prop.index);
                    } else {
                      _offeredPropertyIndices.add(prop.index);
                    }
                  });
                });
              }).toList(),
            ),
          ],
          if (_myProperties.isEmpty) Text(AppLocalizations.of(context)!.noPropertiesToOffer, style: const TextStyle(color: Colors.white38, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildRequestSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _selectedPartner!.color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _selectedPartner!.color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.arrow_downward, color: _selectedPartner!.color, size: 20),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.youRequest(_selectedPartner!.name),
                style: TextStyle(color: _selectedPartner!.color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Cash slider
          Row(
            children: [
              Text(AppLocalizations.of(context)!.cashLabel, style: const TextStyle(color: Colors.white70)),
              Expanded(
                child: Slider(
                  value: _requestedCash.toDouble(),
                  min: 0,
                  max: _selectedPartner!.cash.toDouble(),
                  divisions: (_selectedPartner!.cash / 10).ceil().clamp(1, 100),
                  activeColor: AppTheme.warning,
                  onChanged: (value) {
                    setState(() {
                      _requestedCash = (value / 10).round() * 10;
                    });
                  },
                ),
              ),
              SizedBox(
                width: 60,
                child: Text(
                  '\$$_requestedCash',
                  style: const TextStyle(color: AppTheme.warning, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          // Properties
          if (_partnerProperties.isNotEmpty) ...[
            Text(AppLocalizations.of(context)!.propertiesLabel, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _partnerProperties.map((prop) {
                final isSelected = _requestedPropertyIndices.contains(prop.index);
                return _buildPropertyChip(prop, isSelected, () {
                  setState(() {
                    if (isSelected) {
                      _requestedPropertyIndices.remove(prop.index);
                    } else {
                      _requestedPropertyIndices.add(prop.index);
                    }
                  });
                });
              }).toList(),
            ),
          ],
          if (_partnerProperties.isEmpty) Text(AppLocalizations.of(context)!.noPropertiesAvailable, style: const TextStyle(color: Colors.white38, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildPropertyChip(TileData prop, bool isSelected, VoidCallback onTap) {
    Color? color;
    String name = prop.name;
    IconData icon = Icons.home;

    if (prop is PropertyTileData) {
      color = prop.groupColor;
    } else if (prop is RailroadTileData) {
      color = Colors.grey;
      icon = Icons.train;
    } else if (prop is UtilityTileData) {
      color = Colors.grey;
      icon = Icons.bolt;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? (color ?? Colors.grey) : Colors.black26,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? Colors.white : (color ?? Colors.grey), width: isSelected ? 2 : 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isSelected ? Colors.white : (color ?? Colors.grey)),
            const SizedBox(width: 4),
            Text(
              name.length > 12 ? '${name.substring(0, 10)}...' : name,
              style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white70,
                side: const BorderSide(color: Colors.white24),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _isValidTrade ? _proposeTrade : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(AppLocalizations.of(context)!.proposeTradeBtn, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  void _proposeTrade() {
    final offeredProps = _myProperties.where((p) => _offeredPropertyIndices.contains(p.index)).toList();
    final requestedProps = _partnerProperties.where((p) => _requestedPropertyIndices.contains(p.index)).toList();

    final offer = TradeOffer(id: DateTime.now().millisecondsSinceEpoch.toString(), offerer: widget.currentPlayer, recipient: _selectedPartner!, offeredProperties: offeredProps, offeredCash: _offeredCash, requestedProperties: requestedProps, requestedCash: _requestedCash);

    Navigator.of(context).pop();
    widget.onTradeProposed(offer);
  }
}

/// Dialog for responding to a trade offer
class TradeResponseDialog extends StatelessWidget {
  final TradeOffer offer;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final Function(TradeOffer)? onCounter;

  const TradeResponseDialog({super.key, required this.offer, required this.onAccept, required this.onReject, this.onCounter});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.teal, width: 2),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [_buildHeader(context), _buildTradeDetails(context), _buildActions(context)]),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: offer.offerer.color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Column(
        children: [
          const Icon(Icons.local_offer, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.wantsToTrade(offer.offerer.name),
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTradeDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // What you receive
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppTheme.cashGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.arrow_downward, color: AppTheme.cashGreen, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.youReceive,
                      style: const TextStyle(color: AppTheme.cashGreen, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (offer.offeredCash > 0) Text('\$${offer.offeredCash}', style: const TextStyle(color: Colors.white)),
                ...offer.offeredProperties.map((p) => Text('• ${p.name}', style: const TextStyle(color: Colors.white70))),
                if (offer.offeredCash == 0 && offer.offeredProperties.isEmpty) Text(AppLocalizations.of(context)!.nothing, style: const TextStyle(color: Colors.white38)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // What you give
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppTheme.warning.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.arrow_upward, color: AppTheme.warning, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.youGive,
                      style: const TextStyle(color: AppTheme.warning, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (offer.requestedCash > 0) Text('\$${offer.requestedCash}', style: const TextStyle(color: Colors.white)),
                ...offer.requestedProperties.map((p) => Text('• ${p.name}', style: const TextStyle(color: Colors.white70))),
                if (offer.requestedCash == 0 && offer.requestedProperties.isEmpty) Text(AppLocalizations.of(context)!.nothing, style: const TextStyle(color: Colors.white38)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onReject();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.error,
                    side: const BorderSide(color: AppTheme.error),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(AppLocalizations.of(context)!.reject),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onAccept();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.cashGreen,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(AppLocalizations.of(context)!.accept, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Show the trade proposal dialog
Future<void> showTradeDialog({required BuildContext context, required Player currentPlayer, required List<Player> otherPlayers, required List<TileData> tiles, required Function(TradeOffer) onTradeProposed}) {
  return showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    animationType: DialogAnimationType.slideUp,
    builder: (context) => TradeDialog(currentPlayer: currentPlayer, otherPlayers: otherPlayers, tiles: tiles, onTradeProposed: onTradeProposed),
  );
}

/// Show the trade response dialog
Future<void> showTradeResponseDialog({required BuildContext context, required TradeOffer offer, required VoidCallback onAccept, required VoidCallback onReject, Function(TradeOffer)? onCounter}) {
  return showAnimatedDialog(
    context: context,
    barrierDismissible: false,
    animationType: DialogAnimationType.scale,
    builder: (context) => TradeResponseDialog(offer: offer, onAccept: onAccept, onReject: onReject, onCounter: onCounter),
  );
}

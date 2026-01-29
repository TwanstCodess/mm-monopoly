import 'tile.dart';
import 'player.dart';

/// Represents the current state of an auction
class AuctionState {
  final TileData property;
  final List<Player> participants;
  final int minimumBid;
  final int bidIncrement;

  int currentBid;
  String? currentBidderId;
  int currentBidderIndex;
  Set<String> passedPlayers;
  bool isComplete;
  String? winnerId;

  AuctionState({
    required this.property,
    required this.participants,
    this.minimumBid = 10,
    this.bidIncrement = 10,
    this.currentBid = 0,
    this.currentBidderId,
    this.currentBidderIndex = 0,
    Set<String>? passedPlayers,
    this.isComplete = false,
    this.winnerId,
  }) : passedPlayers = passedPlayers ?? {};

  /// Get the property name
  String get propertyName => property.name;

  /// Get the property price (for reference)
  int get propertyPrice {
    if (property is PropertyTileData) {
      return (property as PropertyTileData).price;
    } else if (property is RailroadTileData) {
      return (property as RailroadTileData).price;
    } else if (property is UtilityTileData) {
      return (property as UtilityTileData).price;
    }
    return 0;
  }

  /// Get the current bidder
  Player get currentBidder => participants[currentBidderIndex];

  /// Get the minimum next bid amount
  int get minimumNextBid => currentBid == 0 ? minimumBid : currentBid + bidIncrement;

  /// Check if a player can bid
  bool canBid(Player player, int amount) {
    if (passedPlayers.contains(player.id)) return false;
    if (player.cash < amount) return false;
    if (amount < minimumNextBid) return false;
    return true;
  }

  /// Place a bid
  void placeBid(Player player, int amount) {
    if (!canBid(player, amount)) return;
    currentBid = amount;
    currentBidderId = player.id;
  }

  /// Player passes (no longer bidding)
  void pass(Player player) {
    passedPlayers.add(player.id);
  }

  /// Move to next bidder
  void nextBidder() {
    int attempts = 0;
    do {
      currentBidderIndex = (currentBidderIndex + 1) % participants.length;
      attempts++;
    } while (passedPlayers.contains(participants[currentBidderIndex].id) &&
        attempts < participants.length);
  }

  /// Get number of active bidders (not passed)
  int get activeBidderCount {
    return participants.where((p) => !passedPlayers.contains(p.id)).length;
  }

  /// Check if auction should end
  bool checkComplete() {
    // Auction ends when only one active bidder remains (or zero)
    if (activeBidderCount <= 1 && currentBidderId != null) {
      isComplete = true;
      winnerId = currentBidderId;
      return true;
    }
    // If everyone passed without any bids, property goes back to bank
    if (activeBidderCount == 0 && currentBidderId == null) {
      isComplete = true;
      winnerId = null;
      return true;
    }
    return false;
  }

  /// Get the winner
  Player? getWinner() {
    if (winnerId == null) return null;
    return participants.firstWhere((p) => p.id == winnerId);
  }

  /// Copy with updated fields
  AuctionState copyWith({
    TileData? property,
    List<Player>? participants,
    int? minimumBid,
    int? bidIncrement,
    int? currentBid,
    String? currentBidderId,
    int? currentBidderIndex,
    Set<String>? passedPlayers,
    bool? isComplete,
    String? winnerId,
  }) {
    return AuctionState(
      property: property ?? this.property,
      participants: participants ?? this.participants,
      minimumBid: minimumBid ?? this.minimumBid,
      bidIncrement: bidIncrement ?? this.bidIncrement,
      currentBid: currentBid ?? this.currentBid,
      currentBidderId: currentBidderId ?? this.currentBidderId,
      currentBidderIndex: currentBidderIndex ?? this.currentBidderIndex,
      passedPlayers: passedPlayers ?? Set.from(this.passedPlayers),
      isComplete: isComplete ?? this.isComplete,
      winnerId: winnerId ?? this.winnerId,
    );
  }
}

/// AI bidding strategy for auctions
class AIAuctionStrategy {
  /// Determine AI's bid based on property value and cash
  static int? determineBid(Player aiPlayer, AuctionState auction) {
    final propertyValue = auction.propertyPrice;
    final minimumBid = auction.minimumNextBid;
    final cash = aiPlayer.cash;

    // Don't bid if can't afford minimum
    if (cash < minimumBid) return null;

    // Calculate maximum AI is willing to pay based on property value
    // AI will pay up to 80% of property value, but keep at least $200 reserve
    final maxWillingToPay = (propertyValue * 0.8).round();
    final maxAffordable = cash - 200;
    final absoluteMax = maxWillingToPay < maxAffordable ? maxWillingToPay : maxAffordable;

    // If minimum bid is already too high, pass
    if (minimumBid > absoluteMax) return null;

    // Bid the minimum amount needed
    return minimumBid;
  }

  /// Determine if AI should pass
  static bool shouldPass(Player aiPlayer, AuctionState auction) {
    return determineBid(aiPlayer, auction) == null;
  }
}

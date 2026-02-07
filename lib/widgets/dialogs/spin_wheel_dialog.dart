import 'package:flutter/material.dart';
import '../../models/spin_prize.dart';
import '../../config/theme.dart';
import '../spin_wheel/spin_wheel_widget.dart';
import '../effects/confetti.dart';
import 'animated_dialog.dart';
import '../../services/audio_service.dart';

/// Dialog containing the spin wheel
class SpinWheelDialog extends StatefulWidget {
  final String playerName;
  final Future<void> Function(SpinPrize) onPrizeWon;

  const SpinWheelDialog({
    super.key,
    required this.playerName,
    required this.onPrizeWon,
  });

  @override
  State<SpinWheelDialog> createState() => _SpinWheelDialogState();
}

class _SpinWheelDialogState extends State<SpinWheelDialog> {
  final GlobalKey<SpinWheelWidgetState> _wheelKey = GlobalKey();
  SpinPrize? _wonPrize;
  bool _hasSpun = false;
  bool _showResult = false;

  void _onPrizeWon(SpinPrize prize) {
    AudioService.instance.onSpinResult();
    setState(() {
      _wonPrize = prize;
      _showResult = true;
    });

    // Show confetti for jackpot or big prizes
    if (prize.type == SpinPrizeType.jackpot || (prize.value ?? 0) >= 200) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          final box = context.findRenderObject() as RenderBox?;
          if (box != null) {
            final center = box.localToGlobal(
              Offset(box.size.width / 2, box.size.height / 2),
            );
            ConfettiManager.show(
              context,
              position: center,
              primaryColor: prize.color,
              particleCount: 50,
            );
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 380),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.amber.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildWheel(),
            const SizedBox(height: 16),
            if (_showResult) _buildResult() else _buildInstructions(),
            const SizedBox(height: 16),
            _buildActions(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber.shade700, Colors.amber.shade500],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.casino,
            color: Colors.white,
            size: 36,
          ),
          const SizedBox(height: 8),
          const Text(
            'LUCKY SPIN!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.playerName}\'s turn to spin!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWheel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SpinWheelWidget(
        key: _wheelKey,
        prizes: SpinPrizes.all,
        onPrizeWon: _onPrizeWon,
        size: 280,
      ),
    );
  }

  Widget _buildInstructions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        _hasSpun
            ? 'Spinning...'
            : 'Tap the center to spin the wheel!',
        style: TextStyle(
          color: Colors.white.withOpacity(0.7),
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildResult() {
    if (_wonPrize == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _wonPrize!.color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _wonPrize!.color),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _wonPrize!.icon,
            color: _wonPrize!.color,
            size: 32,
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You won ${_wonPrize!.name}!',
                  style: TextStyle(
                    color: _wonPrize!.color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _wonPrize!.description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: _showResult
            ? ElevatedButton(
                onPressed: () async {
                  await widget.onPrizeWon(_wonPrize!);
                  if (context.mounted) {
                    Navigator.of(context).pop(_wonPrize);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _wonPrize!.color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Collect Prize!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            : OutlinedButton(
                onPressed: _hasSpun
                    ? null
                    : () {
                        setState(() => _hasSpun = true);
                        _wheelKey.currentState?.spin();
                      },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.amber,
                  side: BorderSide(color: Colors.amber.withOpacity(0.5)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _hasSpun ? 'Good luck!' : 'Or tap here to spin',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
      ),
    );
  }
}

/// Show the spin wheel dialog
Future<SpinPrize?> showSpinWheelDialog({
  required BuildContext context,
  required String playerName,
  required Future<void> Function(SpinPrize) onPrizeWon,
}) {
  return showAnimatedDialog<SpinPrize>(
    context: context,
    barrierDismissible: false,
    animationType: DialogAnimationType.scale,
    builder: (context) => SpinWheelDialog(
      playerName: playerName,
      onPrizeWon: onPrizeWon,
    ),
  );
}

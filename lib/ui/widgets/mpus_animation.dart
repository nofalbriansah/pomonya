import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import '../../core/constants.dart';

class MpusAnimation extends StatefulWidget {
  final bool isWorking;
  final bool isBreak;
  final VoidCallback? onLevelUp;

  const MpusAnimation({
    super.key,
    required this.isWorking,
    required this.isBreak,
    this.onLevelUp,
  });

  @override
  State<MpusAnimation> createState() => _MpusAnimationState();
}

class _MpusAnimationState extends State<MpusAnimation> {
  SMIBool? _isWorkingInput;
  SMIBool? _isBreakInput;
  SMITrigger? _levelCompleteTrigger;

  /* void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
    );
    if (controller != null) {
      artboard.addController(controller);
      _isWorkingInput = controller.findInput<bool>('isWorking') as SMIBool?;
      _isBreakInput = controller.findInput<bool>('isBreak') as SMIBool?;
      _levelCompleteTrigger =
          controller.findInput<bool>('levelComplete') as SMITrigger?;

      _updateInputs();
    }
  } */

  void _updateInputs() {
    _isWorkingInput?.value = widget.isWorking;
    _isBreakInput?.value = widget.isBreak;
  }

  @override
  void didUpdateWidget(MpusAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateInputs();
    if (widget.onLevelUp != null &&
        oldWidget.isWorking &&
        !widget.isWorking &&
        !widget.isBreak) {
      _levelCompleteTrigger?.fire();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 250,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.glassBorder),
      ),
      /* RiveAnimation.asset(
        'assets/animations/pomonya.riv',
        fit: BoxFit.contain,
        onInit: _onRiveInit,
        placeHolder: _buildPlaceholder(),
      ), */
      child: _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          widget.isWorking
              ? Icons.terminal
              : (widget.isBreak ? Icons.local_cafe : Icons.pets),
          size: 80,
          color: AppColors.electricBlue,
        ),
        const SizedBox(height: 10),
        Text(
          widget.isWorking
              ? 'WORKING...'
              : (widget.isBreak ? 'RESTING' : 'IDLE'),
          style: const TextStyle(
            fontFamily: 'Press Start 2P',
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

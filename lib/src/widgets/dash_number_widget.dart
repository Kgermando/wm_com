import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:wm_commercial/src/constants/app_theme.dart';
import 'package:wm_commercial/src/constants/responsive.dart';

class DashNumberWidget extends StatelessWidget {
  const DashNumberWidget(
      {Key? key,
      required this.number,
      required this.title,
      required this.icon,
      required this.color,
      required this.gestureTapCallback})
      : super(key: key);

  final String number;
  final String title;
  final IconData icon;
  final Color color;
  final GestureTapCallback gestureTapCallback;

  @override
  Widget build(BuildContext context) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return InkWell(
      onTap: gestureTapCallback,
      child: Card(
        elevation: 10.0,
        shadowColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: Responsive.isMobile(context) ? double.infinity : 200,
          height: 100,
          color: color,
          padding: const EdgeInsets.all(16.0 * 0.75),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(child: Icon(icon, size: 40.0, color: Colors.white))
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: AutoSizeText(title,
                            maxLines: 2,
                            style: bodySmall!.copyWith(color: Colors.white))),
                    const SizedBox(height: p10),
                    Expanded(
                      flex: 2,
                      child: AutoSizeText(
                        number,
                        maxLines: 1,
                        style: bodyMedium!.copyWith(color: Colors.white),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

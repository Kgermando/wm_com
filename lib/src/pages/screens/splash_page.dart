import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_commercial/src/constants/responsive.dart';
import 'package:wm_commercial/src/pages/screens/controller/splash_controller.dart';
import 'package:wm_commercial/src/utils/info_system.dart';
import 'package:wm_commercial/src/widgets/no_network.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final sized = MediaQuery.of(context).size;

    return Scaffold(
      body: (controller.networkController.connectionStatus == 0)
        ? noNetworkWidget(context)
        : (controller.networkController.connectionStatus == 1)
            ? Center(
                child: Column(
                  children: [
                    Expanded(
                        child: Image.asset(InfoSystem().logoSansFond(),
                          height: Responsive.isDesktop(context) ? sized.height / 4 : sized.height / 3,
                          width: Responsive.isDesktop(context) ?  sized.width / 4 : sized.height / 3)),
                    const SizedBox(
                        width: 50, child: LinearProgressIndicator()),
                    const SizedBox(height: 50)
                  ],
                ),
              )
            : noNetworkWidget(context));
  }
}

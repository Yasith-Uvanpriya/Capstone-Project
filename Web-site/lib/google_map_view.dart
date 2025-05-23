import 'dart:ui_web' as ui;
import 'dart:html' as html;
import 'package:flutter/material.dart';

class GoogleMapPanel extends StatelessWidget {
  GoogleMapPanel({super.key}) {
    const mapSrc = 'assets/map_with_markers.html'; // Local HTML file

    ui.platformViewRegistry.registerViewFactory('google-map-custom', (
      int viewId,
    ) {
      final iframe =
          html.IFrameElement()
            ..src = mapSrc
            ..style.border = '0'
            ..style.width = '100%'
            ..style.height = '100%'
            ..allowFullscreen = true;

      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 800,
      height: 600,
      child: HtmlElementView(viewType: 'google-map-custom'),
    );
  }
}

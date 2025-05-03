import 'dart:ui' as ui;
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:flutter/material.dart';

class GoogleMapPanel extends StatelessWidget {
  const GoogleMapPanel({super.key});

  @override
  Widget build(BuildContext context) {
    const String viewID = 'google-maps-panel';

    // Register the view factory only once
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(viewID, (int viewId) {
      final html.DivElement mapElement =
          html.DivElement()
            ..id = 'map-canvas'
            ..style.width = '100%'
            ..style.height = '100%';

      // Initialize the map once
      Future.delayed(Duration.zero, () {
        js.context.callMethod('eval', [
          '''
          if (!window.map) {
            window.map = new google.maps.Map(document.getElementById("map-canvas"), {
              center: { lat: 6.9271, lng: 79.8612 },
              zoom: 12
            });
          }
          ''',
        ]);
      });

      return mapElement;
    });

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: const HtmlElementView(viewType: viewID),
    );
  }
}

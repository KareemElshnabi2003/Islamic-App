import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:screen_go/extensions/responsive_nums.dart';



final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

 const CameraPosition _kGooglePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);


bottomSheetMapWidget({  required ThemeData theme,
  required BuildContext context,

}) {

  return showModalBottomSheet(context: context, builder: (context) =>Container(
    height: 80.h,
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(color: theme.dividerColor,borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))),
    child: Column(
      children: [
        TextNormalWidget(text: "الموقع", size: 17.sp, color: theme.textTheme.titleLarge!.color!, decoration: TextDecoration.none, decorationColor: theme.textTheme.titleLarge!.color!, maxLines:1, weight: FontWeight.bold),

        SizedBox(
          width: 100.w,
          height: 50.h,
          child: GoogleMap(

            mapType: MapType.hybrid,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),

        )
      ],
    ),
  ),);
}


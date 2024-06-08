import 'package:covefood_domiciliario/controller/services/APIsNKeys/credential.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class APIs {
  static directionAPI(LatLng start, LatLng end) =>
      'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&mode=driving&key=$mapCredential';
}
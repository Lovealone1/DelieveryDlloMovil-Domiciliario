// ignore_for_file: use_build_context_synchronously

import 'package:covefood_domiciliario/constant/constant.dart';
import 'package:covefood_domiciliario/controller/provider/orderProvider/orderProvider.dart';
import 'package:covefood_domiciliario/controller/provider/rideProvider/rideProvider.dart';
import 'package:covefood_domiciliario/controller/services/locationServices/locationServices.dart';
import 'package:covefood_domiciliario/controller/services/orderServices/orderServices.dart';
import 'package:covefood_domiciliario/model/foodOrderModel.dart';
import 'package:covefood_domiciliario/utils/colors.dart';
import 'package:covefood_domiciliario/utils/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PushNotificationDialog {
  static delieveryRequestDialog(String orderID, BuildContext context) async {
    audioPlayer.setAsset('assets/sounds/alert.mp3');
    audioPlayer.play();

    FoodOrderModel foodOrderData =
        await OrderServices.fetchOrderDetails(orderID);
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 50.h,
              width: 90.w,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Solicitud de domicilio',
                      style: AppTextStyles.body16Bold,
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: 'Direccion de recogida: \t',
                              style: AppTextStyles.body14Bold),
                          TextSpan(
                              text: foodOrderData
                                  .restaurantDetails.restaurantName,
                              style: AppTextStyles.body14),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: 'Dirección de entrega: \t',
                              style: AppTextStyles.body14Bold),
                          TextSpan(
                              text: foodOrderData.userAddress!.apartment,
                              style: AppTextStyles.body14),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    SwipeButton(
                      thumbPadding: EdgeInsets.all(1.w),
                      thumb: Icon(Icons.chevron_right, color: white),
                      inactiveThumbColor: black,
                      activeThumbColor: black,
                      inactiveTrackColor: Color.fromRGBO(255, 117, 107, 1),
                      activeTrackColor: Color.fromRGBO(255, 117, 107, 1),
                      elevationThumb: 2,
                      elevationTrack: 2,
                      onSwipe: () {
                        audioPlayer.stop();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Rechazar',
                        style: AppTextStyles.body14Bold,
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    SwipeButton(
                      thumbPadding: EdgeInsets.all(1.w),
                      thumb: Icon(Icons.chevron_right, color: white),
                      inactiveThumbColor: black,
                      activeThumbColor: black,
                      inactiveTrackColor: Colors.green.shade200,
                      activeTrackColor: Colors.green.shade200,
                      elevationThumb: 2,
                      elevationTrack: 2,
                      onSwipe: () async {
                        Position delieveryGuyPosition =
                            await LocationServices.getCurrentLocation();
                        LatLng delieveryGuy = LatLng(
                            delieveryGuyPosition.latitude,
                            delieveryGuyPosition.longitude);
                        LatLng restaurant = LatLng(
                          foodOrderData.restaurantDetails.address!.latitude!,
                          foodOrderData.restaurantDetails.address!.longitude!,
                        );
                        LatLng delievery = LatLng(
                            foodOrderData.userAddress!.latitude,
                            foodOrderData.userAddress!.longitude);
                        context.read<RideProvider>().updateDeliveryLatLngs(
                            delieveryGuy, restaurant, delievery);

                        OrderServices.updateDriverProfileIntoFoodOrderModel(
                            orderID, context);
                        context
                            .read<RideProvider>()
                            .fetchCrrLocationToResturantPoliline(context);
                        context
                            .read<RideProvider>()
                            .fetchResturantToDeliveryPoliline(context);
                        FoodOrderModel orderData =
                            await OrderServices.fetchOrderDetails(orderID);
                        context.read<RideProvider>().updateOrderData(orderData);

                        context
                            .read<OrderProvider>()
                            .updateFoodOrderData(orderData);
                        context.read<RideProvider>().updateInDeliveryStatus(true);
                        context.read<RideProvider>().updateMarker(context);
                        audioPlayer.stop();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Aceptar',
                        style: AppTextStyles.body14Bold,
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

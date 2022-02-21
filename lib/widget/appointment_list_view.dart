import 'package:flutter/material.dart';
import 'package:hhcom/Utils/Constant/constant_widget.dart';
import 'package:hhcom/Utils/app_theme.dart';

class AppointmentListView extends StatelessWidget {
  final String title;
  final String icon;
  final Function tapped;
  final int index;
  final bool hasValue;
  final bool isLeftItem;
  final bool isCart;
  final bool hasPayment;
  final String cartText;

  AppointmentListView({required this.title, required this.icon, required this.tapped, required this.index, required this.hasValue, this.isLeftItem = true, this.isCart = false, this.cartText = "", this.hasPayment = false});

  @override
  Widget build(BuildContext context) {
    return (isLeftItem)
        ? ListTile(
            onTap: () {
              tapped();
            },
            leading: customIcon(icon: icon, size: 3.5),
            title: (isCart)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyles.customerAppointmentDetails(hasValue, isLeft: isLeftItem),
                      ),
                      Text(
                        cartText,
                        style: TextStyles.paymentMode(hasPayment),
                      ),
                    ],
                  )
                : Text(
                    title,
                    style: TextStyles.customerAppointmentDetails(hasValue, isLeft: isLeftItem),
                  ),
          )
        : InkWell(
            onTap: () {
              tapped();
            },
            child: Column(
              children: [
                customIcon(icon: icon, size: 3.5),
                SizedBox(
                  height: 10,
                ),
                Text(
                  title,
                  style: TextStyles.customerAppointmentDetails(hasValue, isLeft: isLeftItem),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          );
    return ListTile(
      onTap: () {
        tapped();
      },
      leading: customIcon(icon: icon),
      title: Text(
        title,
        style: TextStyles.customerAppointmentDetails(this.hasValue),
      ),
    );
  }

  /*
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        tapped();
      },
      leading: customIcon(icon: icon),
      title: Text(
        title,
        style: TextStyles.customerAppointmentDetails(this.hasValue),
      ),
    );
  }*/
}

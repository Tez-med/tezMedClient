import 'package:flutter/material.dart';
import 'package:tez_med_client/generated/l10n.dart';

class StatusHelper {
  static String getName(String status, BuildContext context) {
    // Barcha yangi statuslar bir xil bo'lishi uchun guruhlangan
    const newStatuses = [
      "connecting",
      "nurse_canceled",
      "new",
      "not_pickup",
      "approved",
      "not_online"
    ];

    if (newStatuses.contains(status)) {
      return S.of(context).neww;
    }

    switch (status) {
      case "came":
        return S.of(context).came;
      case "attached":
        return S.of(context).attached;
      case "ontheway":
        return S.of(context).ontheway;
      case "finished":
        return S.of(context).finished;
      case "in_process":
        return S.of(context).in_process;
      case "pending":
        return S.of(context).pending;
      default:
        return "Noma'lum";
    }
  }

  static Color getBackgroundColor(String status) {
    const blueStatuses = [
      "connecting",
      "nurse_canceled",
      "new",
      "not_pickup",
      "approved",
      "not_online",
      "attached",
      "ontheway",
      "in_process"
    ];

    if (blueStatuses.contains(status)) {
      return Colors.blueAccent;
    }

    switch (status) {
      case "finished":
        return Colors.redAccent;
      case "pending":
        return Colors.amber;
      case "came":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

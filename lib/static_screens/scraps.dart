// getLocation() async {
//     LocationData myLocation;
//     String error;
//     Location location = new Location();
//     if (c_position != null && c_position.length > 0) {
//       return true;
//     }

//     try {
//       myLocation = await location.getLocation();
//       currentLocation = myLocation;

//       final coordinates =
//           new Coordinates(myLocation.latitude, myLocation.longitude);
//       var addresses =
//           await Geocoder.local.findAddressesFromCoordinates(coordinates);
//       var first = addresses.first;
//       c_position = first.featureName;

//       if (acquiredlocation == false) {
//         setState(() {
//           acquiredlocation = true;
//         });
//       }

//       return c_position;
//     } on PlatformException catch (e) {
//       if (e.code == 'PERMISSION_DENIED') {
//         error = 'please grant permission';

//         Map<pm.Permission, pm.PermissionStatus> statuses = await [
//           pm.Permission.location,
//           pm.Permission.storage,
//         ].request();
//         print(error);
//         print(statuses);
//         gotLocation = false;
//       }
//       if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
//         error = 'permission denied- please enable it from app settings';
//         print(error);
//         gotLocation = false;
//       }
//       myLocation = null;
//     }
//   }

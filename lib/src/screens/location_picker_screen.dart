import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rent_wheelz/src/models/search_candidate_response_model.dart';
import 'package:rent_wheelz/src/models/search_result_response_model.dart';
import 'package:rent_wheelz/src/utils/app_colors.dart';
import 'package:rent_wheelz/src/utils/constants.dart';
import 'package:rent_wheelz/src/utils/font_family.dart';
import 'package:rent_wheelz/src/utils/utils.dart';
import 'package:rent_wheelz/src/widgets/build_elevated_button.dart';
import 'package:rent_wheelz/src/widgets/build_loading_widget.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final TextEditingController searchQueryController = TextEditingController();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LatLng? latLng;
  bool isLoading = true;
  String? address;
  List<SearchCandidateResponseModel> _searchResults = [];

  Future<Position> determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  Future<void> _getLatLng() async {
    try {
      Position position = await determinePosition();
      setState(() {
        latLng = LatLng(position.latitude, position.longitude);
        isLoading = false;
      });
      await _getAddressFromLatLng(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog(
          'Failed to get your current location. Please check your location settings.');
    }
  }

  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String formattedAddress =
            "${placemark.street}, ${placemark.locality}, ${placemark.country}";
        setState(() {
          address = formattedAddress;
          searchQueryController.text = "";
        });
      } else {
        setState(() {
          address = 'No address available';
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting address: $e');
      }
    }
  }

  Future<void> fetchPlaceDetails(String input) async {
    const String apiKey = Constants.placesSearchAPIKey;
    final String url =
        "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?fields=name,formatted_address,geometry&input=$input&inputtype=textquery&key=$apiKey";
    Dio dio = Dio();

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final searchResultResponseModel =
            SearchResultResponseModel.fromJson(response.data);
        setState(() {
          _searchResults = searchResultResponseModel.candidates ?? [];
        });
      } else {
        if (kDebugMode) {
          print('Error: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception: $e');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            'Error',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: Text(
            message,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    searchQueryController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _getLatLng();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          (latLng != null)
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: BuildElevatedButton(
                    borderRadiusBottomLeft: 12,
                    borderRadiusBottomRight: 12,
                    borderRadiusTopLeft: 12,
                    borderRadiusTopRight: 12,
                    backgroundColor: AppColors.primaryColorOrange,
                    height: screenHeight(context, dividedBy: 22),
                    txt: "Save",
                    onTap: () {
                      if (kDebugMode) {
                        print("Address is: $address");
                      }
                      Navigator.pop(context, {
                        'pickedAddress': address,
                        'pickedLatitude': latLng!.latitude,
                        'pickedLongitude': latLng!.longitude
                      });
                    },
                  ),
                )
              : const SizedBox.shrink()
        ],
        title: Text(
          "Pick a location",
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(fontWeight: FontWeight.w800, fontSize: 22),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Theme(
              data: ThemeData(
                textSelectionTheme: const TextSelectionThemeData(
                  selectionColor: AppColors.primaryColorLight,
                  selectionHandleColor: AppColors.primaryColorDark,
                ),
              ),
              child: TextFormField(
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: Theme.of(context).dividerColor,
                      fontWeight: FontWeight.w400,
                      fontFamily: FontFamily.gothamBook,
                    ),
                cursorColor: AppColors.primaryColorDark,
                controller: searchQueryController,
                decoration: InputDecoration(
                  hintText: "Search the location",
                  hintStyle: TextStyle(
                      color: AppColors.textFieldHintColor,
                      fontSize: 12,
                      fontFamily: FontFamily.gothamBook),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  suffixIcon: searchQueryController.text.isEmpty
                      ? const SizedBox.shrink()
                      : IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: AppColors.borderMediumGrey,
                          ),
                          onPressed: () {
                            searchQueryController.clear();
                            setState(() {
                              _searchResults = [];
                            });
                          },
                        ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: AppColors.primaryColorOrange,
                    ),
                    gapPadding: 0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: AppColors.primaryColorOrange,
                    ),
                    gapPadding: 0,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: AppColors.primaryColorOrange,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: AppColors.primaryColorOrange,
                    ),
                    gapPadding: 0,
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Colors.transparent),
                    gapPadding: 0,
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    fetchPlaceDetails(value);
                  } else {
                    setState(() {
                      _searchResults = [];
                    });
                  }
                },
              ),
            ),
          ),
          if (_searchResults.isNotEmpty)
            SizedBox(
              height: _searchResults.length * 60.0 > 300
                  ? 300
                  : _searchResults.length * 60.0,
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final candidate = _searchResults[index];
                  return ListTile(
                    title: Text(candidate.name ?? "No name available"),
                    subtitle: Text(
                        candidate.formattedAddress ?? "No address available"),
                    onTap: () {
                      final selectedCandidate = _searchResults[index];

                      setState(() {
                        latLng = LatLng(
                          selectedCandidate.geometry?.location?.lat ?? 0.0,
                          selectedCandidate.geometry?.location?.lng ?? 0.0,
                        );
                        address =
                            '${selectedCandidate.name}, ${selectedCandidate.formattedAddress ?? "Address not available"}';

                        _searchResults = [];
                      });

                      _controller.future.then((GoogleMapController controller) {
                        controller.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: latLng!,
                              zoom: 14,
                            ),
                          ),
                        );
                      });
                      searchQueryController.clear();
                    },
                  );
                },
              ),
            ),
          Expanded(
            child: isLoading
                ? const Center(child: BuildLoadingWidget())
                : (latLng != null)
                    ? Stack(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: GoogleMap(
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _controller.complete(controller);
                                  },
                                  onTap: (LatLng tappedLatLng) {
                                    setState(() {
                                      latLng = tappedLatLng;
                                    });
                                    _getAddressFromLatLng(tappedLatLng.latitude,
                                        tappedLatLng.longitude);
                                  },
                                  markers: {
                                    if (latLng != null)
                                      Marker(
                                        markerId: const MarkerId('marker_1'),
                                        position: latLng!,
                                        icon: BitmapDescriptor
                                            .defaultMarkerWithHue(
                                                BitmapDescriptor.hueOrange),
                                      ),
                                  },
                                  initialCameraPosition: CameraPosition(
                                    target: latLng ?? const LatLng(0, 0),
                                    zoom: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (address != null)
                            Positioned(
                              bottom: 40,
                              right: 30,
                              left: 30,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Theme.of(context).cardColor,
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      address!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      )
                    : const Center(
                        child: Text('Enable location services and try again!')),
          ),
        ],
      ),
    );
  }
}

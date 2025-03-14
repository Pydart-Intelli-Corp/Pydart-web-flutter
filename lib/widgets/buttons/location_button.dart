import 'package:flutter/material.dart';
import 'package:flutter_website/api/config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationButton extends StatefulWidget {
  const LocationButton({super.key});

  @override
  State<LocationButton> createState() => _LocationButtonState();
}

class _LocationButtonState extends State<LocationButton> {
  String _shortLocation = ""; // Default short location
  String? _fullLocation;
  bool _isFetching = false;
  bool _showDropdown = false;

  Future<void> _getLocation() async {
    setState(() {
      _isFetching = true;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          setState(() {
            _fullLocation = "Permission Denied";
            _isFetching = false;
          });
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Fetch location from API
      String locationName =
          await _fetchLocationFromAPI(position.latitude, position.longitude);

      setState(() {
        _fullLocation = locationName;
        _shortLocation = _getShortLocation(locationName); // Extract second part
        _isFetching = false;
      });
    } catch (e) {
      setState(() {
        _fullLocation = "Error: ${e.toString()}";
        _isFetching = false;
      });
    }
  }

  Future<String> _fetchLocationFromAPI(double lat, double lon) async {
    try {
      final url = Uri.parse("$apiUrl/geocode/reverse?lat=$lat&lon=$lon");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data["location"] ?? "Unknown Location";
      } else {
        return "Location Not Found";
      }
    } catch (e) {
      return "Error fetching location";
    }
  }

  String _getShortLocation(String fullLocation) {
    // Split the full location by commas and return the second part if available.
    List<String> parts = fullLocation.split(',');
    if (parts.length > 1) {
      return parts[1].trim(); // e.g., "Thrippunithura"
    }
    return fullLocation;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          if (_fullLocation != null) _showDropdown = true;
        });
      },
      onExit: (_) {
        setState(() {
          _showDropdown = false;
        });
      },
      cursor: SystemMouseCursors.click,
      child: Stack(
        clipBehavior:
            Clip.none, // Allow dropdown to overflow without shifting layout
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _getLocation,
              borderRadius: BorderRadius.circular(0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/icons/location.png",
                      width: 15,
                      height: 15,
                      color: const Color.fromARGB(255, 110, 114, 116),
                    ),
                    const SizedBox(width: 8),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: _isFetching
                          ? const SizedBox(
                              key: ValueKey('loading'),
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color.fromARGB(255, 110, 114, 116),
                              ),
                            )
                          : Text(
                              _shortLocation,
                              key: ValueKey<String>(_shortLocation),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 110, 114, 116),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Dropdown positioned absolutely so it doesn't affect the button's layout.
          if (_showDropdown && _fullLocation != null)
            Positioned(
              top: 50, // Adjust this offset based on your button's height
              left: 0,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: Container(
                  key: const ValueKey('dropdown'),
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Text(
                    _fullLocation!,
                    style: const TextStyle(
                        fontSize: 13,
                        color: Color.fromARGB(255, 110, 114, 116)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

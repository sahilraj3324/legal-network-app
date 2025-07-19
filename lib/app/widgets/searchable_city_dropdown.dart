import 'package:flutter/material.dart';
import '../../model/city_model.dart';
import '../../utils/local_data_service.dart';

class SearchableCityDropdown extends StatefulWidget {
  final City? selectedCity;
  final Function(City?) onCitySelected;
  final String? hintText;
  final InputDecoration? decoration;

  const SearchableCityDropdown({
    Key? key,
    this.selectedCity,
    required this.onCitySelected,
    this.hintText = 'Search for a city...',
    this.decoration,
  }) : super(key: key);

  @override
  State<SearchableCityDropdown> createState() => _SearchableCityDropdownState();
}

class _SearchableCityDropdownState extends State<SearchableCityDropdown> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<City> _searchResults = [];
  bool _isSearching = false;
  bool _showDropdown = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    if (widget.selectedCity != null) {
      _searchController.text = widget.selectedCity!.toString();
    }
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _showDropdown = true;
      _searchCities(_searchController.text);
    } else {
      _hideDropdown();
    }
  }

  void _hideDropdown() {
    setState(() {
      _showDropdown = false;
    });
    _removeOverlay();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<void> _searchCities(String query) async {
    if (!mounted) return;

    setState(() {
      _isSearching = true;
    });

    try {
      final results = await LocalDataService.searchCities(query);

      if (mounted) {
        setState(() {
          _searchResults = results.take(10).toList(); // Limit to 10 results
          _isSearching = false;
        });
        _showDropdownOverlay();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
        });
      }
    }
  }

  void _showDropdownOverlay() {
    _removeOverlay();
    
    if (_searchResults.isEmpty && !_isSearching) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 5,
        width: size.width,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: _buildDropdownContent(),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _buildDropdownContent() {
    if (_isSearching) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'No cities found',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final city = _searchResults[index];
        return ListTile(
          title: Text(city.city),
          subtitle: Text(city.state),
          onTap: () {
            _selectCity(city);
          },
          dense: true,
        );
      },
    );
  }

  void _selectCity(City city) {
    setState(() {
      _searchController.text = city.toString();
    });
    widget.onCitySelected(city);
    _hideDropdown();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _searchController,
      focusNode: _focusNode,
      decoration: widget.decoration ??
          InputDecoration(
            hintText: widget.hintText,
            prefixIcon: const Icon(Icons.location_city),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      widget.onCitySelected(null);
                      _hideDropdown();
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
      onChanged: (value) {
        if (value.isEmpty) {
          widget.onCitySelected(null);
          _hideDropdown();
        } else {
          _searchCities(value);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a city';
        }
        return null;
      },
    );
  }
} 
import 'package:flutter/material.dart';
import '../../model/court_model.dart';
import '../../utils/local_data_service.dart';

class SearchableCourtDropdown extends StatefulWidget {
  final Court? selectedCourt;
  final Function(Court?) onCourtSelected;
  final String? hintText;
  final InputDecoration? decoration;
  final String? filterByState; // Optional filter by state

  const SearchableCourtDropdown({
    Key? key,
    this.selectedCourt,
    required this.onCourtSelected,
    this.hintText = 'Search for a court...',
    this.decoration,
    this.filterByState,
  }) : super(key: key);

  @override
  State<SearchableCourtDropdown> createState() => _SearchableCourtDropdownState();
}

class _SearchableCourtDropdownState extends State<SearchableCourtDropdown> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Court> _searchResults = [];
  bool _isSearching = false;
  bool _showDropdown = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    if (widget.selectedCourt != null) {
      _searchController.text = widget.selectedCourt!.toString();
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
      _searchCourts(_searchController.text);
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

  Future<void> _searchCourts(String query) async {
    if (!mounted) return;

    setState(() {
      _isSearching = true;
    });

    try {
      List<Court> results;
      
      if (widget.filterByState != null && widget.filterByState!.isNotEmpty) {
        results = await LocalDataService.getCourtsByState(widget.filterByState!);
        if (query.isNotEmpty) {
          final lowerQuery = query.toLowerCase();
          results = results.where((court) {
            return court.courtName.toLowerCase().contains(lowerQuery) ||
                   court.state.toLowerCase().contains(lowerQuery);
          }).toList();
        }
      } else {
        results = await LocalDataService.searchCourts(query);
      }

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
          'No courts found',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final court = _searchResults[index];
        return ListTile(
          title: Text(
            court.courtName,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        
          onTap: () {
            _selectCourt(court);
          },
          dense: true,
        );
      },
    );
  }

  void _selectCourt(Court court) {
    setState(() {
      _searchController.text = court.courtName;
    });
    widget.onCourtSelected(court);
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
            prefixIcon: const Icon(Icons.account_balance),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      widget.onCourtSelected(null);
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
          widget.onCourtSelected(null);
          _hideDropdown();
        } else {
          _searchCourts(value);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a court';
        }
        return null;
      },
    );
  }
} 
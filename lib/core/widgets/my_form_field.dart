import 'package:flutter/material.dart';

import '../../features/IAL/data/Model/location_model.dart';

class MyFormField extends StatefulWidget {
  final double radius;
  final String? title;
  final String? hint;
  final VoidCallback? suffixIconPressed;
  final IconData? suffixIcon;
  final Widget? widget;
  final TextEditingController? controller;
  final bool isPassword;
  final bool enableSpellCheck;
  final bool isReadonly;
  final List<dynamic>? menuItems;
  final bool showDownMenu;
  final bool multiSelect;
  final TextInputType textType;
  final bool enableSearchSuggestions;
  final String? dependentValue;
  final Function(String)? onDependentValueChanged;
  final Function(dynamic)?
      onItemSelected; // Called with the entire selected item
  final FormFieldValidator<String>? validator;
  final VoidCallback? onTap;
  final Function(String)? onChange;

  const MyFormField({
    super.key,
    this.isPassword = false,
    this.radius = 15,
    this.isReadonly = false,
    this.textType = TextInputType.text,
    this.suffixIcon,
    this.multiSelect = false,
    this.suffixIconPressed,
    this.onTap,
    this.onChange,
    this.widget,
    this.controller,
    this.title = "",
    this.menuItems,
    this.showDownMenu = false,
    this.enableSearchSuggestions =
        true, // Default to true to maintain current behavior
    this.hint,
    this.validator,
    this.dependentValue,
    this.onDependentValueChanged,
    this.onItemSelected,   this.enableSpellCheck = false,
  });

  @override
  MyFormFieldState createState() => MyFormFieldState();
}

class MyFormFieldState extends State<MyFormField> {
  late TextEditingController _textFieldController;
  List<dynamic> _filteredItems = [];
  final Set<String> _selectedItems = {};
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _textFieldController = widget.controller ?? TextEditingController();
    _updateFilteredItems("");
  }

  @override
  void didUpdateWidget(MyFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update filtered items when dependent value changes
    if (widget.dependentValue != oldWidget.dependentValue ||
        widget.menuItems != oldWidget.menuItems) {
      _updateFilteredItems(_textFieldController.text);
    }
  }

  void _updateFilteredItems(String searchValue) {
    if (widget.menuItems == null) return;

    setState(() {
      // If search suggestions are disabled, show all items without filtering by search text
      if (!widget.enableSearchSuggestions || searchValue.isEmpty) {
        _filteredItems = List.from(widget.menuItems!);
      } else {
        _filteredItems = widget.menuItems!
            .where((item) =>
                item.name.toLowerCase().contains(searchValue.toLowerCase()))
            .toList();
      }

      // Additional filtering based on dependent value if it exists
      if (widget.dependentValue != null && widget.dependentValue!.isNotEmpty) {
        _filteredItems = _filteredItems
            .where((item) =>
                item.locationTypeId.toString() == widget.dependentValue)
            .toList();
      }

      if (_filteredItems.isEmpty) {
        _filteredItems.add(
            LocationModel(name: 'No results found', id: 0, locationTypeId: 0));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null && widget.title!.isNotEmpty)
          Text(
            widget.title!,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),
          ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                keyboardType: widget.textType,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: widget.enableSpellCheck,
                enableSuggestions: widget.enableSpellCheck,
                onTap: () {
                  if (widget.showDownMenu && !widget.isReadonly) {
                    setState(() {
                      _isMenuOpen = true;
                    });
                  }
                  widget.onTap?.call();
                },
                readOnly: widget.isReadonly,
                validator: widget.validator ??
                    (value) {
                      if ((value == null || value.isEmpty) &&
                          _selectedItems.isEmpty) {
                        return "* Required";
                      }
                      return null;
                    },
                cursorColor: Colors.blue,
                obscureText: widget.isPassword,
                controller: _textFieldController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.suffixIcon != null)
                        IconButton(
                          onPressed: () {
                            widget.suffixIconPressed?.call();
                          },
                          icon: Icon(
                            widget.suffixIcon,
                            color: Colors.blue,
                          ),
                        ),
                      if (widget.showDownMenu)
                        IconButton(
                          onPressed: _toggleMenu,
                          icon: _isMenuOpen
                              ? const Icon(Icons.keyboard_arrow_up)
                              : const Icon(Icons.keyboard_arrow_down),
                        ),
                    ],
                  ),
                ),
                onChanged: (value) {
                  if (widget.showDownMenu && widget.enableSearchSuggestions) {
                    _updateFilteredItems(value);
                  }
                  widget.onChange?.call(value);
                },
              ),
              if (_isMenuOpen &&
                  widget.showDownMenu &&
                  _filteredItems.isNotEmpty)
                Container(
                  constraints: const BoxConstraints(
                    maxHeight: 200, // Limit the height and make scrollable
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(6),
                      bottomRight: Radius.circular(6),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      final isNoResults = item.name == 'No results found';

                      return Column(
                        children: [
                          if (index > 0) const Divider(height: 1),
                          GestureDetector(
                            onTap: isNoResults
                                ? null
                                : () => _onMenuItemSelected(item),
                            child: ListTile(
                              title: Text(
                                item.name,
                                style: TextStyle(
                                  color:
                                      isNoResults ? Colors.grey : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _onMenuItemSelected(dynamic item) {
    if (item.name == 'No results found') return;

    setState(() {
      if (widget.multiSelect) {
        if (_selectedItems.contains(item.name)) {
          _selectedItems.remove(item.name);
        } else {
          _selectedItems.add(item.name);
        }
        _textFieldController.text = _selectedItems.join(', ');
      } else {
        _textFieldController.text = item.name;
        _isMenuOpen = false;
      }
    });

    // Notify parent about the selection
    if (widget.onDependentValueChanged != null) {
      widget.onDependentValueChanged!(item.id.toString());
    }

    // Provide full item data to parent if needed
    if (widget.onItemSelected != null) {
      widget.onItemSelected!(item);
    }
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }
}

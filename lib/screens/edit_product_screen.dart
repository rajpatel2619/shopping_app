import 'package:flutter/material.dart';
import 'package:shopping_app/providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: '', price: 0, description: '', imageUrl: '');

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          (_imageUrlController.text.startsWith('http') &&
              _imageUrlController.text.startsWith('https')) ||
          (_imageUrlController.text.endsWith('.png') &&
              _imageUrlController.text.endsWith('.jpg') &&
              _imageUrlController.text.endsWith('jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Product'),
          actions: [
            IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
              key: _form,
              child: ListView(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Title'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Provide title';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _editedProduct = Product(
                          title: newValue,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          id: null);
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Price'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a price';
                      }
                      if (double.parse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      if (double.parse(value) <= 0) {
                        return 'Please enter price greator than zero!';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _editedProduct = Product(
                          title: _editedProduct.title,
                          price: double.parse(newValue),
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          id: null);
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptionFocusNode,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Provide description';
                      }
                      if (value.length < 10) {
                        return 'Lenth should be more than 10 chars long!';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: newValue,
                          imageUrl: _editedProduct.imageUrl,
                          id: null);
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.only(top: 8, right: 10),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: _imageUrlController.text.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'Enter a valid Url for Preview the product image!',
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : FittedBox(
                                child: Image.network(_imageUrlController.text),
                                fit: BoxFit.cover,
                              ),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Image Url',
                          ),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imageUrlFocusNode,
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Provide image url';
                            }
                            if (!value.startsWith('http') &&
                                !value.startsWith('https')) {
                              return 'Please enter a valid url';
                            }
                            if (!value.endsWith('.png') &&
                                !value.endsWith('.jpg') &&
                                !value.endsWith('.jpeg')) {
                              return 'Please provide a valid url';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _editedProduct = Product(
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                description: _editedProduct.description,
                                imageUrl: newValue,
                                id: null);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ));
  }
}

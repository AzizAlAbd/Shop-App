import 'package:ShopApp/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/EditProductScreen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlCont = new TextEditingController();
  final _imageFocusNode = FocusNode();
  final _key = new GlobalKey<FormState>();
  var _editProduct =
      Product(id: null, title: "", description: "", price: 0.0, imageUrl: "");

  var _isinit = true;
  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': ''
  };
  var _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isinit) {
      final productId = ModalRoute.of(context).settings.arguments;
      if (productId != null) {
        final product =
            Provider.of<Products>(context, listen: false).findById(productId);
        _editProduct = product;
        _initValues = {
          'title': _editProduct.title,
          'price': _editProduct.price.toString(),
          'description': _editProduct.description,
          'imageUrl': ''
        };
        _imageUrlCont.text = _editProduct.imageUrl;
      }
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _imageFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      if (_imageUrlCont.text.isEmpty ||
          (!_imageUrlCont.text.startsWith("http") &&
              !_imageUrlCont.text.startsWith("https")) ||
          (!_imageUrlCont.text.endsWith(".png") &&
              !_imageUrlCont.text.endsWith(".jpg") &&
              !_imageUrlCont.text.endsWith(".jpeg"))) return;
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isval = _key.currentState.validate();
    if (!isval) {
      return;
    }

    _key.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editProduct.id, _editProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editProduct);
      } catch (e) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text("An Error Occurred"),
              content: Text("Something went wrong"),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.of(ctx).pop(), child: Text('Ok'))
              ],
            );
          },
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _key,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initValues["title"],
                        decoration: InputDecoration(
                          labelText: "Title",
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                              title: value,
                              price: _editProduct.price,
                              id: _editProduct.id,
                              description: _editProduct.description,
                              imageUrl: _editProduct.imageUrl);
                        },
                        validator: (value) {
                          if (value.isEmpty)
                            return "please enter a title";
                          else
                            return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues["price"],
                        decoration: InputDecoration(
                          labelText: "Price",
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descFocusNode);
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                              title: _editProduct.title,
                              price: double.parse(value),
                              id: _editProduct.id,
                              description: _editProduct.description,
                              imageUrl: _editProduct.imageUrl);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "please provide a value";
                          } else if (double.tryParse(value) == null) {
                            return "please enter a valid number";
                          } else if (double.parse(value) <= 0) {
                            return "please enter a number greater then zero";
                          } else
                            return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues["description"],
                        decoration: InputDecoration(
                          labelText: "Description",
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descFocusNode,
                        onSaved: (value) {
                          _editProduct = Product(
                              title: _editProduct.title,
                              price: _editProduct.price,
                              id: _editProduct.id,
                              description: value,
                              imageUrl: _editProduct.imageUrl);
                        },
                        validator: (value) {
                          if (value.isEmpty)
                            return "please enter a description";
                          else if (value.length < 10)
                            return "should be at least ten characters long";
                          else
                            return null;
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
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                              child: _imageUrlCont.text.isEmpty
                                  ? Text("Enter a Url")
                                  : FittedBox(
                                      child: Image.network(
                                        _imageUrlCont.text,
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: "Image Url"),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlCont,
                              focusNode: _imageFocusNode,
                              onEditingComplete: () {
                                setState(() {});
                              },
                              onFieldSubmitted: (_) => _saveForm(),
                              validator: (value) {
                                if (value.isEmpty)
                                  return "please enter a image url";
                                else if (!value.startsWith("http") &&
                                    !value.startsWith("https"))
                                  return "unvalid url";
                                else if (!value.endsWith(".png") &&
                                    !value.endsWith(".jpg") &&
                                    !value.endsWith(".jpeg"))
                                  return "unvalid image url ";
                                else
                                  return null;
                              },
                              onSaved: (value) {
                                _editProduct = Product(
                                    title: _editProduct.title,
                                    price: _editProduct.price,
                                    id: _editProduct.id,
                                    description: _editProduct.description,
                                    imageUrl: value);
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}

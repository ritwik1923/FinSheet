import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/finsheet_bloc.dart';
import '../data/model/entities.dart';

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  final _priceInputController = TextEditingController();
  final _commentInputController = TextEditingController();
  final _tagInputController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TagModel _tag;
  bool type = true;
  bool showtags = false;

  void validateAndSave() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      print('Form is valid');
    } else {
      print('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinsheetBloc, FinsheetState>(
      builder: (context, state) {
        if (state is FinsheetLoadedDBState) {
          Future<void> _addprice() async {
            if (_priceInputController.text.isEmpty ||
                (_tagInputController.text.isEmpty && _tag == Null)) return;
            print(
                "${_priceInputController.text} ${_tagInputController.text} \n${_commentInputController.text}");
            FinModel order = FinModel(
                price: double.parse(_priceInputController.text),
                comments: _commentInputController.text,
                createdTime: DateTime.now(),
                updatedTime: DateTime.now(),
                type: type);
            if (_tagInputController.text != "")
              order.tag.target = TagModel(tag: _tagInputController.text);
            else
              order.tag.target = _tag;

            print("tag : ${order.tag}\nprice: ${order.price}");
            state.addFin(order);
            _priceInputController.text = '';
            _tagInputController.text = '';
            _commentInputController.text = '';
          }

          return SafeArea(
            child: Scaffold(
                body: Container(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // DataEntry(),

                    Row(
                      children: [
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back_ios_new_outlined)),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Add Expenditure",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    Form(
                      key: _formKey,
                      child: Column(children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.only(left: 8, top: 8),
                                child: TextFormField(
                                  controller: _tagInputController,
                                  key: const Key('input'),
                                  validator: (value) => value!.isEmpty
                                      ? 'tag cannot be blank'
                                      : null,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        // borderSide: BorderSide(color: Colors.teal),
                                        ),
                                    hintText: 'Enter Tag',
                                    helperText: 'Write new tag here.',
                                    labelText: 'Tag',
                                    // prefixIcon: const Icon(
                                    //   Icons.person,
                                    //   color: Colors.green,
                                    // ),
                                    // prefixText: ' ',
                                    // suffixText: 'USD',
                                    // suffixStyle: const TextStyle(color: Colors.green),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: TextFormField(
                                  controller: _priceInputController,
                                  key: const Key('input'),
                                  validator: (value) => value!.isEmpty
                                      ? 'price cannot be blank'
                                      : null,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        // borderSide: BorderSide(color: Colors.teal),
                                        ),
                                    hintText: 'Enter Price',
                                    helperText: 'Write Price here.',
                                    labelText: 'Price',
                                    // prefixIcon: const Icon(
                                    //   Icons.person,
                                    //   color: Colors.green,
                                    // ),
                                    // prefixText: ' ',
                                    // suffixText: 'USD',
                                    // suffixStyle: const TextStyle(color: Colors.green),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    showtags = !showtags;
                                  });
                                },
                                icon: Icon(!showtags
                                    ? Icons.arrow_drop_down
                                    : Icons.arrow_drop_up_outlined))
                          ],
                        ),
                        if (showtags)
                          StreamBuilder<List<TagModel>>(
                              stream: state.getallTags(),
                              // stream: state.getAllExpense(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return Wrap(
                                  children: [
                                    Wrap(
                                      children: [
                                        for (var tag in snapshot.data!)
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _tag = tag;
                                              });
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              margin: const EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey
                                                        .withOpacity(.5)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                              ),
                                              child:
                                                  Text("${tag.tag} ${tag.id}"),
                                            ),
                                          )
                                      ],
                                    )
                                  ],
                                );
                              }),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: TextFormField(
                            controller: _commentInputController,
                            key: const Key('input'),
                            keyboardType: TextInputType.multiline,
                            minLines:
                                3, //Normal textInputField will be displayed
                            maxLines:
                                5, // when user presses enter it will adapt to it
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  // borderSide: BorderSide(color: Colors.teal),
                                  ),
                              hintText: 'Enter comment',
                              helperText: 'Write comment here.',
                              labelText: 'comment',
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  type = true;
                                  print("add $type");
                                });
                              },
                              icon: Icon(Icons.add_box_outlined),
                              color: type == true
                                  ? Colors.lightBlueAccent
                                  : Colors.white60,
                            ),
                            Text(""),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    type = false;
                                    print("min ");
                                  });
                                },
                                icon: Icon(
                                    Icons.indeterminate_check_box_outlined,
                                    color: type == false
                                        ? Colors.lightBlueAccent
                                        : Colors.white60)),
                            // icon: Icon(Icons.call_made_outlined)),
                          ],
                        ),
                      ]),
                    ),

                    Expanded(child: Container()),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          child: Text("Submit"),
                          onPressed: () async {
                            // your code
                            await _addprice();
                            validateAndSave();
                            Navigator.pop(context);
                          }),
                    )
                  ],
                ),
              ),
            )),
          );
        } else
          return Text("State error");
      },
    );
  }
}

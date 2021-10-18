import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:stacked/stacked.dart';
import 'forum_create_post_viewmodel.dart';

class ForumCreatePostViewmodel extends StatelessWidget {
  const ForumCreatePostViewmodel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForumCreatePostModel>.reactive(
        viewModelBuilder: () => ForumCreatePostModel(),
        builder: (context, model, chilld) => Padding(
              padding: const EdgeInsets.only(top: 75, left: 16, right: 16),
              child: createPostTemplate(model, context),
            ));
  }
}

Column createPostTemplate(ForumCreatePostModel model, context) {
  return Column(
    children: [
      Row(
        children: [
          Expanded(
              flex: 5,
              child: SizedBox(
                height: 55,
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: model.title,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 2)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0)),
                      label: const Text(
                        'Title',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              )),
          Expanded(
              flex: 6,
              child: FutureBuilder(
                  future: model.requestCategorieNames(),
                  builder: (context, snapshot) {
                    List<String> names = [];
                    names = snapshot.data as List<String>;
                    return Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: DropdownButtonFormField(
                          style: const TextStyle(color: Colors.white),
                          dropdownColor: const Color(0xFF0a0a23),
                          decoration: InputDecoration(
                            isDense: true,
                            enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2)),
                          ),
                          value: model.categoryDropDownValue,
                          onChanged: (String? value) {
                            model.changeDropDownValue(value);
                          },
                          items: snapshot.hasData
                              ? names.map<DropdownMenuItem<String>>(
                                  (String value) {
                                  return DropdownMenuItem<String>(
                                      value: value, child: Text(value));
                                }).toList()
                              : [
                                  'Category'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                      value: value, child: Text(value));
                                }).toList()),
                    );
                  })),
        ],
      ),
      Row(
        children: const [
          Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Text(
              'Your code / message',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      Row(
        children: [
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: model.code,
                minLines: 10,
                maxLines: null,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0)),
                  errorText: model.categoryHasError
                      ? model.categoryError
                      : model.topicHasError
                          ? model.errorMessage
                          : null,
                  errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2)),
                ),
              ),
            ),
          )
        ],
      ),
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                      side: const BorderSide(width: 2, color: Colors.white),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0))),
                  onPressed: () {
                    model.createPost(model.title.text, model.code.text);
                  },
                  child: const Text(
                    'CREATE NEW POST',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ),
        ],
      )
    ],
  );
}

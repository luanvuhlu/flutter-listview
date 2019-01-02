import 'package:flutter/material.dart';
import '../models/user/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/firebase/comment.dart';
import '../models/firebase/user.dart' as user_fire;
import '../services/blocs/comment/comment_bloc.dart';

class UserDetailPage extends StatelessWidget {
  final User user;
  final CommentBloc bloc;
  UserDetailPage(this.user)
      : bloc = CommentBloc(user: user_fire.User(email: user.email));

  @override
  Widget build(BuildContext context) {
    print(user.email);
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double targetHeight =
        deviceHeight < 600.0 ? 480.0 : deviceHeight - 320;
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.name.first} ${user.name.last}'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20, left: 20),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag: 'userAvatar${user.email}',
                      child: Image.network(
                        user.picture.large,
                        width: 128,
                        height: 128,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Container(
                        // decoration: BoxDecoration(
                        //     border: Border.all(color: Colors.red, width: 2)),
                        child: Column(
                          children: <Widget>[
                            _buildNameRow(),
                            _buildGenderRow(),
                            _buildDateOfBirthRow(),
                            _buildEmailRow(),
                            _buildPhoneRow(),
                            // _buildCellPhoneRow(),
                            _buildAddressRow(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // _buildAddressMap(context),
              Expanded(
                child: SizedBox(
                  height: targetHeight,
                  child: _buildCommentList(context),
                ),
              ),
              _buildCommentInput(context),
            ],
          ),
        ),
      ),
    );
  }

  final TextEditingController _controller = new TextEditingController();

  Widget _buildCommentInput(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          StreamBuilder(
            stream: bloc.content,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return TextField(
                controller: _controller,
                onChanged: bloc.changeContent,
                maxLines: 4,
                decoration: InputDecoration(
                    labelText: 'Content', errorText: snapshot.error),
              );
            },
          ),
          StreamBuilder(
            stream: bloc.submitValid,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return RaisedButton(
                color: Theme.of(context).buttonColor,
                textColor: Theme.of(context).textTheme.title.color,
                onPressed: !snapshot.hasData || !snapshot.data
                    ? null
                    : () => bloc.addComment().then((_) => _controller.clear()),
                child: StreamBuilder(
                  stream: bloc.adding,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    return snapshot.hasData && snapshot.data
                        ? CircularProgressIndicator()
                        : Text('Add');
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildCommentList(BuildContext context) {
    return StreamBuilder<List<Comment>>(
      stream: bloc.commentsStream(),
      builder: (BuildContext context, AsyncSnapshot<List<Comment>> snapshot) {
        if (!snapshot.hasData) {
          return Text('Loading...');
        }
        if (snapshot.data.isEmpty) {
          return Text('There is no comment');
        }
        final List<Comment> comments = snapshot.data;
        return ListView.builder(
          padding: EdgeInsets.only(top: 20),
          itemCount: comments.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black26))),
              child: Wrap(
                children: <Widget>[Text(comments[index].content)],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAddressRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Address: '),
        Flexible(
            child: Text(
                '${user.location.street}, ${user.location.city}, ${user.location.state}'))
      ],
    );
  }

  Widget _buildAddressMap(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double targetWidth = deviceWidth - 40;
    final double targetHeight =
        deviceHeight < 600.0 ? 480.0 : deviceHeight - 320;
    return FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 500)),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            height: targetHeight,
            width: targetWidth,
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                print('Created');
              },
              options: GoogleMapOptions(
                  cameraPosition: CameraPosition(
                      target: LatLng(
                          double.parse(user.location.coordinates.latitude),
                          double.parse(user.location.coordinates.longitude)))),
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildGenderRow() {
    return Row(
      children: <Widget>[
        Text('Gender: '),
        Icon(user.gender == 'female'
            ? Icons.pregnant_woman
            : Icons.accessibility)
      ],
    );
  }

  Widget _buildDateOfBirthRow() {
    return Row(
      children: <Widget>[Text('Age: '), Text(user.dob.age.toString())],
    );
  }

  Widget _buildEmailRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Email: '),
        Flexible(
          child: Text(user.email),
        )
      ],
    );
  }

  Widget _buildPhoneRow() {
    return Row(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Text('Phone: '),
              Text(user.phone),
            ],
          ),
        ),
        // SizedBox(
        //   width: 20,
        // ),
      ],
    );
  }

  Widget _buildCellPhoneRow() {
    return Row(
      children: <Widget>[
        Text('CellPhone: '),
        Text(user.cell),
      ],
    );
  }

  Widget _buildNameRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Text('First name: '),
              Flexible(
                child: Text(user.name.first),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Text('Last name: '),
              Flexible(
                child: Text(user.name.last),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}

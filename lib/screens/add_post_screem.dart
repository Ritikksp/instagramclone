import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/Model/user.dart';
import 'package:instagram/provider/user_provider.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}



class _AddPostScreenState extends State<AddPostScreen> {
  TextEditingController _descreptionControler = TextEditingController();
  Uint8List? _file;
  bool _isLoading = false;

  _selectImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Create a post"),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: const Text("Take a photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: const Text("Choose from gallary"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text("Cencele"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void postImage(
    String uid,
    String username,
    String profImage
  )async{
    setState((){
      _isLoading = true;
    });
    try{
      String res = await firestoreMethods().uploadImage(
        _descreptionControler.text, 
        _file!, 
        uid, 
        username,
        profImage
      );
      if(res == "success"){
        setState((){
      _isLoading = false;
      });
        ShowSnackBar("Posted", context);
        clearImage();
      }else{
        setState((){
      _isLoading = false;
      });
        ShowSnackBar(res, context);
      }
    }catch(e){
      ShowSnackBar(e.toString(), context);
    }

  }

  @override
  void dispose() {
    super.dispose();
    _descreptionControler.dispose();
  }

  void clearImage(){
    _file =null;
  }

  @override
  Widget build(BuildContext context) {
    
    final User user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Center(
            child: Container(
              child: IconButton(
                icon: const Icon(
                  Icons.image,
                  size: 25,
                ),
                onPressed: () {
                  _selectImage(context);
                },
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: Text('Post it'),
              actions: [
                TextButton(
                    onPressed: () => postImage(
                      user.uid,
                      user.username,
                      user.photoUrl
                      ),
                    child: const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Text(
                        "Post",
                        style: TextStyle(
                            color: blueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ))
              ],
            ),
            body: Column(
              children: [
                _isLoading ? const LinearProgressIndicator():
                const Padding(padding: EdgeInsets.only(top: 0)
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          user.photoUrl
                          ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextField(
                        controller: _descreptionControler,
                        decoration: InputDecoration(
                            hintText: "Write a caption...",
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                        width: 45,
                        height: 45,
                        child: AspectRatio(
                          aspectRatio: 487 / 453,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: MemoryImage(_file!),
                                    fit: BoxFit.cover,
                                    alignment: FractionalOffset.topCenter)),
                          ),
                        )),
                    const Divider(),
                  ],
                )
              ],
            ),
          );
  }
}

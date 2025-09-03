import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order_makan/fileservice.dart';
import 'package:path/path.dart' as p;

class ImagepickerWidget extends StatefulWidget {
  final String imgdir;
  final String Function(String a) imgdirUpdater;
  const ImagepickerWidget(this.imgdir,
      {required this.imgdirUpdater, super.key});

  @override
  State<ImagepickerWidget> createState() => _ImagepickerWidgetState();
}

class _ImagepickerWidgetState extends State<ImagepickerWidget> {
  late String imgdir;
  bool loading = false;
  @override
  void initState() {
    imgdir = widget.imgdir;
    super.initState();
  }

  Future<String?> uploadFile(XFile a) async {
    // var savedir = await getApplicationDocumentsDirectory();
    var compressedData = await FileService.imageCompress(await a.readAsBytes());
    // var createdfile = await File(p.join(savedir.path, p.basename(a.path)))
    //     .writeAsBytes(compressedData);
    //    return createdfile;
    return (await FileService.menuimageUpload(
            compressedData, p.basename(a.path)))
        ?.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: (imgdir.isEmpty)

          ///new image
          ? ElevatedButton.icon(
              onPressed: () async {
                XFile? a =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (a != null) {
                  setState(() {
                    loading = true;
                  });
                  var dlUrl = await uploadFile(a);
                  setState(() {
                    loading = false;
                    imgdir = dlUrl ?? '';
                  });
                  widget.imgdirUpdater(dlUrl ?? '');
                }
              },
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Gambar'))

          ///replace image
          : loading
              ? CircularProgressIndicator.adaptive()
              : SizedBox(
                  height: 110,
                  child: InkWell(
                    onTap: () async {
                      var a = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (a != null) {
                        setState(() {
                          loading = true;
                        });
                        var dlUrl = await uploadFile(a);
                        setState(() {
                          loading = false;
                          imgdir = dlUrl ?? '';
                        });
                        widget.imgdirUpdater(dlUrl ?? '');
                      }
                    },
                    child: imgdir.contains('assets')
                        ? Image.asset(imgdir)
                        : Image.network(
                            (imgdir),
                            errorBuilder: (context, error, stackTrace) =>
                                Card.outlined(child: Text(error.toString())),
                          ),
                  ),
                ),
    );
  }
}

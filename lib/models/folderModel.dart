
class Folder {
  Folder({
    required this.name,
    required this.isExpanded,
    required this.isVisible,
    required this.isFolder,
    required this.isDelete,
    required this.subfolders,
  });

  String name;
  bool isExpanded;
  bool isVisible;
  bool isFolder;
  bool isDelete;
  List<Folder> subfolders;
}
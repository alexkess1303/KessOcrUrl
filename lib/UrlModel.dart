class UrlModel
{
  final String origionalText;
  List<String> urls;
  String status;
  bool isLaunchable;

  UrlModel({this.origionalText})
  {
    final urlRegExp = new RegExp(
        r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
    final urlMatches = urlRegExp.allMatches(origionalText);
    List<String> urls = urlMatches.map(
            (urlMatch) => origionalText.substring(urlMatch.start, urlMatch.end))
        .toList();

    switch(urls.length){
      case 0:
        status = "No urls";
        isLaunchable = false;
        break;
      case 1:
        status = 'Url <'+urls.first+'>';
        isLaunchable = true;
        break;
      default:
        status = urls.length.toString() + ' urls';
        isLaunchable = false;
        break;
    }
  }

  bool canLaunch()
  {
    //return (urls != null && urls.length == 1);
    //if (urls == null) return false;
    //if (urls.length != 1) return false;
    //return true;
    return isLaunchable;
  }
  String getSubTitle()
  {
    return status;
    //if (canLaunch())
    //    return status + 'Can';
    //return status+ 'Not';
  }
}
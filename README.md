# tenor_picker

A plugin that allows you to pick animated GIF images from [Tenor](https://tenor.com).



## Getting Started

First, you need to register an app at the [Tenor Developers Portal](https://developers.tenor.com/) in order to retrieve an API key.

Pick a GIF:

```dart
import 'package:tenor_client/tenor_client.dart';

final gif = await TenorPicker.pickGif(
                  context: context, 
                  apiKey: '[YOUR TENOR APIKEY]');
```

Display a GIF using the ```TenorImage``` widget. The following snippet demonstrates how to render a GIF in its original format:
```dart
Widget build(BuildContext context) {
  return TenorImage.original(gif: gif);
}
```

Alternatively, load and display the GIF image using the ```Image``` widget:
```dart
Widget build(BuildContext context) {
  return Image.network(
      gif.images.original.url, 
      headers: {'accept': 'image/*'}))
}
```


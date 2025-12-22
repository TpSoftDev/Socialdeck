'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"manifest.json": "9ff2d08cde31b5913f2900dc7795296f",
"index.html": "df2b063d470df0df6bcc6dc72c61c0cf",
"/": "df2b063d470df0df6bcc6dc72c61c0cf",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "075d656a2ed66e2069680daf7e990924",
"assets/fonts/MaterialIcons-Regular.otf": "32fe3ee15d2e52f9f4bc4c2242dc7437",
"assets/NOTICES": "55f49641b0cc21d24568682272ab15a2",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/socialdeck/assets/icons/dark/invertedStroke/Pinch%2520Adjust.svg": "27dad5b3db36fcc8c1b86d092ec1ff9d",
"assets/packages/socialdeck/assets/icons/dark/invertedStroke/Placeholder.svg": "62fa46a3a8cc7feaa634e8ab130652db",
"assets/packages/socialdeck/assets/icons/dark/invertedStroke/Placeholder-1.svg": "5ad28ea65fb939fd1c8cf34da2242cca",
"assets/packages/socialdeck/assets/icons/dark/misc/Vector%252035.svg": "a583bcc5803654cf92137c4a327ae91e",
"assets/packages/socialdeck/assets/icons/dark/misc/Circle%2520Check.svg": "26ae8ee4d2c4d9a5ddf543c551d423ca",
"assets/packages/socialdeck/assets/icons/dark/misc/Ellipse%252010.svg": "2e5ee647028cdd081c38a9adc3e6ee30",
"assets/packages/socialdeck/assets/icons/dark/misc/Add%2520Profile%2520Card.svg": "2978540cf1798d54651e41ccc37ca26f",
"assets/packages/socialdeck/assets/icons/dark/misc/Google.svg": "5c8f06530a93c86c3854385024580601",
"assets/packages/socialdeck/assets/icons/dark/misc/WordmarkDarkmode.svg": "529e841eec3f6e0401cebcd808df364c",
"assets/packages/socialdeck/assets/icons/dark/misc/Ellipse%252010-1.svg": "2e5ee647028cdd081c38a9adc3e6ee30",
"assets/packages/socialdeck/assets/icons/dark/misc/Vector%252023.svg": "217531c72b52042b5826e6b0e967bed2",
"assets/packages/socialdeck/assets/icons/dark/misc/Google-1.svg": "373b34506d3f6b006e18d4c165971cce",
"assets/packages/socialdeck/assets/icons/dark/misc/Vector%252035-1.svg": "2b2ccb323e9160f381f4cf0ad1b670c7",
"assets/packages/socialdeck/assets/icons/dark/misc/Play%2520Box.svg": "03e63baa3b843246178ec7709dc09353",
"assets/packages/socialdeck/assets/icons/dark/misc/Circle%2520X.svg": "9f7ec6520eeee447993a421dcf835c71",
"assets/packages/socialdeck/assets/icons/dark/misc/Vector%252030.svg": "41d266b6873489efc9241e3770eb9f8b",
"assets/packages/socialdeck/assets/icons/dark/misc/Vector%252033.svg": "cb09a2435f63ce5f3a4a4ba58ab8c8bc",
"assets/packages/socialdeck/assets/icons/dark/misc/Apple.svg": "79d18f69513d4853f440457e057cc2e9",
"assets/packages/socialdeck/assets/icons/dark/fill/Friends.svg": "b8ba6ff358ccaee562ca9a1ef75b9aef",
"assets/packages/socialdeck/assets/icons/dark/fill/Store.svg": "0c9dfe71955984a3aeed9e7edc950cbf",
"assets/packages/socialdeck/assets/icons/dark/fill/Deck.svg": "aac32be664994a57f400f370af818837",
"assets/packages/socialdeck/assets/icons/dark/fill/Settings.svg": "4b119f258006ab090dafe551477bfd1e",
"assets/packages/socialdeck/assets/icons/dark/fill/Profile.svg": "83f6405f73a8f2e106fd996892bc20cc",
"assets/packages/socialdeck/assets/icons/dark/fill/Home.svg": "ee5047b92dd87bc7245a3798805c2e34",
"assets/packages/socialdeck/assets/icons/dark/stroke/Friends.svg": "ef34eff91ae69e825018326e2288c6c9",
"assets/packages/socialdeck/assets/icons/dark/stroke/Store.svg": "b0e6a004c748b5f8df76a6d5006013cf",
"assets/packages/socialdeck/assets/icons/dark/stroke/Add%2520Friend.svg": "ee0b440bd64463ef0cc37a40a0b5809b",
"assets/packages/socialdeck/assets/icons/dark/stroke/Clock.svg": "0ca5cb97baf54f11de5e01011fd28bf0",
"assets/packages/socialdeck/assets/icons/dark/stroke/Section%2520Labels.svg": "b35a6f31d88e1f1b51c0213ce84ab334",
"assets/packages/socialdeck/assets/icons/dark/stroke/Search.svg": "a52628351dfe288a7a56319c59c2571d",
"assets/packages/socialdeck/assets/icons/dark/stroke/Left%2520Chevron.svg": "5c261afc5472970b86adfe0f1f96da19",
"assets/packages/socialdeck/assets/icons/dark/stroke/Down%2520Chevron.svg": "1f01afb672a09a8ef27df9dddb894cd3",
"assets/packages/socialdeck/assets/icons/dark/stroke/Deck.svg": "a7a45179ff4ba762dfd32ecbcbc0fa07",
"assets/packages/socialdeck/assets/icons/dark/stroke/Eye.svg": "566a1730b5b15c4e13eee94d94eedcc8",
"assets/packages/socialdeck/assets/icons/dark/stroke/Star.svg": "421f02ceb9fba4fa7b6150d07caa0195",
"assets/packages/socialdeck/assets/icons/dark/stroke/Settings.svg": "4b119f258006ab090dafe551477bfd1e",
"assets/packages/socialdeck/assets/icons/dark/stroke/Up%2520Chevron.svg": "7e1d35ea479cb7b3fb341c36deaf36c4",
"assets/packages/socialdeck/assets/icons/dark/stroke/Megaphone.svg": "9642c2c90f427bf11970d41535d2bf9d",
"assets/packages/socialdeck/assets/icons/dark/stroke/Placeholder.svg": "62fa46a3a8cc7feaa634e8ab130652db",
"assets/packages/socialdeck/assets/icons/dark/stroke/More.svg": "0252599c167381c45d2bd9ca88b5eac3",
"assets/packages/socialdeck/assets/icons/dark/stroke/X.svg": "73911e012da58ab16d706f2c165b8460",
"assets/packages/socialdeck/assets/icons/dark/stroke/Right%2520Chevron.svg": "4684061ed12493e49ab91a5919701cfd",
"assets/packages/socialdeck/assets/icons/dark/stroke/Zoom%2520Out.svg": "29df41ad26ae61a1790469e9aa51f149",
"assets/packages/socialdeck/assets/icons/dark/stroke/Play%2520Hollow.svg": "f40cbb75499a4ba646aa9aa013e2aa0c",
"assets/packages/socialdeck/assets/icons/dark/stroke/Closed%2520Eye.svg": "b8f2e03211f38a9f49f0e7f62b2e3b21",
"assets/packages/socialdeck/assets/icons/dark/stroke/Mail.svg": "58005c297ef7b48a8c3c60f5f2716d99",
"assets/packages/socialdeck/assets/icons/dark/stroke/Profile.svg": "f1d24369b4a083c8b460e8868a73bd49",
"assets/packages/socialdeck/assets/icons/dark/stroke/Grid.svg": "88056a6a60cd38e17b6651c04fb08d66",
"assets/packages/socialdeck/assets/icons/dark/stroke/Trash.svg": "a923bc622582094301602a54e2e1568c",
"assets/packages/socialdeck/assets/icons/dark/stroke/Help.svg": "9b26d9ed5b57cf50a619ddb032b042b3",
"assets/packages/socialdeck/assets/icons/dark/stroke/Home.svg": "2605207243afbe23f59025fc0b9c06a6",
"assets/packages/socialdeck/assets/icons/dark/stroke/Camera.svg": "33be55ddbe9f8872de411345dc034c2b",
"assets/packages/socialdeck/assets/icons/dark/stroke/Edit.svg": "9f7cbc95e748bf50fbf14c04e072ae21",
"assets/packages/socialdeck/assets/icons/dark/stroke/Zoom%2520In.svg": "6a24cb8b907d85de9d0103e95545e61c",
"assets/packages/socialdeck/assets/icons/dark/stroke/Socialdeck%2520Logo.svg": "9a213e182602304b932c3994afd7b823",
"assets/packages/socialdeck/assets/icons/light/invertedStroke/Pinch%2520Adjust.svg": "6d2f730b9022d5db0212571e15c674b5",
"assets/packages/socialdeck/assets/icons/light/invertedStroke/Placeholder.svg": "102c8eab83123911ad3c0615f34c566f",
"assets/packages/socialdeck/assets/icons/light/invertedStroke/Placeholder-1.svg": "f4ad5aad13bab1c96df7cb6ba0c2bcc3",
"assets/packages/socialdeck/assets/icons/light/misc/Vector%252035.svg": "2b300e43c8e58e82d3191c95d99b1637",
"assets/packages/socialdeck/assets/icons/light/misc/WordmarkLightMode.svg": "bd541ccb8429a4f6be959f298f2dd440",
"assets/packages/socialdeck/assets/icons/light/misc/Circle%2520Check.svg": "0461c9b3726097eabf0bc22c2f9285c4",
"assets/packages/socialdeck/assets/icons/light/misc/Ellipse%252010.svg": "3da33882c9fcc54563ff05e81796320f",
"assets/packages/socialdeck/assets/icons/light/misc/Add%2520Profile%2520Card.svg": "4f0608e68ce202694e675b80ffb307b1",
"assets/packages/socialdeck/assets/icons/light/misc/Google.svg": "5c8f06530a93c86c3854385024580601",
"assets/packages/socialdeck/assets/icons/light/misc/Ellipse%252010-1.svg": "3da33882c9fcc54563ff05e81796320f",
"assets/packages/socialdeck/assets/icons/light/misc/Vector%252023.svg": "217531c72b52042b5826e6b0e967bed2",
"assets/packages/socialdeck/assets/icons/light/misc/Google-1.svg": "d4d4813aa7ad68eace7bf2e7dae53a36",
"assets/packages/socialdeck/assets/icons/light/misc/Vector%252035-1.svg": "3e4666de195dd0c122ad2a87767a9a02",
"assets/packages/socialdeck/assets/icons/light/misc/Play%2520Box.svg": "48ef6a66b9901f5993f008438808cb74",
"assets/packages/socialdeck/assets/icons/light/misc/Circle%2520X.svg": "dd86391a99f59c95734bfdcce5c8d0cd",
"assets/packages/socialdeck/assets/icons/light/misc/Vector%252030.svg": "d495c5d53206d47a905de16fb32e2b16",
"assets/packages/socialdeck/assets/icons/light/misc/Vector%252033.svg": "b26d0fb2ab43d8eccb01c209ba1a0777",
"assets/packages/socialdeck/assets/icons/light/misc/Apple.svg": "c3873fdd7c24a939df7e176949cfcffb",
"assets/packages/socialdeck/assets/icons/light/fill/Friends.svg": "e2cbd9c74468508f3fbed3e073082d2b",
"assets/packages/socialdeck/assets/icons/light/fill/Store.svg": "922a2ae453856f4330871f5df9e99646",
"assets/packages/socialdeck/assets/icons/light/fill/Deck.svg": "1b49d62551a14c537ec12dedbdd5ee8c",
"assets/packages/socialdeck/assets/icons/light/fill/Settings.svg": "870eb42d7b89760747e75c70ec06cad3",
"assets/packages/socialdeck/assets/icons/light/fill/Profile.svg": "fc40765271fa50f6616211ac1422d815",
"assets/packages/socialdeck/assets/icons/light/fill/Home.svg": "c634969e9d5629d0d1810b83c40c305e",
"assets/packages/socialdeck/assets/icons/light/stroke/Friends.svg": "fc91966fd2bad2c649ff61cde34ba8a1",
"assets/packages/socialdeck/assets/icons/light/stroke/Store.svg": "4c295c7c93f487d9983581d4d0329bdf",
"assets/packages/socialdeck/assets/icons/light/stroke/Add%2520Friend.svg": "abfb9f8e44dedf8d11bb8658e2ff11d7",
"assets/packages/socialdeck/assets/icons/light/stroke/Clock.svg": "4a5966f5b77584b4b789d06ed9299771",
"assets/packages/socialdeck/assets/icons/light/stroke/Section%2520Labels.svg": "63e7f3ec3d2740679a6db1fb87460a87",
"assets/packages/socialdeck/assets/icons/light/stroke/Search.svg": "fadfaa5e5aac7a7a197324b42a29da8e",
"assets/packages/socialdeck/assets/icons/light/stroke/Left%2520Chevron.svg": "963a5f2d4ba986c3a5c8558363cce3db",
"assets/packages/socialdeck/assets/icons/light/stroke/Down%2520Chevron.svg": "f818a739e3706f2e7e22a19c4ce5d448",
"assets/packages/socialdeck/assets/icons/light/stroke/Deck.svg": "bf0fc437b3d834f452e5922f9daef89e",
"assets/packages/socialdeck/assets/icons/light/stroke/Eye.svg": "4565f142a9e56bd14e0f1aeed4fc3190",
"assets/packages/socialdeck/assets/icons/light/stroke/Star.svg": "b43c0371dd388d55376686843a02f341",
"assets/packages/socialdeck/assets/icons/light/stroke/Settings.svg": "a128ed779de117f6cf1c2c6c2d0c59f0",
"assets/packages/socialdeck/assets/icons/light/stroke/Up%2520Chevron.svg": "b5cf64f870e78d2f08719bd7bf0f203c",
"assets/packages/socialdeck/assets/icons/light/stroke/Megaphone.svg": "ee4da45c7fd06fa367bd703b2d3aa19f",
"assets/packages/socialdeck/assets/icons/light/stroke/Placeholder.svg": "102c8eab83123911ad3c0615f34c566f",
"assets/packages/socialdeck/assets/icons/light/stroke/More.svg": "53f3896c7f7ddfb02e4dabbbb02f3168",
"assets/packages/socialdeck/assets/icons/light/stroke/X.svg": "7814b1b622acc737c21da3b14a162704",
"assets/packages/socialdeck/assets/icons/light/stroke/Right%2520Chevron.svg": "b5bac568e6672e284c095396b6dd6321",
"assets/packages/socialdeck/assets/icons/light/stroke/Zoom%2520Out.svg": "b38ecda9fbdc8f403a77fd1463627185",
"assets/packages/socialdeck/assets/icons/light/stroke/Play%2520Hollow.svg": "6cdcc0e5fd32ac2b968af1d030b3f479",
"assets/packages/socialdeck/assets/icons/light/stroke/Closed%2520Eye.svg": "1ddfa32efcd73e0133f2e150a54b08ac",
"assets/packages/socialdeck/assets/icons/light/stroke/Mail.svg": "6aa4ac2ff26a0e1904346ebf5e45f9a2",
"assets/packages/socialdeck/assets/icons/light/stroke/Profile.svg": "bd5292b266de80d75e985da1af6fa500",
"assets/packages/socialdeck/assets/icons/light/stroke/Grid.svg": "7632921164ac870a87939a2ac1593490",
"assets/packages/socialdeck/assets/icons/light/stroke/Trash.svg": "d65a26fa2ffdb8d189677cdc27dcd827",
"assets/packages/socialdeck/assets/icons/light/stroke/Help.svg": "a4a16327420226cbf0097abbb988620b",
"assets/packages/socialdeck/assets/icons/light/stroke/Home.svg": "03d24ef12ca5eb5a6f50212ca29e0954",
"assets/packages/socialdeck/assets/icons/light/stroke/Camera.svg": "ff1d04eb48727084aacb78a206ecdb40",
"assets/packages/socialdeck/assets/icons/light/stroke/Edit.svg": "761b324c3f31c8d01542f55b9fd664f2",
"assets/packages/socialdeck/assets/icons/light/stroke/Zoom%2520In.svg": "75a83e0eba0e423a1abe1fc93c577987",
"assets/packages/socialdeck/assets/icons/light/stroke/Socialdeck%2520Logo.svg": "72fe15af35d1ffaac31851b4a785d203",
"assets/packages/socialdeck/assets/splash_screen/State=Step%25203.svg": "4cfcbb190e013e52c81a0023ec83a8b2",
"assets/packages/socialdeck/assets/splash_screen/Native_Splash.png": "6b6a168698bb42b1049459383f3ac738",
"assets/packages/socialdeck/assets/splash_screen/State=Step%25201.svg": "9a40bd547565ffaa4773422c2f4e5729",
"assets/packages/socialdeck/assets/splash_screen/State=Step%25202.svg": "8090c74266570be3ff3176d7d3e8dad5",
"assets/packages/socialdeck/assets/fonts/Poppins-Light.ttf": "fcc40ae9a542d001971e53eaed948410",
"assets/packages/socialdeck/assets/fonts/Poppins-MediumItalic.ttf": "cf5ba39d9ac24652e25df8c291121506",
"assets/packages/socialdeck/assets/fonts/Poppins-Medium.ttf": "bf59c687bc6d3a70204d3944082c5cc0",
"assets/packages/socialdeck/assets/fonts/Poppins-Italic.ttf": "c1034239929f4651cc17d09ed3a28c69",
"assets/packages/socialdeck/assets/fonts/Poppins-SemiBold.ttf": "6f1520d107205975713ba09df778f93f",
"assets/packages/socialdeck/assets/fonts/Poppins-Regular.ttf": "093ee89be9ede30383f39a899c485a82",
"assets/packages/socialdeck/assets/fonts/Poppins-Bold.ttf": "08c20a487911694291bd8c5de41315ad",
"assets/packages/socialdeck/assets/Photos/IL9A0532-Enhanced-NR.jpg": "0dbcbd4778b84879d732b8b396775690",
"assets/packages/socialdeck/assets/Photos/AR507983.jpg": "8969ccf20708a30ccd7eb81e7f0513ce",
"assets/packages/socialdeck/assets/Photos/IL9A0718-Enhanced-NR.jpg": "311adbe44fb8438802f251447bd15266",
"assets/packages/socialdeck/assets/Photos/IL9A0562-Enhanced-NR.jpg": "2294b847039549eb12430167c588ec7d",
"assets/packages/socialdeck/assets/Photos/IL9A0517-Enhanced-NR.jpg": "d3ecf0a7a4dc69f2af08295146eab2c0",
"assets/packages/socialdeck/assets/Photos/IL9A9720-Enhanced-NR.jpg": "dbff8340cc9f105475cdcfb475d204c8",
"assets/packages/socialdeck/assets/Photos/IL9A9948-Enhanced-NR.jpg": "619a5272a4760280ff766f3a60257514",
"assets/packages/socialdeck/assets/Photos/IL9A0525-Enhanced-NR.jpg": "5a70bd90c5afc598cf095e35e1383765",
"assets/packages/socialdeck/assets/Photos/AR507973.jpg": "7122b5f2d2b7faf74b0c68234bdf78e6",
"assets/packages/socialdeck/assets/Photos/IL9A0723-Enhanced-NR.jpg": "93b4d4d7def1a1a1bfacf396c508a798",
"assets/packages/socialdeck/assets/Photos/IL9A9717-Enhanced-NR.jpg": "ee4b05af36bfcbfca02c7d3abde61df6",
"assets/packages/socialdeck/assets/Photos/IL9A0725-Enhanced-NR.jpg": "f8bef4b092004e35d9601c264aa3f5d1",
"assets/packages/socialdeck/assets/backgrounds/checkered-background.png": "6a893068a0a60c8787d7b43835879a78",
"assets/packages/widgetbook/assets/logo.webp": "23ea085d1f6477c395a4de7f880f08b1",
"assets/packages/widgetbook/assets/fonts/Poppins/Poppins-Light.ttf": "fcc40ae9a542d001971e53eaed948410",
"assets/packages/widgetbook/assets/fonts/Poppins/Poppins-ExtraBoldItalic.ttf": "8afe4dc13b83b66fec0ea671419954cc",
"assets/packages/widgetbook/assets/fonts/Poppins/Poppins-BoldItalic.ttf": "19406f767addf00d2ea82cdc9ab104ce",
"assets/packages/widgetbook/assets/fonts/Poppins/Poppins-SemiBoldItalic.ttf": "9841f3d906521f7479a5ba70612aa8c8",
"assets/packages/widgetbook/assets/fonts/Poppins/Poppins-MediumItalic.ttf": "cf5ba39d9ac24652e25df8c291121506",
"assets/packages/widgetbook/assets/fonts/Poppins/Poppins-Medium.ttf": "bf59c687bc6d3a70204d3944082c5cc0",
"assets/packages/widgetbook/assets/fonts/Poppins/Poppins-Italic.ttf": "c1034239929f4651cc17d09ed3a28c69",
"assets/packages/widgetbook/assets/fonts/Poppins/Poppins-BlackItalic.ttf": "e9c5c588e39d0765d30bcd6594734102",
"assets/packages/widgetbook/assets/fonts/Poppins/Poppins-ThinItalic.ttf": "01555d25092b213d2ea3a982123722c9",
"assets/packages/widgetbook/assets/fonts/Poppins/Poppins-ExtraLightItalic.ttf": "a9bed017984a258097841902b696a7a6",
"assets/packages/widgetbook/assets/fonts/Poppins/Poppins-ExtraLight.ttf": "6f8391bbdaeaa540388796c858dfd8ca",
"assets/packages/widgetbook/assets/fonts/Poppins/Poppins-Thin.ttf": "9ec263601ee3fcd71763941207c9ad0d",
"assets/packages/widgetbook/assets/fonts/Poppins/Poppins-ExtraBold.ttf": "d45bdbc2d4a98c1ecb17821a1dbbd3a4",
"assets/packages/widgetbook/assets/fonts/Poppins/Poppins-Black.ttf": "14d00dab1f6802e787183ecab5cce85e",
"assets/packages/widgetbook/assets/fonts/Poppins/Poppins-SemiBold.ttf": "6f1520d107205975713ba09df778f93f",
"assets/packages/widgetbook/assets/fonts/Poppins/Poppins-Regular.ttf": "093ee89be9ede30383f39a899c485a82",
"assets/packages/widgetbook/assets/fonts/Poppins/Poppins-Bold.ttf": "08c20a487911694291bd8c5de41315ad",
"assets/packages/widgetbook/assets/fonts/Poppins/Poppins-LightItalic.ttf": "0613c488cf7911af70db821bdd05dfc4",
"assets/FontManifest.json": "c3f9cc4c6fa95450d5ad345c222aa4dd",
"assets/AssetManifest.bin": "995e3a01e4035be5c275320ea1f02173",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter_bootstrap.js": "bf5f6b54814966fda5ccf1e0d6b3f86e",
"version.json": "79b76fd19ba16630b316c39ce4f4ddcc",
"main.dart.js": "4d1ed401b554d214cfc37a34da415e0d"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}

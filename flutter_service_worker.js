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
"assets/AssetManifest.bin.json": "48f2847465d6bcdb9910764d2a0da7bc",
"assets/fonts/MaterialIcons-Regular.otf": "32fe3ee15d2e52f9f4bc4c2242dc7437",
"assets/NOTICES": "55f49641b0cc21d24568682272ab15a2",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/socialdeck/assets/icons/misc/Google.svg": "4d17571379b3691b51e70d0f50ee06b3",
"assets/packages/socialdeck/assets/icons/misc/Wordmark.svg": "57757128f6d5f2d7aa1d26e3161a0cc8",
"assets/packages/socialdeck/assets/icons/misc/Delete.svg": "072a523b6a62c5b655fa599e55be85c5",
"assets/packages/socialdeck/assets/icons/misc/Apple.svg": "c3873fdd7c24a939df7e176949cfcffb",
"assets/packages/socialdeck/assets/icons/fill/Friends.svg": "8f29449e8764149aa59f968af12613a6",
"assets/packages/socialdeck/assets/icons/fill/Deck.svg": "e16730c7ae5528d005793889f5f684e7",
"assets/packages/socialdeck/assets/icons/fill/Settings.svg": "b6a70c3da432708854c6640c92b85bae",
"assets/packages/socialdeck/assets/icons/fill/Mail.svg": "ae4fe6627e60ec8539e7098822f663c6",
"assets/packages/socialdeck/assets/icons/fill/Home.svg": "de8502c87f6945b643ff57f074136259",
"assets/packages/socialdeck/assets/icons/stroke/Crown.svg": "e59a4c0e412bee6f52693c0bac885f82",
"assets/packages/socialdeck/assets/icons/stroke/Friends.svg": "18ad267c616a773195c563f268e09390",
"assets/packages/socialdeck/assets/icons/stroke/Store.svg": "fef63aaf5da16ac76809e542ce2f187c",
"assets/packages/socialdeck/assets/icons/stroke/Add%2520Friend.svg": "234ad5da25b8e6f2cfcbdd785463c939",
"assets/packages/socialdeck/assets/icons/stroke/Clock.svg": "69f6c1860bca77a93053b1c0c292a9a5",
"assets/packages/socialdeck/assets/icons/stroke/Search.svg": "f49c4d2e85a6976b6d8d894513e6f84e",
"assets/packages/socialdeck/assets/icons/stroke/List.svg": "d61e3ff2936da0ffbd689c45b585364e",
"assets/packages/socialdeck/assets/icons/stroke/Left%2520Chevron.svg": "5bfe50705007bedf4a38f5b5add30117",
"assets/packages/socialdeck/assets/icons/stroke/Down%2520Chevron.svg": "cfa55fafa9b67d3299c7a368e6e6bad3",
"assets/packages/socialdeck/assets/icons/stroke/Cards.svg": "7143ecf9cb414b76168ec258e33a88e8",
"assets/packages/socialdeck/assets/icons/stroke/Player.svg": "e5f8352a4e8a71a16d2786a3a1f26cf7",
"assets/packages/socialdeck/assets/icons/stroke/Eye.svg": "2f16bcda6f4bf63e6ba2bd0ffd77d283",
"assets/packages/socialdeck/assets/icons/stroke/Pinch%2520Adjust.svg": "c0ebf4ee43cdd06ef8203557220d2f1e",
"assets/packages/socialdeck/assets/icons/stroke/Star.svg": "ce9f42a6fd7d5e473ec1e44978a2b2f8",
"assets/packages/socialdeck/assets/icons/stroke/Settings.svg": "7fd951a00ea218de3a190800ff09f4b2",
"assets/packages/socialdeck/assets/icons/stroke/Up%2520Chevron.svg": "2e6a999fbd1e1719ea5a6478016348e5",
"assets/packages/socialdeck/assets/icons/stroke/Megaphone.svg": "a24117176e389f8f3a43fce2ac521de9",
"assets/packages/socialdeck/assets/icons/stroke/Placeholder.svg": "5b2d8b4537f37a55c5ca34ecfa127014",
"assets/packages/socialdeck/assets/icons/stroke/More.svg": "f99327bc40a05ba24bee3e7c27e6dfbd",
"assets/packages/socialdeck/assets/icons/stroke/X.svg": "2aebaedcf65322e17bf8ae34868b2462",
"assets/packages/socialdeck/assets/icons/stroke/Right%2520Chevron.svg": "2fe6444b7eaf15f94cb3ddfd40113b6c",
"assets/packages/socialdeck/assets/icons/stroke/Right%2520Arrow.svg": "92c39d77bb1e5542d21084aeeadd9ae0",
"assets/packages/socialdeck/assets/icons/stroke/Play%2520Hollow.svg": "77601d3b1568f6c2dfc1970717c32921",
"assets/packages/socialdeck/assets/icons/stroke/Closed%2520Eye.svg": "04cf17bb41c964b6ebf9e40a1474b4e9",
"assets/packages/socialdeck/assets/icons/stroke/Mail.svg": "94de1c84e7d596c3c478b74e6fc9b157",
"assets/packages/socialdeck/assets/icons/stroke/Grid.svg": "483b1e9eb11befa49b1d37ddd863ae02",
"assets/packages/socialdeck/assets/icons/stroke/Leave.svg": "22facf9fac67796b87963d9601f3ccf9",
"assets/packages/socialdeck/assets/icons/stroke/Trash.svg": "8b669a2bb7f65aa24dc0e1958f5684a2",
"assets/packages/socialdeck/assets/icons/stroke/Redo.svg": "6b074324fdf1f2f41a393a78906779c7",
"assets/packages/socialdeck/assets/icons/stroke/Information.svg": "234c3bb4ab3ac1ad166d038fd72e9587",
"assets/packages/socialdeck/assets/icons/stroke/Home.svg": "3531569aabbea2f94f42e38f0383cc15",
"assets/packages/socialdeck/assets/icons/stroke/Camera.svg": "4f9dbfad497ac6dd2e246f6ac30e3314",
"assets/packages/socialdeck/assets/icons/stroke/Edit.svg": "c7da5acf11152ca35bc69aedb320144d",
"assets/packages/socialdeck/assets/icons/stroke/Socialdeck%2520Logo.svg": "8e75ac1fc5661abeb325f0d8700c639b",
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
"assets/AssetManifest.bin": "5b9836913f647dea727757a0739b635a",
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
"flutter_bootstrap.js": "01b39fceb4e112129bae072ee733d012",
"version.json": "79b76fd19ba16630b316c39ce4f4ddcc",
"main.dart.js": "a8f78da5ecf4b7086a73d5cbd6f07c25"};
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

{{flutter_js}}
{{flutter_build_config}}

(function () {
  function isAppleWebKit() {
    var ua = navigator.userAgent || '';
    var vendor = navigator.vendor || '';
    var isIOS =
      /iPhone|iPad|iPod/i.test(ua) ||
      ((navigator.platform || '') === 'MacIntel' && (navigator.maxTouchPoints || 0) > 1);

    return isIOS && vendor === 'Apple Computer, Inc.' && /AppleWebKit/i.test(ua);
  }

  _flutter.loader.load({
    serviceWorkerSettings: isAppleWebKit()
      ? null
      : {
          serviceWorkerVersion: {{flutter_service_worker_version}},
        },
  });
})();

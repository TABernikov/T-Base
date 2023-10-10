
(function() {

  if ('serviceWorker' in navigator) {
    navigator.serviceWorker
             .register('Face/service-worker.js')
             .then(function() { console.log('Service Worker Registered'); });
  }
})();

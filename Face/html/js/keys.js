document.addEventListener('keydown', function(event) {
    if (event.code == 'KeyT' && event.shiftKey && event.altKey) {
      window.location.href = "/works/tmc"
    }
    if (event.code == 'KeyW' && event.shiftKey && event.altKey) {
        window.location.href = "/works/storage/orders"
    }
    if (event.code == 'KeyO' && event.shiftKey && event.altKey) {
    window.location.href = "/works/orders"
    }
    if (event.code == 'KeyC' && event.shiftKey && event.altKey) {
    window.location.href = "/works/cal"
    }
    if (event.code == 'KeyQ' && event.shiftKey && event.altKey) {
    window.location.href = "/works/prof"
    }
    if (event.code == 'KeyS' && event.shiftKey && event.altKey) {
    window.location.href = "/works/tmcadvancesearch"
    }
      
  });
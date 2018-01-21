function doQuery() {
  let input = document.querySelector("#query");
  let req = new XMLHttpRequest();
  req.addEventListener("load", function() {
    let result_area = document.querySelector("#results");
    let response = this.responseText.trim() == '' ? '...' : this.responseText;
    // beautify the results a little for easier reading
    result_area.innerHTML = response.replace(/,/g, ', ');
  });
  req.open("GET", "/?text=" + encodeURIComponent(input.value) + "&tz_offset=" + new Date().getTimezoneOffset());
  req.send();
}

document.querySelector("#query").addEventListener('keydown', function(event) {
  if (event.keyCode == 13) {
    doQuery();
    event.preventDefault();
  }
});
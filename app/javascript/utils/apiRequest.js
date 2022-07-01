const csrfToken = document.querySelector("[name='csrf-token']").content;

const apiRequest = (url, method, body) =>
  fetch(url, {
    method: method, // *GET, POST, PUT, DELETE, etc.
    mode: "cors", // no-cors, *cors, same-origin
    cache: "no-cache", // *default, no-cache, reload, force-cache, only-if-cached
    credentials: "same-origin", // include, *same-origin, omit
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": csrfToken,
    },
    body: JSON.stringify(body), // body data type must match "Content-Type" header
  });

export default apiRequest;

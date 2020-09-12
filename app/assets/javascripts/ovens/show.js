document.addEventListener('DOMContentLoaded', () => {
  let cookieStatus, eventSource;

  cookieStatus = document.querySelector('.cookie-status');
  eventSource = new EventSource('/ovens/2/progress');

  eventSource.addEventListener('message', event => {
    cookieStatus.innerHTML = event.data;
    eventSource.close();
  });
})

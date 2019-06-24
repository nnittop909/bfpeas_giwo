$('.timepicker').timepicker()
.on('changeTime', function(ev) {
  alert('time has changed');
});
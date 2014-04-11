// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require twitter/bootstrap
// require turbolinks
//= require angular
//= require angular-resource
//= require jquery-ui-timepicker-addon
//= require_tree ./application/
//= require_tree .
$.datepicker.regional['ru'] = {
  closeText: 'Закрыть',
  prevText: '<Пред',
  nextText: 'След>',
  currentText: 'Сегодня',
  monthNames: ['Январь','Февраль','Март','Апрель','Май','Июнь',
  'Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь'],
  monthNamesShort: ['Янв','Фев','Мар','Апр','Май','Июн',
  'Июл','Авг','Сен','Окт','Ноя','Дек'],
  dayNames: ['воскресенье','понедельник','вторник','среда','четверг','пятница','суббота'],
  dayNamesShort: ['вск','пнд','втр','срд','чтв','птн','сбт'],
  dayNamesMin: ['Вс','Пн','Вт','Ср','Чт','Пт','Сб'],
  weekHeader: 'Не',
  dateFormat: 'dd.mm.yy',
  firstDay: 1,
  isRTL: false,
  showMonthAfterYear: false,
  yearSuffix: ''
};
$.timepicker.regional['ru'] = {
  timeOnlyTitle: 'Выберите время',
  timeText: 'Время',
  hourText: 'Часы',
  minuteText: 'Минуты',
  secondText: 'Секунды',
  millisecText: 'Миллисекунды',
  timezoneText: 'Часовой пояс',
  currentText: 'Сейчас',
  closeText: 'Закрыть',
  timeFormat: 'HH:mm',
  amNames: ['AM', 'A'],
  pmNames: ['PM', 'P'],
  isRTL: false
};
$.timepicker.setDefaults($.timepicker.regional['ru']);
$.datepicker.setDefaults($.datepicker.regional['ru']);
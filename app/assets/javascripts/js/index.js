$(document).ready(function() {

  /* -------------------------------cache DOM------------------------------- */
  //$cal1 and $cal2 are part of $cal
  var $cal = $('.calendar');
  var $cal1 = $('#calendar1');
  var $cal2 = $('#calendar2');
  var events_path = gon.events_path;
  

  /* --------------------------initialize calendar-------------------------- */
  /* --------------------------javascript version------------------------------
  $('.calendar').fullCalendar({
      editable: true,
      eventLimit: true, // allow "more" link when too many events
      // create events
        events: [{
            "title": "All Day Event",
            "start": "2016-10-01"
        }, {
            "title": "Long Event",
            "start": "2016-10-07",
            "end": "2016-10-10"
        }, {
            "id": "999",
            "title": "Repeating Event",
            "start": "2016-10-10T16:00:00-05:00"
        }, {
            "id": "999",
            "title": "Repeating Event",
            "start": "2016-10-16T16:00:00-05:00"
        }, {
            "id":"1",
            "title": "Conference",
            "start": "2018-10-11",
            "end": "2018-10-13",
            "color":null,
            "created_at":"2018-10-04T10:05:31.245Z",
            "updated_at":"2018-10-04T10:05:31.245Z"

        }, {
            "title": "Meeting",
            "start": "2016-10-12T10:30:00-05:00",
            "end": "2016-10-12T12:30:00-05:00"
        }, {
            "title": "Run tests",
            "start": "2018-10-12T12:00:00"
        }] 

    });
  /* --------------------------connect to rails db-------------------------- */
  $('.calendar').fullCalendar({
      events: '/users' + '/user_id' + '/events.json',
      //defaultTimedEventDuration: '01:00:00',
      //設定開始時間
      minTime: "07:00:00",
      //設定結束時間
      maxTime: "18:59:00",
      forceEventDuration: true,
  });

  /* -------------------manage cal2 (right pane)------------------- */
  $cal2.fullCalendar('changeView', 'agendaDay');
  $cal2.fullCalendar('option', 'height', 807);
  $cal2.fullCalendar('option', {
      header: {
        left: '',
        center: 'prev title next',
        //right: 'month,agendaWeek'
        right: ''
      },
      navLinks: false,
      
      slotEventOverlap: false,
      allDaySlot: false,
      selectable: true,
      selectHelper: true,

      

      select: function(start, end) {
        {
          $.getScript('' + '/events/new', function() {
            $('#event_date_range').val(moment(start).format("MM/DD/YYY HH:mm") + ' - ' + moment(end).format("MM/DD/YYY HH:mm"));
            date_range_picker();
            $('.start_hidden').val(moment(start).format('YYYY-MM-DD HH:mm'));
            $('.end_hidden').val(moment(end).format('YYYY-MM-DD HH:mm'));
          })
        }
        var eventData;
          if (title) {
              eventData = {
                  title: title,
                  start: start,
                  end: end
              };
              $cal.fullCalendar('renderEvent', eventData, true); // stick? = true
          }
        $cal.fullCalendar('unselect');
      },
      editable:true,

      eventDrop: function(event, delta, revertFunc) {
        event_data = { 
          event: {
            id: event.id,
            start: event.start.format(),
            end: event.end.format()
          }
        };
        $.ajax({
            //url: event.update_url,
            data: event_data,
            //type: 'PATCH'
            type:"PUT",
            url: event_path + 'events/' + event.id,
        });
      },
      eventClick: function(event, jsEvent, view) {
        $.getScript("users/" + "user_id" +"/events/"+ event.id + "/edit", function() {
          $('#event_date_range').val(moment(event.start).format("MM/DD/YYYY HH:mm") + ' - ' + moment(event.end).format("MM/DD/YYYY HH:mm"))
          date_range_picker();
          $('.start_hidden').val(moment(event.start).format('YYYY-MM-DD HH:mm'));
          $('.end_hidden').val(moment(event.end).format('YYYY-MM-DD HH:mm'));
        });
      
        /*
          if (calEvent.allDay) {
              var cal1Event = getCal1Event(calEvent._id);
          } else {
              var cal1Event = calEvent;
          }/*
          var title = prompt('Edit Appointment Info:', calEvent.title, {
              buttons: {
                  Ok: true,
                  Cancel: false
              }
          });
          


          
          if (title) {
              calEvent.title = title;
              cal1Event.title = title;
              $cal2.fullCalendar('updateEvent', calEvent);
          }
          */

      }
  });


  /* -------------------manage cal1 (right pane)------------------- */
  $cal1.fullCalendar('option', {
      header: {
        left: 'title',
        center: '',
        //right: 'month,agendaWeek'
        right:'prev,next today',
      },
      navLinks: false,
      dayClick: function(date) {
          cal2GoTo(date);
      },
      eventClick: function(calEvent) {
          cal2GoTo(calEvent.start);
      },
      selectable: false,
      // show a bar as we drag along days
      selectHelper: true,
      // make changes and add events to calendar
      editable: true,
      // if a day has more than can be displayed, to show (+ 2 more)
      eventLimit: true
    });



  /* -------------------moves right pane to date------------------- */
  function cal2GoTo(date) {
      $cal2.fullCalendar('gotoDate', date);
  }


  /* full calendar gives all day events given different ids in month/week view
    and day view. create/edit event in day (right) view, so correct for
    id change to update in month/week (left)
  */
  function getCal1Event(cal2Id) {
      var num = cal2Id.slice(-1) - 5;
      var id = "_fc" + num;
      return $cal1.fullCalendar('clientEvents', id)[0];
  }

});



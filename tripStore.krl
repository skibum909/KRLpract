ruleset trip_rules {
  meta {
    name "Trips"
    description <<
an echo service for CS462 lab
>>
    author "Dave Bennett"
    logging on
    sharing on
    provides hello
    provides trips
    provides long_trips
    provides short_trips
 
  }
  global {
    long_trip = 200;
    hello = function(obj) {
      msg = "Hello " + obj
      msg
    };
    trips = function() {
      trips = ent:trips
    };
    long_trips = function() {
      long_trips = ent:long_trips
    };
    short_trips = function() {
      short_trips = ent:trips if not ent:long_trips{time}
    };
  }

  rule collect_trips{
    select when explicit trip_processed
    pre {
      mileage = event:attr("mileage").defaultsTo(ent:mileage,"no mileage passed in");
      time = time:strftime(time:now({"tz":"America/Denver"}), "%F %T");
      init = time:mileage;
    }
    {
      send_directive("trip") with
        trip_length = mileage;
    }
    always {
      set ent:trips init if not ent:trips{time};
      log ("LOG mileage " + mileage);
    }
 }

  rule collect_long_trips{
    select when explicit trip_processed mileage "(.*)" setting(m)
    if (m < long_trip) then {
      notify("My app", "Not a long trip.")
    }
    notfired {
      raise explicit event found_long_trip;
    }
  }

  rule found_long{
    select when explicit found_long_trip
      set ent:long_trips init if not ent:long_trips{time};
  }

  rule clear_trips{
    select when car trip_reset
      clear ent:trips;
      clear ent:long_trips
 
}

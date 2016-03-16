ruleset trip_rules {
  meta {
    name "Store_Trips"
    description <<
an echo service for CS462 lab
>>
    author "Dave Bennett"
    logging on
    sharing on
    provides trips
    provides long_trips
    provides short_trips
 
  }
  global {
    long_trip = 200;
    trips = function() {
      trips = ent:trips;
      trips
    };
    long_trips = function() {
      long_trips = ent:long_trips;
      long_trips
    };
    short_trips = function() {
      short_trips = ent:trips.difference(ent:long_trips);
      short_trips
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
      send_directive("store_trip") with
        trip_length = trips();
    }
    always {
      set ent:trips init;
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
    pre {
    }
    {
      send_directive("store_long_trip") with
        long_trip = mileage;
    }
    always{
      set ent:long_trips init;
    }
  }

  rule clear_trips{
    select when car trip_reset
    pre {
    }
    {
      send_directive("clear_trips") with
        trips = "cleared"
    }
    always{
      clear ent:trips;
      clear ent:long_trips;
    }
  }
}

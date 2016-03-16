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
 
  }
  global {
    long_trip = 200;
    hello = function(obj) {
      msg = "Hello " + obj
      msg
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
      set ent:time init if not ent:time{mileage};
      log ("LOG mileage " + mileage);
    }
 }

  rule find_long_trips{
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
    send_directive("found_long_trip") with
      trip_length = m;
  }
 
}

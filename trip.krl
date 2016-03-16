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

  rule process_trip is active{
    select when explicit trip_processed mileage "(.*)" setting(m)
    send_directive("trip") with
      trip_length = m;
 }

  rule find_long_trips is active{
    select when explicit trip_processed mileage "(.*)" setting(m)
    if (m < long_trip) then {
      notify("My app", "Not a long trip.")
    }
    notfired {
      raise explicit event found_long_trip;
    }
  }

  rule found_long is active{
    select when explicit found_long_trip
    send_directive("found_long_trip") with
      trip_length = m;
  }
 
}

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
 
}

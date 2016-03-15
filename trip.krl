ruleset trip_rules {
  meta {
    name "Hello World"
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

  rule echo is active{
    select when echo message mileage "(.*)" setting(m)
    send_directive("trip") with
      trip_length = m;
 }
 
}

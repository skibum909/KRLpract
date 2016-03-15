ruleset hello_world {
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
  rule hello_world is active{
    select when echo hello
    send_directive("say") with
      something = "Hello World";
  }


  rule echo is active{
    select when echo message input "(.*)" setting(m)
    send_directive("say") with
      something = m;
 }
 
}

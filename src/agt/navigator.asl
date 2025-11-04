!controlNavigation.


+!controlNavigation: command(N, Command)[source(teletela)] & not busy[source(eye)] <-
  .send(eye, achieve, Command);
  .print("⚓: Sending eye command", Command);
  .wait(1000);
  !controlNavigation;
.


+!controlNavigation: not command(N, Command)[source(teletela)] <-
  .wait(1000);
  !controlNavigation;
.


+!controlNavigation: busy[source(eye)] <-
  .wait(2000);
  .print("⚓:  Waiting eye to be ready.");
  !controlNavigation;
.

+!cancel <-
  .abolish(command(_, _));
  .print("⚓:  Waiting eye to be ready.");

  .send(eye, tell, cancel);
.

+!setNotBusy <-
  .send(eye, achieve, setNotBusy);
.



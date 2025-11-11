currentCommand(1).
!controlNavigation.


+!controlNavigation: busy[source(eye)] <-
  .print("⚓:  Waiting eye to be ready.");
  .wait(5000);
  !controlNavigation;
.

+!controlNavigation: not command(N, Command)[source(teletela)] <-
  .print("⚓:  Waiting commands.");
  .wait(5000);
  !controlNavigation;
.

+!controlNavigation: currentCommand(N) & command(N, Command)[source(teletela)] & not busy[source(eye)] <-
  .send(eye, achieve, Command);
  .print("⚓: Achieving eye command: ", N, " ", Command);
  .wait(busy[source(eye)], 20000);
  .print("⚓: Command concluded!",N);
  -command(N,Command)[source(teletela)];
  -+currentCommand(N+1);
  !controlNavigation;
.

-!controlNavigation <-
  .wait(2000);
  .print("⚓: Something is wrong....");
  !controlNavigation;
.

+!cancel <-
  .abolish(command(_, _));
  .print("⚓: Operation canceled");

  .send(eye, tell, cancel);
.

+!setNotBusy <- .send(eye, achieve, setNotBusy); .


+command(N, Command)[source(teletela)] <-
  .print("⚓: Command received: ", Command)
.
!controlNavigation.


+!controlNavigation: busy[source(eye)] <-
  .print("⚓:  Waiting eye to be ready.");
  .wait(5000);
  !controlNavigation;
.

+!controlNavigation: not command(N, Command)[source(teletela)] <-
  .print("⚓:  Nada PRA FAZER.");
  .wait(5000);
  !controlNavigation;
.

+!controlNavigation: command(N, Command)[source(teletela)] & not busy[source(eye)] <-
  .send(eye, achieve, Command);
  .print("⚓: Achieving eye command: ",N," ", Command);
  .wait(busy[source(eye)], 20000);
  .print("Recebi busy remover N=",N);
  -command(N,Command)[source(teletela)];
  !controlNavigation;
.

-!controlNavigation <-
  .wait(2000);
  .print("algo nao está certo....");
  !controlNavigation;
.

+!cancel <-
  .abolish(command(_, _));
  .print("⚓:  canceled operation");

  .send(eye, tell, cancel);
.

+!setNotBusy <- .send(eye, achieve, setNotBusy); .


//-busy[source(eye)] <- .print("Ok, eye tá busy") .

+command(N, Command)[source(teletela)] <-
  .print("Recebi comando: ", Command)
.
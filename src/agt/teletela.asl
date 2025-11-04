teletelaUUID("b135dd8a-23e5-4b3e-9405-288c40b7fac3").
humanUUID("b2fc3586-245f-4c28-b1ed-56d8e7936a49").

commandId(0).

!connect.

+!connect : teletelaUUID(UUID) <- 
	.wait(2000);
	.connectCN("skynet.chon.group", 5000, UUID);
	.print("📺: Conectado à Skynet 🌐");
	+ready
.

+ready <- !pathRequest.

+!pathRequest: teletelaUUID(UUID) & humanUUID(Human) & not running<-
	.print("📺: Wainting human command.");
	.random(R); 
	.wait(10000*R);
	!pathRequest
.
+!pathRequest: running.

-!pathRequest <- .print("📺: Secretary is not reachable").

+!path(Path) <-
  +running;
  .print("Path received", Path);
  .send(eye, tellHow, Path);
  .wait(3000);
  .send(eye, achieve, path)
.

//? ----------- Single Actions -----------

+!up(Limit)[source(H)] <-
  +running;
	?commandId(N);
	+commandId(N+1);
  .print("👁️: Up command received");
	.send(navigator, tell, command(N+1, up(Limit)));
	.sendOut(H,tell,"👁️: up command sent");
.
+!down(Limit)[source(H)] <-
  +running;
	?commandId(N);
	+commandId(N+1);
	.send(navigator, tell, command(N+1, down(Limit)));
  .print("👁️: Down command received");
	.sendOut(H,tell,"👁️: Down command sent");
.
+!forward(Limit)[source(H)] <-
  +running;
	?commandId(N);
	+commandId(N+1);
	.send(navigator, tell, command(N+1, forward(Limit)));
  .print("👁️: Forward command received");
	.sendOut(H,tell,"👁️: forward command sent");
.
+!backward(Limit)[source(H)] <-
  +running;
	?commandId(N);
	+commandId(N+1);
	.send(navigator, tell, command(N+1, backward(Limit)));
  .print("👁️:Backward command received");
	.sendOut(H,tell,"👁️: backward command sent");
.
+!left(Limit)[source(H)] <-
  +running;
	?commandId(N);
	+commandId(N+1);
	.send(navigator, tell, command(N+1, left(Limit)));
  .print("👁️: Left command received");
	.sendOut(H,tell,"👁️: Left command sent");
.
+!right(Limit)[source(H)] <-
  +running;
	?commandId(N);
	+commandId(N+1);
	.send(navigator, tell, command(N+1, right(Limit)));
  .print("👁️: Right command received");
	.sendOut(H,tell,"👁️: right command sent");
.

+!takeoff[source(H)] <-
	+running;
	?commandId(N);
	+commandId(N+1);
	.send(navigator, tell, command(N+1, takeoff));
  .print("👁️: Right command received");
	.sendOut(H,tell,"👁️: takeoff command sent");
.
+!turnOff[source(H)] <-
	-running;
	?commandId(N);
	+commandId(N+1);
	.send(navigator, tell, command(N+1, takeoff));
  .print("👁️: Right command received");
	.sendOut(H,tell,"👁️: turnoff command sent");
.


+!cancel <-
	.send(navigator, achieve, cancel);
  .print("Canceling all command");
.
+!cancel(Command) <-
	.send(navigator, achieve, cancel(Command));
	.send(navigator, achieve, setNotBusy);
  .print("👁️: Canceling all commands");
	.sendOut(H,tell,"👁️: Canceling all commands");
.


+pathConcluded : teletelaUUID(UUID) & secretaryUUID(Secretary)  <- 
	.sendOut(UUID, tell, message(UUID, "Path Concluded"));
	.wait(1000);
	-pathConcluded
.
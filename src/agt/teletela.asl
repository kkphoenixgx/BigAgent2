teletelaUUID("b135dd8a-23e5-4b3e-9405-288c40b7fac3").
humanUUID("b2fc3586-245f-4c28-b1ed-56d8e7936a49").

commandId(0).
currentLimit(0).

!connect.

+!connect : teletelaUUID(UUID) <- 
	.wait(2000);
	.connectCN("skynet.chon.group", 5000, UUID);
	.print("📺: Conectado à Skynet 🌐");
	+ready
.

//+ready <- !pathRequest.

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
	-+commandId(N+1);
  .print("👁️: Up command received");
	!upAjustNumber(Limit);
	?currentLimit(NewLimit);
	.send(navigator, tell, command(N+1, up(NewLimit)));
	.sendOut(H,tell,"👁️: up command sent");
.
+!down(Limit)[source(H)] <-
  +running;
	?commandId(N);
	-+commandId(N+1);
	!downAjustNumber(Limit);
	?currentLimit(NewLimit);
	.send(navigator, tell, command(N+1, down(NewLimit)));
  .print("👁️: Down command received");
	.sendOut(H,tell,"👁️: Down command sent");
.
+!forward(Limit)[source(H)] <-
  +running;
	?commandId(N);
	-+commandId(N+1);
	!forwardAjustNumber(Limit);
	?currentLimit(NewLimit);
	.send(navigator, tell, command(N+1, forward(NewLimit)));
  .print("👁️: Forward command received");
	.sendOut(H,tell,"👁️: forward command sent");
.
+!backward(Limit)[source(H)] <-
  +running;
	?commandId(N);
	-+commandId(N+1);
	!backwardAjustNumber(Limit);
	?currentLimit(NewLimit);
	.send(navigator, tell, command(N+1, backward(NewLimit)));
  .print("👁️:Backward command received");
	.sendOut(H,tell,"👁️: backward command sent");
.
+!left(Limit)[source(H)] <-
  +running;
	?commandId(N);
	-+commandId(N+1);
	!leftAjustNumber(Limit);
	?currentLimit(NewLimit);
	.send(navigator, tell, command(N+1, left(NewLimit)));
  .print("👁️: Left command received");
	.sendOut(H,tell,"👁️: Left command sent");
.
+!right(Limit)[source(H)] <-
  +running;
	?commandId(N);
	-+commandId(N+1);
	!rightAjustNumber(Limit);
  .print("👁️: Right command received");
	?currentLimit(NewLimit);
	.send(navigator, tell, command(N+1, right(NewLimit)));
	.sendOut(H,tell,"👁️: right command sent");
.

+!takeoff[source(H)] <-
	+running;
	?commandId(N);
	-+commandId(N+1);
	.send(navigator, tell, command(N+1, takeoff));
  .print("👁️: Right command received");
	.sendOut(H,tell,"👁️: takeoff command sent");
.
+!turnOff[source(H)] <-
	-running;
	?commandId(N);
	-+commandId(N+1);
	.send(navigator, tell, command(N+1, turnOff));
  .print("👁️: Right command received");
	.sendOut(H,tell,"👁️: turnoff command sent");
.

+!cancel <-
	.send(navigator, achieve, cancel);
  .print("Canceling all commands");
.



+pathConcluded : teletelaUUID(UUID) & secretaryUUID(Secretary)  <- 
	.sendOut(UUID, tell, message(UUID, "Path Concluded"));
	.wait(1000);
	-pathConcluded
.

//? ----------- Helpers -----------

//TODO:  Up down sempre deve ser + ou -
+!upAjustNumber(N) : N > 0  <- NewLimit = N*1; -+currentLimit(NewLimit) .
+!upAjustNumber(N) : N == 0 <- NewLimit = 0; -+currentLimit(NewLimit) .
+!upAjustNumber(N) : N < 0  <- NewLimit = N*-1; -+currentLimit(NewLimit) .


+!downAjustNumber(N) : N > 0  <- NewLimit = N*-1; -+currentLimit(NewLimit) .
+!downAjustNumber(N) : N == 0 <- NewLimit= 0; -+currentLimit(NewLimit) .
+!downAjustNumber(N) : N < 0  <- NewLimit = N * -1; -+currentLimit(NewLimit) .


+!leftAjustNumber(N) : N > 0  <- NewLimit = N*-1; -+currentLimit(NewLimit) .
+!leftAjustNumber(N) : N == 0 <- NewLimit = 0; -+currentLimit(NewLimit) .
+!leftAjustNumber(N) : N < 0  <- NewLimit = N; -+currentLimit(NewLimit) .


+!rightAjustNumber(N) : N > 0  <- NewLimit = N*1; -+currentLimit(NewLimit) .
+!rightAjustNumber(N) : N == 0 <- NewLimit = 0; -+currentLimit(NewLimit) .
+!rightAjustNumber(N) : N < 0  <- NewLimit = N*-1; -+currentLimit(NewLimit) .


+!forwardAjustNumber(N) : N > 0  <- NewLimit = N*-1; -+currentLimit(NewLimit) .
+!forwardAjustNumber(N) : N == 0 <- NewLimit = 0; -+currentLimit(NewLimit) .
+!forwardAjustNumber(N) : N < 0  <- NewLimit = N*1; -+currentLimit(NewLimit) .


+!backwardAjustNumber(N) : N > 0  <- NewLimit = N*1;  -+currentLimit(NewLimit) .
+!backwardAjustNumber(N) : N == 0 <- NewLimit = 0;    -+currentLimit(NewLimit) .
+!backwardAjustNumber(N) : N < 0  <- NewLimit = N*-1; -+currentLimit(NewLimit) .
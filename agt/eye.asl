serialPort(ttyEmulatedPort0).

!start.

// 👁️ ⬆️ ⬇️ ➡️ ⬅️ 

//--------------- Loops Core ---------------

+!start <-
    .print("--: Opening Eyes...");
	.argo.port(ttyEmulatedPort0);
	.argo.limit(1000);
    .argo.percepts(open);
	
.


+port(P,S)[source(percept)]: serialPort(Port) & P=Port & S=on & not running <-
    +running;
    .print("👁️: Body connected.");
	.send(teletela, tell, ready);
.

-!path <- 
  .print("👁️: I do not know the path.");
.

//--------------- Fase de navegação ---------------

+!argoAct(Command): not cancel <-
    .argo.act(Command);
    //!reset;
.
-!argoAct(Command) <-
    .print("👁️: Takeoff canceled.");
.

//? Internal take off
+!takeOff <- 
	.print("👁️: To infinity and beyond!");
	
	!argoAct(up);

	.wait(3000);

    !argoAct(up);

	.wait(2000);

    !argoAct(up);

	.wait(2000);

	+flying;

	.print("👁️: Ready to action!")
.

+!takeoff <- 
    !setBusy;

	.print("👁️: To infinity and beyond!!");
	
	!argoAct(up);

	.wait(3000);

    !argoAct(up);

	.wait(2000);

    !argoAct(up);

	.wait(2000);

	+flying;

	.print("👁️: Ready to action!");
    !reset;
.
+!takeoff[source(X)] <- 
    !setBusy;
	.print("👁️: To infinity and beyond!!");
	
	!argoAct(up);

	.wait(3000);

    !argoAct(up);

	.wait(2000);

    !argoAct(up);

	.wait(2000);

	+flying;

	.print("👁️: Ready to action!");
    !reset;
.

+!land : flying <- 
    !setBusy;
    .print("👁️: Landing...");
    .argo.act(land);
    -flying;
    !reset;
.

/*+!land[source(X)] : flying <- 
    !setBusy;
    .print("👁️: Landing... COM SOURCE!!!!!!!!!!");
    .argo.act(land);
    -flying;
    !reset;
.
*/
-!land <-
    .print("👁️: Cannot execute land. You sure am I flying?");
.


+!turnOff <- 
    !setBusy;
    .print("👁️: Turning off!");
    .argo.act(off);
    .wait(1000);
    .print("--: Closing eyes!");
    !reset;
.
+!turnOff[source(X)] <- 
    !setBusy;
    .print("👁️: Turning off!");
    .argo.act(off);
    .wait(1000);
    .print("--: Closing eyes!");
    !reset;
.


//--------------- UP (Z) --------------busy[source(eye)]-

+!up(Limit)[source(S)]: gps(_, _, Z) <- 
    !setBusy;
    Destination = Z + Limit; 
    !upTo(Destination);
    .print("👁️: Up executed.");
.
+!up(Limit)[source(S)]: not gps(_, _, Z) <- 
    .print("👁️: Without gps...");
    .wait(2000);
    !up(Limit);
.
-!up(Limit) <- .print("👁️: Warning: falied to execute up.").


//? Take off automático
+!upTo(Limit): not flying <-
    !takeOff;
    !upTo(Limit);
.
+!upTo(Limit): flying <-
    .print("👁️: Rising to: ", Limit);
    !setBusy;
    !risingTo(Limit);
.


+!risingTo(Limit): gps(_, _, Z) & (1 * Limit) - 0.1 > Z & not cancel <- 
    //!printMetaDebug(Limit); //! debug
	
    .print("👁️: Rising... ⬆️ ");
    .argo.act(up);
    .wait(2000);
    !risingTo(Limit);
.
-!risingTo(Limit): gps(_, _, Z) & (1 * Limit) - 0.1 > Z & not cancel <- 
	.wait(2000);
	!risingTo(Limit)
.
+!risingTo(Limit) : gps(_, _, Z) & (1 * Limit) - 0.1 <= Z & not cancel <- 
    !reset;
   	.print("👁️: Rise concluded.");
.

+!risingTo(Limit) : not gps(_, _, Z) <- 
    .print("👁️: Without gps...");
    .wait(2000);
    !risingTo(Limit);
.

+!risingTo(Limit): cancel <-
    !reset;
    .print("👁️: Canceled rising.");
.

//--------------- DOWN (Z) ---------------


+!down(Limit)[source(S)] : flying & gps(_, _, Z) <-
    !setBusy;
    Destination = Z + Limit; 
    !downTo(Destination);
    .print("👁️: Down executed."); 
.
+!down(Limit)[source(S)]: not gps(_, _, Z) <- 
    .print("👁️: Without gps...");
    .wait(2000);
    !down(Limit);
.
-!down(Limit) <- .print("👁️: Warning: falied to execute down. Not flying or without gps").



+!downTo(DownLimit) : flying   <-
    .print("👁️: Downing to: ", DownLimit);
    !setBusy;
    !downingTo(DownLimit)
.


+!downingTo(DownLimit) : gps(_, _, Z) & (DownLimit + 0.1) < Z & not cancel <- 
    //!printMetaDebug(DownLimit); //! debug
    
    .print("👁️: Downing... ⬇️");
    .argo.act(down);

    .wait(2000);
    !downingTo(DownLimit)
.

-!downingTo(DownLimit) : gps(_, _, Z) & (DownLimit + 0.1) < Z & not cancel <- 
    .wait(2000);
    !downingTo(DownLimit)
.

+!downingTo(DownLimit) : gps(_, _, Z) & (DownLimit + 0.1) >= Z & not cancel <- 
    !reset;
    .print("👁️: Down concluded.");
.

+!downingTo(DownLimit) : not gps(_, _, Z) <- 
    .print("👁️: Without gps...");
    .wait(2000);
    !downingTo(DownLimit);
.

+!downingTo(DownLimit): cancel <-
    !reset;
    .print("👁️: Canceled downing.");
.


//--------------- Foward (X) ---------------

+!forward(Limit)[source(S)] : flying & gps(X, _, _) <-
    !setBusy;
    Destination = X + Limit; 
    !forwardTo(Destination);
    .print("👁️: Forward executed."); 
.
+!forward(Limit)[source(S)]: not gps(X, _, _) <- 
    .print("👁️: Without gps...");
    .wait(2000);
    !forward(Limit);
.
-!forward(Limit) <- .print("👁️ Warning: falied to execute down. Not flying or without gps").


+!forwardTo(FrontLimit) : flying  <-
    .print("👁️: Forwarding to: ", FrontLimit);
    !setBusy;
    !forwardingTo(FrontLimit);
.


+!forwardingTo(FrontLimit) : gps(X, _, _) & (FrontLimit + 0.1) < X & not cancel <- 
    //!printMetaDebug(FrontLimit); //! debug

    .print("👁️: Going To Destination!");
    .argo.act(forward);

    .wait(2000);
    !forwardingTo(FrontLimit)
.
-!forwardingTo(FrontLimit) : gps(X, _, _) & (FrontLimit + 0.1) < X & not cancel <- 
    .wait(2000);
    !forwardingTo(FrontLimit)
.
+!forwardingTo(FrontLimit) : gps(X, _, _) & (FrontLimit + 0.1) >= X & not cancel  <- 
    !reset;
    .print("👁️: Forward concluded.");
.

+!forwardingTo(FrontLimit) : not gps(X, _, _)   <- 
    .print("👁️: Without gps...");
    .wait(2000);
    !forwardingTo(FrontLimit);
.

+!forwardingTo(FrontLimit): cancel <-
    !reset;
    .print("👁️: Canceled forwarding.");
.


//--------------- Backwards (X) ---------------

+!backward(Limit)[source(S)] : flying & gps(X, _, _) <-
    !setBusy;
    Destination = X + Limit; 
    !backwardTo(Destination);
    .print("👁️: Backward executed"); 
.
+!backward(Limit)[source(S)]: not gps(X, _, _) <- 
    .print("👁️: Without gps...");
    .wait(2000);
    !forward(Limit);
.
-!backward(Limit) <- .print("👁️ Warning: falied to execute down. Not flying or without gps").



+!backwardTo(BackLimit) : flying  <-
    .print("👁️: Backwarding to: ", BackLimit);
    !setBusy;
    !backwardingTo(BackLimit)
.

+!backwardingTo(BackLimit) : gps(X, _, _) & (BackLimit - 0.1) > X & not cancel <- 
    //!printMetaDebug(BackLimit); //! debug

    .print("👁️: Backwarding ⬇️...");
    .argo.act(backward);

    .wait(2000);
    !backwardingTo(BackLimit)
.
-!backwardingTo(BackLimit) : gps(X, _, _) & (BackLimit - 0.1) > X & not cancel <- 
    .wait(2000);
    !backwardingTo(BackLimit)
.
+!backwardingTo(BackLimit) : gps(X, _, _) & (BackLimit - 0.1) <= X & not cancel <- 
    !reset;
    .print("👁️: Backward concluded.");
.

+!backwardingTo(BackLimit) : not gps(X, _, _) <- 
    .print("👁️: Without gps...");
    .wait(2000);
    !backwardingTo(BackLimit);
.

+!backwarding(BackLimit) : cancel  <-
    !reset;
    .print("👁️: Backward Canceled.");
.


//--------------- Left (Y) ---------------


+!left(Limit)[source(S)] : flying & gps(_, Y, _) <-
    !setBusy;
    Destination = Y + Limit; 
    !leftTo(Destination);
    .print("👁️: Left executed."); 
.
+!left(Limit)[source(S)]: not gps(_, Y, _) <- 
    .print("👁️: Without gps...");
    .wait(2000);
    !left(Limit);
.
-!left(Limit) <- .print("👁️ Warning: falied to execute down. Not flying or without gps").



+!leftTo(LeftLimit) : flying  <-
    .print("👁️: Lefting to: ", LeftLimit);
    !setBusy;
    !leftingTo(LeftLimit)
.

+!leftingTo(LeftLimit) : gps(_, Y, _) & (LeftLimit + 0.1) < Y & not cancel <- 
    //!printMetaDebug(LeftLimit); //! debug

    .print("👁️: Going left ⬅️...");
    .argo.act(left);

    .wait(2000);
    !leftingTo(LeftLimit)
.
-!leftingTo(LeftLimit) : gps(_, Y, _) & (LeftLimit + 0.1) < Y & not cancel <- 
    .wait(2000);
    !leftingTo(LeftLimit)
.
+!leftingTo(LeftLimit) : gps(_, Y, _) & (LeftLimit + 0.1) >= Y & not cancel <- 
    !reset;
    .print("👁️: Left concluded.");
.

+!leftingTo(LeftLimit) : not gps(_, Y, _) <- 
    .print("👁️: Without gps...");
    .wait(2000);
    !leftingTo(LeftLimit);
.

+!leftingTo(LeftLimit) : cancel  <-
    !reset;
    .print("👁️: Left canceled.");
.



//--------------- Right (Y) ---------------

+!right(Limit)[source(S)] : flying & gps(_, Y, _) <-
    !setBusy;
    Destination = Y + Limit;
    !rightTo(Destination);
    .print("👁️: Right executed.");
.
+!right(Limit)[source(S)]: not gps(_, Y, _) <- 
    .print("👁️: Without gps...");
    .wait(2000);
    !right(Limit);
.
-!right(Limit) <- .print("👁️ Warning: falied to execute down. Not flying or without gps").



+!rightTo(RightLimit) : flying <-
    .print("👁️: Righting to: ", RightLimit);
    !setBusy;
    !rightingTo(RightLimit);
.

+!rightingTo(RightLimit) : gps(_, Y, _) & (RightLimit - 0.1) > Y & not cancel <- 
    //!printMetaDebug(RightLimit); //! debug

    .print("👁️: Going right ➡️...");
    .argo.act(right);

    .wait(2000);
    !rightingTo(RightLimit)
.
-!rightingTo(RightLimit) : gps(_, Y, _) & (RightLimit - 0.1) > Y & not cancel <- 
    .wait(2000);
    !rightingTo(RightLimit)
.
+!rightingTo(RightLimit) : gps(_, Y, _) & (RightLimit - 0.1) <= Y & not cancel <- 
    !reset;
    .print("👁️: Righting concluded.");
.

+!rightingTo(RightLimit) : not gps(_, Y, _) <- 
    .print("👁️: Without gps...");
    .wait(2000);
    !rightingTo(RightLimit);
.

+!rightingTo(RightLimit) : cancel <-
    !reset;
    .print("👁️: Righting canceled.");
.

//--------------- Helpers ---------------

+!reset <- 
    -cancel[source(_)];
    -cancel;
    -busy;
    .broadcast(untell, busy);
    .print("👁️: I am open to work!")
.

+!setNotBusy <-
    -busy;
    .broadcast(untell, busy);
.

+!setBusy <- 
    +busy;
    .broadcast(tell, busy);
.

+cancel[source(X)] <-
    +cancel
.


//--------------- Debug ---------------


//+gps(X, Y, Z) <- 
//	.print("--DEBUG GPS: Percepção recebida: gps(", X, ", ", Y, ", ", Z, ")")
//.

+!printMetaDebug(A) : gps(X, Y, Z) <-
   .print("--DEBUG: Position X: ", X, " Meta: ", ((A * 1) - 0.1) );
   .print("--DEBUG: Position Y: ", Y, " Meta: ", ((A * 1) - 0.1) );
   .print("--DEBUG: Position Z: ", Z, " Meta: ", ((A * 1) - 0.1) );
   .wait(1500)
.


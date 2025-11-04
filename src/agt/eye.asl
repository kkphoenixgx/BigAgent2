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
  .print("👁️: I do not know the path");
.

//--------------- Fase de navegação ---------------

+!argoAct(Command): not cancel <-
    .argo.act(Command);

.
-!argoAct(Command) <-
    .print("👁️: Takeoff canceled");

.

+!takeoff <- 
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

+!land : flying <- 
    .print("👁️: Landing...");
    .argo.act(land);
    -flying
.

+!turnOff <- 
    .print("👁️: Turning off!");
    .argo.act(off);
    .wait(1000);
    .print("--: Closing eyes!");
.

+!setNotBusy <-
    -busy;
    .broadcast(untell, busy);
.

+cancel[source(X)] <-
    +cancel
.

//--------------- UP ---------------

+!up(Limit): not flying & not busy <-
    !takeoff;
    !up(Limit);
.

+!up(Limit): flying <-
    .print("👁️: Rising to: ", Limit);
    +busy;
    .broadcast(tell, busy);
    !rising(Limit);
.

+!rising(Limit): gps(_, _, Z) & (1 * Limit) - 0.1 > Z & not cancel <- 
    //!printMetaDebug(Limit); //! debug
	
    .print("👁️: Rising... ⬆️ ");
        .argo.act(up);

    .wait(2000);
    !rising(Limit)
.
-!rising(Limit): gps(_, _, Z) & (1 * Limit) - 0.1 > Z & not cancel <- 
	.wait(2000);
	!rising(Limit)
.


+!rising(Limit) : gps(_, _, Z) & (1 * Limit) - 0.1 <= Z & not cancel <- 
    .broadcast(untell, busy);
   	.print("👁️: Rise concluded.");
.

+!rising(Limit): cancel <-
    .print("Canceled rising");
    -cancel[source(_)];
    -busy;
    .broadcast(untell, busy);
.

//--------------- DOWN ---------------

+!down(DownLimit) : flying <-
    .print("👁️: Downing to: ", DownLimit);
    +busy;    
    .broadcast(tell, busy);
    !downing(DownLimit)
.

+!downing(DownLimit) : gps(_, _, Z) & (DownLimit + 0.1) < Z & not cancel <- 
    //!printMetaDebug(DownLimit); //! debug
    
    .print("👁️: Downing... ⬇️");
    .argo.act(down);

    .wait(2000);
    !downing(DownLimit)
.

-!downing(DownLimit) : gps(_, _, Z) & (DownLimit + 0.1) < Z & not cancel <- 
    .wait(2000);
    !downing(DownLimit)
.

+!downing(DownLimit) : gps(_, _, Z) & (DownLimit + 0.1) >= Z & not cancel <- 
    .broadcast(untell, busy);
    .print("👁️: Descida concluída.");
.

+!downing(DownLimit): cancel <-
    .print("Canceled downing");
    -cancel[source(_)];
    -busy;
    .broadcast(untell, busy);
.


//--------------- Foward X ---------------

+!forward(FrontLimit) : flying <-
    .print("👁️: Indo para frente até: ", FrontLimit);
    +busy;    
    .broadcast(tell, busy);
    !forwarding(FrontLimit)
.


+!forwarding(FrontLimit) : gps(X, _, _) & (FrontLimit + 0.1) < X & not cancel <- 
    //!printMetaDebug(FrontLimit); //! debug

    .print("👁️: Going To Destination!");
    .argo.act(forward);

    .wait(2000);
    !forwarding(FrontLimit)
.
-!forwarding(FrontLimit) : gps(X, _, _) & (FrontLimit + 0.1) < X & not cancel <- 
    .wait(2000);
    !forwarding(FrontLimit)
.


+!forwarding(FrontLimit) : gps(X, _, _) & (FrontLimit + 0.1) >= X & not cancel  <- 
    .broadcast(untell, busy);
    .print("👁️: Frente concluída.");
.

+!forwarding(FrontLimit): cancel <-
    .print("Canceled forwarding");
    -cancel[source(_)];
    -busy;
    .broadcast(untell, busy);
.


//--------------- Backwards X ---------------

+!backward(BackLimit) : flying <-
    .print("👁️: Indo para trás até: ", BackLimit);
    +busy;    
    .broadcast(tell, busy);
    !backwarding(BackLimit)
.

+!backwarding(BackLimit) : gps(X, _, _) & (BackLimit - 0.1) > X & not cancel <- 
    //!printMetaDebug(BackLimit); //! debug

    .print("👁️: Indo para trás ⬇️");
    .argo.act(backward);

    .wait(2000);
    !backwarding(BackLimit)
.

-!backwarding(BackLimit) : gps(X, _, _) & (BackLimit - 0.1) > X & not cancel <- 
    .wait(2000);
    !backwarding(BackLimit)
.

+!backwarding(BackLimit) : gps(X, _, _) & (BackLimit - 0.1) <= X & not cancel <- 
    .broadcast(untell, busy);
    .print("👁️: Traseira concluída.");
.

//--------------- Left Y ---------------

+!left(LeftLimit) : flying <-
    .print("👁️: Indo para esquerda até: ", LeftLimit);
    +busy;    
    .broadcast(tell, busy);
    !lefting(LeftLimit)
.

+!lefting(LeftLimit) : gps(_, Y, _) & (LeftLimit + 0.1) < Y & not cancel <- 
    //!printMetaDebug(LeftLimit); //! debug

    .print("👁️: Indo para esquerda ⬅️");
    .argo.act(left);

    .wait(2000);
    !lefting(LeftLimit)
.

-!lefting(LeftLimit) : gps(_, Y, _) & (LeftLimit + 0.1) < Y & not cancel <- 
    .wait(2000);
    !lefting(LeftLimit)
.

+!lefting(LeftLimit) : gps(_, Y, _) & (LeftLimit + 0.1) >= Y & not cancel <- 
    .broadcast(untell, busy);
    .print("👁️: Esquerda concluída.");
.


//--------------- Right Y ---------------

+!right(RightLimit) : flying <-
    .print("👁️: Indo para direita até: ", RightLimit);
    +busy;
    .broadcast(tell, busy);
    !righting(RightLimit)
.

+!righting(RightLimit) : gps(_, Y, _) & (RightLimit - 0.1) > Y & not cancel <- 
    //!printMetaDebug(RightLimit); //! debug

    .print("👁️: Indo para direita ➡️");
    .argo.act(right);

    .wait(2000);
    !righting(RightLimit)
.

-!righting(RightLimit) : gps(_, Y, _) & (RightLimit - 0.1) > Y & not cancel <- 
    .wait(2000);
    !righting(RightLimit)
.

+!righting(RightLimit) : gps(_, Y, _) & (RightLimit - 0.1) <= Y & not cancel <- 
    .broadcast(untell, busy);
    .print("👁️: Direita concluída.")
.

//--------------- Comunicate ---------------

+!contactBack <- 
	.send(teletela, tell, pathConcluded).

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


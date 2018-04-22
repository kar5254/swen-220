/*
 * Starter skeleton for Cafe using semaphores
 */

#define NCUSTS 3 	/* number of customers */
#define NCASHIERS 1 /* number of cashiers */
#define NSERVERS 1 	/* number of servers */
#define NOBODY 255

#define semaphore byte   /* define a sempahore */

/*
 * lock (down) and unlock (up) functions for mutex semaphores
 */
inline unlock(s) {s++;}
inline lock(s) {atomic{ s>0 ; s--}}

/*
 * wait (down) and notify (up) functions for signaling semaphores
 */
inline notify(s) {s++;}
inline wait(s) {atomic{ s>0 ; s--}}

mtype = {CHILI, SANDWICH, PIZZA, NULL} ; // the types of foods (added null for resets)
mtype favorites[NCUSTS];
mtype orders[NCUSTS] = NULL;

byte ordering = NOBODY;

semaphore waitingFood[NCUSTS] = 1;
semaphore cashierOpen = 1;
semaphore serverOpen = 1;

bool waiting[NCUSTS] = false;


/*
 * Process representing a customer.
 * Takes in their favorite food and an integer id
 * to represent them
 */
proctype Customer(mtype favorite; byte id)
{
	/* customer cycle */
	do
	::
		//Enter
		printf("Customer %d Entered\n", id);

		//Record
		favorites[id] = favorite;

		//Wait for cashier
		cashierOpen > 0;
		atomic{
			lock(cashierOpen);
			printf("Cashier selects customer %d\n", id);
			ordering = id;
		}
		//Order
		orders[id] = favorite;
		printf("Customer orders %e\n", favorite);
		unlock(cashierOpen);
		ordering = NOBODY;
		

		printf("Customer %d is waiting for %e\n", id, favorite);
		waiting[id] = true;
		wait(waitingFood[id]);
		waitingFood[id] > 0;
		
		printf("Customer %d recieves food and leaves\n", id);
		favorites[id] = NULL;
		orders[id] = NULL;
		
	od ;
}

/*
 * Process representing a cashier
 */
proctype Cashier()
{
	do
	::
		printf("Cashier is waiting for a customer\n");
		cashierOpen < 1;
		printf("Cashier takes the order of Customer %d\n", ordering);
		serverOpen > 0;
		printf("Cashier passes order to server\n");
	od ;
}

/*
 * Process representing a server 
 */
proctype Server()
{
	byte id;
	do
	::
		printf("Server is waiting for order\n");
		for(id : 0..2){
			if
			::  waiting[id] ->
				lock(serverOpen);
				printf("Server creates order of %e for %d\n", orders[id], id);
				printf("Server delivers order of %e to %d\n", orders[id], id);
				notify(waitingFood[id]);
				unlock(serverOpen);
			::  else ->
					skip;
			fi;
		}
	od ;

}

/*
 * Sets up processes. This model creates two
 * customers with the favorite foods PIZZA & CHILI.
 */
init{

	atomic{
		run Customer(PIZZA, 0) ;
		run Customer(CHILI, 1) ;
		run Cashier();
		run Server();		
	}
}

/*
 * Safety: The server always gives the correct food
 * for the customer
 */

ltl S_ServerCorrectFood {
	true;
}

/*
 * Safety: The cashier always sends the correct customer
 * order to the servers.
 */

ltl S_CashierSendsCorrectOrder{
	true;
}

/* 
 * Liveness: If the customer wants to place
 * an order then it eventually does.
 */

ltl L_CustomerOrders {
	true;
}

/* 
 * Liveness: Eventually the server is busy
 * fulfilling an order.
 */

ltl L_ServerBusy{
	true;
}



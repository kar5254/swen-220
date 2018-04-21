/*
 * Starter skeleton for Cafe using semaphores
 */

#define NCUSTS 2 	/* number of customers */
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

mtype = {CHILI, SANDWICH, PIZZA} ;	/* the types of foods */
mtype favorites[NCUSTS];

byte numWaiting = 0;
byte numServed = 0;
byte ordering = NOBODY;

semaphore foodReady = 0;
semaphore cashier = 1;

bool want

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

		/* 1. Customer enters the cafe */
		printf("C%d enters.\n", id) ;

		/* 2. Record a new customer */
		favorites[id] = favorite;
		numWaiting++;
	
		/* 3. Wait for the cashier */

		cashier > 0;
		ordering = id;
		lock(cashier);
		numWaiting--;
		numServed++;

		/* 4. Customer places order for favorite food */
		printf("C%d orders %e.\n", id, favorite) ;
		
		/* 5. Wait for the order to be fulfilled */
		
		wait(foodReady);
		
		unlock(cashier);

		foodReady < 1;
		notify(foodReady);
		
		/* 6. Customer exits with food */
		printf("C%d leaves.\n", id);
		numServed--;

	od ;
}

/*
 * Process representing a cashier
 */
proctype Cashier()
{
	do
	::
		/* 1. Cashier waits for a new customer */
		printf("Cashier is waiting for a new customer.\n");
		
		
		
		/* 2. Cashier selects a waiting customer */
		printf("Cashier selects customer.\n");
		
		/* 3. Cashier takes selected customer's order */
		printf("Cashier takes order.\n");

		/* 4. Cashier passes order to server */
		printf("Cashier passes order to server.\n");

	od ;
}

/*
 * Process representing a server 
 */
proctype Server()
{

	do
	::
		printf("Server is free.\n") ;
		/* Server is waiting for an order */

		/* Server retrives an order and takes it down */
		printf("Server is retrieves an order for customer...\n") ;

		/* Server makes the order */
		printf("Server makes order.\n");


		/* server gives the order to the customer */
		printf("Server delivers order to customer.\n");
		
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



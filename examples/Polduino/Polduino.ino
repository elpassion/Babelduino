/*
	Polduino

  An example of Arduino code written in polish language.

*/

#include <Polduino.h>

procedura ustaw() {
	niech imie = 'Jan';

	jezeli (imie == 'Michał') {
		wynik 0;
	} w_przeciwnym_razie {
	  powtorz (niech i = 0; i < 10; i++) {
			czekaj(i);
		}
	}	
}

procedura powtarzaj() {
	czekaj(100);
}

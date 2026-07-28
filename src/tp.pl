habitante(denken, aurbest, 1290, humano).
habitante(voll, ende, 1200, enano).
habitante(serie, weise, 500, elfo).
habitante(fern, weise, 1370, humano).
habitante(stark, riegel, 1368, humano).
habitante(lawie,aurbest, 1372, humano).
habitante(kanne, weise, 1365, humano).
habitante(wirbel, weise, 1365, humano).
habitante(lernen, aurbest, 1315, humano).
habitante(frieren, weise, 100, elfo).
habitante(eisen, riegel, 1150, enano).

esperanzaVida(humano, 80).
esperanzaVida(enano, 350).

estaVivo(Persona, Anio):-
    habitante(Persona, _, Nacimiento, elfo),
    Anio >= Nacimiento.

estaVivo(Persona, Anio):-
    habitante(Persona, _, Nacimiento, Raza),
    Raza \= elfo,
    esperanzaVida(Raza, AniosMaximos),
    Anio >= Nacimiento,
    Anio =< Nacimiento + AniosMaximos. 

:- begin_tests(tpIntegrador, []).

test(kanne_esta_viva_en_1370):-
    estaVivo(kanne, 1370).

test(kanne_no_esta_viva_en_1300, fail):-
    estaVivo(kanne,1300).

test(kanne_no_esta_viva_en_2000, fail):-
    estaVivo(kanne,2000).

test(voll_esta_vivo_en_1550):-
    estaVivo(voll, 1550).

test(voll_esta_vivo_en_1551, fail):-
    estaVivo(voll,1551).

test(serie_esta_viva_en_5000):-
    estaVivo(serie, 5000).

:- end_tests(tpIntegrador).

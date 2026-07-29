% Parte 1

habitante(denken, aurbest, 1290, humano).
habitante(voll, ende, 1200, enano).
habitante(serie, weise, 500, elfo).
habitante(fern, weise, 1370, humano).
habitante(stark, riegel, 1368, humano).
habitante(lawine,aurbest, 1372, humano).
habitante(kanne, weise, 1365, humano).
habitante(wirbel, weise, 1350, humano).
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

% Parte 2

conoce(wirbel, 1390, presencio , rescatarHermanaWirbel , [stark , fern] , klares).
conoce(frieren, 1390, presencio , rescatarHermanaWirbel , [stark , fern] , klares).
conoce(lawine, 1393, cancion , destruirAura , [frieren] , weise).
conoce(voll, 1400, libro(50) , destruirAura , [denken] , aurbest).
conoce(serie, 1335, libro(100) , destruirReyDemonio , [frieren, himmel , heiter, eisen] , ende).
conoce(kanne, 1375, presencio , recuperarGatoPerdido , [himmel, frieren] , weise).

recuerda(Persona, Hazania, Anio):-
    conoce(Persona, AnioConoce, presencio , Hazania , _ , _ ),
    Anio >= AnioConoce,
    estaVivo(Persona, Anio).
recuerda(Persona, Hazania, Anio):-
    conoce(Persona, AnioConoce, cancion , Hazania , _ , _),
    Anio >= AnioConoce,
    Anio =< AnioConoce + 15,
    estaVivo(Persona, Anio).
recuerda(Persona, Hazania, Anio):-
    conoce(Persona, AnioConoce, libro(Paginas), Hazania , _ , _ ),
    Anio >= AnioConoce,
    Anio =< AnioConoce + Paginas,
    estaVivo(Persona, Anio).

% Tests

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

% Tests 2

test(no_recuerda_destruir_aura_en_1380_, fail):-
    recuerda(lawine, destruirAura, 1380).

test(recuerda_destruir_aura_en_1400):-
    recuerda(lawine, destruirAura, 1400).

test(no_recuerda_destruir_aura_en_1410, fail):-
    recuerda(lawine, destruirAura, 1410).

test(recuerda_destruir_aura_en_1450):-
    recuerda(voll, destruirAura, 1450).

test(no_recuerda_destruir_aura_en_1460, fail):-
    recuerda(voll, destruirAura, 1460).

test(recuerda_rescatar_hermana_en_1430):-
    recuerda(wirbel, rescatarHermanaWirbel, 1430).

test(no_recuerda_rescatar_hermana_en_1440, fail):-
    recuerda(wirbel, rescatarHermanaWirbel, 1440).

:- end_tests(tpIntegrador).
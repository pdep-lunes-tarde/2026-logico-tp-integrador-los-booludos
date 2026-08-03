% Parte 1

% Punto 1

habitante(denken, auberst, 1290, humano).
habitante(voll, ende, 1200, enano).
habitante(serie, weise, 500, elfo).
habitante(fern, weise, 1370, humano).
habitante(stark, riegel, 1368, humano).
habitante(lawine,auberst, 1372, humano).
habitante(kanne, weise, 1365, humano).
habitante(wirbel, weise, 1350, humano).
habitante(lernen, auberst, 1315, humano).
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

% Punto 2

conoce(wirbel, 1390, presencio , rescatarHermanaWirbel , [stark , fern] , klares).
conoce(frieren, 1390, presencio , rescatarHermanaWirbel , [stark , fern] , klares).
conoce(lawine, 1393, cancion , destruirAura , [frieren] , weise).
conoce(voll, 1400, libro(50) , destruirAura , [denken] , auberst).
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

distintosDetalles(Personas1,Personas2,_,_):-
    Personas1 \= Personas2.
distintosDetalles(_,_,Lugar1,Lugar2):-
    Lugar1 \= Lugar2.

estaCorroborada(Hazania):-
    not (conoce(_, _, _, Hazania, Personas1, Lugar1),
        conoce(_, _, _, Hazania, Personas2, Lugar2),
        distintosDetalles(Personas1,Personas2,Lugar1,Lugar2)
        ).

estaOlvidada(Hazania,Anio):-
    not recuerda(_,Hazania,Anio).

% Punto 3

conmemoraFestivo(weise, destruirReyDemonio, 1340).

estatua(auberst, bronce, elEquipoDeHeroes, destruirReyDemonio, 1370).
estatua(auberst, marmol, elHeroeDelSur, destruirSchlatOmnisciente, 1340).
 
mantenimientoEstatua(elEquipoDeHeroes, 1400).
mantenimientoEstatua(elEquipoDeHeroes, 1450).
mantenimientoEstatua(elHeroeDelSur, 1410).

recuerda(Persona, Hazania, Anio):-
    habitante(Persona, Pueblo, _, _),
    conmemoraFestivo(Pueblo, Hazania, AnioInicioConmemoracion),
    anioEnQueConocioConmemoracion(Persona, AnioInicioConmemoracion, AnioConocio),
    Anio >= AnioConocio,
    estaVivo(Persona, Anio).
recuerda(Persona, Hazania, Anio):-
    habitante(Persona, Pueblo, _, _),
    estatua(Pueblo, _, Estatua, Hazania, AnioConstruccion),
    anioEnQueConocioConmemoracion(Persona, AnioConstruccion, AnioConocio),
    Anio >= AnioConocio,
    estaVivo(Persona, Anio),
    estatuaEnBuenEstado(Estatua, Anio).

aniosMaximoSinMantenimiento(marmol, 30).
aniosMaximoSinMantenimiento(bronce, 15).

anioEnQueConocioConmemoracion(Persona, AnioInicioConmemoracion, AnioInicioConmemoracion):-
    habitante(Persona, _, AnioNacimiento, _),
    AnioNacimiento =< AnioInicioConmemoracion.
anioEnQueConocioConmemoracion(Persona, AnioInicioConmemoracion, AnioNacimiento):-
    habitante(Persona, _, AnioNacimiento, _),
    AnioNacimiento > AnioInicioConmemoracion.

estatuaEnBuenEstado(Estatua, Anio):-
    estatua(_, Material, Estatua, _, AnioConstruccion),
    AnioConstruccion =< Anio,
    aniosMaximoSinMantenimiento(Material, AniosMaximos),
    Anio - AnioConstruccion =< AniosMaximos.
estatuaEnBuenEstado(Estatua, Anio):-
    estatua(_, _, Estatua, _, AnioConstruccion),
    AnioConstruccion =< Anio,
    mantenimientoEstatua(Estatua, AnioMantenimiento),
    AnioMantenimiento =< Anio.

% Tests 1

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

test(una_hazania_que_contiene_mismo_detalles_esta_corroborada):-
    estaCorroborada(rescatarHermanaWirbel).

test(una_hazania_que_contiene_distintos_detalles_no_esta_corroborada, fail):-
    estaCorroborada(destruirAura).

test(una_hazania_que_nadie_recuerda_esta_olvidada):-
    estaOlvidada(destruirAura,1460).

test(una_hazania_que_alguien_recuerda_no_esta_olvidada,fail):-
    estaOlvidada(destruirAura,1440).

% Tests 3

test(la_estatua_esta_en_buen_estado_por_su_antiguedad_reciente_o_por_el_mantenimiento):-
    estatuaEnBuenEstado(elHeroeDelSur, 1360),
    estatuaEnBuenEstado(elEquipoDeHeroes, 1405).
 
test(la_estatua_no_se_encuentra_en_buen_estado_sin_su_mantenimiento_ni_antiguedad_valida, fail):-
    estatuaEnBuenEstado(elEquipoDeHeroes, 1390),
    estatuaEnBuenEstado(elHeroeDelSur, 1375),
    estatuaEnBuenEstado(elEquipoDeHeroes, 1360).
 
test(tal_persona_recuerda_una_hazania_conmemorada_con_un_dia_festivo_si_esta_vive_en_ese_pueblo):-
    recuerda(fern, destruirReyDemonio, 1400).
 
test(tal_persona_no_recuerda_una_hazania_conmemorada_en_un_pueblo_donde_esta_no_vive, fail):-
    recuerda(voll, destruirReyDemonio, 1420).
 
test(tal_persona_recuerda_una_hazania_conmemorada_por_una_estatua_si_esta_se_encuentra_en_buen_estado):-
    recuerda(lawine, destruirReyDemonio, 1400).
 
test(tal_persona_no_recuerda_una_hazania_conmemorada_con_estatua_si_esta_se_encuentra_en_mal_estado, fail):-
    recuerda(lawine, destruirReyDemonio, 1390).
 
test(tal_persona_conoce_una_conmemoracion_desde_su_inicio_si_esta_ya_habia_nacido):-
    recuerda(frieren, destruirReyDemonio, 1340).
 
test(tal_persona_no_recuerda_una_conmemoracion_antes_de_que_esta_comience, fail):-
    recuerda(frieren, destruirReyDemonio, 1339).

:- end_tests(tpIntegrador).

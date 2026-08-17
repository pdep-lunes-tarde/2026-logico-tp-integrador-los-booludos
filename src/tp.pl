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

dura(presencio, _ ,_).
dura(cancion, Anio, AnioActual):-
    AnioActual =< Anio + 15.
dura(libro(Paginas), Anio, AnioActual):-
    AnioActual =< Anio + Paginas.

perdura(Persona,Hazania,Anio,AnioConoce):-
    conoce(Persona, AnioConoce, Tipo, Hazania, _, _),
    dura(Tipo, AnioConoce, Anio).
perdura(Persona,Hazania,Anio,AnioConoce):-
    habitante(Persona, Pueblo, _, _),
    conmemoraFestivo(Pueblo, Hazania, AnioInicioConmemoracion),
    anioEnQueConocioConmemoracion(Persona, AnioInicioConmemoracion, AnioConoce).
perdura(Persona,Hazania,Anio,AnioConoce):-
    habitante(Persona, Pueblo, _, _),
    estatua(Pueblo, _, Estatua, Hazania, AnioConstruccion),
    anioEnQueConocioConmemoracion(Persona, AnioConstruccion, AnioConoce),
    estatuaEnBuenEstado(Estatua, Anio).

recuerda(Persona, Hazania, Anio) :-
    perdura(Persona,Hazania,Anio,AnioConoce),
    Anio >= AnioConoce,
    estaVivo(Persona, Anio).

distintosDetalles(Personas1,Personas2,_,_):-
    Personas1 \= Personas2.
distintosDetalles(_,_,Lugar1,Lugar2):-
    Lugar1 \= Lugar2.

estaCorroborada(Hazania):-
    conoce(_,_,_,Hazania,_,_),
    not((conoce(_, _, _, Hazania, Personas1, Lugar1),
        conoce(_, _, _, Hazania, Personas2, Lugar2),
        distintosDetalles(Personas1,Personas2,Lugar1,Lugar2)
        )).

estaOlvidada(Hazania,Anio):-
    conoce(_,_,_,Hazania,_,_),
    not(recuerda(_,Hazania,Anio)).

% Punto 3

conmemoraFestivo(weise, destruirReyDemonio, 1340).

estatua(auberst, bronce, elEquipoDeHeroes, destruirReyDemonio, 1370).
estatua(auberst, marmol, elHeroeDelSur, destruirSchlatOmnisciente, 1340).
 
mantenimientoEstatua(elEquipoDeHeroes, 1400).
mantenimientoEstatua(elEquipoDeHeroes, 1450).
mantenimientoEstatua(elHeroeDelSur, 1410).

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
    estatua(_, Material, Estatua, _, AnioConstruccion),
    AnioConstruccion =< Anio,
    aniosMaximoSinMantenimiento(Material, AniosMaximos),
    mantenimientoEstatua(Estatua, AnioMantenimiento),
    AnioMantenimiento =< Anio,
    Anio - AnioMantenimiento =< AniosMaximos.

% Tests 1

:- begin_tests(tpIntegrador, []).

test("Un humano está vivo si el año consultado está dentro de su esperanza de vida"):-
    estaVivo(kanne, 1370).

test("Nadie está vivo en un año anterior a su fecha de nacimiento", fail):-
    estaVivo(kanne, 1300).

test("Un humano fallece y ya no está vivo si el año supera su esperanza de vida", fail):-
    estaVivo(kanne, 2000).

test("Un enano está vivo si el año consultado está dentro de su extensa esperanza de vida"):-
    estaVivo(voll, 1550).

test("Un enano no está vivo si el año supera su esperanza de vida máxima", fail):-
    estaVivo(voll, 1551).

test("Un elfo es inmortal y está vivo en cualquier año posterior a su nacimiento"):-
    estaVivo(serie, 5000).

% Tests 2

test("Alguien no puede recordar una hazaña en un año anterior a haberla conocido", fail):-
    recuerda(lawine, destruirAura, 1380).

test("Alguien recuerda una hazaña que conoció por una canción si aún no pasaron 15 años"):-
    recuerda(lawine, destruirAura, 1400).

test("Alguien olvida una hazaña conocida por una canción cuando pasan más de 15 años", fail):-
    recuerda(lawine, destruirAura, 1410).

test("Alguien recuerda una hazaña de un libro si los años transcurridos no superan sus páginas"):-
    recuerda(voll, destruirAura, 1450).

test("Alguien olvida una hazaña de un libro cuando los años transcurridos superan sus páginas", fail):-
    recuerda(voll, destruirAura, 1460).

test("Alguien recuerda una hazaña que presenció toda su vida mientras siga vivo"):-
    recuerda(wirbel, rescatarHermanaWirbel, 1430).

test("Nadie puede recordar una hazaña, aunque la haya presenciado, si ya falleció", fail):-
    recuerda(wirbel, rescatarHermanaWirbel, 1440).

test("Una hazaña está corroborada si todos los que la conocen coinciden en los detalles (personas y lugar)"):-
    estaCorroborada(rescatarHermanaWirbel).

test("Una hazaña no está corroborada si hay contradicciones en los detalles entre quienes la conocen", fail):-
    estaCorroborada(destruirAura).

test("Una hazaña está olvidada en un año particular si ninguna persona viva la recuerda"):-
    estaOlvidada(destruirAura, 1460).

test("Una hazaña no está olvidada si al menos una persona viva aún la recuerda", fail):-
    estaOlvidada(destruirAura, 1440).

% Tests 3

test("Una estatua está en buen estado si es reciente respecto a su material o si recibió mantenimiento a tiempo"):-
    estatuaEnBuenEstado(elHeroeDelSur, 1360),
    estatuaEnBuenEstado(elEquipoDeHeroes, 1405).
 
test("Una estatua no está en buen estado si superó el tiempo máximo de su material sin recibir mantenimiento", fail):-
    estatuaEnBuenEstado(elEquipoDeHeroes, 1390),
    estatuaEnBuenEstado(elHeroeDelSur, 1375),
    estatuaEnBuenEstado(elEquipoDeHeroes, 1360).
 
test("Una persona recuerda una hazaña si vive en un pueblo con un día festivo que la conmemora"):-
    recuerda(fern, destruirReyDemonio, 1400).
 
test("Una persona no recuerda una hazaña por día festivo si este se celebra en un pueblo distinto al suyo", fail):-
    recuerda(voll, destruirReyDemonio, 1420).
 
test("Una persona recuerda una hazaña si en su pueblo hay una estatua conmemorativa en buen estado"):-
    recuerda(lawine, destruirReyDemonio, 1400).
 
test("Una persona no recuerda una hazaña por estatua si esta se encuentra en mal estado", fail):-
    recuerda(lawine, destruirReyDemonio, 1390).
 
test("Alguien conoce una conmemoración desde su inicio si ya había nacido cuando se instauró"):-
    recuerda(frieren, destruirReyDemonio, 1340).
 
test("Nadie puede recordar una conmemoración en un año anterior a que esta comience a celebrarse", fail):-
    recuerda(frieren, destruirReyDemonio, 1339).

:- end_tests(tpIntegrador).

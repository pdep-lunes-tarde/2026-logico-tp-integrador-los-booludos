% Parte 1

% Punto 1

habitante(denken, auberst, 1290, humano).
habitante(voll, ende, 1200, enano).
habitante(serie, weise, 500, elfo).
habitante(fern, weise, 1370, humano).
habitante(stark, riegel, 1368, humano).
habitante(lawine,auberst, 1372, humano).
habitante(kanne, weise, 1365, humano).
habitante(wirbel, klares, 1350, humano).
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
    conmemora(Pueblo, AnioInicioConmemoracion, Tipo, Hazania, _, _),
    anioEnQueConocioConmemoracion(Persona, AnioInicioConmemoracion, AnioConoce),
    conmemoracionVigente(Tipo, Anio).

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

conmemora(weise, 1340, festivo, destruirReyDemonio, [frieren, himmel, heiter, eisen], ende).
conmemora(auberst, 1370, estatua(bronce, elEquipoDeHeroes), destruirReyDemonio, [frieren, himmel, heiter, eisen], ende).
conmemora(auberst, 1340, estatua(marmol, elHeroeDelSur), destruirSchlatOmnisciente, [heroeDelSur], ende).
 
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

conmemoracionVigente(festivo, _).
conmemoracionVigente(estatua(_, NombreEstatua), Anio):-
    estatuaEnBuenEstado(NombreEstatua, Anio).

estatuaEnBuenEstado(NombreEstatua, Anio):-
    conmemora(_, AnioConstruccion, estatua(Material, NombreEstatua), _, _, _),
    aniosMaximoSinMantenimiento(Material, AniosMaximos),
    anioDeReferencia(NombreEstatua, AnioConstruccion, AnioReferencia),
    AnioReferencia =< Anio,
    Anio - AnioReferencia =< AniosMaximos.

anioDeReferencia(_, AnioConstruccion, AnioConstruccion).
anioDeReferencia(NombreEstatua, _, AnioMantenimiento):-
    mantenimientoEstatua(NombreEstatua, AnioMantenimiento).

% Parte 2

% Punto 5

esHeroe(Personaje):-
    conoce(_,_,_,_,Personajes,_),
    member(Personaje, Personajes).
esHeroe(Personaje):-
    conmemora(_,_,_,_,Personajes,_),
    member(Personaje, Personajes).

inspiro(Inspirador, Inspirado):-
    esHeroe(Inspirador),
    esHeroe(Inspirado),
    Inspirador \= Inspirado,
    conocioAlgunaVez(Inspirado, Hazania),
    participo(Inspirador, Hazania).

heroesQueInspiraron(Inspirado, Inspiradores):-
    esHeroe(Inspirado),
    findall(Inspirador, inspiro(Inspirado, Inspirador), Inspiradores).

cadenaDeInspiracion(Heroe, Cadena):-
    esHeroe(Heroe),
    cadenaDeInspiracion(Heroe, [Heroe], Cadena).

cadenaDeInspiracion(Heroe, Vistos, [Heroe|Resto]):-
    inspiro(Heroe, Inspirado),
    \+ member(Inspirado, Vistos),
    cadenaDeInspiracion(Inspirado, [Inspirado|Vistos], Resto).

cadenaDeInspiracion(Heroe, Vistos, [Heroe, Inspirado]):-
    inspiro(Heroe, Inspirado),
    \+ member(Inspirado, Vistos).

conocioAlgunaVez(Persona, Hazania):-
    conoce(Persona, _, _, Hazania, _, _).
conocioAlgunaVez(Persona, Hazania):-
    habitante(Persona, Pueblo, _, _),
    conmemora(Pueblo, _, _, Hazania, _, _).

participo(Persona, Hazania):-
    conoce(_, _, _, Hazania, Personajes, _),
    member(Persona, Personajes).
participo(Persona, Hazania):-
    conmemora(_, _, _, Hazania, Personajes, _),
    member(Persona, Personajes).

% Punto 6

dreamTeam(Heroe, Equipo):-
    esHeroe(Heroe),
    findall(Antecesor, esAntecesor(Antecesor, Heroe), AntecesoresConRepetidos),
    list_to_set(AntecesoresConRepetidos, Antecesores),
    subconjunto(Antecesores, SubAntecesores),
    SubAntecesores \= [],
    list_to_set([Heroe|SubAntecesores], EquipoGenerado),
    mismoConjunto(EquipoGenerado, Equipo).

esAntecesor(Antecesor, Heroe):-
    cadenaDeInspiracion(Antecesor, Cadena),
    member(Heroe, Cadena),
    Antecesor \= Heroe.

subconjunto([], []).
subconjunto([Antecesor|RestoAntecesores], [Antecesor|SubconjuntoRestoAntecesores]):-
    subconjunto(RestoAntecesores, SubconjuntoRestoAntecesores).
subconjunto([_|RestoAntecesores], SubconjuntoRestoAntecesores):-
    subconjunto(RestoAntecesores, SubconjuntoRestoAntecesores).

mismoConjunto(Lista1, Lista2):-
    length(Lista1, N),
    length(Lista2, N),
    contieneATodos(Lista1, Lista2).

contieneATodos([], _).
contieneATodos([Elemento|Resto], Lista):-
    member(Elemento, Lista),
    contieneATodos(Resto, Lista).

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

% --- Tests Parte 2 ---

% Tests 4

test("Un pueblo recuerda una hazaña si al menos uno de sus habitantes la recuerda en ese año") :- 
    seRecuerdaEnPueblo(weise, destruirReyDemonio, 1400),
    seRecuerdaEnPueblo(klares, rescatarHermanaWirbel, 1395).
test("Un pueblo no recuerda una hazaña si ningún habitante la conoce en ese año", fail) :- 
    seRecuerdaEnPueblo(klares, destruirReyDemonio, 1395).

test("Las páginas leídas en un pueblo suman las hojas de los libros conocidos por sus habitantes en ese año") :- 
    paginasLeidasEnPueblo(weise, 1335, 100).
test("Las páginas leídas en un pueblo son cero si ningún habitante conoció libros en ese año") :- 
    paginasLeidasEnPueblo(weise, 1336, 0).

test("Un pueblo es el más lector si la suma de sus páginas leídas es mayor o igual a la del resto de los pueblos") :- 
    puebloMasLector(ende, 1400).

test("Un pueblo es chismoso si recuerda hazañas pero absolutamente ninguna está corroborada") :- 
    puebloChismoso(ende, 1420).
test("Un pueblo no es chismoso si al menos una de las hazañas que recuerda sí está corroborada", fail) :- 
    puebloChismoso(weise, 1400).


test("Una hazaña es importante para un pueblo si todos sus habitantes vivos en ese año la recuerdan") :- 
    hazaniaImportante(weise, destruirReyDemonio, 1400).
test("Una hazaña no es importante para un pueblo si existe al menos un habitante vivo que no la recuerda", fail) :- 
    hazaniaImportante(weise, recuperarGatoPerdido, 1400).

test("Pueblo es musical si la mayoria de sus Hazañas recordadas son por cancion"):-
    puebloMusical(auberst, 1395).

test("Pueblo con menos de la mitad de hazañas recordadas musicalmente no es musical", fail):-
    puebloMusical(weise, 1400).

test(""):-
    puebloTiemposSinPrecedentes(klares, 1395).

test("", fail):-
    puebloTiemposSinPrecedentes(weise, 1400).

% Tests 5

test("Una persona es un héroe si participó en al menos una hazaña que alguien conoce"):-
    esHeroe(frieren).

test("Una persona no es un héroe si no participó en ninguna hazaña", fail):-
    esHeroe(wirbel).

test("Fern inspiró a Frieren porque Frieren conoce una hazaña en la que participó Fern"):-
    inspiro(fern, frieren).

test("Stark inspiró a Frieren porque Frieren conoce una hazaña en la que participó Stark"):-
    inspiro(stark, frieren).

test("Una persona no fue inspirada si no conocemos ninguna hazaña que haya conocido", fail):-
    inspiro(_,eisen).

test("Una cadena de inspiracion es valida cuando cada heroe inspiro al siguiente"):-
    cadenaDeInspiracion(stark, [stark, frieren]).

test("si un heroe no conoce hazañas de otro entonces este no lo inspiro", fail):-
    cadenaDeInspiracion(denken, [denken, frieren]).

test("Una cadena de inspiracion no puede contener dos veces el mismo heroe", fail):-
    cadenaDeInspiracion(frieren, [frieren, fern, frieren]).

% Tests 6

test("Un equipo formado por un héroe junto con al menos uno de sus antecesores es un dream team válido"):-
    dreamTeam(fern, [fern, himmel]).

test("La validez de un dream team no depende del orden en que aparecen sus integrantes"):-
    dreamTeam(fern, [himmel, fern]).

test("Un equipo formado únicamente por el héroe, sin ningún antecesor, no es un dream team válido", fail):-
    dreamTeam(fern, [fern]).

test("Un equipo que no incluye al héroe para el que se arma no es un dream team válido", fail):-
    dreamTeam(fern, [frieren]).

:- end_tests(tpIntegrador).


seRecuerdaEnPueblo(Pueblo, Hazania, Anio):-
    habitante(Persona, Pueblo, _, _),
    recuerda(Persona, Hazania, Anio).

paginasLeidasEnPueblo(Pueblo, Anio, TotalPaginas):-
    habitante(_, Pueblo, _, _),
    findall(Paginas,
        (habitante(Persona, Pueblo, _, _), conoce(Persona, Anio, libro(Paginas), _, _, _)),
        ListaPaginas),
    sum_list(ListaPaginas, TotalPaginas).

puebloMasLector(Pueblo, Anio):-
    paginasLeidasEnPueblo(Pueblo, Anio, MaxPaginas),
    forall(paginasLeidasEnPueblo(_, Anio, OtrasPaginas), MaxPaginas >= OtrasPaginas).

puebloChismoso(Pueblo, Anio):-
    seRecuerdaEnPueblo(Pueblo, _, Anio),
    forall(seRecuerdaEnPueblo(Pueblo, Hazania, Anio), not(estaCorroborada(Hazania))).

hazaniaImportante(Pueblo, Hazania, Anio):-
    seRecuerdaEnPueblo(Pueblo, Hazania, Anio),
    forall(
        (habitante(Persona, Pueblo, _, _), estaVivo(Persona, Anio)),
        recuerda(Persona, Hazania, Anio)
    ).

sinRepetidos([], []).
sinRepetidos([Cabeza|Cola], Filtrado):-
    member(Cabeza, Cola),
    sinRepetidos(Cola, Filtrado).
sinRepetidos([Cabeza|Cola], [Cabeza|Filtrado]):-
    not(member(Cabeza, Cola)),
    sinRepetidos(Cola, Filtrado).


puebloMusical(Pueblo, Anio):-
    findall(Hazania, seRecuerdaEnPueblo(Pueblo, Hazania, Anio), Hazanias),
    sinRepetidos(Hazanias, HazaniasFiltradas),
    findall(Hazania, ( seRecuerdaEnPueblo(Pueblo, Hazania, Anio),conoce(_, _, cancion, Hazania, _, _) ), HazaniasCancion),
    sinRepetidos(HazaniasCancion, HazaniasCancionFiltradas),

    length(HazaniasFiltradas, Total),
    length(HazaniasCancionFiltradas, ConCancion),

    ConCancion * 2 > Total.

puebloTiemposSinPrecedentes(Pueblo, Anio):-
    forall( hazaniaImportante(Pueblo, Hazania, Anio),( habitante(Persona, Pueblo, _, _),conoce(Persona, _, presencio, Hazania, _, _) ) ).

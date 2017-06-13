%pareja(Persona, Persona)
pareja(marsellus, mia).
pareja(pumkin,    honeyBunny).
pareja(bernardo, bianca). %Punto 2, Parte 1
pareja(bernardo, charo). %Punto 2, Parte 1

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).
%Punto 3
trabajaPara(Superior, bernardo) :-
  trabajaPara(marsellus, Superior),
  Superior \= jules.

trabajaPara(Empleador, george) :-
  saleCon(Empleador, bernardo).

%%% PARTE 1

%Punto 1   No es recursiva porque no utiliza el predicado dentro de sí mismo.
saleCon(Persona, OtraPersona) :-
  pareja(Persona, OtraPersona).

saleCon(Persona, OtraPersona) :-
  pareja(OtraPersona, Persona).

%Punto 4
esFiel(Persona) :-
  saleCon(Persona, _),
  not(saleConVarios(Persona)).

saleConVarios(Persona) :-
  saleCon(Persona, OtraPersona),
  saleCon(Persona, Tercero),
  Tercero \= OtraPersona.

%Punto 5   el predicado es recursivo
%Caso base:
acataOrden(Superior, Empleado) :-
  trabajaPara(Superior, Empleado).
%Caso recursivo:
acataOrden(Superior, Empleado) :-
  trabajaPara(Empleador, Empleado),
  acataOrden(Superior, Empleador).

%%% PARTE 2

% Información base

% personaje(Nombre, Ocupacion)
personaje(pumkin,     ladron([estacionesDeServicio, licorerias])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent,    mafioso(maton)).
personaje(jules,      mafioso(maton)).
personaje(marsellus,  mafioso(capo)).
personaje(winston,    mafioso(resuelveProblemas)).
personaje(mia,        actriz([foxForceFive])).
personaje(butch,      boxeador).
personaje(bernardo,   mafioso(cerebro)).
personaje(bianca,     actriz([elPadrino1])).
personaje(elVendedor, vender([humo, iphone])).
personaje(jimmie,     vender([auto])).

% encargo(Solicitante, Encargado, Tarea).
% las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent, cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).
encargo(bernardo, vincent, buscar(jules, fuerteApache)).
encargo(bernardo, winston, buscar(jules, sanMartin)).
encargo(bernardo, winston, buscar(jules, lugano)).

amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

%Punto 1
esPeligroso(Personaje) :-
  actividadPeligrosa(Personaje).

esPeligroso(Personaje) :-
  jefePeligroso(Personaje).

actividadPeligrosa(Personaje) :-
  personaje(Personaje, mafioso(maton)).

actividadPeligrosa(Personaje) :-
  personaje(Personaje, ladron(QueRoba)),
  member(licorerias, QueRoba).

jefePeligroso(Personaje) :-
  trabajaPara(Jefe, Personaje),
  esPeligroso(Jefe).

%Punto 2
sanCayetano(Personaje) :-
  tieneCerca(Personaje, _),
  forall(tieneCerca(Personaje, Cercano), leDaEncargo(Personaje, Cercano)).

tieneCerca(Personaje, Cercano) :-
  amigo(Personaje, Cercano).

tieneCerca(Personaje, Cercano) :-
  amigo(Cercano, Personaje).

tieneCerca(Personaje, Cercano) :-
  trabajaPara(Personaje, Cercano).

tieneCerca(Personaje, Cercano) :-
  trabajaPara(Cercano, Personaje).

leDaEncargo(Personaje, Encargado) :-
  encargo(Personaje, Encargado, _).

%Punto 3
nivelRespeto(vincent, 15).

nivelRespeto(Personaje, Nivel) :-
  personaje(Personaje, Ocupacion),
  nivelPorOcupacion(Nivel, Ocupacion).

nivelPorOcupacion(Nivel, actriz(Peliculas)) :-
  length(Peliculas, CantidadPeliculas),
  Nivel is CantidadPeliculas/10.

nivelPorOcupacion(Nivel, mafioso(Rol)) :-
  nivelMafioso(Nivel, Rol).

nivelMafioso(10, resuelveProblemas).
nivelMafioso(20, capo).

%Punto 4
esRespetable(Personaje) :-
  nivelRespeto(Personaje, Nivel),
  Nivel > 9.

respetabilidad(CantidadRespetables, CantidadNoRespetables) :-
  cantidadPersonajesRespetables(CantidadRespetables),
  cantidadPersonajes(CantidadPersonajes),
  CantidadNoRespetables is CantidadPersonajes - CantidadRespetables.

cantidadPersonajesRespetables(Cantidad) :-
  findall(Personaje, esRespetable(Personaje), Respetables),
  length(Respetables, Cantidad).

cantidadPersonajes(CantidadPersonajes) :-
  findall(_, personaje(_, _), TodosLosPersonajes),
  length(TodosLosPersonajes, CantidadPersonajes).

%Punto 5
masAtareado(Personaje) :-
  personaje(Personaje, _),
  forall(personaje(OtroPersonaje, _), tieneMasEncargos(Personaje, OtroPersonaje)).

tieneMasEncargos(Personaje, OtroPersonaje) :-
  cantidadEncargos(Personaje, Cantidad),
  cantidadEncargos(OtroPersonaje, OtraCantidad),
  Cantidad >= OtraCantidad.

cantidadEncargos(Personaje, Cantidad) :- %Personaje entra ligado
  findall(_, encargo(Personaje, _, _), Encargos),
  length(Encargos, Cantidad).

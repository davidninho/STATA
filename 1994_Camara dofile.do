***************************************Senado 1994***************************************
*Elaborado por David Niño.

*1. BORRAR TOTALES (OK)
drop if codmpio==99

*e. CODMPIO:
/*NOTA: Acá realizo el reemplazo del código de Amalfi y el ingreso de Andes. Sin embargo, 
al final del do file detallo el ingreso de otros municipios, el cual hice de otra forma*/ 

**Reemplazar el de Amalfi 
replace codmpio=5031 if codmpio==5034

**Incluir a Andes (Desde fila 1519 hasta fila 1771) (OK)
insobs 253, before(1519)
replace codmpio = 5034 in 1519/1771 

*VARIABLES: ELIMINAR Y AGREGAR
**Eliminar variables (OK)
drop faccion

*Agregar variables
generate fecha_eleccion = "Marzo 13", before(coddpto)
generate nombre_partido = ".", after(codigo_partido)

rename nombre nombres

*Circuncscripcion
generate circunscripcion = 1, after(municipio)
replace circunscripcion = 4 if codigo_lista==206


*k. APELLIDOS Y NOMBRES (OK) (mirar si se puede corregir)
gen nombre_completo = primer_apellido + " " + segundo_apellido + " " + nombre

**Collapse para candidatos según departamentos
collapse (sum) votos, by(coddpto codigo_lista primer_apellido segundo_apellido nombre nombre_completo)

collapse (sum) votos, by(codigo_lista primer_apellido segundo_apellido nombre nombre_completo)
collapse (sum) votos, by(nombre_completo codigo_lista)

/*Nota: Para el reemplazo en nombres y apellidos, al principio lo había hecho por códigos. Sin embargo, 
tuve en cuenta lo que me dijo de que podrían haber dos candidatos para un solo código y por eso puse
los collapse antes de replace, con el fin de asegurarme que ese fuera el único candidato para ese código. 

En este caso, me pareció más práctico hacer esos collpase que corregirlo y verificarlo todo nuevamente*/

**Reemplazar primer apellido, candidato 137-> "BETANCOUR" a "BETANCOURT". Es el único con este primer apellido. 
collapse (sum) votos if codigo_lista==137, by (codigo_lista primer_apellido segundo_apellido nombre)
replace primer_apellido = "BETANCOURT" if codigo_lista==137}
replace segundo_apellido = "." if codigo_lista==137	
replace nombre= "LUIS ALFONSO" if codigo_lista==137


**REEMPLAZO DE CABEZAS DE LISTA
*Carlos Espinosa Faciolince

sort codigo_lista codmpio
gen cabeza_lista =.

replace codigo_partido=1 if codigo_lista==108
replace primer_apellido="." if codigo_lista==108
replace segundo_apellido="." if codigo_lista==108
replace nombre="PARTIDO LIBERAL COLOMBIANO" if codigo_lista==108
replace curules=. if codigo_lista==108
replace cabeza_lista=. if (codigo_lista==108 & nombre="PARTIDO LIBERAL COLOMBIANO")

**Insertar a los dos candidatos. Inserto 2106 filas porqué son 1053 municipios. 
insobs 2106, after(8424)
replace codigo_lista = 108 in 8425/10530 
replace codigo_partido=1 if codigo_lista==108
replace primer_apellido="ESPINOSA" in 8425/9477
replace segundo_apellido="FACIOLINCE" in 8425/9477
replace nombre="CARLOS" in 8425/9477
replace votos=0 in 8425/9477
replace curules=1 in 8425/9477
replace cabeza_lista=1 in 8425/9477

replace primer_apellido="CABALLERO" in 9478/10530
replace segundo_apellido="ADUEN" in 9478/10530
replace nombre="ENRIQUE RAFAEL" in 9478/10530
replace votos=0 in 9478/10530
replace curules=1 in 9478/10530
replace cabeza_lista=0 in 9478/10530

replace ano=1994 if codigo_lista==108
replace tipo_eleccion=2 if codigo_lista==108

**Haciendo collapse para comprobar
collapse (sum) votos if codigo_lista==108, by(primer_apellido segundo_apellido nombre codigo_lista codigo_partido curules cabeza_lista)


*h. CODIGO_PARTIDO ( o nombre, dependiendo el caso)
replace codigo_partido = 186 if codigo_lista==326

replace nombre_partido = "ALIANZA SOCIAL INDIGENA"  if codigo_lista==150
replace nombre_partido = "NUEVA FUERZA DEMOCRATICA" if codigo_lista==244
replace nombre_partido = "MOV. SOCIAL AGRARIO" if codigo_lista==248
replace nombre_partido = "CONSERVADOR-FUERZA PROGRESISTA"  if codigo_lista==268
replace nombre_partido = "NUEV. FUERZA DEMOC. EQUIP. UNIONI" if codigo_lista==276
replace nombre_partido = "NUEVA FUERZA DEMOCRATICA-MURCO" if codigo_lista==295
replace nombre_partido = "NUEVA FUERZA DEMOCRATICA" if codigo_lista==301
replace nombre_partido = "ALIANZA SOCIAL INDIGENA" if codigo_lista==335

**Eliminar los códigos de partido que estaban en la base de los candidatos donde hay nombres de partido.
replace codigo_partido =.  if codigo_lista==150
replace codigo_partido =.  if codigo_lista==244
replace codigo_partido =.  if codigo_lista==248
replace codigo_partido =.  if codigo_lista==268
replace codigo_partido =.  if codigo_lista==276
replace codigo_partido =.  if codigo_lista==295
replace codigo_partido =.  if codigo_lista==301
replace codigo_partido =.  if codigo_lista==335


*o. VOTOS (OK)
/*En la verificación de los votos por departamento, hice un collapse con la cantidad total de votos por departamento
y lo comparé con la información plasmada en el PDF. En este sentido, analicé solo los departamentos que presentaban
inconsistencias frente a la información del PDF.*/ 
collapse (sum) votos, by (coddpto)

*CALDAS
collapse (sum) votos if coddpto==17, by(codmpio municipio)
collapse (sum) votos if coddpto==17, by(codigo_lista)

**Collapse municipios 
collapse (sum) votos if codmpio==17272, by(codigo_lista)

**Reemplazar
replace votos = 0 if (codmpio==17272 & codigo_lista==109)


**AGREGANDO LOCALIDADES QUE NO ESTÁN EN LA BASE
***Nota: Andes (Ant) fue agregada previamente


**Aldana
insobs 259, after(273244)
replace codmpio = 52022 in 273245/273503
replace ano = 1994 if codmpio==52022
replace municipio = "ALDANA" if codmpio==52022
replace coddpto = 52 if codmpio==52022
replace tipo_eleccion = 2 if codmpio==52022

/*Para los nombres y códigos de lista de candidatos, 
los copié de otro municipio y los pegue en las nuevas filas 
creadas para ingresar los datos de este municipio*/

***Añadir votos
replace votos = 0 if (codmpio==52022 & codigo_lista==268 & nombre=="PARTIDO CONSERVADOR-FUERZA PROGRESISTA")

**Ordenar por codigo de municipio para pegar nombres de candidatos
sort codmpio codigo_lista

*Vaupes
**Bocas
insobs 259, after(273503)
replace municipio = "BOCAS DE" in 273504/273762
replace ano = 1994 if municipio=="BOCAS DE" 
replace coddpto = 97 if municipio=="BOCAS DE" 
replace tipo_eleccion = 2 if municipio=="BOCAS DE" 

/*Para los nombres y códigos de lista de candidatos, 
los copié de otro municipio y los pegue en las nuevas filas 
creadas para ingresar los datos de este municipio*/

**Agregando los votos
replace votos = 1 if (municipio=="BOCAS DE" & codigo_lista==140)

*NOMBRES DE MUNICIPIO: 
drop municipio
merge m:1 codmpio using "D:\Escritorio\UniAndes 2021\Senado 1994\Bases complementarias\Municipios - 2002.dta"
order municipio, after(codmpio)
drop _merge

/*Reemplazar nombres de variables que no hicieron match.
Estos municipios, aunque se encuentran en la base de 1994, no se encuentran
en la base de 2002. 

Entre tanto, "BOCAS DE" es el municipio de Vaupes que comenté que se encuentra 
en el PDF con los votos pero no en la base insumo de stata*/
 
replace municipio = "BOCAS DE" if (coddpto==97 & codmpio==.)

*CURULES
/*NOTA: Las curules de los candidatos que son cabeza de lista y arrastran a uno más
ya las defini previamente. Estos candidatos son los de codigo_lista 108, 268 y
305.*/
replace curules = 1 if codigo_lista==180


**Reemplazando valores para candidatos que no obtuvieron ninguna curul. 
replace curules =0 if curules==.

**Reemplazando los valores de los candidatos que llevan más de una curul.
replace curules =. if (codigo_lista==108 & nombre=="PARTIDO LIBERAL COLOMBIANO")


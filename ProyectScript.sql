-- Procesos

-- Proceso para dar drops por matar enemingos
DELIMITER $$
CREATE PROCEDURE dropeo(IN personaje INT, IN enemigo INT)
BEGIN
	declare dropeo INT;
	select id_objeto into dropeo from objeto as o inner join fuente as f on f.id_fuente = fk_idfuente where fk_enemigo = enemigo;
    if dropeo is not null then
		insert into objeto_obtenido(fk_objeto,fk_personaje,fecha) values(dropeo,personaje,now());
    end if;
END$$
DELIMITER ;







-- Funciones

-- Funcion para ver localización de una mision
delimiter $$
create function encontrar_mision(id_quest INT)
returns varchar(255)
deterministic
begin
	declare loc varchar(255);
    select r.nombre into loc from region as r inner join npc on id_region=fk_region inner join mision on id_npc=fk_npc where id_mision=id_quest;
    return loc;
end$$

delimiter ;

select encontrar_mision(1);

-- Funcion para hacer una media del poder
delimiter $$
create function estimar_poder(id_pers INT)
returns float
deterministic
begin
	declare total float;
    select (ataque+defensa+velocidad+magia) into total from base_stats inner join personaje on id_base_stats=fk_base_stats where id_personaje=id_pers;
    return total;
end$$

delimiter ;

select estimar_poder(1);










-- Triggers


-- Trigger actualiza la vida del objetivo de la habilidad despues del impacto y si mata a un enemigo lo respawnea y da el dropeo
delimiter $$
DROP TRIGGER update_life$$
CREATE TRIGGER  update_life AFTER INSERT ON combate FOR each row 
BEGIN 
	declare v int;
	if new.ataque_enemigo = 0 then
		update enemigo as e set e.vida = e.vida - new.daño where new.id_enemigo= e.id_enemigo;
        select vida into v from enemigo where new.id_enemigo= id_enemigo;
        if v <= 0 then
			update enemigo as e set e.vida = e.vida_base where new.id_enemigo= e.id_enemigo;
            call dropeo (new.id_personaje,new.id_enemigo);
            update personaje set enemigos_derrotados = enemigos_derrotados+1;
		end if;
	else
		update personaje as p set p.vida = p.vida - new.daño where new.id_personaje = p.id_personaje;
        select vida into v from personaje where new.id_personaje= id_personaje;
        if v <= 0 then
			update personaje as e set e.vida = e.vida_base where new.id_personaje= e.id_personaje;
            update enemigo set jugadores_derrotados = jugadores_derrotados+1;
		end if;
	end if;
END$$
delimiter ;

-- Trigger calculo daño
delimiter $$
DROP TRIGGER calculo_daño$$
CREATE TRIGGER  calculo_daño BEFORE INSERT ON combate FOR each row 
BEGIN 
	declare stats_ataque, stats_defensa, poder_habilidad int;
    select poder into poder_habilidad from tipo_habilidad inner join habilidades on id_tipo_habilidad = fk_tipo where id_habilidades=new.fk_habilidades;
    if new.ataque_enemigo=0 then
		select ataque into stats_ataque from base_stats inner join personaje as p on id_base_stats=fk_base_stats where p.id_personaje=new.id_personaje;
		select defensa into stats_defensa from base_stats inner join enemigo as e on id_base_stats=fk_base_stats where e.id_enemigo=new.id_personaje;
    else
		select ataque into stats_ataque from base_stats inner join personaje as e on id_base_stats=fk_base_stats where e.id_enemigo=new.id_personaje;
		select defensa into stats_defensa from base_stats inner join enemigo as p on id_base_stats=fk_base_stats where p.id_personaje=new.id_personaje;
    end if;
    set new.daño=poder_habilidad+stats_ataque-stats_defensa;
END$$
delimiter ;

-- Trigger aumentar tiempo de juego tanto del personaje como del jugador
delimiter $$
DROP TRIGGER añadir_horas$$
CREATE TRIGGER  añadir_horas AFTER INSERT ON sesion FOR each row 
BEGIN 
	declare añadir_hora int;
	select timestampdiff(hour, new.fecha_inicio, new.fecha_fin) into añadir_hora;
    update personaje inner join jugador on id_jugador=fk_jugador 
    set horas = horas+añadir_hora, horas_jugadas = horas_jugadas + añadir_hora where new.fk_personaje=id_personaje;
END$$
delimiter ;
insert into sesion(fecha_inicio,fecha_fin,fk_personaje) values("2025-01-01 20:00:00","2025-01-01 23:30:21",1);











-- Vistas

-- 1. Jugadores con mayor progresión por hora jugada
CREATE OR REPLACE VIEW Vista_Progreso AS
SELECT count(mc.fk_mision), p.nombre, p.horas  FROM mision_completada as mc INNER JOIN personaje as p ON mc.fk_personaje=p.id_personaje GROUP BY p.nombre,p.horas ORDER BY p.horas;

SELECT * FROM Vista_Progreso;

-- 2. Promedio de nivel por clase
CREATE OR REPLACE VIEW Vista_Promedio_Clase AS
SELECT sum(p.nivel), c.nombre FROM clase as c INNER JOIN personaje as p ON p.fk_clase=c.id_clase GROUP BY c.nombre ORDER BY p.nivel;

SELECT * FROM Vista_Promedio_clase;

-- 3. Tasa exito misiones por tipo
CREATE OR REPLACE VIEW Vista_Exito_Mision AS
SELECT count(fk_mision)/aceptada*100 AS porcentaje_exito, tipo FROM mision INNER JOIN mision_completada ON id_mision = fk_mision GROUP BY aceptada, tipo;
SELECT * FROM Vista_Exito_Mision;

-- 4. Criaturas que generan mayor mortalidad
CREATE OR REPLACE VIEW Vista_Mortalidad AS
SELECT nombre, nivel, jugadores_derrotados FROM enemigo ORDER BY jugadores_derrotados DESC;
SELECT * FROM Vista_Mortalidad;

-- 5. Media, mediana y porcentil 90 de daño por combate
CREATE OR REPLACE VIEW Vista_Media_Daño AS
SELECT avg(daño) AS media FROM combate;

SELECT * FROM Vista_Media_daño;

CREATE OR REPLACE VIEW Vista_Mediana_Daño AS
SELECT daño AS mediana FROM combate WHERE id_combate=count(daño)/2;

SELECT * FROM Vista_Mediana_daño;

CREATE OR REPLACE VIEW Vista_Porcentil AS
-- SELECT * FROM combate ORDER BY daño desc LIMIT (SELECT ceil(count(daño)*0.1) FROM combate); ( NO funciona preguntar a profe)

SELECT * FROM Vista_Porcentil;

-- 6. Rareza mas frecuente
CREATE OR REPLACE VIEW Vista_Rareza_Frecuente AS
SELECT count(fk_objeto) AS cantidad, nombre_rareza FROM objeto_obtenido INNER JOIN objeto ON fk_objeto=id_objeto INNER JOIN rareza ON fk_rareza=id_rareza GROUP BY fk_rareza ORDER BY cantidad;

SELECT * FROM Vista_Rareza_Frecuente;

-- 7. Ingresos de mercados por ciudad
CREATE OR REPLACE VIEW Vista_Ingresos AS
SELECT sum(precio) AS Recaudado, r.nombre as Region, npc.nombre FROM transaccion 
INNER JOIN mercado ON id_mercado = fk_mercado 
INNER JOIN npc ON fk_npc=id_npc
INNER JOIN region AS r ON fk_region=id_region
 GROUP BY r.nombre, npc.nombre;
 
SELECT * FROM Vista_Ingresos;

-- 8. Ranking de gremios por reputación y miembros activos
CREATE OR REPLACE VIEW Vista_Gremios AS
SELECT count(id_miembro_gremio), trofeos, nombre FROM miembro_gremio INNER JOIN gremio ON fk_gremio=id_gremio GROUP BY nombre, trofeos ORDER BY trofeos;

SELECT * FROM Vista_Gremios;

-- 9. Jugadores que completan misiones por encima del nivel recomendado
CREATE OR REPLACE VIEW Vista_Jugadores_Menos_Nivel_Misiones AS
SELECT p.nombre, m.titulo,m.nivel_recomendad, p.nivel 
FROM personaje AS p 
INNER JOIN mision_completada AS mc ON mc.fk_personaje=p.id_personaje 
INNER JOIN mision AS m ON mc.fk_mision=m.id_mision 
WHERE p.nivel<m.nivel_recomendad;

SELECT * FROM Vista_Jugadores_Menos_Nivel_Misiones;

-- 10. Objetos más comprados
CREATE OR REPLACE VIEW Vista_Compras AS
SELECT count(fk_objeto) AS ventas, t.precio, nombre FROM transaccion as t INNER JOIN objeto ON fk_objeto=id_objeto GROUP BY precio, nombre;

SELECT * FROM Vista_Compras;

-- 11. Analisis outliers oro acumulado
CREATE OR REPLACE VIEW Vista_Oro AS

SELECT * FROM Vista_Oro;

-- 12. Correlacion entre clase y tasa de victorias en combate
CREATE OR REPLACE VIEW Vista_Clase_Victoria AS
SELECT sum(enemigos_derrotados), c.nombre FROM personaje INNER JOIN clase AS c ON id_clase=fk_clase GROUP BY c.nombre;
SELECT * FROM Vista_Clase_Victoria;


-- 13.distribución de tiempo empleado por misión --
CREATE OR REPLACE VIEW Vista_Tiempo_Mision AS
SELECT
    m.titulo AS Nombre_Mision,
    COUNT(mc.fk_mision) AS Veces_Completada,
    SEC_TO_TIME(SUM(TIME_TO_SEC(mc.tiempo_empleado))) AS Tiempo_Total_Empleando,
    SEC_TO_TIME(AVG(TIME_TO_SEC(mc.tiempo_empleado))) AS Tiempo_Promedio_Empleando
FROM
    mision_completada mc
JOIN
    mision m ON mc.fk_mision = m.id_mision
GROUP BY
    m.titulo
ORDER BY
    Tiempo_Promedio_Empleando DESC;
    
SELECT * FROM Vista_Tiempo_Mision;

-- Jugadores que no han Ganado Logros en los Últimos 30 Días
CREATE OR REPLACE VIEW Vista_Ultimo_Logro AS
SELECT
    j.nombre AS Nombre_Jugador,
    MAX(lh.fecha) AS Fecha_Ultimo_Logro
FROM
    jugador j
JOIN
    personaje p ON j.id_jugador = p.fk_jugador
LEFT JOIN
    logro_has_personaje lh ON p.id_personaje = lh.fk_personaje
GROUP BY
    j.id_jugador, j.nombre;
    SELECT * FROM Vista_Ultimo_Logro;

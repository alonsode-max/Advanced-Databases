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
		end if;
	else
		update personaje as p set p.vida = p.vida - new.daño where new.id_personaje = p.id_personaje;
	end if;
END$$
delimiter ;

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

-- 13.distribución de tiempo empleado por misión --
CREATE OR REPLACE VIEW Vista_Tiempo_Mision AS
SELECT
    m.titulo AS Nombre_Mision,
    COUNT(mc.mision_id_mision) AS Veces_Completada,
    SEC_TO_TIME(SUM(TIME_TO_SEC(mc.tiempo_empleado))) AS Tiempo_Total_Empleando,
    SEC_TO_TIME(AVG(TIME_TO_SEC(mc.tiempo_empleado))) AS Tiempo_Promedio_Empleando
FROM
    mision_completada mc
JOIN
    mision m ON mc.mision_id_mision = m.id_mision
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
    logro_has_personaje lh ON p.id_personaje = lh.personaje_id_personaje
GROUP BY
    j.id_jugador, j.nombre;
    SELECT * FROM Vista_Ultimo_Logro;

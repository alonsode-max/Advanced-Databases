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
		end if;
	else
		update personaje as p set p.vida = p.vida - new.daño where new.id_personaje = p.id_personaje;
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

-- Trigger aumentar tiempo de juego tanto del personaje como del jugador (No funciona todavia)
delimiter $$
DROP TRIGGER añadir_horas$$
CREATE TRIGGER  añadir_horas AFTER INSERT ON sesion FOR each row 
BEGIN 
	declare añadir_horas int;
	select timestampdiff(hour, fecha_inicio, fecha_fin) into añadir_horas;
    update personaje inner join jugador on id_jugador=fk_jugador 
    set horas = horas+añadir_horas, horas_jugadas = horas_jugadas + añadir_horas where new.fk_personaje=id_personaje;
END$$
delimiter ;
insert into sesion(fecha_inicio,fecha_fin,fk_personaje) values("2025-01-01 20:00:00","2025-01-01 23:30:21",1);











-- Vistas

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

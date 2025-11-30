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

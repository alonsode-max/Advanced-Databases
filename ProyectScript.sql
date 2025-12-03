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



-- PROCEDIMIENTO : REGISTRAR FIN DE SESIÓN Y ACTUALIZAR PERSONAJE
-- Objetivo: Actualiza las horas totales del personaje y calcula
-- las ganancias de oro por sesión (asume 10 de oro por hora).
DROP PROCEDURE IF EXISTS `ActualizarFinSesion`;

DELIMITER //
CREATE PROCEDURE `ActualizarFinSesion`(
    IN p_id_sesion INT
)
BEGIN
    DECLARE v_id_personaje INT;
    DECLARE v_fecha_inicio DATETIME;
    DECLARE v_duracion_horas DECIMAL(10, 2);
    DECLARE v_oro_ganado INT;

    SELECT fk_personaje, fecha_inicio, fecha_fin
    INTO v_id_personaje, v_fecha_inicio, @v_fecha_fin_actual
    FROM sesion
    WHERE id_sesion = p_id_sesion;

    IF v_id_personaje IS NULL OR @v_fecha_fin_actual IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sesión no encontrada o ya finalizada.';
    END IF;

    UPDATE sesion
    SET fecha_fin = NOW()
    WHERE id_sesion = p_id_sesion;

    SET v_duracion_horas = TIMESTAMPDIFF(MINUTE, v_fecha_inicio, NOW()) / 60.0;

    SET v_oro_ganado = FLOOR(v_duracion_horas * 10); -- tambien para redondear redondea hacia arriba

    UPDATE personaje
    SET
        horas = horas + CEIL(v_duracion_horas), -- ceil se utiliza para redondear un número decimal
        oro = oro + v_oro_ganado
    WHERE
        id_personaje = v_id_personaje;

    SELECT 'Sesión finalizada y personaje actualizado' AS Resultado,
           v_duracion_horas AS Duracion_Total_Horas,
           v_oro_ganado AS Oro_Ganado;
END //
DELIMITER ;

INSERT INTO sesion (id_sesion, fecha_inicio, fk_personaje) VALUES (999, DATE_SUB(NOW(), INTERVAL 90 MINUTE), 1);

 CALL ActualizarFinSesion(999);
 
 
-- PROCEDIMIENTO 2: REGISTRAR COMBATE Y ACTUALIZAR CONTADORES DE DEFENSA
-- Objetivo: Registra la derrota de un enemigo y actualiza los contadores
-- de ambos lados (personaje y enemigo).
DROP PROCEDURE IF EXISTS `RegistrarDerrotaEnemigo`;

DELIMITER //
CREATE PROCEDURE `RegistrarDerrotaEnemigo`(
    IN p_id_personaje INT,
    IN p_id_enemigo INT,
    IN p_fk_habilidades INT,
    IN p_dano INT,
    IN p_ataque_enemigo TINYINT,
    IN p_resultado VARCHAR(10) -- 'VICTORIA' o 'DERROTA'
)
BEGIN
    -- 1. Registrar la entrada de combate en la tabla 'combate'
    INSERT INTO combate (id_personaje, id_enemigo, fecha, fk_habilidades, daño, ataque_enemigo)
    VALUES (p_id_personaje, p_id_enemigo, NOW(), p_fk_habilidades, p_dano, p_ataque_enemigo);

    IF p_resultado = 'VICTORIA' THEN
        UPDATE personaje
        SET enemigos_derrotados = enemigos_derrotados + 1
        WHERE id_personaje = p_id_personaje;

        SELECT 'VICTORIA - Contadores de Personaje y Combate Actualizados' AS Resultado;

    ELSEIF p_resultado = 'DERROTA' THEN
        UPDATE enemigo
        SET jugadores_derrotados = jugadores_derrotados + 1
        WHERE id_enemigo = p_id_enemigo;

        SELECT 'DERROTA - Contador de Enemigo y Combate Actualizados' AS Resultado;

    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Resultado de combate no válido. Debe ser VICTORIA o DERROTA.';
    END IF;

END //
DELIMITER ;

 CALL RegistrarDerrotaEnemigo(1, 2, 1, 500, 0, 'VICTORIA');

-- Derrota del Personaje (Personaje 3 es derrotado por Enemigo 1)
CALL RegistrarDerrotaEnemigo(3, 1, 1, 10, 1, 'DERROTA');






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



-- -- TRIGGER : ASIGNACIÓN DE RANGO DE GREMIO POR DEFECTO
-- si un personaje es añadido a miembro gremio si especificar el rengao automaticamente se el añade 1

DROP TRIGGER IF EXISTS `before_miembro_gremio_insert`;

DELIMITER //
CREATE TRIGGER `before_miembro_gremio_insert`
BEFORE INSERT ON `miembro_gremio`
FOR EACH ROW
BEGIN
    -- Comprueba si el fk_rango_gremio es 0, NULL, o no fue establecido (usando NEW.rango)
    -- Asumimos que 'Miembro' tiene ID 1.
    IF NEW.fk_rango_gremio IS NULL OR NEW.fk_rango_gremio = 0 THEN
        SET NEW.fk_rango_gremio = 1;
        SET NEW.rango = 'Miembro';
    END IF;
END //
DELIMITER ;

INSERT INTO miembro_gremio (fecha_ingreso, fk_personaje, fk_gremio, rango, fk_rango_gremio)
VALUES (CURDATE(), 10, 3, 'Sin Asignar', NULL);

-- TRIGGER : LOGICA ECONOMICA DESPUÉS DE LA TRANSACCIÓN
-- Después de registrar una compra en 'transaccion',
-- resta el oro al personaje comprador y actualiza su contador de compras.

DROP TRIGGER IF EXISTS `after_transaccion_insert`;

DELIMITER //
CREATE TRIGGER `after_transaccion_insert`
AFTER INSERT ON `transaccion`
FOR EACH ROW
BEGIN
    DECLARE v_costo DECIMAL(10, 2);

    -- 1. Obtener el precio total de la transacción (que es el costo para el personaje)
    SET v_costo = NEW.precio;

    -- 2. Restar el costo del Oro del Personaje
    UPDATE personaje
    SET oro = oro - v_costo
    WHERE id_personaje = NEW.fk_personaje;
    
END //
DELIMITER ;
INSERT INTO transaccion (fk_mercado, fk_personaje, precio, fecha, fk_objeto)
VALUES (1, 8, 25.5, NOW(), 21);








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

SELECT * FROM Vista_Exito_Mision;

-- 4. Criaturas que generan mayor mortalidad
CREATE OR REPLACE VIEW Vista_Mortalidad AS

SELECT * FROM Vista_Mortalidad;

-- 5. Media, mediana y porcentil 90 de daño por combate
CREATE OR REPLACE VIEW Vista_Media_Daño AS
SELECT avg(daño) AS media FROM combate;

SELECT * FROM Vista_Media_daño;

CREATE OR REPLACE VIEW Vista_Media_Daño AS
SELECT avg(daño) AS media FROM combate;

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

SELECT * FROM Vista_Clase_Victoria;



-- 13. Distribución de tiempo empleado por misión
SELECT
    m.titulo AS Nombre_Mision,
    AVG(TIME_TO_SEC(mc.tiempo_empleado) / 60) AS Tiempo_Promedio_Minutos
FROM
    mision_completada mc
JOIN
    mision m ON mc.fk_mision = m.id_mision
GROUP BY
    m.titulo
ORDER BY
    Tiempo_Promedio_Minutos DESC;

-- 14. Jugadores que no han ganado logros en los últimos 30 días
SELECT
    p.nombre AS Nombre_Personaje,
    p.id_personaje
FROM
    personaje p
LEFT JOIN
    logro_has_personaje lhp ON p.id_personaje = lhp.fk_personaje
WHERE
    p.horas > 10 
GROUP BY
    p.id_personaje, p.nombre;


-- 15. Criaturas más rentables por minuto de combate
SELECT
    e.nombre AS Nombre_Criatura,
    e.nivel,
    SUM(p.oro) / COUNT(c.id_combate) AS Oro_Promedio_Ganado_Simulado,
    AVG(c.daño) AS Danio_Promedio_Recibido_Por_Criatura
FROM
    enemigo e
JOIN
    combate c ON e.id_enemigo = c.id_enemigo
JOIN
    personaje p ON c.id_personaje = p.id_personaje
GROUP BY
    e.id_enemigo, e.nombre, e.nivel
ORDER BY
    Oro_Promedio_Ganado_Simulado DESC
LIMIT 10;

-- 16. Evolución mensual del número de jugadores activos
SELECT
    DATE_FORMAT(fecha_inicio, '%Y-%m') AS Mes,
    COUNT(DISTINCT fk_personaje) AS Jugadores_Activos_Mensuales
FROM
    sesion
GROUP BY
    Mes
ORDER BY
    Mes;

-- 17. Ranking de eventos según participación promedio
SELECT
    e.nombre AS Nombre_Evento,
    COUNT(DISTINCT pe.fk_personaje) AS Total_Participantes
FROM
    participacion_evento pe
JOIN
    evento e ON pe.fk_evento = e.id_evento
GROUP BY
    e.nombre
ORDER BY
    Total_Participantes DESC;

-- 18. Top 10 vendedores del mercado con margen medio
SELECT
    t.fk_personaje,
    p.nombre AS Nombre_Vendedor,
    AVG(t.precio - o.precio) AS Margen_Medio
FROM
    transaccion t
JOIN
    objeto o ON t.fk_objeto = o.id_objeto
JOIN
    personaje p ON t.fk_personaje = p.id_personaje
GROUP BY
    t.fk_personaje, p.nombre
ORDER BY
    Margen_Medio DESC
LIMIT 10;

-- 19. Tasa de abandonos de gremio y tendencias
-- SIMULACIÓN: Mide la proporción de miembros de bajo nivel (menos de 10) en cada gremio,
-- lo cual es un indicador de inestabilidad y posible abandono.
SELECT
    g.nombre AS Nombre_Gremio,
    g.trofeos AS Trofeos_Totales,
    COUNT(mg.fk_personaje) AS Miembros_Actuales,
    AVG(CASE WHEN p.nivel < 10 THEN 1 ELSE 0 END) * 100 AS Porcentaje_Miembros_Bajo_Nivel
FROM
    gremio g
JOIN
    miembro_gremio mg ON g.id_gremio = mg.fk_gremio
JOIN
    personaje p ON mg.fk_personaje = p.id_personaje
GROUP BY
    g.id_gremio, g.nombre, g.trofeos
ORDER BY
    Miembros_Actuales DESC;

-- 20. Media móvil del precio de objetos legendarios
SELECT
    t1.fecha,
    o.nombre AS Nombre_Objeto,
    t1.precio,
    (
        SELECT AVG(t2.precio)
        FROM transaccion t2
        WHERE t2.fk_objeto = t1.fk_objeto AND t2.fecha <= t1.fecha
    ) AS Media_Acumulada
FROM
    transaccion t1
JOIN
    objeto o ON t1.fk_objeto = o.id_objeto
WHERE
    o.fk_rareza >= 4
ORDER BY
    o.nombre, t1.fecha;

-- 21. Tendencia temporal del volumen de comercio
SELECT
    DATE(fecha) AS Dia,
    COUNT(fk_objeto) AS Volumen_Diario_Transacciones
FROM
    transaccion
GROUP BY
    Dia
ORDER BY
    Dia;

-- 22. Tiempo total invertido por misión agrupado por región
SELECT
    r.nombre AS Nombre_Region,
    SUM(TIME_TO_SEC(mc.tiempo_empleado) / 60) AS Tiempo_Total_Minutos
FROM
    mision_completada mc
JOIN
    mision m ON mc.fk_mision = m.id_mision
JOIN
    npc n ON m.fk_npc = n.id_npc
JOIN
    region r ON n.fk_region = r.id_region
GROUP BY
    r.nombre
ORDER BY
    Tiempo_Total_Minutos DESC;

-- 23. Comparación entre Jugadores Premium y Estándar
-- SIMULACIÓN: 'Premium' se define como cualquier personaje con más de 200 horas jugadas O más de 5000 oro (indicadores de alta dedicación).
SELECT
    CASE
        WHEN p.horas > 200 OR p.oro > 5000 THEN 'Premium_Simulado'
        ELSE 'Estandar_Simulado'
    END AS Tipo_Jugador,
    AVG(p.nivel) AS Nivel_Promedio,
    AVG(p.horas) AS Horas_Promedio,
    AVG(p.oro) AS Oro_Promedio,
    COUNT(p.id_personaje) AS Total_Personajes
FROM
    personaje p
GROUP BY
    Tipo_Jugador;

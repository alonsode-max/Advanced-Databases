-- Datos para tablas sin dependencias externas (catálogo)
INSERT INTO `pais` (`nombre`) VALUES
('España'), ('México'), ('Argentina'), ('Colombia');

INSERT INTO `base_stats` (`ataque`, `defensa`, `velocidad`, `magia`) VALUES
(120, 80, 50, 20),   -- 1: Stats Físicos altos
(60, 100, 40, 50),   -- 2: Stats Defensivos
(30, 40, 60, 150),   -- 3: Stats Mágicos altos
(90, 70, 70, 70);    -- 4: Stats Balanceados

INSERT INTO `clase` (`descripcion`, `atributos`) VALUES
('Guerrero enfocado en el combate cuerpo a cuerpo.', 'Fuerza, Vitalidad'),   -- 1
('Mago especializado en hechizos ofensivos.', 'Intelecto, Maná'),         -- 2
('Pícaro ágil, experto en evasión y golpes críticos.', 'Agilidad, Suerte'),   -- 3
('Sanador de apoyo con hechizos de protección.', 'Espíritu, Resistencia');   -- 4

INSERT INTO `tipo_habilidad` (`nombre`, `poder`, `rango`) VALUES
('Cuerpo a Cuerpo', 10, 1), -- 1
('Hechizo de Fuego', 15, 5), -- 2
('Hechizo de Curación', 0, 4), -- 3
('Ataque Rápido', 8, 2); -- 4

INSERT INTO `tipo` (`id_tipo`, `tipo_nombre`) VALUES
(1, 'Arma'),
(2, 'Armadura'),
(3, 'Poción'),
(4, 'Material');

INSERT INTO `rareza` (`id_rareza`, `nombre_rareza`) VALUES
(1, 'Común'),
(2, 'Raro'),
(3, 'Épico'),
(4, 'Legendario');

INSERT INTO `fuente` (`id_fuente`, `nombre`) VALUES
(1, 'Drop de Monstruo'),
(2, 'Venta en Mercado'),
(3, 'Recompensa de Misión'),
(4, 'Evento Especial');

INSERT INTO `rango_gremio` (`nombre`) VALUES
('Miembro'), -- 1
('Oficial'), -- 2
('Líder'); -- 3

INSERT INTO `gremio` (`nombre`, `fecha_creación`, `trofeos`) VALUES
('Los Dragones Rojos', '2025-01-15', 500), -- 1
('La Hermandad de Acero', '2025-05-20', 1200); -- 2

INSERT INTO `rango_enemigos` (`nombre`, `tamaño`, `buff`) VALUES
('Normal', 1.0, 1.0), -- 1
('Elite', 1.5, 1.5), -- 2
('Jefe', 3.0, 2.5); -- 3

INSERT INTO `region` (`nombre`, `nivel_minimo`) VALUES
('Praderas de Inicio', 1), -- 1
('Bosque Oscuro', 10), -- 2
('Montañas de Fuego', 30); -- 3

INSERT INTO `evento` (`nombre`, `fecha_inicio`, `fecha_fin`, `bonificaciones`, `descripcion`) VALUES
('Festival de la Cosecha', '2025-11-20', '2025-11-30', 'Doble de Oro', 'Evento anual con misiones y recompensas especiales.'), -- 1
('Invasión de Goblins', '2025-12-05', '2025-12-15', 'Drop de materiales raros', 'Los Goblins atacan las Praderas de Inicio.'); -- 2

-- Datos que dependen de la tabla `rareza`
INSERT INTO `logro` (`fk_rareza`) VALUES
(1), -- 1: Logro Común
(2), -- 2: Logro Raro
(3); -- 3: Logro Épico

-- Datos que dependen de la tabla `pais`
INSERT INTO `jugador` (`nombre`, `fecha_registro`, `horas_jugadas`, `fk_pais`) VALUES
('Alice', '2025-10-01', 150, 1), -- 1: España
('Bob', '2025-10-05', 200, 2),   -- 2: México
('Charlie', '2025-11-10', 50, 3); -- 3: Argentina

-- Datos que dependen de `tipo_habilidad` y `clase`
INSERT INTO `habilidades` (`nombre`, `descripcion`, `rango`, `nivel`, `fk_tipo`, `clase_id_clase`) VALUES
('Corte Poderoso', 'Ataque cuerpo a cuerpo potente.', 1, 1, 1, 1), -- 1: Guerrero
('Bola de Fuego', 'Lanza un proyectil mágico de fuego.', 5, 5, 2, 2), -- 2: Mago
('Curación Menor', 'Restaura una pequeña cantidad de salud.', 4, 1, 3, 4); -- 3: Sanador

-- Datos que dependen de `region`
INSERT INTO `npc` (`nombre`, `texto`, `fk_region`) VALUES
('Mercader Tom', 'Bienvenido, ¿qué deseas comprar?', 1), -- 1
('Líder de la Guardia', 'Necesito ayuda en el Bosque Oscuro.', 2); -- 2

-- Datos que dependen de `npc`
INSERT INTO `mercado` (`fk_npc`) VALUES
(1); -- 1: Mercado manejado por Mercader Tom

-- Datos que dependen de `region`, `rango_enemigos` y `base_stats`
INSERT INTO `enemigo` (`nombre`, `nivel`, `fk_region`, `fk_rango`, `fk_base_stats`) VALUES
('Lobo Joven', 2, 1, 1, 4), -- 1
('Golem de Piedra', 15, 2, 2, 2), -- 2
('Dragón de Fuego', 50, 3, 3, 1); -- 3

-- Datos que dependen de `jugador`, `clase` y `base_stats`
INSERT INTO `personaje` (`nombre`, `nivel`, `vida`, `mana`, `fk_jugador`, `fk_clase`, `fk_base_stats`) VALUES
('Aric el Guerrero', 10, 800.0, 50.0, 1, 1, 1), -- 1: Alice, Guerrero
('Magus Bob', 12, 450.0, 250.0, 2, 2, 3),    -- 2: Bob, Mago
('Charly Ágil', 5, 600.0, 100.0, 3, 3, 4);    -- 3: Charlie, Pícaro

-- Datos que dependen de `npc`
INSERT INTO `mision` (`titulo`, `tipo`, `nivel_recomendad`, `fk_npc`) VALUES
('Recolección de Bayas', 'Recolección', 1, 1), -- 1
('Eliminar Goblins', 'Combate', 10, 2); -- 2

-- Datos que dependen de `tipo`, `rareza`, `fuente` y `mercado`
INSERT INTO `objeto` (`nombre`, `nivel_requerido`, `precio`, `efecto`, `tipo_idtipo`, `rareza_idrareza`, `fuente_idfuente`, `mercado_idmercado`) VALUES
('Espada de Hierro', 1, 10.5, 'Ataque +5', 1, 1, 2, 1), -- 1
('Poción de Vida', 1, 5.0, 'Restaura 100 Vida', 3, 1, 2, 1), -- 2
('Armadura Épica', 20, 500.0, 'Defensa +50', 2, 3, 3, NULL), -- 3: Recompensa de Misión
('Fragmento Mágico', 5, 2.0, 'Material de crafteo', 4, 2, 1, 1); -- 4

-- Datos de tablas de relaciones N:M (intersección)

INSERT INTO `miembro_gremio` (`fecha_ingreso`, `rango`, `fk_personaje`, `fk_gremio`, `fk_rango_gremio`) VALUES
('2025-10-02', 'Líder', 1, 1, 3),     -- Aric, Líder de Los Dragones Rojos
('2025-10-06', 'Miembro', 2, 1, 1),   -- Magus Bob, Miembro de Los Dragones Rojos
('2025-11-12', 'Oficial', 3, 2, 2);   -- Charly, Oficial de La Hermandad de Acero

INSERT INTO `mision_completada` (`mision_id_mision`, `personaje_id_personaje`, `fecha`, `tiempo_empleado`) VALUES
(1, 1, '2025-11-24', '00:15:00'), -- Aric completó Recolección de Bayas
(1, 2, '2025-11-25', '00:10:00'); -- Magus Bob completó Recolección de Bayas

INSERT INTO `objecto_obtenido` (`objeto_idobjeto`, `personaje_id_personaje`, `fecha`) VALUES
(3, 1, '2025-11-24 10:00:00'), -- Aric obtuvo Armadura Épica
(4, 2, '2025-11-25 15:30:00'); -- Magus Bob obtuvo Fragmento Mágico

INSERT INTO `transaccion` (`mercado_idmercado`, `personaje_id_personaje`, `precio`, `fecha`, `fk_idobjeto`) VALUES
(1, 1, 10.5, '2025-11-25 18:00:00', 1), -- Aric compró Espada de Hierro
(1, 3, 5.0, '2025-11-25 18:05:00', 2);  -- Charly compró Poción de Vida

INSERT INTO `logro_has_personaje` (`logro_id_logro`, `personaje_id_personaje`, `fecha`) VALUES
(1, 1, '2025-11-20 09:00:00'), -- Aric obtuvo Logro Común
(1, 2, '2025-11-21 11:00:00'); -- Magus Bob obtuvo Logro Común

INSERT INTO `participacion_evento` (`fk_evento`, `fk_personaje`, `puntos`) VALUES
(1, 1, 150.0), -- Aric participó en Festival de la Cosecha
(1, 2, 200.5), -- Magus Bob participó en Festival de la Cosecha
(2, 1, 50.0);  -- Aric comenzó a participar en Invasión de Goblins

INSERT INTO `personaje_has_enemigo` (`personaje_id_personaje`, `enemigo_id_enemigo`, `fecha`, `habilidades_id_habilidades`, `daño`) VALUES
(1, 1, '2025-11-25 19:00:00', 1, 150), -- Aric atacó a Lobo Joven con Corte Poderoso
(2, 1, '2025-11-25 19:05:00', 2, 200); -- Magus Bob atacó a Lobo Joven con Bola de Fuego


SELECT
    p.nombre AS Nombre_Personaje,
    c.descripcion AS Clase,
    j.nombre AS Nombre_Jugador,
    pa.nombre AS Pais_Origen,
    p.nivel
FROM
    personaje p
JOIN
    jugador j ON p.fk_jugador = j.id_jugador
JOIN
    pais pa ON j.fk_pais = pa.id_pais
JOIN
    clase c ON p.fk_clase = c.id_clase;
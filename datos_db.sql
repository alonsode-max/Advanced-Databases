USE `databases`;

-- Deshabilitar la verificación de claves foráneas temporalmente
SET FOREIGN_KEY_CHECKS = 0;

-- ** Tablas sin dependencias FK o con FK a sí mismas **

-- 1. base_stats
INSERT INTO `base_stats` VALUES (1,120,80,50,20),(2,60,100,40,50),(3,30,40,60,150),(4,90,70,70,70);

-- 2. clase
INSERT INTO `clase` VALUES (1,'Guerrero enfocado en el combate cuerpo a cuerpo.','Fuerza, Vitalidad'),(2,'Mago especializado en hechizos ofensivos.','Intelecto, Maná'),(3,'Pícaro ágil, experto en evasión y golpes críticos.','Agilidad, Suerte'),(4,'Sanador de apoyo con hechizos de protección.','Espíritu, Resistencia');

-- 3. pais
INSERT INTO `pais` VALUES (1,'España'),(2,'México'),(3,'Argentina'),(4,'Colombia');

-- 4. evento
INSERT INTO `evento` VALUES (1,'Festival de la Cosecha','2025-11-20','2025-11-30','Doble de Oro','Evento anual con misiones y recompensas especiales.'),(2,'Invasión de Goblins','2025-12-05','2025-12-15','Drop de materiales raros','Los Goblins atacan las Praderas de Inicio.');

-- 5. gremio
INSERT INTO `gremio` VALUES (1,'Los Dragones Rojos','2025-01-15',500),(2,'La Hermandad de Acero','2025-05-20',1200);

-- 6. rango_enemigos
INSERT INTO `rango_enemigos` VALUES (1,'Normal',1,1),(2,'Elite',1.5,1.5),(3,'Jefe',3,2.5);

-- 7. rango_gremio
INSERT INTO `rango_gremio` VALUES (1,'Miembro'),(2,'Oficial'),(3,'Líder');

-- 8. rareza
INSERT INTO `rareza` VALUES (1,'Común'),(2,'Raro'),(3,'Épico'),(4,'Legendario');

-- 9. region
INSERT INTO `region` VALUES (1,'Praderas de Inicio',1),(2,'Bosque Oscuro',10),(3,'Montañas de Fuego',30);

-- 10. tipo
INSERT INTO `tipo` VALUES (1,'Arma'),(2,'Armadura'),(3,'Poción'),(4,'Material');

-- 11. tipo_habilidad
INSERT INTO `tipo_habilidad` VALUES (1,'Cuerpo a Cuerpo',10,1),(2,'Hechizo de Fuego',15,5),(3,'Hechizo de Curación',0,4),(4,'Ataque Rápido',8,2);

---

-- ** Tablas que dependen de las anteriores **

-- 12. jugador (Depende de pais)
INSERT INTO `jugador` VALUES (1,'Alice','2025-10-01',150,1),(2,'Bob','2025-10-05',200,2),(3,'Charlie','2025-11-10',50,3);

-- 13. personaje (Depende de jugador, clase, base_stats)
INSERT INTO `personaje` VALUES (1,'Aric el Guerrero',10,800,50,1,1,1),(2,'Magus Bob',12,450,250,2,2,3),(3,'Charly Ágil',5,600,100,3,3,4);

-- 14. enemigo (Depende de region, rango_enemigos, base_stats)
INSERT INTO `enemigo` VALUES (1,'Lobo Joven',2,1,1,4,500,500),(2,'Golem de Piedra',15,2,2,2,500,1000),(3,'Dragón de Fuego',50,3,3,1,2500,2500);

-- 15. habilidades (Depende de tipo_habilidad, clase)
INSERT INTO `habilidades` VALUES (1,'Corte Poderoso','Ataque cuerpo a cuerpo potente.',1,1,1,1),(2,'Bola de Fuego','Lanza un proyectil mágico de fuego.',5,5,2,2),(3,'Curación Menor','Restaura una pequeña cantidad de salud.',4,1,3,4);

-- 16. npc (Depende de region)
INSERT INTO `npc` VALUES (1,'Mercader Tom','Bienvenido, ¿qué deseas comprar?',1),(2,'Líder de la Guardia','Necesito ayuda en el Bosque Oscuro.',2);

-- 17. logro (Depende de rareza)
INSERT INTO `logro` VALUES (1,1),(2,2),(3,3);

-- 18. miembro_gremio (Depende de personaje, gremio, rango_gremio)
INSERT INTO `miembro_gremio` VALUES (1,'2025-10-02','Líder',1,1,3),(2,'2025-10-06','Miembro',2,1,1),(3,'2025-11-12','Oficial',3,2,2);

-- 19. mision (Depende de npc)
INSERT INTO `mision` VALUES (1,'Recolección de Bayas','Recolección',1,1),(2,'Eliminar Goblins','Combate',10,2);

-- 20. mercado (Depende de npc)
INSERT INTO `mercado` VALUES (1,1);

-- 21. fuente (Depende de enemigo)
INSERT INTO `fuente` VALUES (1,'Dropeado por dragon',3),(2,'Venta en Mercado',NULL),(3,'Recompensa de Misión',NULL),(4,'Evento Especial',NULL);

---

-- ** Tablas de relación N:M o con muchas dependencias **

-- 22. combate (Depende de personaje, enemigo, habilidades)
INSERT INTO `combate` VALUES (1,1,'2025-11-25 19:00:00',1,150,0),(1,2,'2025-11-25 19:05:00',2,500,0),(1,3,'2025-11-25 19:05:00',1,2500,0),(2,1,'2025-11-25 19:05:00',2,200,0),(2,3,'2025-11-25 22:03:00',1,1,0);

-- 23. participacion_evento (Depende de evento, personaje)
INSERT INTO `participacion_evento` VALUES (1,1,150),(1,2,200.5),(2,1,50);

-- 24. logro_has_personaje (Depende de logro, personaje)
INSERT INTO `logro_has_personaje` VALUES (1,1,'2025-11-20 09:00:00'),(1,2,'2025-11-21 11:00:00');

-- 25. mision_completada (Depende de mision, personaje)
INSERT INTO `mision_completada` VALUES (1,1,'2025-11-24','00:15:00'),(1,2,'2025-11-25','00:10:00');

-- 26. objeto (Depende de tipo, rareza, fuente, mercado)
INSERT INTO `objeto` VALUES (1,'Espada de Hierro',1,10.5,'Ataque +5',1,1,2,1),(2,'Poción de Vida',1,5,'Restaura 100 Vida',3,1,2,1),(3,'Armadura Épica',20,500,'Defensa +50',2,3,3,NULL),(4,'Fragmento Mágico',5,2,'Material de crafteo',4,2,1,1);

-- 27. objeto_obtenido (Depende de objeto, personaje)
INSERT INTO `objeto_obtenido` VALUES (3,1,'2025-11-24 10:00:00'),(4,1,'2025-11-30 13:59:25'),(4,2,'2025-11-25 15:30:00'),(4,2,'2025-11-30 14:06:11');

-- 28. transaccion (Depende de mercado, personaje, objeto)
INSERT INTO `transaccion` VALUES (1,1,10.5,'2025-11-25 18:00:00',1),(1,3,5,'2025-11-25 18:05:00',2);

-- Volver a habilitar la verificación de claves foráneas
SET FOREIGN_KEY_CHECKS = 1;

-- 2. Vacía la tabla base_stats y reinicia su contador AUTO_INCREMENT
TRUNCATE TABLE base_stats;

-- 3. Vuelve a insertar los datos.
INSERT INTO `base_stats` VALUES (1,120,80,50,20),(2,60,100,40,50),(3,30,40,60,150),(4,90,70,70,70);

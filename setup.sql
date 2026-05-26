-- ══════════════════════════════════════════
-- MUNDIAL 2026 · LPS SEGURIDAD
-- Ejecutar en Supabase > SQL Editor
-- ══════════════════════════════════════════

-- 1. Tabla principal de partidos
CREATE TABLE IF NOT EXISTS mundial_partidos (
  id           SERIAL PRIMARY KEY,
  fase         TEXT NOT NULL DEFAULT 'grupos',
  grupo        TEXT,
  equipo1      TEXT NOT NULL,
  flag1        TEXT,
  equipo2      TEXT NOT NULL,
  flag2        TEXT,
  goles1       SMALLINT DEFAULT NULL,
  goles2       SMALLINT DEFAULT NULL,
  penales1     SMALLINT DEFAULT NULL,
  penales2     SMALLINT DEFAULT NULL,
  fecha        DATE NOT NULL,
  hora_arg     TEXT NOT NULL,
  sede         TEXT,
  es_argentina BOOLEAN DEFAULT FALSE,
  partido_num  SMALLINT,
  updated_at   TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Trigger auto-update timestamp
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = NOW(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS mundial_updated_at ON mundial_partidos;
CREATE TRIGGER mundial_updated_at
  BEFORE UPDATE ON mundial_partidos
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- 3. Row Level Security
ALTER TABLE mundial_partidos ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Lectura publica" ON mundial_partidos;
CREATE POLICY "Lectura publica" ON mundial_partidos FOR SELECT USING (true);
DROP POLICY IF EXISTS "Admin update" ON mundial_partidos;
CREATE POLICY "Admin update" ON mundial_partidos FOR UPDATE USING (auth.role() = 'authenticated');
DROP POLICY IF EXISTS "Admin insert" ON mundial_partidos;
CREATE POLICY "Admin insert" ON mundial_partidos FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- 4. Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE mundial_partidos;

-- 5. Push subscriptions
CREATE TABLE IF NOT EXISTS mundial_push_subs (
  id         SERIAL PRIMARY KEY,
  endpoint   TEXT UNIQUE NOT NULL,
  p256dh     TEXT NOT NULL,
  auth       TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE mundial_push_subs ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Insert publico" ON mundial_push_subs;
CREATE POLICY "Insert publico" ON mundial_push_subs FOR INSERT WITH CHECK (true);

-- ══════════════════════════════════════════
-- DATOS: FASE DE GRUPOS (72 partidos)
-- Columnas: fase,grupo,equipo1,flag1,equipo2,flag2,fecha,hora_arg,sede,es_argentina,partido_num
-- ══════════════════════════════════════════
INSERT INTO mundial_partidos (fase,grupo,equipo1,flag1,equipo2,flag2,fecha,hora_arg,sede,es_argentina,partido_num) VALUES
-- GRUPO A
('grupos','A','Mexico','','Sudafrica','','2026-06-11','16:00','Los Angeles',FALSE,1),
('grupos','A','Corea del Sur','','Rep. Checa','','2026-06-11','23:00','Nueva York',FALSE,2),
('grupos','A','Rep. Checa','','Sudafrica','','2026-06-18','13:00','Seattle',FALSE,13),
('grupos','A','Mexico','','Corea del Sur','','2026-06-18','22:00','Houston',FALSE,14),
('grupos','A','Rep. Checa','','Mexico','','2026-06-24','22:00','Dallas',FALSE,37),
('grupos','A','Sudafrica','','Corea del Sur','','2026-06-24','22:00','Kansas City',FALSE,38),
-- GRUPO B
('grupos','B','Canada','','Bosnia','','2026-06-12','16:00','Toronto',FALSE,3),
('grupos','B','Qatar','','Suiza','','2026-06-13','16:00','Vancouver',FALSE,4),
('grupos','B','Suiza','','Bosnia','','2026-06-18','16:00','Miami',FALSE,15),
('grupos','B','Canada','','Qatar','','2026-06-18','19:00','Filadelfia',FALSE,16),
('grupos','B','Suiza','','Canada','','2026-06-24','16:00','Boston',FALSE,39),
('grupos','B','Bosnia','','Qatar','','2026-06-24','16:00','Atlanta',FALSE,40),
-- GRUPO C
('grupos','C','Brasil','','Marruecos','','2026-06-13','19:00','Los Angeles',FALSE,5),
('grupos','C','Haiti','','Escocia','','2026-06-13','22:00','Dallas',FALSE,6),
('grupos','C','Escocia','','Marruecos','','2026-06-19','19:00','Nueva York',FALSE,17),
('grupos','C','Brasil','','Haiti','','2026-06-19','22:00','Houston',FALSE,18),
('grupos','C','Marruecos','','Haiti','','2026-06-24','19:00','Boston',FALSE,41),
('grupos','C','Brasil','','Escocia','','2026-06-24','19:00','Seattle',FALSE,42),
-- GRUPO D
('grupos','D','EE.UU.','','Paraguay','','2026-06-12','22:00','Nueva York',FALSE,7),
('grupos','D','Australia','','Turquia','','2026-06-14','01:00','Los Angeles',FALSE,8),
('grupos','D','EE.UU.','','Australia','','2026-06-19','16:00','Kansas City',FALSE,19),
('grupos','D','Turquia','','Paraguay','','2026-06-20','01:00','Miami',FALSE,20),
('grupos','D','Turquia','','EE.UU.','','2026-06-25','23:00','Atlanta',FALSE,43),
('grupos','D','Paraguay','','Australia','','2026-06-25','23:00','Filadelfia',FALSE,44),
-- GRUPO E
('grupos','E','Alemania','','Curazao','','2026-06-14','14:00','Guadalajara',FALSE,9),
('grupos','E','C. de Marfil','','Ecuador','','2026-06-14','20:00','Dallas',FALSE,10),
('grupos','E','Alemania','','C. de Marfil','','2026-06-20','17:00','Kansas City',FALSE,21),
('grupos','E','Ecuador','','Curazao','','2026-06-20','21:00','Houston',FALSE,22),
('grupos','E','Ecuador','','Alemania','','2026-06-25','17:00','Los Angeles',FALSE,45),
('grupos','E','Curazao','','C. de Marfil','','2026-06-25','17:00','Toronto',FALSE,46),
-- GRUPO F
('grupos','F','Paises Bajos','','Japon','','2026-06-14','17:00','Atlanta',FALSE,11),
('grupos','F','Suecia','','Tunez','','2026-06-14','23:00','Vancouver',FALSE,12),
('grupos','F','Paises Bajos','','Suecia','','2026-06-20','14:00','Seattle',FALSE,23),
('grupos','F','Tunez','','Japon','','2026-06-21','01:00','Dallas',FALSE,24),
('grupos','F','Tunez','','Paises Bajos','','2026-06-25','20:00','Filadelfia',FALSE,47),
('grupos','F','Japon','','Suecia','','2026-06-25','20:00','Miami',FALSE,48),
-- GRUPO G
('grupos','G','Belgica','','Egipto','','2026-06-15','16:00','Houston',FALSE,25),
('grupos','G','Iran','','Nueva Zelanda','','2026-06-15','22:00','Los Angeles',FALSE,26),
('grupos','G','Belgica','','Iran','','2026-06-21','16:00','Nueva York',FALSE,27),
('grupos','G','Nueva Zelanda','','Egipto','','2026-06-21','22:00','Boston',FALSE,28),
('grupos','G','Nueva Zelanda','','Belgica','','2026-06-27','00:00','Seattle',FALSE,49),
('grupos','G','Egipto','','Iran','','2026-06-27','00:00','Atlanta',FALSE,50),
-- GRUPO H
('grupos','H','Espana','','Cabo Verde','','2026-06-15','13:00','Kansas City',FALSE,29),
('grupos','H','Arabia Saudita','','Uruguay','','2026-06-15','19:00','Filadelfia',FALSE,30),
('grupos','H','Espana','','Arabia Saudita','','2026-06-21','13:00','Dallas',FALSE,31),
('grupos','H','Uruguay','','Cabo Verde','','2026-06-21','19:00','Miami',FALSE,32),
('grupos','H','Uruguay','','Espana','','2026-06-26','21:00','Houston',FALSE,51),
('grupos','H','Cabo Verde','','Arabia Saudita','','2026-06-26','21:00','Los Angeles',FALSE,52),
-- GRUPO I
('grupos','I','Francia','','Senegal','','2026-06-16','16:00','Nueva York',FALSE,33),
('grupos','I','Irak','','Noruega','','2026-06-16','19:00','Filadelfia',FALSE,34),
('grupos','I','Francia','','Irak','','2026-06-22','18:00','Atlanta',FALSE,35),
('grupos','I','Noruega','','Senegal','','2026-06-22','21:00','Vancouver',FALSE,36),
('grupos','I','Noruega','','Francia','','2026-06-26','16:00','Boston',FALSE,53),
('grupos','I','Senegal','','Irak','','2026-06-26','16:00','Toronto',FALSE,54),
-- GRUPO J — ARGENTINA
('grupos','J','Argentina','','Argelia','','2026-06-16','22:00','Kansas City',TRUE,55),
('grupos','J','Austria','','Jordania','','2026-06-17','01:00','Dallas',FALSE,56),
('grupos','J','Argentina','','Austria','','2026-06-22','14:00','Dallas',TRUE,57),
('grupos','J','Jordania','','Argelia','','2026-06-23','00:00','Kansas City',FALSE,58),
('grupos','J','Argentina','','Jordania','','2026-06-27','23:00','Dallas',TRUE,67),
('grupos','J','Argelia','','Austria','','2026-06-27','23:00','Kansas City',FALSE,68),
-- GRUPO K
('grupos','K','Portugal','','RD Congo','','2026-06-17','14:00','Houston',FALSE,59),
('grupos','K','Uzbekistan','','Colombia','','2026-06-17','23:00','Seattle',FALSE,60),
('grupos','K','Portugal','','Uzbekistan','','2026-06-23','14:00','Los Angeles',FALSE,61),
('grupos','K','Colombia','','RD Congo','','2026-06-23','23:00','Atlanta',FALSE,62),
('grupos','K','Colombia','','Portugal','','2026-06-27','20:30','Miami',FALSE,69),
('grupos','K','RD Congo','','Uzbekistan','','2026-06-27','20:30','Filadelfia',FALSE,70),
-- GRUPO L
('grupos','L','Inglaterra','','Croacia','','2026-06-17','17:00','Miami',FALSE,63),
('grupos','L','Ghana','','Panama','','2026-06-17','20:00','Houston',FALSE,64),
('grupos','L','Inglaterra','','Ghana','','2026-06-23','17:00','Kansas City',FALSE,65),
('grupos','L','Panama','','Croacia','','2026-06-23','20:00','Boston',FALSE,66),
('grupos','L','Panama','','Inglaterra','','2026-06-27','18:00','Vancouver',FALSE,71),
('grupos','L','Croacia','','Ghana','','2026-06-27','18:00','Toronto',FALSE,72);

-- ══════════════════════════════════════════
-- ELIMINATORIA
-- ══════════════════════════════════════════
INSERT INTO mundial_partidos (fase,equipo1,flag1,equipo2,flag2,fecha,hora_arg,sede,es_argentina,partido_num) VALUES
('16avos','2 Grupo A','','2 Grupo B','','2026-06-28','16:00','Kansas City',FALSE,73),
('16avos','1 Grupo C','','Mej.3 D/E/F','','2026-06-28','20:00','Nueva Jersey',FALSE,74),
('16avos','1 Grupo E','','2 Grupo F','','2026-06-29','14:00','Seattle',FALSE,75),
('16avos','1 Grupo F','','2 Grupo C','','2026-06-29','22:00','Houston',FALSE,76),
('16avos','2 Grupo E','','2 Grupo I','','2026-06-30','14:00','Boston',FALSE,77),
('16avos','1 Grupo I','','Mejor Tercero','','2026-06-30','18:00','Miami',FALSE,78),
('16avos','1 Grupo A','','Mejor Tercero','','2026-06-30','22:00','Los Angeles',FALSE,79),
('16avos','1 Grupo L','','Mejor Tercero','','2026-07-01','13:00','Vancouver',FALSE,80),
('16avos','1 Grupo G','','Mej.3 A/E/H/I/J','','2026-07-01','17:00','Atlanta',FALSE,81),
('16avos','1 Grupo D','','Mej.3 B/E/F/I/J','','2026-07-01','21:00','Filadelfia',FALSE,82),
('16avos','2 Grupo K','','2 Grupo L','','2026-07-02','14:00','Toronto',FALSE,83),
('16avos','1 Grupo H','','2 Grupo J','','2026-07-02','18:00','Dallas',FALSE,84),
('16avos','1 Grupo B','','Mej.3 E/F/G/I/J','','2026-07-02','22:00','Guadalajara',FALSE,85),
('16avos','2 Grupo D','','2 Grupo G','','2026-07-03','15:00','San Francisco',FALSE,86),
('16avos','1 Grupo J - Argentina','','2 Grupo H','','2026-07-03','19:00','Dallas',TRUE,87),
('16avos','1 Grupo K','','Mej.3 D/E/I/J/L','','2026-07-03','22:30','Ciudad de Mexico',FALSE,88),
('octavos','Ganador P73','','Ganador P75','','2026-07-04','14:00','A definir',FALSE,89),
('octavos','Ganador P74','','Ganador P77','','2026-07-04','18:00','A definir',FALSE,90),
('octavos','Ganador P76','','Ganador P78','','2026-07-05','17:00','A definir',FALSE,91),
('octavos','Ganador P79','','Ganador P80','','2026-07-05','21:00','A definir',FALSE,92),
('octavos','Ganador P83','','Ganador P84','','2026-07-06','16:00','A definir',FALSE,93),
('octavos','Argentina','','Ganador 16avos','','2026-07-06','21:00','A definir',TRUE,94),
('octavos','Ganador P86','','Ganador P88','','2026-07-07','13:00','A definir',FALSE,95),
('octavos','Ganador P85','','Ganador P87','','2026-07-07','17:00','A definir',FALSE,96),
('cuartos','Ganador Octavos','','Ganador Octavos','','2026-07-09','17:00','Boston',FALSE,97),
('cuartos','Ganador Octavos','','Ganador Octavos','','2026-07-10','16:00','Los Angeles',FALSE,98),
('cuartos','Argentina','','Ganador Octavos','','2026-07-11','18:00','Miami',TRUE,99),
('cuartos','Ganador Octavos','','Ganador Octavos','','2026-07-11','22:00','Kansas City',FALSE,100),
('semifinal','Argentina','','Ganador Cuartos','','2026-07-14','16:00','Dallas',TRUE,101),
('semifinal','Ganador Cuartos','','Ganador Cuartos','','2026-07-15','16:00','Atlanta',FALSE,102),
('3erpuesto','Perdedor Semi 1','','Perdedor Semi 2','','2026-07-18','18:00','Miami',FALSE,103),
('final','Ganador Semi 1','','Ganador Semi 2','','2026-07-19','16:00','MetLife Stadium Nueva York',FALSE,104);

-- ══════════════════════════════════════════
-- VERIFICACION FINAL
-- ══════════════════════════════════════════
SELECT fase, COUNT(*) as partidos FROM mundial_partidos GROUP BY fase ORDER BY MIN(id);

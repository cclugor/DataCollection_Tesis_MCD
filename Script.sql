





(SELECT nodo_transform_v AS ELEMENTO, coor_gps_lat AS LATITUD, coor_gps_lon AS LONGITUD, coor_z AS ALTITUD, 'Transformador' AS tipo , ubicacion FROM ccomun@gtech  c    JOIN cconectividad_e@gtech  USING (g3e_fid) WHERE c.estado = 'OPERACION' AND c.g3e_fno = 20400)
UNION
(SELECT r.codigo, coor_gps_lat, coor_gps_lon, coor_z, 'Reconectador' as tipo, ubicacion FROM ereconec_at@gtech  r    JOIN ccomun@gtech  c USING (g3e_fid)    JOIN cconectividad_e@gtech USING (g3e_fid) WHERE c.estado = 'OPERACION')
UNION
(SELECT r.codigo, coor_gps_lat, coor_gps_lon, coor_z, 'Interruptor' as tipo, ubicacion FROM einterru_at@gtech  r    JOIN ccomun@gtech  c USING (g3e_fid)    JOIN cconectividad_e@gtech  USING (g3e_fid)WHERE c.estado = 'OPERACION')
UNION
(SELECT cu.codigo, coor_gps_lat, coor_gps_lon, coor_z, 'Cuchilla' AS tipo, ubicacion FROM ecuchill_at@gtech cu    JOIN ccomun@gtech c USING (g3e_fid)    JOIN cconectividad_e@gtech USING (g3e_fid) WHERE c.estado = 'OPERACION')
UNION
(SELECT ai.codigo, coor_gps_lat, coor_gps_lon, coor_z, 'Aisladero' AS tipo, ubicacion FROM eaislade_at@gtech ai    JOIN ccomun@gtech c USING (g3e_fid)    JOIN cconectividad_e@gtech USING (g3e_fid)WHERE c.estado = 'OPERACION')
UNION
(SELECT codigo_operativo, coor_gps_lat, coor_gps_lon, coor_z, 'Aisladero' AS tipo, ubicacion FROM eaislade_at@gtech ai    JOIN ccomun@gtech c USING (g3e_fid)    JOIN cconectividad_e@gtech USING (g3e_fid) WHERE c.estado = 'OPERACION')
UNION
(SELECT codigo_operativo, coor_gps_lat, coor_gps_lon, coor_z, 'Cuchilla' AS tipo, ubicacion FROM ecuchill_at@gtech cu    JOIN ccomun@gtech c USING (g3e_fid)    JOIN cconectividad_e@gtech USING (g3e_fid) WHERE c.estado = 'OPERACION')
UNION
(SELECT codigo_operativo, coor_gps_lat, coor_gps_lon, coor_z, 'Interruptor' as tipo, ubicacion FROM einterru_at@gtech r    JOIN ccomun@gtech c USING (g3e_fid)    JOIN cconectividad_e@gtech USING (g3e_fid) WHERE c.estado = 'OPERACION')
;
     
SELECT * FROM einterru_at@gtech r    
JOIN ccomun@gtech c USING (g3e_fid)    
JOIN cconectividad_e@gtech USING (g3e_fid) 
WHERE c.estado = 'OPERACION'
and coor_gps_lat is null or coor_gps_lon is null;






SELECT P.ID, P.TITULO, P.GENERO,P.STOCK, D.NOMBRE AS "DIRECTOR",
LISTAGG(A.NOMBRE, ', ') WITHIN GROUP (ORDER BY P.ID) "ACTOR(ES)"
FROM PELICULA P, DIRECTOR D, ACTOR A, ACTOR_PELI AP 
WHERE P.ID_DIRECTOR = D.ID
AND AP.ID_PELICULA = P.ID
AND AP.ID_ACTOR = A.ID
GROUP BY P.ID, P.TITULO, P.GENERO,P.STOCK, D.NOMBRE;


SELECT A.EXPEDIENTE_ID, LISTAGG(CAT.VALOR, ', ') WITHIN GROUP (ORDER BY A.ENF_CRONICA_ID) ENF_CRONICAS
FROM SIPAI.SIPAI_PER_VACUNADA_ENF_CRON A
JOIN CATALOGOS.SBC_CAT_CATALOGOS CAT
  ON CAT.CATALOGO_ID = A.ENF_CRONICA_ID
--WHERE EXPEDIENTE_ID = 31
GROUP BY A.EXPEDIENTE_ID;

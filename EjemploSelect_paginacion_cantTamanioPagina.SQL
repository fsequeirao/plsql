SELECT *
       FROM (
            SELECT *
             FROM (
                SELECT ROW_NUMBER () OVER (ORDER BY PERSONA_ID ASC)
                       LINE_NUMBER,
                       PERSONA_ID, EXPEDIENTE_ID, PRIMER_NOMBRE, 
                       SEGUNDO_NOMBRE, PRIMER_APELLIDO, SEGUNDO_APELLIDO,
                       FECHA_NACIMIENTO, IDENTIFICACION
           FROM
              (SELECT A.PERSONA_ID, A.EXPEDIENTE_ID, A.PRIMER_NOMBRE, 
                      A.SEGUNDO_NOMBRE, A.PRIMER_APELLIDO, A.SEGUNDO_APELLIDO,
                      A.FECHA_NACIMIENTO, A.IDENTIFICACION
                 FROM CATALOGOS.SBC_MST_PERSONAS A
                WHERE PRIMER_NOMBRE = 'FREDDY' AND
                     -- SEGUNDO_NOMBRE = 'FRANCISCO' AND
                      PRIMER_APELLIDO = 'SEQUEIRA' AND
                     -- SEGUNDO_APELLIDO = 'ORTEGA' AND
                      NOMBRE_COMPLETO = 'SEQUEIRA FREDDY'
               -- A.FECHA_NACIMIENTO BETWEEN :pFechaInicio AND :pFechaFin
              )
                 )
    WHERE LINE_NUMBER < ((:pPgnAct * :pPgnTmn) + 1)
   ORDER BY LINE_NUMBER)
WHERE LINE_NUMBER >= ( ( ( :pPgnAct - 1) * :pPgnTmn) + 1);




       
SELECT *
       FROM (
            SELECT *
             FROM (
                SELECT ROW_NUMBER () OVER (ORDER BY CONTROL_VACUNA_ID ASC)
                       LINE_NUMBER,
                       CONTROL_VACUNA_ID
           FROM
              (SELECT A.CONTROL_VACUNA_ID
                 FROM SIPAI.SIPAI_MST_CONTROL_VACUNA A
                WHERE A.CONTROL_VACUNA_ID IN (SELECT B.CONTROL_VACUNA_ID
                 FROM SIPAI.SIPAI_DET_VACUNACION B
                WHERE B.CONTROL_VACUNA_ID = A.CONTROL_VACUNA_ID 
                      AND B.FECHA_VACUNACION BETWEEN :pFechaInicio AND :pFechaFin)
              )
                 )
    WHERE LINE_NUMBER < ((:pPgnAct * :pPgnTmn) + 1)
   ORDER BY LINE_NUMBER)
WHERE LINE_NUMBER >= ( ( ( :pPgnAct - 1) * :pPgnTmn) + 1); 
                               
DECLARE
 -- cursor principal para obtener registros con mas de una dosis aplicada
 CURSOR CDATOS IS
        SELECT CONTROL_VACUNA_ID
          FROM SIPAI.SIPAI_MST_CONTROL_VACUNA
         WHERE CANTIDAD_VACUNA_APLICADA = CANTIDAD_VACUNA_PROGRAMADA
         ORDER BY 1;
vDetVacId SIPAI.SIPAI_DET_VACUNACION.DET_VACUNACION_ID%TYPE;
vRegisros SIMPLE_INTEGER := 0;
--- Obtiene el registro con la máxima fecha de vacunación, la cual es la que se quiere eliminar
 FUNCTION FN_OBT_MAX_FEC_VACUNA (pCtrlVacunaId IN SIPAI.SIPAI_MST_CONTROL_VACUNA.CONTROL_VACUNA_ID%TYPE) RETURN DATE AS
 vFecha SIPAI.SIPAI_DET_VACUNACION.FECHA_VACUNACION%TYPE;
 BEGIN
      SELECT MAX(FECHA_VACUNACION)
        INTO vFecha
        FROM SIPAI.SIPAI_DET_VACUNACION
       WHERE CONTROL_VACUNA_ID = pCtrlVacunaId;
 RETURN vFecha;
 EXCEPTION
 WHEN OTHERS THEN
      RETURN vFecha;
 END FN_OBT_MAX_FEC_VACUNA;
 -- A partir del control vacuna id y la fecha de vacunación, se obtiene el DetalleId que se eliminará. 
 FUNCTION FN_OBT_DETVAC_ID (pCtrlVacunaId IN SIPAI.SIPAI_MST_CONTROL_VACUNA.CONTROL_VACUNA_ID%TYPE , 
                            pFecha        IN SIPAI.SIPAI_DET_VACUNACION.FECHA_VACUNACION%TYPE) RETURN NUMBER AS
 BEGIN
    SELECT DET_VACUNACION_ID
      INTO vDetVacId
      FROM SIPAI.SIPAI_DET_VACUNACION
     WHERE CONTROL_VACUNA_ID = pCtrlVacunaId AND
           TRUNC(FECHA_VACUNACION) = TRUNC(pFecha);
 RETURN vDetVacId;
 EXCEPTION
 WHEN OTHERS THEN
      RETURN vDetVacId;
 END FN_OBT_DETVAC_ID;  

 -- A partir del control vacuna id, se obtiene cual es el id detalle a eliminar.
 FUNCTION FN_OBT_DET_VACUNA (pCtrlVacunaId IN SIPAI.SIPAI_MST_CONTROL_VACUNA.CONTROL_VACUNA_ID%TYPE) RETURN NUMBER AS
 vContador SIMPLE_INTEGER := 0;
 vFecha    SIPAI.SIPAI_DET_VACUNACION.FECHA_VACUNACION%TYPE;
 BEGIN
   SELECT COUNT (1)
     INTO vContador
     FROM SIPAI.SIPAI_DET_VACUNACION
    WHERE CONTROL_VACUNA_ID = pCtrlVacunaId;
    
    CASE
         -- si el control vacuna id, poseé mas de 1 registros en detalle, se procede a obtener la mayor fecha de vacunación para luego obtner el detalleId que se debe eliminar
    WHEN vContador > 1 THEN
         -- Se obtiene la maxima fecha de vacunación relacinada al control vacuna id
         vFecha := FN_OBT_MAX_FEC_VACUNA (pCtrlVacunaId);
         dbms_output.put_line ('Maxima fecha: '||vFecha||', del control vacunaId: '||pCtrlVacunaId);
         CASE
         WHEN vFecha IS NOT NULL THEN
              -- si la fecha vacunación no es nula, se procede a obtner el IdDetalle que se va a eliminar.
              vDetVacId := FN_OBT_DETVAC_ID (pCtrlVacunaId, vFecha);
         ELSE NULL;
         END CASE; 
    ELSE NULL;
    END CASE;
 RETURN vDetVacId;
 EXCEPTION
 WHEN OTHERS THEN
      RETURN vDetVacId;    
 END FN_OBT_DET_VACUNA;
 -- Elimina el registro de detalle vacunación
 PROCEDURE PR_DEL_DETALLE_VACUNA(pDetVacId IN SIPAI.SIPAI_DET_VACUNACION.DET_VACUNACION_ID%TYPE) IS
 BEGIN
    DELETE SIPAI.SIPAI_DET_VACUNACION
     WHERE DET_VACUNACION_ID = pDetVacId;
          dbms_output.put_line ('Elimina detalle vacuna: '||pDetVacId);
 EXCEPTION
 WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR (-20000, 'Problema al intentar borrar registro de tabla detalle vacunación. Id: '||pDetVacId||' - '||SQLERRM); 
 END PR_DEL_DETALLE_VACUNA;
 -- actualiza los campos fecha fin vacunación, cantidad vacuna aplicada y usuario modificación
 PROCEDURE PR_U_CTRL_VACUNA (pCtrlVacunaId IN SIPAI.SIPAI_MST_CONTROL_VACUNA.CONTROL_VACUNA_ID%TYPE) IS
 BEGIN
     UPDATE SIPAI.SIPAI_MST_CONTROL_VACUNA
        SET FECHA_FIN_VACUNA = NULL,
            CANTIDAD_VACUNA_APLICADA = CANTIDAD_VACUNA_APLICADA - 1,
            USUARIO_MODIFICACION = 'aemes'  -- hay que poner un usuario valido que exista en la tabla usuarios.
     WHERE CONTROL_VACUNA_ID = pCtrlVacunaId;
     dbms_output.put_line ('Actualiza Control vacuna: '||pCtrlVacunaId);
 EXCEPTION
 WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR (-20000, 'Problema al intentar actualizar registro de tabla control vacunación. Id: '||pCtrlVacunaId||' - '||SQLERRM);              
 END PR_U_CTRL_VACUNA;

 BEGIN
   -- Se ejecuta cursor para obtener registros a modificar y eliminar
   FOR I IN cDATOS LOOP
       vDetVacId := FN_OBT_DET_VACUNA(I.CONTROL_VACUNA_ID);
       dbms_output.put_line ('ControlVacuna Cursor: '||I.CONTROL_VACUNA_ID);
       dbms_output.put_line ('vDetVacId: '||vDetVacId);
       CASE
       WHEN NVL(vDetVacId,0) > 0 THEN
            PR_DEL_DETALLE_VACUNA(vDetVacId);
            PR_U_CTRL_VACUNA (I.CONTROL_VACUNA_ID);
       ELSE NULL;
       END CASE;
       vRegisros := vRegisros + 1;
   END LOOP;
   DBMS_OUTPUT.PUT_LINE ('Registros procesados: '||vRegisros);
 END;

-- Al ejecutar el script anterior, esta consulta no deberia de traer registros
-- Este script es solo para componer los registros a los que les registraron otra dosis, 
-- antes que inicie oficialmente la aplicación de la 2da dosis
--SELECT *
--FROM SIPAI.SIPAI_MST_CONTROL_VACUNA
--WHERE CANTIDAD_VACUNA_APLICADA = CANTIDAD_VACUNA_PROGRAMADA
--ORDER BY 1;



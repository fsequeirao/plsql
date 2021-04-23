

DECLARE
 CURSOR cPersona IS
 SELECT A.EXPEDIENTE_ID, A.PERSONA_ID, B.COMUNIDAD_ID, 
        B.MUNICIPIO_ID, REPLACE(B.DISTRITO_ID,0,NULL) DISTRITO_ID, B.DIRECCION_DOMICILIO DIRECCION,
        'fsequeira' USR, 7140 TIPO_RESIDENCIA_ID, 1 ES_PRINCIPAL  
   FROM DEPURACION.SBC_MST_PERSONAS A
   JOIN CATALOGOS.SBC_MST_PERSONAS B
     ON B.PERSONA_ID = A.PERSONA_ID AND
        B.DIRECCION_DOMICILIO IS NOT NULL
   WHERE A.EXPEDIENTE_ID IS NOT NULL ;  
   
    
  TYPE T_Columnas IS RECORD
  (
  vEXPEDIENTE_ID      DEPURACION.SBC_MST_PERSONAS.EXPEDIENTE_ID%TYPE,
  vPERSONA_ID         DEPURACION.SBC_MST_PERSONAS.PERSONA_ID%TYPE, 
  vCOMUNIDAD_ID       DEPURACION.SBC_DET_PRS_RESIDENCIA.COMUNIDAD_ID%TYPE, 
  vMUNICIPIO_ID       DEPURACION.SBC_DET_PRS_RESIDENCIA.MUNICIPIO_ID%TYPE, 
  vDISTRITO_ID        DEPURACION.SBC_DET_PRS_RESIDENCIA.DISTRITO_ID%TYPE, 
  vDIRECCION          DEPURACION.SBC_DET_PRS_RESIDENCIA.DIRECCION%TYPE,
  vUSR                DEPURACION.SBC_MST_PERSONAS.USUARIO_REGISTRO%TYPE,
  vTIPO_RESIDENCIA_ID DEPURACION.SBC_DET_PRS_RESIDENCIA.TIPO_RESIDENCIA_ID%TYPE, 
  vES_PRINCIPAL       DEPURACION.SBC_DET_PRS_RESIDENCIA.ES_PRINCIPAL%TYPE  
  );
  
     
  TYPE T_INSERT IS TABLE OF T_Columnas;
  l_item_recs T_INSERT;  
BEGIN
    OPEN cPersona;
    LOOP
    FETCH cPersona BULK COLLECT INTO l_item_recs LIMIT 1000;
    -- Procesamos los registros
    FORALL j IN 1..l_item_recs.count   
    INSERT INTO SBC_DET_PRS_RESIDENCIA (EXPEDIENTE_ID, COMUNIDAD_ID, DISTRITO_ID, 
                                        MUNICIPIO_ID, DIRECCION, ESTADO_REGISTRO_ID, USUARIO_REGISTRO,
                                        TIPO_RESIDENCIA_ID, ES_PRINCIPAL)
     VALUES (l_item_recs(j).vEXPEDIENTE_ID, l_item_recs(j).vCOMUNIDAD_ID, l_item_recs(j).vDISTRITO_ID, 
             l_item_recs(j).vMUNICIPIO_ID, l_item_recs(j).vDIRECCION, 6869, l_item_recs(j).vUSR, l_item_recs(j).vTIPO_RESIDENCIA_ID,
             l_item_recs(j).vES_PRINCIPAL);
    EXIT WHEN cPersona%NOTFOUND ;
     
    END LOOP ;
    CLOSE cPersona ;
END;




---- ejemplo
DECLARE
     
 CURSOR c_data IS
    SELECT ID,VALOR FROM T_PRUEBAS WHERE ID<1000000;    
  TYPE T_PRUEBASColumns IS RECORD
  (
    id          T_PRUEBAS.id%TYPE,
    valor       T_PRUEBAS.valor%TYPE    
  );     

   
  TYPE T_PRUEBASTab IS TABLE OF T_PRUEBASColumns;
  l_item_recs T_PRUEBASTab;         
BEGIN
    OPEN c_data;
    LOOP
    FETCH c_data BULK COLLECT INTO l_item_recs LIMIT 1000;
    -- Procesamos los registros
    FOR i IN 1..l_item_recs.count
    LOOP
    
        IF l_item_recs(i).valor <100 THEN
            l_item_recs(i).valor:=l_item_recs(i).valor*1.1;         
        ELSE
            l_item_recs(i).valor:=l_item_recs(i).valor*0.9;
        END IF;                         
    END LOOP;   
    FORALL j IN 1..l_item_recs.count   
        UPDATE T_PRUEBAS SET VALOR=l_item_recs(j).valor WHERE ID=l_item_recs(j).id;
     
    EXIT WHEN c_data%NOTFOUND ;
     
    END LOOP ;
     
    CLOSE c_data ;
END;
/




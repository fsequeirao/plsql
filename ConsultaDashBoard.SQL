DECLARE
vFechaInicio   DATE := TO_DATE ('01/03/2020');
vFechaFin      DATE := TO_DATE ('24/09/2020'); 
vUnidadSaludId NUMBER;
vEntAdminId    NUMBER;
vAgrupado      VARCHAR2(20):= 'S';
vRegistro      VIGILANCIA.PKG_SVSC_VIGILANCIA.VAR_REFCURSOR;
vResultado     VARCHAR2(1000);     
vMsgError      VARCHAR2(1000);
vSexo          VARCHAR2(1);
vPOSITIVOS     NUMBER;
vACTIVOS       NUMBER;
vRECUPERADOS   NUMBER;
vFALLECIDOS    NUMBER;
vSRC           NUMBER;
vSRC_CLINICO   NUMBER;

BEGIN
    VIGILANCIA.PKG_SVSC_VIGILANCIA.SVSC_C_DASHBOARD (pFechaInicio   => vFechaInicio,  
                                                     pFechaFin      => vFechaFin,     
                                                     pUnidadSaludId => vUnidadSaludId,
                                                     pEntAdminId    => vEntAdminId,   
                                                     pAgrupado      => vAgrupado,     
                                                     pRegistro      => vRegistro,                       
                                                     pResultado     => vResultado,                 
                                                     pMsgError      => vMsgError);
 CASE
 WHEN vMsgError IS NOT NULL THEN
      DBMS_OUTPUT.PUT_LINE ('Error: '||vMsgError);
      DBMS_OUTPUT.PUT_LINE ('Resultado: '||vResultado);       
 ELSE    
         DBMS_OUTPUT.PUT_LINE ('Resultado exitoso: '||vResultado);                                                 
  LOOP
  FETCH vRegistro
        INTO vSexo,
             vPOSITIVOS,    
             vACTIVOS,     
             vRECUPERADOS, 
             vFALLECIDOS,  
             vSRC,         
             vSRC_CLINICO; 
             
  EXIT WHEN vRegistro%NOTFOUND;           
       DBMS_OUTPUT.PUT_LINE('SEXO: '|| vSexo);       
       DBMS_OUTPUT.PUT_LINE('Positivo: '||vPOSITIVOS);
       DBMS_OUTPUT.PUT_LINE('Activo: '||vACTIVOS);
       DBMS_OUTPUT.PUT_LINE('Recuperado: '||vRECUPERADOS);
       DBMS_OUTPUT.PUT_LINE('Fallecido: '||vFALLECIDOS);
       DBMS_OUTPUT.PUT_LINE('Seguimiento laboratorio: '||vSRC);
       DBMS_OUTPUT.PUT_LINE('Seguimiento clinico: '||vSRC_CLINICO);
   END LOOP;
   CLOSE vRegistro;                                                
 END CASE; 
END;
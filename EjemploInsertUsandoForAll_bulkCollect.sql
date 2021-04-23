DECLARE
   c_limit   PLS_INTEGER := 100;
   vContador SIMPLE_INTEGER := 0;
   vProcesar SIMPLE_INTEGER := 1000;
   CURSOR DATOS
   IS
      SELECT EXPEDIENTE_ID,
             PERSONA_ID,
             TIPO_PERSONA_ID,
             TIPO_PERSONA_CODIGO,
             TIPO_PERSONA_VALOR,
             PACIENTE_ID,
             TIPO_EXPEDIENTE_ID,
             TIPO_EXPEDIENTE_CODIGO,
             TIPO_EXPEDIENTE_NOMBRE,
             CODIGO_EXPEDIENTE_ELECTRONICO,
             IDENTIFICACION_ID,
             IDENTIFICACION_CODIGO,
             IDENTIFICACION_NOMBRE,
             IDENTIFICACION_NUMERO,
             PRIMER_NOMBRE,
             SEGUNDO_NOMBRE,
             PRIMER_APELLIDO,
             SEGUNDO_APELLIDO,
             NOMBRE_COMPLETO,
             SEXO_ID,
             SEXO_CODIGO,
             SEXO_VALOR,
             FECHA_NACIMIENTO,
             PAIS_ORIGEN_ID,
             PAIS_ORIGEN_NOMBRE,
             REGION_NACIMIENTO_ID,
             REGION_NACIMIENTO_NOMBRE,
             DEPARTAMENTO_NACIMIENTO_ID,
             DEPARTAMENTO_NACIMIENTO_NOMBRE,
             MUNICIPIO_NACIMIENTO_ID,
             MUNICIPIO_NACIMIENTO_NOMBRE,
             MUNICIPIO_RESIDENCIA_ID,
             COMUNIDAD_ID,
             DISTRITO_ID,
             DIRECCION_RESIDENCIA,
             UNIDAD_SALUD_OCR_ID,
             ESTADO_REGISTRO_ID,
             DIFUNTO,
             EMAIL,
             ETNIA_ID,
             ETNIA_CODIGO,
             ETNIA_VALOR,
             TIPO_SANGRE_ID,
             TIPO_SANGRE_CODIGO,
             TIPO_SANGRE_VALOR,
             ESTADO_CIVIL_ID,
             ESTADO_CIVIL_CODIGO,
             ESTADO_CIVIL_VALOR,           
             RELIGION_ID,
             RELIGION_CODIGO,
             RELIGION_VALOR,
             OCUPACION_ID,
             OCUPACION_CODIGO,
             OCUPACION_VALOR,
             SISTEMA_ORIGEN_ID,
             SISTEMA_ORIGEN_NOMBRE,
             USUARIO_REGISTRA_ID,
             USUARIO_REGISTRA_NOMBRE, 
             FECHA_REGISTRO,
             USUARIO_MODIFICA_NOMBRE,
             FECHA_MODIFICACION,
             USUARIO_PASIVA,
             FECHA_PASIVO,
--             USUARIO_ELIMINA,
--             FECHA_ELIMINADO,
             PERSONA_FRK_ID,  -- AGREGAR NUEVAS
             IDENTIFICADA,
             USUARIO_MODIFICA_ID,
             TELEFONO_ID,
             TELEFONO
        FROM DEPURACION.VM_UNION_ALL_PERSONAS;

   TYPE ARRAY_OBJECTS IS TABLE OF DATOS%ROWTYPE;

   collection           ARRAY_OBJECTS;
BEGIN
   OPEN DATOS;
   LOOP
      FETCH DATOS BULK COLLECT INTO collection LIMIT c_limit;
         FORALL i IN 1 .. collection.COUNT
            INSERT INTO DEPURACION.SBC_MST_PERSONAS_NOMINAL 
                   (EXPEDIENTE_ID,                 
                    PERSONA_ID,                    
                    TIPO_PERSONA_ID,               
                    TIPO_PERSONA_CODIGO,           
                    TIPO_PERSONA_VALOR,            
                    PACIENTE_ID,                   
                    TIPO_EXPEDIENTE_ID,            
                    TIPO_EXPEDIENTE_CODIGO,        
                    TIPO_EXPEDIENTE_NOMBRE,        
                    CODIGO_EXPEDIENTE_ELECTRONICO, 
                    TIPO_IDENTIFICACION_ID,        
                    IDENTIFICACION_CODIGO,         
                    IDENTIFICACION_NOMBRE,         
                    IDENTIFICACION_NUMERO,         
                    PRIMER_NOMBRE,                 
                    SEGUNDO_NOMBRE,                
                    PRIMER_APELLIDO,               
                    SEGUNDO_APELLIDO,              
                    NOMBRE_COMPLETO,               
                    SEXO_ID,                       
                    SEXO_CODIGO,                   
                    SEXO_VALOR,                    
                    FECHA_NACIMIENTO,              
                    PAIS_NACIMIENTO_ID,            
                    PAIS_ORIGEN_NOMBRE,            
                    REGION_NACIMIENTO_ID,          
                    REGION_NACIMIENTO_NOMBRE,      
                    DEPARTAMENTO_NACIMIENTO_ID,    
                    DEPARTAMENTO_NACIMIENTO_NOMBRE,
                    MUNICIPIO_NACIMIENTO_ID,       
                    MUNICIPIO_NACIMIENTO_NOMBRE,
                    MUNICIPIO_RESIDENCIA_ID,
                    COMUNIDAD_RESIDENCIA_ID,
                    DISTRITO_RESIDENCIA_ID,
                    DIRECCION_RESIDENCIA,
                    UNIDAD_SALUD_OCR_ID,
                    ESTADO_REGISTRO_ID,     
                    FALLECIDO,              
                    EMAIL,                  
                    ETNIA_ID,               
                    ETNIA_CODIGO,           
                    ETNIA_VALOR,            
                    TIPO_SANGRE_ID,         
                    TIPO_SANGRE_CODIGO,     
                    TIPO_SANGRE_VALOR,      
                    ESTADO_CIVIL_ID,        
                    ESTADO_CIVIL_CODIGO,    
                    ESTADO_CIVIL_VALOR,     
                    RELIGION_ID,            
                    RELIGION_CODIGO,        
                    RELIGION_VALOR,         
                    OCUPACION_ID,           
                    OCUPACION_CODIGO,       
                    OCUPACION_VALOR,        
                    SISTEMA_ORIGEN_ID,      
                    SISTEMA_ORIGEN_NOMBRE,  
                    USUARIO_REGISTRA_ID,    
                    USUARIO_REGISTRA_NOMBRE,
                    FECHA_REGISTRO,         
                    USUARIO_MODIFICA_NOMBRE,
                    FECHA_MODIFICACION,     
                    USUARIO_PASIVA,         
                    FECHA_PASIVO,           
                    PERSONA_FK_ID,      
                    PER_IDENTIFICADA,   
                    USUARIO_MODIFICA_ID,
                    TELEFONO_ID,        
                    TELEFONO           
                    )
                 VALUES 
                   (
                    collection(i).EXPEDIENTE_ID,
                    collection(i).PERSONA_ID,
                    collection(i).TIPO_PERSONA_ID,
                    collection(i).TIPO_PERSONA_CODIGO,
                    collection(i).TIPO_PERSONA_VALOR,
                    collection(i).PACIENTE_ID,
                    collection(i).TIPO_EXPEDIENTE_ID,
                    collection(i).TIPO_EXPEDIENTE_CODIGO,
                    collection(i).TIPO_EXPEDIENTE_NOMBRE,
                    collection(i).CODIGO_EXPEDIENTE_ELECTRONICO,
                    collection(i).IDENTIFICACION_ID,
                    collection(i).IDENTIFICACION_CODIGO,
                    collection(i).IDENTIFICACION_NOMBRE,
                    collection(i).IDENTIFICACION_NUMERO,
                    collection(i).PRIMER_NOMBRE,
                    collection(i).SEGUNDO_NOMBRE,
                    collection(i).PRIMER_APELLIDO,
                    collection(i).SEGUNDO_APELLIDO,
                    collection(i).NOMBRE_COMPLETO,
                    collection(i).SEXO_ID,
                    collection(i).SEXO_CODIGO,
                    collection(i).SEXO_VALOR,
                    collection(i).FECHA_NACIMIENTO,
                    collection(i).PAIS_ORIGEN_ID,
                    collection(i).PAIS_ORIGEN_NOMBRE,
                    collection(i).REGION_NACIMIENTO_ID,
                    collection(i).REGION_NACIMIENTO_NOMBRE,
                    collection(i).DEPARTAMENTO_NACIMIENTO_ID,
                    collection(i).DEPARTAMENTO_NACIMIENTO_NOMBRE,
                    collection(i).MUNICIPIO_NACIMIENTO_ID,
                    collection(i).MUNICIPIO_NACIMIENTO_NOMBRE,
                    collection(i).MUNICIPIO_RESIDENCIA_ID,
                    collection(i).COMUNIDAD_ID,
                    collection(i).DISTRITO_ID,
                    collection(i).DIRECCION_RESIDENCIA,
                    collection(i).UNIDAD_SALUD_OCR_ID,
                    collection(i).ESTADO_REGISTRO_ID,
                    collection(i).DIFUNTO,
                    collection(i).EMAIL,
                    collection(i).ETNIA_ID,
                    collection(i).ETNIA_CODIGO,
                    collection(i).ETNIA_VALOR,
                    collection(i).TIPO_SANGRE_ID,
                    collection(i).TIPO_SANGRE_CODIGO,
                    collection(i).TIPO_SANGRE_VALOR,
                    collection(i).ESTADO_CIVIL_ID,
                    collection(i).ESTADO_CIVIL_CODIGO,
                    collection(i).ESTADO_CIVIL_VALOR,           
                    collection(i).RELIGION_ID,
                    collection(i).RELIGION_CODIGO,
                    collection(i).RELIGION_VALOR,
                    collection(i).OCUPACION_ID,
                    collection(i).OCUPACION_CODIGO,
                    collection(i).OCUPACION_VALOR,
                    collection(i).SISTEMA_ORIGEN_ID,
                    collection(i).SISTEMA_ORIGEN_NOMBRE,
                    collection(i).USUARIO_REGISTRA_ID,
                    collection(i).USUARIO_REGISTRA_NOMBRE, 
                    collection(i).FECHA_REGISTRO,
                    collection(i).USUARIO_MODIFICA_NOMBRE,
                    collection(i).FECHA_MODIFICACION,
                    collection(i).USUARIO_PASIVA,
                    collection(i).FECHA_PASIVO,
                    collection(i).PERSONA_FRK_ID,  -- AGREGAR NUEVAS
                    collection(i).IDENTIFICADA,
                    collection(i).USUARIO_MODIFICA_ID,
                    collection(i).TELEFONO_ID,
                    collection(i).TELEFONO);
      vContador := vContador + 1;
      
      CASE
      WHEN MOD (vContador, vProcesar) = 0 THEN
           COMMIT;
           vContador := 0;
      ELSE NULL;
      END CASE;              
      EXIT WHEN DATOS%NOTFOUND;
   END LOOP;
   CLOSE DATOS;
   COMMIT;
   DBMS_OUTPUT.PUT_LINE ('proceso exitoso');
END;
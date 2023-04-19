-- Crear el tipo de datos OBJECT que se utilizar� para representar las filas de la tabla que se retornar� desde la funci�n. 
CREATE OR REPLACE TYPE CATALOGOS_OT IS OBJECT 
(
 CATALOGO_SUP  NUMBER,
 CODIGO_SUP    VARCHAR2(20),
 VALOR_SUP     VARCHAR2(100),
 CATALOGO_ID   NUMBER,
 CODIGO        VARCHAR2(100),
 VALOR         VARCHAR2(100)
);


-- Crear el tipo de datos TABLE que se utilizar� para representar la tabla que se retornar� desde la funci�n. Este tipo de datos utilizar� el tipo de datos OBJECT que se cre� en el paso anterior. 
CREATE OR REPLACE TYPE CATALOGOS_TAB AS TABLE OF CATALOGOS_OT;


/*
Crear la funci�n que utilizar� el tipo de datos TABLE como tipo de retorno. 
La funci�n debe tomar como par�metro de entrada cualquier valor necesario 
para realizar los c�lculos necesarios para generar los datos de la tabla. 
La funci�n debe utilizar el tipo de datos TABLE como tipo de retorno y 
retornar los datos en forma de una tabla utilizando la cl�usula RETURN. 
*/
CREATE OR REPLACE FUNCTION GET_CATALOGOS_DATA (pCatalogoId NUMBER, pCodigo IN VARCHAR2) RETURN CATALOGOS_TAB PIPELINED    -- La cl�usula PIPELINED se utiliza para indicar que la funci�n devolver� los resultados de forma "paso a paso", a medida que se van generando, en lugar de generar todos los datos de la tabla antes de devolverlos. Esto puede ser �til para mejorar el rendimiento y reducir la cantidad de memoria necesaria para generar la tabla.
IS
  catalogo_data CATALOGOS_OT;
BEGIN
  FOR I IN (select a.catalogo_sup, b.codigo codigo_sup, b.valor valor_sup, 
                     a.catalogo_id, a.codigo, a.valor
                from catalogos.sbc_cat_catalogos A
                JOIN catalogos.sbc_cat_catalogos b
                  on b.catalogo_id = a.catalogo_sup
                 and b.codigo = pCodigo 
               --WHERE A.CATALOGO_ID = pCatalogoId
               )
  LOOP
    catalogo_data := CATALOGOS_OT(I.catalogo_sup, I.codigo_sup, I.valor_sup,
                                  I.catalogo_id, I.codigo, I.valor);
    PIPE ROW(catalogo_data);    -- La sentencia PIPE ROW en el bloque LOOP de la funci�n es la que se utiliza para agregar cada fila de la tabla a la tabla de salida.
  END LOOP;
  RETURN;
END;



SELECT *
FROM TABLE (GET_CATALOGOS_DATA(6869, 'STREG'))
where codigo = 'ACTREG'


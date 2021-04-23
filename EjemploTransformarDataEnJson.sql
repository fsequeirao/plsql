
/* Formatted on 4/3/2021 12:00:38 (QP5 v5.267.14150.38573) */
SELECT JSON_SERIALIZE (
                       JSON_OBJECT (
                                     KEY 'personas' VALUE (
                                        SELECT JSON_ARRAYAGG (
                                                                JSON_OBJECT (
                                                                            KEY 'Id' VALUE A.PERSONA_ID,
                                                                            KEY 'primerNombre' VALUE A.PRIMER_NOMBRE,
                                                                            KEY 'primerApellido' VALUE A.PRIMER_APELLIDO,
                                                                            KEY 'expediente' VALUE (
                                                                                                      SELECT JSON_ARRAYAGG (
                                                                                                                             JSON_OBJECT (
                                                                                                                               KEY 'Id' VALUE B.EXPEDIENTE_ID,
                                                                                                                               KEY 'codExpedienteElectronico' VALUE B.CODIGO_EXPEDIENTE_ELECTRONICO
                                                                                                                             )
                                                                                                                           )
                                                                                                        FROM HOSPITALARIO.SNH_MST_CODIGO_EXPEDIENTE B
                                                                                                       WHERE B.EXPEDIENTE_ID = A.EXPEDIENTE_ID
                                                                                                     ),
                                                                            KEY 'identificacion' VALUE A.IDENTIFICACION,
                                                                            KEY 'tipoIdentificacion' VALUE (
                                                                                   SELECT JSON_ARRAYAGG(
                                                                                             JSON_OBJECT(
                                                                                                          KEY 'id' VALUE C.CATALOGO_ID,
                                                                                                          KEY 'codigo' VALUE C.CODIGO,
                                                                                                          KEY 'valor' VALUE C.VALOR,
                                                                                                          KEY 'descripcion' VALUE C.DESCRIPCION
                                                                                                         )
                                                                                                        )
                                                                                   FROM CATALOGOS.SBC_CAT_CATALOGOS C
                                                                                   WHERE C.CATALOGO_ID = A.TIPO_IDENTIFICACION_ID
                                                                                  ),
                                                                             KEY 'estado' VALUE (
                                                                             SELECT JSON_ARRAYAGG(
                                                                                             JSON_OBJECT(
                                                                                                          KEY 'id' VALUE D.CATALOGO_ID,
                                                                                                          KEY 'codigo' VALUE D.CODIGO,
                                                                                                          KEY 'valor' VALUE D.VALOR,
                                                                                                          KEY 'descripcion' VALUE D.DESCRIPCION
                                                                                                         )
                                                                                                        )
                                                                                   FROM CATALOGOS.SBC_CAT_CATALOGOS D
                                                                                   WHERE D.CATALOGO_ID = A.ESTADO_REGISTRO_ID
                                                                                   )
                                                                                )
                                                                )
                                        FROM CATALOGOS.SBC_MST_PERSONAS A
                                        WHERE PRIMER_NOMBRE = 'FREDDY' AND PRIMER_APELLIDO = 'SEQUEIRA'
                                        AND ROWNUM < 5
                                     --   A.IDENTIFICACION = '5610709810004U'
                                      )
                                    )
               PRETTY) AS personas
FROM DUAL
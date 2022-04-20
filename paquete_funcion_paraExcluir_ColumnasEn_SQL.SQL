--- Esto es a partir de oracle 18C
--- spec del paquete.
create or replace package except_cols_pkg as 
 
  function describe ( 
    tab         in out dbms_tf.table_t, 
    except_cols dbms_tf.columns_t 
  ) return dbms_tf.describe_t; 

end except_cols_pkg;  
/


--- body of the package
create or replace package body except_cols_pkg as 
 
  function describe ( 
    tab         in out dbms_tf.table_t, 
    except_cols dbms_tf.columns_t 
  ) return dbms_tf.describe_t as 
  begin 
     
    for i in 1 .. tab.column.count loop 
     
      if tab.column(i).description.name  
         member of except_cols then 
          
        tab.column(i).for_read := false; 
        tab.column(i).pass_through := false; 
         
      end if; 
       
    end loop; 
    
    return dbms_tf.describe_t (); 
 
  end describe; 
   
end except_cols_pkg;  
/


-- function of polymorphic type.
create or replace function except_cols ( 
  tab         table,    
  except_cols columns 
) return table pipelined  
  row polymorphic  
  using except_cols_pkg; 
/



--- ejemplo de exclusión de columnas.


SELECT *
  FROM except_cols(hospitalario.snh_mst_ingresos_egresos, 
                   columns (edad_exacta_ingreso, 
                            grupo_etareo_id,
                            admision_servicio_id, 
                            preg_ingreso_id))

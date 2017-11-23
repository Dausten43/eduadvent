select cc.MATRICULA ,
(select (sum(importe*decode(naturaleza,'C',1,0)) - sum(importe*decode(naturaleza,'D',1,0))) as sal 
    from mateo.cont_movimiento m 
    where m.id_ejercicio = '001-' || to_char(cc.fecha,'yyyy')  
    and m.id_auxiliarm = cc.matricula
    and m.fecha < cc.fecha
    )as saldo,
cc.CARGA_ID ,
cc.BLOQUE ,
cc.NOMBRE ,
cc.MODALIDAD_ID ,
cc.MODALIDAD ,
cc.TALUMNO_ID ,
cc.TALUMNO ,
cc.FECHA ,
cc.FORMAPAGO ,
cc.RESIDENCIA ,
cc.FACULTAD_ID ,
cc.FACULTAD ,
cc.CARRERA_ID ,
cc.CARRERA ,
cc.PLAN_ID ,
cc.NOMBRE_PLAN ,
cc.GRADO ,
cc.INSCRITO ,
cc.DORMITORIO   from MATEO.FES_CCOBRO cc
where carga_id='17181A' and inscrito='S'
order by matricula , fecha
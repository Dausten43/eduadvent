/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package kinder.boletin.base;

import java.util.Collection;
import java.util.List;
import net.sf.jasperreports.engine.JRDataSource;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;

/**
 *
 * @author Daniel
 */
public class ListaReportes {
    private Collection<AreasCriterios> lsAc;
    JRDataSource dsAc;

    
    public JRDataSource getDsAc(){
        return new JRBeanCollectionDataSource(getLsAc());
    }

    /**
     * @return the lsAc
     */
    public Collection<AreasCriterios> getLsAc() {
        return lsAc;
    }

    /**
     * @param lsAc the lsAc to set
     */
    public void setLsAc(Collection<AreasCriterios> lsAc) {
        this.lsAc = lsAc;
    }
}

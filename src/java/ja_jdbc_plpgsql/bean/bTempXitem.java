/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ja_jdbc_plpgsql.bean;

import java.sql.Timestamp;

/**
 *
 * @author psantos
 */
public class bTempXitem {
    
    
    private Integer cod_item;
    private Float fl_valor;
    private Timestamp datah;

    /**
     * @return the cod_item
     */
    public Integer getCod_item() {
        return cod_item;
    }

    /**
     * @param cod_item the cod_item to set
     */
    public void setCod_item(Integer cod_item) {
        this.cod_item = cod_item;
    }

    /**
     * @return the fl_valor
     */
    public Float getFl_valor() {
        return fl_valor;
    }

    /**
     * @param fl_valor the fl_valor to set
     */
    public void setFl_valor(Float fl_valor) {
        this.fl_valor = fl_valor;
    }

    /**
     * @return the datah
     */
    public Timestamp getDatah() {
        return datah;
    }

    /**
     * @param datah the datah to set
     */
    public void setDatah(Timestamp datah) {
        this.datah = datah;
    }
    
    
}

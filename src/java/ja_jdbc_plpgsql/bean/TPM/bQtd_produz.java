/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ja_jdbc_plpgsql.bean.TPM;

import java.sql.Timestamp;

/**
 *
 * @author psantos
 */
public class bQtd_produz {
    
    private Integer cod_qtd;
    private Integer cod_linha;
    private Integer min_dia;
    private Timestamp datah;
   // private bQtd_prod_reg bQtd_prod_reg;

    /**
     * @return the cod_qtd
     */
    public Integer getCod_qtd() {
        return cod_qtd;
    }

    /**
     * @param cod_qtd the cod_qtd to set
     */
    public void setCod_qtd(Integer cod_qtd) {
        this.cod_qtd = cod_qtd;
    }

    /**
     * @return the cod_linha
     */
    public Integer getCod_linha() {
        return cod_linha;
    }

    /**
     * @param cod_linha the cod_linha to set
     */
    public void setCod_linha(Integer cod_linha) {
        this.cod_linha = cod_linha;
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

    /**
     * @return the min_dia
     */
    public Integer getMin_dia() {
        return min_dia;
    }

    /**
     * @param min_dia the min_dia to set
     */
    public void setMin_dia(Integer min_dia) {
        this.min_dia = min_dia;
    }
    
}

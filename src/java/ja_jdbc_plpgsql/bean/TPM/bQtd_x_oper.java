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
public class bQtd_x_oper {
    private Integer cod_qtd;
    private Integer cod_cr;
    private Timestamp datah;

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
     * @return the cod_cr
     */
    public Integer getCod_cr() {
        return cod_cr;
    }

    /**
     * @param cod_cr the cod_cr to set
     */
    public void setCod_cr(Integer cod_cr) {
        this.cod_cr = cod_cr;
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

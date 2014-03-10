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
public class bQtd_prod_reg {

    private Integer cod_qtd;
    private Timestamp datahora;
    private Integer quantidade;
    private boolean tipo_bot;

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
     * @return the datahora
     */
    public Timestamp getDatahora() {
        return datahora;
    }

    /**
     * @param datahora the datahora to set
     */
    public void setDatahora(Timestamp datahora) {
        this.datahora = datahora;
    }

    /**
     * @return the quantidade
     */
    public Integer getQuantidade() {
        return quantidade;
    }

    /**
     * @param quantidade the quantidade to set
     */
    public void setQuantidade(Integer quantidade) {
        this.quantidade = quantidade;
    }

    /**
     * @return the tipo_bot
     */
    public boolean isTipo_bot() {
        return tipo_bot;
    }

    /**
     * @param tipo_bot the tipo_bot to set
     */
    public void setTipo_bot(boolean tipo_bot) {
        this.tipo_bot = tipo_bot;
    }
}

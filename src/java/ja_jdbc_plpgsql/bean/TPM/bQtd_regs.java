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
public class bQtd_regs {
    private Integer cod_qtd;
    private Integer cod_linha;
    private Integer min_dia;
    private Timestamp datah;
    private Double perda;
    private Double tempo;
    private Double eficiencia;

    private Integer cod_op;
    private String strdatah;
    private String cod_parada;
    
    private String cod_prod;
    private Timestamp datah_ini;
    private Timestamp datah_fim;
    
    private Integer qtd_op;
    private String nroserieini;
    private String nroseriefim;
    private String strobs;
    
    
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
     * @return the perda
     */
    public Double getPerda() {
        return perda;
    }

    /**
     * @param perda the perda to set
     */
    public void setPerda(Double perda) {
        this.perda = perda;
    }

    /**
     * @return the tempo
     */
    public Double getTempo() {
        return tempo;
    }

    /**
     * @param tempo the tempo to set
     */
    public void setTempo(Double tempo) {
        this.tempo = tempo;
    }

    /**
     * @return the eficiencia
     */
    public Double getEficiencia() {
        return eficiencia;
    }

    /**
     * @param eficiencia the eficiencia to set
     */
    public void setEficiencia(Double eficiencia) {
        this.eficiencia = eficiencia;
    }

    /**
     * @return the cod_op
     */
    public Integer getCod_op() {
        return cod_op;
    }

    /**
     * @param cod_op the cod_op to set
     */
    public void setCod_op(Integer cod_op) {
        this.cod_op = cod_op;
    }

    /**
     * @return the strdatah
     */
    public String getStrdatah() {
        return strdatah;
    }

    /**
     * @param strdatah the strdatah to set
     */
    public void setStrdatah(String strdatah) {
        this.strdatah = strdatah;
    }

    /**
     * @return the cod_parada
     */
    public String getCod_parada() {
        return cod_parada;
    }

    /**
     * @param cod_parada the cod_parada to set
     */
    public void setCod_parada(String cod_parada) {
        this.cod_parada = cod_parada;
    }

    /**
     * @return the cod_prod
     */
    public String getCod_prod() {
        return cod_prod;
    }

    /**
     * @param cod_prod the cod_prod to set
     */
    public void setCod_prod(String cod_prod) {
        this.cod_prod = cod_prod;
    }

    /**
     * @return the datah_ini
     */
    public Timestamp getDatah_ini() {
        return datah_ini;
    }

    /**
     * @param datah_ini the datah_ini to set
     */
    public void setDatah_ini(Timestamp datah_ini) {
        this.datah_ini = datah_ini;
    }

    /**
     * @return the datah_fim
     */
    public Timestamp getDatah_fim() {
        return datah_fim;
    }

    /**
     * @param datah_fim the datah_fim to set
     */
    public void setDatah_fim(Timestamp datah_fim) {
        this.datah_fim = datah_fim;
    }

    /**
     * @return the qtd_op
     */
    public Integer getQtd_op() {
        return qtd_op;
    }

    /**
     * @param qtd_op the qtd_op to set
     */
    public void setQtd_op(Integer qtd_op) {
        this.qtd_op = qtd_op;
    }

    /**
     * @return the nroserieini
     */
    public String getNroserieini() {
        return nroserieini;
    }

    /**
     * @param nroserieini the nroserieini to set
     */
    public void setNroserieini(String nroserieini) {
        this.nroserieini = nroserieini;
    }

    /**
     * @return the nroseriefim
     */
    public String getNroseriefim() {
        return nroseriefim;
    }

    /**
     * @param nroseriefim the nroseriefim to set
     */
    public void setNroseriefim(String nroseriefim) {
        this.nroseriefim = nroseriefim;
    }

    /**
     * @return the strobs
     */
    public String getStrobs() {
        return strobs;
    }

    /**
     * @param strobs the strobs to set
     */
    public void setStrobs(String strobs) {
        this.strobs = strobs;
    }
    
    
    
}

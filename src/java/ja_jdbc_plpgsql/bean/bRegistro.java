package ja_jdbc_plpgsql.bean;

import java.sql.Timestamp;

/**
 *
 * @author psantos
 */
public class bRegistro {

    private Integer cod_cr;
    private Integer cod_status;
    private String cod_prod;
    private String serial;
    private String posto_gmp;
    private Integer cod_gmp;
    private Integer cod_posto;
    private Timestamp datah;
    private String dataStr;
    private String complemento;
    private String inspecao;
    private String str_nome;

    public bRegistro() {
        cod_cr = -1;
        cod_status = -1;
        cod_prod = "";
        serial = "";
        posto_gmp = "";
        complemento = "";
        inspecao = "";
        cod_gmp = -1;
    }

    public bRegistro(int aInt, int aInt0, String cod_prod, String string, String string0, Timestamp timestamp, String string1, String string2, String string3) {
        cod_cr = aInt;
        cod_status = aInt0;
        this.cod_prod = cod_prod;
        serial = string;
        posto_gmp = string0;
        datah = timestamp;
        complemento = string1;
        inspecao = string2;
        str_nome = string3;
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
     * @return the cod_status
     */
    public Integer getCod_status() {
        return cod_status;
    }

    public String getCod_statusS() {
        if (cod_status == 0) {
            return "OK";
        }
        //return String.valueOf("NOK - " + cod_status);
        return String.valueOf("NOK");
    }
    
    //usado na web:
    public String getCod_statusW() {
        if (cod_status == 0) {
            return "1,\"OK\"";
        }
        return String.valueOf("-1,\"NOK\"");
    }

    /**
     * @param cod_status the cod_status to set
     */
    public void setCod_status(Integer cod_status) {
        this.cod_status = cod_status;
    }

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
     * @return the serial
     */
    public String getSerial() {
        return serial;
    }

    /**
     * @param serial the serial to set
     */
    public void setSerial(String serial) {
        this.serial = serial;
    }

    /**
     * @return the posto_gmp
     */
    public String getPosto_gmp() {
        return posto_gmp;
    }

    /**
     * @param posto_gmp the posto_gmp to set
     */
    public void setPosto_gmp(String posto_gmp) {
        this.posto_gmp = posto_gmp;
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
     * @return the complemento
     */
    public String getComplemento() {
        return complemento;
    }

    /**
     * @param complemento the complemento to set
     */
    public void setComplemento(String complemento) {
        this.complemento = complemento;
    }

    /**
     * @return the inspecao
     */
    public String getInspecao() {
        return inspecao;
    }

    /**
     * @param inspecao the inspecao to set
     */
    public void setInspecao(String inspecao) {
        this.inspecao = inspecao;
    }

    /**
     * @return the str_nome
     */
    public String getStr_nome() {
        return str_nome;
    }

    /**
     * @param str_nome the str_nome to set
     */
    public void setStr_nome(String str_nome) {
        this.str_nome = str_nome;
    }

    /**
     * @return the dataStr
     */
    public String getDataStr() {
        return dataStr;
    }

    /**
     * @param dataStr the dataStr to set
     */
    public void setDataStr(String dataStr) {
        this.dataStr = dataStr;
    }

    /**
     * @return the cod_gmp
     */
    public Integer getCod_gmp() {
        return cod_gmp;
    }

    /**
     * @param cod_gmp the cod_gmp to set
     */
    public void setCod_gmp(Integer cod_gmp) {
        this.cod_gmp = cod_gmp;
    }

    /**
     * @return the cod_posto
     */
    public Integer getCod_posto() {
        return cod_posto;
    }

    /**
     * @param cod_posto the cod_posto to set
     */
    public void setCod_posto(Integer cod_posto) {
        this.cod_posto = cod_posto;
    }
}

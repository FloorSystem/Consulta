package ja_jdbc_plpgsql.bean;

import java.sql.Timestamp;

/**
 *
 * @author psantos
 */
public class bAssisTec {

    private Integer cod_assistec;
    private Integer cod_cr;
    private String str_cr_operador;
    private int cod_deposito;
    private Timestamp datahora;
    private String str_relatorio;
    private String obs;
    private String cod_prod;
    private String cod_prod2;
    private String serial;

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
     * @return the str_cr_operador
     */
    public String getStr_cr_operador() {
        return str_cr_operador;
    }

    /**
     * @param str_cr_operador the str_cr_operador to set
     */
    public void setStr_cr_operador(String str_cr_operador) {
        this.str_cr_operador = str_cr_operador;
    }

    /**
     * @return the cod_assistec
     */
    public Integer getCod_assistec() {
        return cod_assistec;
    }

    /**
     * @param cod_assistec the cod_assistec to set
     */
    public void setCod_assistec(Integer cod_assistec) {
        this.cod_assistec = cod_assistec;
    }

    /**
     * @return the cod_deposito
     */
    public int getCod_deposito() {
        return cod_deposito;
    }

    /**
     * @param cod_deposito the cod_deposito to set
     */
    public void setCod_deposito(int cod_deposito) {
        this.cod_deposito = cod_deposito;
    }

    /**
     * @return the str_relatorio
     */
    public String getStr_relatorio() {
        return str_relatorio;
    }

    /**
     * @param str_relatorio the str_relatorio to set
     */
    public void setStr_relatorio(String str_relatorio) {
        this.str_relatorio = str_relatorio;
    }

    /**
     * @return the obs
     */
    public String getObs() {
        return obs;
    }

    /**
     * @param obs the obs to set
     */
    public void setObs(String obs) {
        this.obs = obs;
    }

    /**
     * @return the cod_prod2
     */
    public String getCod_prod2() {
        return cod_prod2;
    }

    /**
     * @param cod_prod2 the cod_prod2 to set
     */
    public void setCod_prod2(String cod_prod2) {
        this.cod_prod2 = cod_prod2;
    }
}


package ja_jdbc_plpgsql.bean;

import java.sql.Timestamp;

/**
 *
 * @author psantos
 */
public class bTmp_item {

    private Integer cod_item;
    private String str_item;
    private String obs_item;
    private String medida;
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
     * @return the str_item
     */
    public String getStr_item() {
        return str_item;
    }

    /**
     * @param str_item the str_item to set
     */
    public void setStr_item(String str_item) {
        this.str_item = str_item;
    }

    /**
     * @return the obs_item
     */
    public String getObs_item() {
        return obs_item;
    }

    /**
     * @param obs_item the obs_item to set
     */
    public void setObs_item(String obs_item) {
        this.obs_item = obs_item;
    }

    /**
     * @return the medida
     */
    public String getMedida() {
        return medida;
    }

    /**
     * @param medida the medida to set
     */
    public void setMedida(String medida) {
        this.medida = medida;
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

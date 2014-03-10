/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ja_jdbc_plpgsql.bean;

/**
 *
 * @author psantos
 */
public class bConsultaDef {
    
    private Integer cont;
    private Float percent;
    private Integer total;
    private Integer cod_def;
    private String str_def;
    private String str_prod;

    /**
     * @return the cont
     */
    public Integer getCont() {
        return cont;
    }

    /**
     * @param cont the cont to set
     */
    public void setCont(Integer cont) {
        this.cont = cont;
    }

    /**
     * @return the percent
     */
    public Float getPercent() {
        return percent;
    }

    /**
     * @param percent the percent to set
     */
    public void setPercent(Float percent) {
        this.percent = percent;
    }

    /**
     * @return the str_def
     */
    public String getStr_def() {
        return str_def;
    }

    /**
     * @param str_def the str_def to set
     */
    public void setStr_def(String str_def) {
        this.str_def = str_def;
    }

    /**
     * @return the total
     */
    public Integer getTotal() {
        return total;
    }

    /**
     * @param total the total to set
     */
    public void setTotal(Integer total) {
        this.total = total;
    }

    /**
     * @return the str_prod
     */
    public String getStr_prod() {
        return str_prod;
    }

    /**
     * @param str_prod the str_prod to set
     */
    public void setStr_prod(String str_prod) {
        this.str_prod = str_prod;
    }

    /**
     * @return the cod_def
     */
    public Integer getCod_def() {
        return cod_def;
    }

    /**
     * @param cod_def the cod_def to set
     */
    public void setCod_def(Integer cod_def) {
        this.cod_def = cod_def;
    }
    
    
}

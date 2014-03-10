
package ja_jdbc_plpgsql.bean;

/**
 *
 * @author psantos
 */
public class bConsulta {

    private String cod_prod;
    private String str_prod;
    private String dia;
    private Integer nok;
    private Integer ok;
   // private Integer produzidos;
    private Float yield;

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
     * @return the dia
     */
    public String getDia() {
        return dia;
    }

    /**
     * @param dia the dia to set
     */
    public void setDia(String dia) {
        this.dia = dia;
    }

    /**
     * @return the nok
     */
    public Integer getNok() {
        return nok;
    }

    /**
     * @param nok the nok to set
     */
    public void setNok(Integer nok) {
        this.nok = nok;
    }

    /**
     * @return the ok
     */
    public Integer getOk() {
        return ok;
    }

    /**
     * @param ok the ok to set
     */
    public void setOk(Integer ok) {
        this.ok = ok;
    }


    /**
     * @return the yield
     */
    public Float getYield() {
        return yield;
    }

    /**
     * @param yield the yield to set
     */
    public void setYield(Float yield) {
        this.yield = yield;
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
    

    
    
}

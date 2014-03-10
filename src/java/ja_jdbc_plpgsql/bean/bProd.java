/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ja_jdbc_plpgsql.bean;

/**
 *
 * @author psantos
 */
public class bProd {

    private String cod_prod;
    private String str_prod;
    private String str_ean;
    private String str3;
    private int pos;

    public bProd(String aInt, String string, String ean, String string1) {
        cod_prod = aInt;
        str_prod = string;
        str_ean = ean;
        str3 = string1;
    }

    public bProd() {
        cod_prod = "";
        str_prod = "";
    }

    /**
     * @return the cod_prod
     */
    public String getCod_prod() {
        return  cod_prod;
    }

    /**
     * @param cod_prod the cod_prod to set
     */
    public void setCod_prod(String cod_prod) {
        this.cod_prod = cod_prod;
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
     * @return the str2
     */
    public String getEan() {
        return str_ean;
    }

    /**
     * @param str2 the str2 to set
     */
    public void setEan(String str_ean) {
        this.str_ean = str_ean;
    }

    /**
     * @return the str3
     */
    public String getStr3() {
        return str3;
    }

    /**
     * @param str3 the str3 to set
     */
    public void setStr3(String str3) {
        this.str3 = str3;
    }

    /**
     * @return the pos
     */
    public int getPos() {
        return pos;
    }

    /**
     * @param pos the pos to set
     */
    public void setPos(int pos) {
        this.pos = pos;
    }
}

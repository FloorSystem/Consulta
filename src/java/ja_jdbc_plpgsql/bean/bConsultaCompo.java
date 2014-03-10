/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ja_jdbc_plpgsql.bean;

/**
 *
 * @author psantos
 */
public class bConsultaCompo {

    private Integer cont;
    private String cod_prod;
    private String str_compo;
    private String descricao1;

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
     * @return the str_compo
     */
    public String getStr_compo() {
        return str_compo;
    }

    /**
     * @param str_compo the str_compo to set
     */
    public void setStr_compo(String str_compo) {
        this.str_compo = str_compo;
    }

    /**
     * @return the descricao1
     */
    public String getDescricao1() {
        return descricao1;
    }

    /**
     * @param descricao1 the descricao1 to set
     */
    public void setDescricao1(String descricao1) {
        this.descricao1 = descricao1;
    }
}

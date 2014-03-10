/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ja_jdbc_plpgsql.bean;

/**
 *
 * @author psantos
 */
public class bOperador {

    private Integer cod_cr;
    private String str_nome;

    public bOperador() {
        cod_cr = -1;
        str_nome = "";
    }

    public bOperador(Integer cod, String str) {
        cod_cr = cod;
        str_nome = str;
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
}

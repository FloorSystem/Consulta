

package ja_jdbc_plpgsql.bean;

import java.sql.Timestamp;

/**
 *
 * @author psantos
 */
public class bDefeito {
    
  private String cod_prod;
  private String serial;
  private Integer cod_tp_defeito;
  private String str_tp_defeito;
  private Integer cod_sintoma;
  private String str_sintoma;
  private char  tipo_montagem;
  private String cod_comp;
  private Integer pos_comp;
  private Timestamp datahora;
  private Integer cod_cr;
  private String str_nome;
  private String str_obs;
  private String str_compo;
  private String str_cr_operador;
  

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
     * @return the cod_tp_defeito
     */
    public Integer getCod_tp_defeito() {
        return cod_tp_defeito;
    }

    /**
     * @param cod_tp_defeito the cod_tp_defeito to set
     */
    public void setCod_tp_defeito(Integer cod_tp_defeito) {
        this.cod_tp_defeito = cod_tp_defeito;
    }

    /**
     * @return the cod_sintoma
     */
    public Integer getCod_sintoma() {
        return cod_sintoma;
    }

    /**
     * @param cod_sintoma the cod_sintoma to set
     */
    public void setCod_sintoma(Integer cod_sintoma) {
        this.cod_sintoma = cod_sintoma;
    }

    /**
     * @return the tipo_montagem
     */
    public char getTipo_montagem() {
        return tipo_montagem;
    }

    /**
     * @param tipo_montagem the tipo_montagem to set
     */
    public void setTipo_montagem(char tipo_montagem) {
        this.tipo_montagem = tipo_montagem;
    }

    /**
     * @return the cod_comp
     */
    public String getCod_comp() {
        return cod_comp;
    }

    /**
     * @param cod_comp the cod_comp to set
     */
    public void setCod_comp(String cod_comp) {
        this.cod_comp = cod_comp;
    }

    /**
     * @return the pos_comp
     */
    public Integer getPos_comp() {
        return pos_comp;
    }

    /**
     * @param pos_comp the pos_comp to set
     */
    public void setPos_comp(Integer pos_comp) {
        this.pos_comp = pos_comp;
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
     * @return the str_obs
     */
    public String getStr_obs() {
        return str_obs;
    }

    /**
     * @param str_obs the str_obs to set
     */
    public void setStr_obs(String str_obs) {
        this.str_obs = str_obs;
    }

    /**
     * @return the str_tp_defeito
     */
    public String getStr_tp_defeito() {
        return str_tp_defeito;
    }

    /**
     * @param str_tp_defeito the str_tp_defeito to set
     */
    public void setStr_tp_defeito(String str_tp_defeito) {
        this.str_tp_defeito = str_tp_defeito;
    }

    /**
     * @return the str_sintoma
     */
    public String getStr_sintoma() {
        return str_sintoma;
    }

    /**
     * @param str_sintoma the str_sintoma to set
     */
    public void setStr_sintoma(String str_sintoma) {
        this.str_sintoma = str_sintoma;
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

    
}

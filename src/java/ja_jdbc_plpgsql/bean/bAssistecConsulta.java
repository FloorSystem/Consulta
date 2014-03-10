package ja_jdbc_plpgsql.bean;

import java.sql.Timestamp;

/**
 *
 * @author psantos
 */
public class bAssistecConsulta {

    private Integer cod_assistec;
    private Integer cod_sintoma;
    private Integer op_num;
    private String cod_comp;
    private Integer pos_comp;
    private Timestamp datareg;
    private String str_sa;
    private String str_compo;
    private Integer cod_tp_defeito;
    private String str_tp_defeito;
    private String str_sintoma;
    private char tipo_montagem;
    private Integer cod_cr;
    private String str_cr_operador;
    private int cod_deposito;
    private Timestamp datahora;
    private String str_relatorio;
    private String obs;
    private String cod_prod;
    private String cod_prod2;
    private String serial;

    public bAssistecConsulta() {
        cod_assistec = -1;
        //  cod_tb_defeito = -1;
        cod_sintoma = -1;
        cod_comp = "";
        pos_comp = -1;
        //datareg ;
        str_sa = "";
        cod_tp_defeito = -1;
        str_tp_defeito = "";
        str_sintoma = "";
        tipo_montagem = ' ';
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
     * @return the datareg
     */
    public Timestamp getDatareg() {
        return datareg;
    }

    /**
     * @param datareg the datareg to set
     */
    public void setDatareg(Timestamp datareg) {
        this.datareg = datareg;
    }

    /**
     * @return the str_sa
     */
    public String getStr_sa() {
        return str_sa;
    }

    /**
     * @param str_sa the str_sa to set
     */
    public void setStr_sa(String str_sa) {
        this.str_sa = str_sa;
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
     * @return the op_num
     */
    public Integer getOp_num() {
        return op_num;
    }

    /**
     * @param op_num the op_num to set
     */
    public void setOp_num(Integer op_num) {
        this.op_num = op_num;
    }
}

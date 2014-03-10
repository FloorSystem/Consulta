package ja_jdbc_plpgsql.bean.TPM;

import java.sql.Timestamp;

/**
 *
 * @author psantos
 */
public class bQtd_parada {

    private Integer cod_qtd;
    private String cod_parada;
    private Timestamp datah_ini;
    private Timestamp datah_fim;
    private String str_obs;

    /**
     * @return the cod_qtd
     */
    public Integer getCod_qtd() {
        return cod_qtd;
    }

    /**
     * @param cod_qtd the cod_qtd to set
     */
    public void setCod_qtd(Integer cod_qtd) {
        this.cod_qtd = cod_qtd;
    }

    /**
     * @return the cod_parada
     */
    public String getCod_parada() {
        return cod_parada;
    }

    /**
     * @param cod_parada the cod_parada to set
     */
    public void setCod_parada(String cod_parada) {
        this.cod_parada = cod_parada;
    }

    /**
     * @return the datah_ini
     */
    public Timestamp getDatah_ini() {
        return datah_ini;
    }

    /**
     * @param datah_ini the datah_ini to set
     */
    public void setDatah_ini(Timestamp datah_ini) {
        this.datah_ini = datah_ini;
    }

    /**
     * @return the datah_fim
     */
    public Timestamp getDatah_fim() {
        return datah_fim;
    }

    /**
     * @param datah_fim the datah_fim to set
     */
    public void setDatah_fim(Timestamp datah_fim) {
        this.datah_fim = datah_fim;
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
}

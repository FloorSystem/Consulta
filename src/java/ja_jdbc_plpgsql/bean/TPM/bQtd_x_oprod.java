
package ja_jdbc_plpgsql.bean.TPM;

import java.sql.Timestamp;

/**
 *
 * @author psantos
 */
public class bQtd_x_oprod {
    private Integer cod_qtd;
    private Integer cod_op;
    private Timestamp datah;
    private String cod_prod;

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
     * @return the cod_op
     */
    public Integer getCod_op() {
        return cod_op;
    }

    /**
     * @param cod_op the cod_op to set
     */
    public void setCod_op(Integer cod_op) {
        this.cod_op = cod_op;
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
    
}

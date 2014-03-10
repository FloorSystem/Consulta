package ja_jdbc_plpgsql.jdbc;

import ja_jdbc_plpgsql.bean.bDefeito;
import ja_jdbc_plpgsql.bean.bRegistro;
import ja_jdbc_plpgsql.connection.DBConnectionManager;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 *
 * @author psantos
 */
public class jItm {

    private static DBConnectionManager conMgr;
    static CallableStatement call;

    static {
        conMgr = DBConnectionManager.getInstance();
    }

    /*
     * 1. Pesquisa os registros funcionais do Serial
     */
    public static ArrayList<bRegistro> PesquisaFun(String arg_serial) throws SQLException, ClassNotFoundException {
        ArrayList<bRegistro> sts = new ArrayList<bRegistro>();
        ResultSet rs;
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("SELECT "
                    + "tb_registro.cod_cr, "
                    + "tb_registro.cod_status, "
                    + "tb_registro.cod_prod, "
                    + "tb_registro.serial, "
                    + "'GMP-' || cod_gmp || '-' || cod_posto AS posto_gmp, "
                    + "tb_registro.datah, "
                    + "tb_registro.complemento, "
                    + "tb_registro.inspecao, "
                    + "tb_operador.str_nome "
                    + "FROM tb_registro, "
                    + "tb_operador "
                    + "WHERE "
                    + "serial = ? "
                    + "AND tb_operador.cod_cr = tb_registro.cod_cr "
                    + "ORDER BY datah;");
            call.setString(1, arg_serial);
            rs = call.executeQuery();

            while (rs.next()) {
                bRegistro bObj = new bRegistro();
                bObj.setCod_status(rs.getInt("cod_status"));
                bObj.setCod_prod(rs.getString("cod_prod"));
                bObj.setSerial(rs.getString("serial"));
                bObj.setPosto_gmp(rs.getString("posto_gmp"));
                bObj.setDatah(rs.getTimestamp("datah"));
                bObj.setComplemento(rs.getString("complemento"));
                bObj.setInspecao(rs.getString("inspecao"));
                bObj.setStr_nome(rs.getString("str_nome"));
                sts.add(bObj);
            }
            return sts;
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
    }

    /*
     * 2. Listar Reparos/Defeitos
     */
    public static ArrayList<bDefeito> getDefeitos(String arg_serial) throws SQLException, ClassNotFoundException {
        ArrayList<bDefeito> sts = new ArrayList<bDefeito>();
        bDefeito bObj;
        ResultSet rs;
        Connection conPol = conMgr.getConnection("PD");
        if (conPol == null) {
            throw new SQLException("Numero Maximo de Conexoes Atingida!");
        }
        try {
            call = conPol.prepareCall("SELECT  "
                    + "  tb_operador.str_nome,  "
                    + "  tb_defeito.cod_prod,  "
                    + "  tb_defeito.serial,  "
                    + "  tb_defeito.tipo_montagem,  "
                    + "  tb_defeito.cod_comp,  "
                    + "  tb_defeito.pos_comp,  "
                    + "  tb_defeito.datahora,  "
                    + "  tb_defeito.cod_cr,  "
                    + "  tb_defeito.str_obs,  "
                    + "  tb_tp_defeito.str_defeito "
                    + "FROM  "
                    + "  public.tb_operador,  "
                    + "  public.tb_defeito,  "
                    + "  public.tb_tp_defeito "
                    + "WHERE  "
                    + "  serial = ? AND "
                    + "  tb_operador.cod_cr = tb_defeito.cod_cr AND "
                    + "  tb_defeito.cod_tp_defeito = tb_tp_defeito.cod_tp_defeito; ");

            call.setString(1, arg_serial);
            rs = call.executeQuery();

            while (rs.next()) {
                bObj = new bDefeito();
                bObj.setCod_prod(rs.getString("cod_prod"));
                bObj.setSerial(rs.getString("serial"));
                bObj.setStr_tp_defeito(rs.getString("str_defeito"));
                bObj.setTipo_montagem(rs.getString("tipo_montagem").charAt(0));
                bObj.setCod_comp(rs.getString("cod_comp"));
                bObj.setPos_comp(rs.getInt("pos_comp"));
                bObj.setDatahora(rs.getTimestamp("datahora"));
                bObj.setCod_cr(rs.getInt("cod_cr"));
                bObj.setStr_cr_operador(rs.getString("str_nome"));
                bObj.setStr_obs(rs.getString("str_obs"));
                sts.add(bObj);
            }
            return sts;
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
    }

}

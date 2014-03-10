package ja_jdbc_plpgsql.jdbc.TPM;

import ja_jdbc_plpgsql.bean.TPM.bQtd_parada;
import ja_jdbc_plpgsql.bean.TPM.bQtd_produz;
import ja_jdbc_plpgsql.bean.TPM.bQtd_prod_reg;
import ja_jdbc_plpgsql.bean.TPM.bQtd_regs;
import ja_jdbc_plpgsql.bean.TPM.bQtd_x_oper;
import ja_jdbc_plpgsql.bean.TPM.bQtd_x_oprod;
import ja_jdbc_plpgsql.bean.TPM.bTp_parada;
import ja_jdbc_plpgsql.connection.DBConnectionManager;
import java.sql.Timestamp;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.ParseException;
import java.util.ArrayList;

/**
 *
 * @author psantos
 */
public class jQtdProduz {

    // static Connection con;
    private static DBConnectionManager conMgr;
    static CallableStatement call;

    static {
        conMgr = DBConnectionManager.getInstance();
    }

    public static int salvarProduz(bQtd_produz bObj) throws ClassNotFoundException, SQLException {
        Connection conPol = conMgr.getConnection("PD");
        int ret;
        //con = Conectar.getConnection();
        try {

            call = conPol.prepareCall("{ ? = call sp_qtdproduz_insert(?,?)}");
            call.registerOutParameter(1, Types.INTEGER);
            call.setInt(2, bObj.getCod_linha());
            call.setTimestamp(3, bObj.getDatah());


            call.execute();

            ret = call.getInt(1);
            if (ret == 0) {
                throw new SQLException("Não foi possível Salvar. Reveja os parâmetros.");
            }

            call.close();
            return ret;
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        //  return ret;
    }

    public static int salvarProduzReg(bQtd_prod_reg bObj) throws ClassNotFoundException, SQLException {
        Connection conPol = conMgr.getConnection("PD");
        int ret;
        //con = Conectar.getConnection();
        try {

            call = conPol.prepareCall("INSERT INTO tb_qtd_prod_reg( "
                    + "       cod_qtd, datahora, quantidade, tipo_bot) "
                    + "VALUES (?, ?, ?, ?);");

            call.setInt(1, bObj.getCod_qtd());
            call.setTimestamp(2, bObj.getDatahora());
            call.setInt(3, bObj.getQuantidade());
            call.setBoolean(4, bObj.isTipo_bot());

            ret = call.executeUpdate();
            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return ret;
    }

    public static int saveQtd_x_oprod(bQtd_x_oprod bObj) throws ClassNotFoundException, SQLException {
        Connection conPol = conMgr.getConnection("PD");
        int ret;
        //con = Conectar.getConnection();
        try {

            call = conPol.prepareCall("INSERT INTO tb_qtd_x_oprod( "
                    + "       cod_qtd, cod_op, datah, cod_prod) "
                    + "VALUES (?, ?, ?, ?);");

            call.setInt(1, bObj.getCod_qtd());
            call.setInt(2, bObj.getCod_op());
            call.setTimestamp(3, bObj.getDatah());
            call.setString(4, bObj.getCod_prod());

            ret = call.executeUpdate();
            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return ret;
    }

    public static int saveQtd_x_oper(bQtd_x_oper bObj) throws ClassNotFoundException, SQLException {
        Connection conPol = conMgr.getConnection("PD");
        int ret;
        try {
            call = conPol.prepareCall("INSERT INTO tb_qtd_x_oper( "
                    + "       cod_qtd, cod_cr, datah) "
                    + "VALUES (?, ?, ?);");
            call.setInt(1, bObj.getCod_qtd());
            call.setInt(2, bObj.getCod_cr());
            call.setTimestamp(3, bObj.getDatah());
            ret = call.executeUpdate();
            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return ret;
    }

    public static int saveQtd_parada(bQtd_parada bObj) throws ClassNotFoundException, SQLException {
        Connection conPol = conMgr.getConnection("PD");
        int ret;
        try {
            call = conPol.prepareCall("INSERT INTO tb_qtd_parada( "
                    + "       cod_qtd, cod_parada, datah_ini, datah_fim, str_obs) "
                    + "VALUES (?, ?, ?, ?, ?);");
            call.setInt(1, bObj.getCod_qtd());
            call.setString(2, bObj.getCod_parada());
            call.setTimestamp(3, bObj.getDatah_ini());
            call.setTimestamp(4, bObj.getDatah_fim());
            call.setString(5, bObj.getStr_obs());
            ret = call.executeUpdate();
            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return ret;
    }

    public static int saveTp_parada(bTp_parada bObj) throws ClassNotFoundException, SQLException {
        Connection conPol = conMgr.getConnection("PD");
        int ret;
        try {
            call = conPol.prepareCall("INSERT INTO tb_tp_parada( "
                    + "       cod_parada, str_parada) "
                    + "VALUES (?, ?);");
            call.setString(1, bObj.getCod_parada());
            call.setString(2, bObj.getStr_parada());
            ret = call.executeUpdate();
            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return ret;
    }

    public static int upMinDia(int min, Integer argCod) throws ClassNotFoundException, SQLException {
        Connection conPol = conMgr.getConnection("PD");
        int ret;
        try {
            call = conPol.prepareCall("UPDATE tb_qtd_produz "
                    + " SET min_dia=?"
                    + " WHERE cod_qtd=?;");
            call.setInt(1, min);
            call.setInt(2, argCod);
            ret = call.executeUpdate();
            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return ret;
    }

    /*
    <salvar/>
     */
    public static void excluiReg(Integer arg_cod, Timestamp arg_datah) throws ClassNotFoundException, SQLException {

        Connection conPol = conMgr.getConnection("PD");
        try {
            call = conPol.prepareCall("DELETE FROM tb_qtd_prod_reg WHERE cod_qtd = ? AND datahora = ? ;");
            call.setInt(1, arg_cod);
            call.setTimestamp(2, arg_datah);
            call.execute();
            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
    }

    /* 1ª consulta, remsumo na tela
     */
    public static ArrayList<bQtd_prod_reg> getResumo(Integer arg_cod) throws SQLException, ClassNotFoundException {
        String sql = "SELECT * "
                + "  FROM tb_qtd_prod_reg "
                + " WHERE cod_qtd = ? ORDER BY datahora;";

        ResultSet rs;
        ArrayList<bQtd_prod_reg> sts = new ArrayList<bQtd_prod_reg>();
        Connection conPol = conMgr.getConnection("PD");
        try {
            call = conPol.prepareCall(sql);
            call.setInt(1, arg_cod);

            rs = call.executeQuery();

            while (rs.next()) {
                bQtd_prod_reg bObj = new bQtd_prod_reg();
                bObj.setCod_qtd(rs.getInt("cod_qtd"));
                bObj.setDatahora(rs.getTimestamp("datahora"));
                bObj.setQuantidade(rs.getInt("quantidade"));
                bObj.setTipo_bot(rs.getBoolean("tipo_bot"));
                sts.add(bObj);
            }
            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    /* 2ª consulta, busca todos os registros para poder editar
     */
    public static ArrayList<bQtd_produz> getAllproduz(Integer arg_op) throws SQLException, ClassNotFoundException {
        String sql = "SELECT *  FROM  tb_qtd_produz ORDER BY datah desc LIMIT 30;";

        ResultSet rs;
        ArrayList<bQtd_produz> sts = new ArrayList<bQtd_produz>();
        Connection conPol = conMgr.getConnection("PD");
        try {
            call = conPol.prepareCall(sql);
            //   call.setInt(1, arg_op);

            rs = call.executeQuery();

            while (rs.next()) {
                bQtd_produz bObj = new bQtd_produz();
                bObj.setCod_qtd(rs.getInt("cod_qtd"));
                bObj.setCod_linha(rs.getInt("cod_linha"));
                bObj.setMin_dia(rs.getInt("min_dia"));
                bObj.setDatah(rs.getTimestamp("datah"));
                sts.add(bObj);
            }
            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    public static bQtd_produz getproduz(Integer arg_cod) throws SQLException, ClassNotFoundException {
        String sql = "SELECT *  FROM  tb_qtd_produz "
                + "  WHERE cod_qtd = ?;";

        ResultSet rs;
        bQtd_produz bObj = new bQtd_produz();
        Connection conPol = conMgr.getConnection("PD");
        try {
            call = conPol.prepareCall(sql);
            call.setInt(1, arg_cod);
            rs = call.executeQuery();
            while (rs.next()) {
                bObj.setCod_qtd(rs.getInt("cod_qtd"));
                bObj.setCod_linha(rs.getInt("cod_linha"));
                bObj.setDatah(rs.getTimestamp("datah"));
                bObj.setMin_dia(rs.getInt("min_dia"));
            }

            call.close();
            return bObj;
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
    }

    // Lista as paradas tela
    public static ArrayList<bTp_parada> getAllparada() throws SQLException, ClassNotFoundException {
        String sql = "SELECT *  FROM  tb_tp_parada ORDER BY cod_parada";

        ResultSet rs;
        ArrayList<bTp_parada> sts = new ArrayList<bTp_parada>();
        Connection conPol = conMgr.getConnection("PD");
        try {
            call = conPol.prepareCall(sql);
            //   call.setInt(1, arg_op);

            rs = call.executeQuery();

            while (rs.next()) {
                bTp_parada bObj = new bTp_parada();
                bObj.setCod_parada(rs.getString("cod_parada"));
                bObj.setStr_parada(rs.getString("str_parada"));
                sts.add(bObj);
            }
            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    // Lista os operadores do registro
    public static ArrayList<bQtd_x_oper> getOpers(Integer arg_cod) throws SQLException, ClassNotFoundException {
        String sql = "SELECT *  FROM  tb_qtd_x_oper where cod_qtd = ? order by datah;";

        ResultSet rs;
        ArrayList<bQtd_x_oper> sts = new ArrayList<bQtd_x_oper>();
        Connection conPol = conMgr.getConnection("PD");
        try {
            call = conPol.prepareCall(sql);
            call.setInt(1, arg_cod);

            rs = call.executeQuery();

            while (rs.next()) {
                bQtd_x_oper bObj = new bQtd_x_oper();
                bObj.setCod_qtd(rs.getInt("cod_qtd"));
                bObj.setCod_cr(rs.getInt("cod_cr"));
                bObj.setDatah(rs.getTimestamp("datah"));
                sts.add(bObj);
            }
            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    // Lista as OPs
    public static ArrayList<bQtd_x_oprod> getOprods(Integer arg_cod) throws SQLException, ClassNotFoundException {
        String sql = "SELECT *  FROM  tb_qtd_x_oprod where cod_qtd = ? order by datah;";

        ResultSet rs;
        ArrayList<bQtd_x_oprod> sts = new ArrayList<bQtd_x_oprod>();
        Connection conPol = conMgr.getConnection("PD");
        try {
            call = conPol.prepareCall(sql);
            call.setInt(1, arg_cod);

            rs = call.executeQuery();

            while (rs.next()) {
                bQtd_x_oprod bObj = new bQtd_x_oprod();
                bObj.setCod_qtd(rs.getInt("cod_qtd"));
                bObj.setCod_op(rs.getInt("cod_op"));
                bObj.setDatah(rs.getTimestamp("datah"));
                bObj.setCod_prod(rs.getString("cod_prod"));
                sts.add(bObj);
            }
            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    // Lista as Paradas
    public static ArrayList<bQtd_parada> getParadas(Integer arg_cod) throws SQLException, ClassNotFoundException {
        String sql = "SELECT *  FROM  tb_qtd_parada where cod_qtd = ? order by datah_ini;";

        ResultSet rs;
        ArrayList<bQtd_parada> sts = new ArrayList<bQtd_parada>();
        Connection conPol = conMgr.getConnection("PD");
        try {
            call = conPol.prepareCall(sql);
            call.setInt(1, arg_cod);

            rs = call.executeQuery();

            while (rs.next()) {
                bQtd_parada bObj = new bQtd_parada();
                bObj.setCod_qtd(rs.getInt("cod_qtd"));
                bObj.setCod_parada(rs.getString("cod_parada"));
                bObj.setDatah_ini(rs.getTimestamp("datah_ini"));
                bObj.setDatah_fim(rs.getTimestamp("datah_fim"));
                bObj.setStr_obs(rs.getString("str_obs"));
                sts.add(bObj);
            }
            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    // grafic web 1 ok
    public static ArrayList<bQtd_regs> getEficienciaRelat(String arg_dt1, int arg_linha) throws SQLException, ClassNotFoundException, ParseException {
        String sql = "{ call sp_eficiencia(?,?)}";

        ResultSet rs;
        ArrayList<bQtd_regs> sts = new ArrayList<bQtd_regs>();
        Connection conPol = conMgr.getConnection("PD");
        try {
            call = conPol.prepareCall(sql);
            call.setString(1, arg_dt1);
            call.setInt(2, arg_linha);

            rs = call.executeQuery();

            while (rs.next()) {
                bQtd_regs bQtd_regs = new bQtd_regs();
                bQtd_regs.setDatah(rs.getTimestamp(1));
                bQtd_regs.setPerda(rs.getDouble(2));
                bQtd_regs.setEficiencia(rs.getDouble(3));
                //   bQtd_regs.setMin_dia(rs.getInt(4));

                sts.add(bQtd_regs);
            }
            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    public static ArrayList getEficienciaMediaMes(String arg_dt1) throws SQLException, ClassNotFoundException, ParseException {
        String sql = "{ call sp_eficiencia_media(?)}";

        ResultSet rs;
        ArrayList sts = new ArrayList();
        Connection conPol = conMgr.getConnection("PD");
        try {
            call = conPol.prepareCall(sql);
            call.setString(1, arg_dt1);

            rs = call.executeQuery();

            while (rs.next()) {
                sts.add(rs.getString(1) + "\t" + rs.getDouble(2) + "\t" + rs.getDouble(3) + "\t" + rs.getDouble(4));
            }
            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    // web ok - adicionar Descrição da parada!
    public static ArrayList getEficienciaMediaMes(String arg_dt1, int arg_linha) throws SQLException, ClassNotFoundException, ParseException {
        String sql = "{ call sp_eficiencia_media(?,?)}";

        ResultSet rs;
        ArrayList sts = new ArrayList();
        Connection conPol = conMgr.getConnection("PD");
        try {
            call = conPol.prepareCall(sql);
            call.setString(1, arg_dt1);
            call.setInt(2, arg_linha);

            rs = call.executeQuery();

            while (rs.next()) {
                sts.add(rs.getString(1) + "\t" + rs.getDouble(2) + "\t" + rs.getDouble(3) + "%\t" + rs.getDouble(4) + "%");
            }
            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    // web lista 1 Mapeamento de Perdas
    // web ok
    public static ArrayList<bQtd_regs> getSetpOP(String arg_dt1, int arg_linha) throws SQLException, ClassNotFoundException, ParseException {
        //String sql = "{ call sp_eficiencia_lista_ops_setp(?,?)}";
        String sql = "SELECT "
                + "  tb_qtd_parada.cod_op, "
                + "  tb_op.item, "
                + "  tb_op.qtd, "
                + "  tb_op_nunser.nroserieini, "
                + "  tb_op_nunser.nroseriefim,"
                + "  tb_qtd_parada.cod_parada, "
                + "  tb_qtd_parada.datah_ini, "
                + " (extract(epoch from(tb_qtd_parada.datah_fim - tb_qtd_parada.datah_ini))/60) as tempominu,"
                + " tb_qtd_parada.str_obs "
                + "FROM "
                + "  tb_qtd_parada, "
                + "  tb_op, "
                + "  tb_op_nunser, "
                + "  tb_qtd_produz "
                + "WHERE "
                + "  tb_qtd_parada.cod_op = tb_op.op AND"
                + "  tb_op.op = tb_op_nunser.nroop AND"
                + "  tb_qtd_produz.cod_qtd = tb_qtd_parada.cod_qtd AND"
                + "  tb_qtd_parada.cod_parada = 'SETP' AND "
                + "  tb_qtd_produz.cod_linha = ? AND "
                + "  date_trunc('month',  tb_qtd_produz.datah) =  TO_timestamp(?,'MM/YYYY') "
                + "order by tb_qtd_parada.datah_ini;";

        ResultSet rs;
        ArrayList<bQtd_regs> sts = new ArrayList<bQtd_regs>();
        Connection conPol = conMgr.getConnection("PD");
        try {
            call = conPol.prepareCall(sql);
            call.setInt(1, arg_linha);
            call.setString(2, arg_dt1);



            rs = call.executeQuery();

            while (rs.next()) {
                bQtd_regs bQtd_regs = new bQtd_regs();
                bQtd_regs.setCod_op(rs.getInt("cod_op"));
                bQtd_regs.setCod_prod(rs.getString("item"));
                bQtd_regs.setQtd_op(rs.getInt("qtd"));
                bQtd_regs.setNroserieini(rs.getString("nroserieini"));
                bQtd_regs.setNroseriefim(rs.getString("nroseriefim"));
                bQtd_regs.setCod_parada(rs.getString("cod_parada"));
                bQtd_regs.setDatah_ini(rs.getTimestamp("datah_ini"));
                bQtd_regs.setTempo(rs.getDouble("tempominu"));
                bQtd_regs.setStrobs(rs.getString("str_obs"));

                sts.add(bQtd_regs);
//                sts.add(rs.getInt(1) + "\t" +  rs.getString(2) + "\t" + rs.getString(3) + "\t" + QtdProduz1.DataftStr(rs.getTimestamp(4),"dd/MM/yyyy HH:mm:ss") + "\t" + QtdProduz1.DataftStr(rs.getTimestamp(5),"dd/MM/yyyy HH:mm:ss") + "\t" + rs.getDouble(6) + "\t" + rs.getString(7));
            }
            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }

    // web lista 2 Mapeamento de Perdas			
    // não suado.
    public static ArrayList<bQtd_regs> getEficMap(String arg_dt1, Integer arg_linha) throws SQLException, ClassNotFoundException, ParseException {
        // String sql = "{ call sp_eficiencia_map( cast('09/2012' as text) ,cast (1 as integer))}";
        String sql = "SELECT "
                + "  tb_qtd_x_oprod.cod_op, "
                + "  to_char(tb_qtd_produz.datah,'dd/MM/yyyy') as datah, "
                + "  tb_qtd_parada.cod_parada,   "
                + "  SUM(extract(epoch from(tb_qtd_parada.datah_fim - tb_qtd_parada.datah_ini))/60)  as tempox "
                + "FROM "
                + "  public.tb_qtd_parada, "
                + "  public.tb_qtd_x_oprod, "
                + "  public.tb_qtd_produz "
                + "WHERE "
                + "  tb_qtd_parada.cod_qtd = tb_qtd_produz.cod_qtd AND"
                + "  tb_qtd_x_oprod.cod_qtd = tb_qtd_produz.cod_qtd AND"
                + "  date_trunc('month',  tb_qtd_x_oprod.datah) =  TO_timestamp(?,'MM/YYYY')"
                + "  AND"
                + "  tb_qtd_produz.cod_linha = ? "
                + "GROUP BY "
                + "  tb_qtd_x_oprod.cod_op, "
                + "  tb_qtd_parada.cod_parada, "
                + "  tb_qtd_produz.datah "
                + "ORDER BY"
                + "  tb_qtd_produz.datah ASC, cod_op, cod_parada;";

        ResultSet rs;
        ArrayList<bQtd_regs> sts = new ArrayList<bQtd_regs>();
        Connection conPol = conMgr.getConnection("PD");
        try {
            call = conPol.prepareCall(sql);
            call.setString(1, arg_dt1);
            call.setInt(2, arg_linha);

            rs = call.executeQuery();

            while (rs.next()) {
                bQtd_regs bQtd_regs = new bQtd_regs();
                bQtd_regs.setCod_op(rs.getInt("cod_op"));
                bQtd_regs.setStrdatah(rs.getString("datah"));
                bQtd_regs.setCod_parada(rs.getString("cod_parada"));
                bQtd_regs.setTempo(rs.getDouble("tempox"));

                sts.add(bQtd_regs);
            }
            call.close();
        } finally {
            if (conPol != null) {
                conMgr.freeConnection("PD", conPol);
            }
        }
        return sts;
    }
}
